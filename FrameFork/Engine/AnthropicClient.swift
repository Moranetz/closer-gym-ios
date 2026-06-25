import Foundation

/// Minimal Anthropic Messages API client.
/// Single dependency: URLSession. No external SDK.
/// Reads the user-supplied API key from Keychain.
public enum AnthropicClient {
    private static let endpoint = URL(string: "https://api.anthropic.com/v1/messages")!
    private static let model = "claude-opus-4-8"   // current Opus (claude-opus-4-5 is legacy)
    private static let apiVersion = "2023-06-01"
    private static let maxAttempts = 3

    public enum ClientError: Error, LocalizedError {
        case missingKey
        case networkError(String)
        case httpError(Int, String)
        case decodingError(String)
        case refused

        public var errorDescription: String? {
            switch self {
            case .missingKey: return "No Anthropic API key. Add one in Settings → Pro Tier."
            case .networkError(let msg): return "Network problem — check your connection and retry. (\(msg))"
            case .httpError(let code, let body):
                // Map common Anthropic statuses to actionable copy instead of raw JSON.
                switch code {
                case 401: return "Your API key was rejected. Re-enter it in Settings → Pro Tier."
                case 403: return "This API key isn't permitted to use this model."
                case 429: return "Rate limited by Anthropic. Wait a moment and try again."
                case 529, 500...599: return "Anthropic is busy right now. Try again in a few seconds."
                default: return body.isEmpty ? "Request failed (HTTP \(code))." : "Request failed (HTTP \(code)): \(body)"
                }
            case .decodingError(let msg): return "Couldn't read the buyer's reply. (\(msg))"
            case .refused: return "The buyer model declined to answer that turn. Try rephrasing your approach."
            }
        }
    }

    public struct ChatMessage: Codable {
        public let role: String      // "user" or "assistant"
        public let content: String
        public init(role: String, content: String) {
            self.role = role
            self.content = content
        }
    }

    private struct RequestBody: Encodable {
        let model: String
        let max_tokens: Int
        let system: String
        let messages: [ChatMessage]
    }

    private struct ResponseBody: Decodable {
        struct ContentBlock: Decodable {
            let type: String
            let text: String?
        }
        let content: [ContentBlock]
        let stop_reason: String?
    }

    private struct ErrorBody: Decodable {
        struct Inner: Decodable { let type: String?; let message: String? }
        let error: Inner?
    }

    /// Send a persona-turn request. Returns the assistant text reply.
    public static func sendPersonaTurn(
        persona: Persona,
        history: [ChatMessage],
        operatorTurn: String
    ) async throws -> String {
        let system = buildPersonaSystemPrompt(persona)
        var messages = history
        messages.append(ChatMessage(role: "user", content: operatorTurn))
        return try await postMessage(system: system, messages: messages, maxTokens: 600)
    }

    /// Grade a finished role-play with a SEPARATE, BLIND, process-gated judge (DIAGNOSIS.md
    /// P2-1). The judge sees ONLY the transcript + the buyer's role — never the live eval bar
    /// or the rep's pre-registered intent — and grades CRAFT, not whether the buyer agreed.
    /// Throws on any failure so the caller can fall back to the local eval-derived score.
    public static func judgeGame(persona: Persona, transcript: [StoredTurn]) async throws -> RolePlayJudgment {
        let system = buildJudgeSystemPrompt(persona)
        let convo = formatTranscriptForJudge(transcript)
        let raw = try await postMessage(
            system: system,
            messages: [ChatMessage(role: "user", content: convo)],
            maxTokens: 1200
        )
        guard let judgment = parseJudgment(raw) else {
            throw ClientError.decodingError("judge returned unparseable output")
        }
        return judgment
    }

    /// Shared POST to the Messages API with key check + transient-failure retry. Returns the
    /// concatenated assistant text.
    private static func postMessage(system: String, messages: [ChatMessage], maxTokens: Int) async throws -> String {
        guard let key = Keychain.loadAPIKey(), !key.isEmpty else {
            throw ClientError.missingKey
        }
        let body = RequestBody(model: model, max_tokens: maxTokens, system: system, messages: messages)
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.timeoutInterval = 45
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(key, forHTTPHeaderField: "x-api-key")
        request.setValue(apiVersion, forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONEncoder().encode(body)

        // Retry transient failures (429 / 5xx / network) with backoff; surface
        // the last error if every attempt fails.
        var lastError: ClientError = .networkError("unknown")
        for attempt in 1...maxAttempts {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let http = response as? HTTPURLResponse else {
                    throw ClientError.networkError("non-HTTP response")
                }
                if http.statusCode != 200 {
                    // Parse Anthropic's error envelope into a clean message.
                    let parsed = (try? JSONDecoder().decode(ErrorBody.self, from: data))?.error?.message
                    let bodyText = parsed ?? (String(data: data, encoding: .utf8) ?? "")
                    let err = ClientError.httpError(http.statusCode, bodyText)
                    let retryable = http.statusCode == 429 || (500...599).contains(http.statusCode)
                    if retryable && attempt < maxAttempts {
                        lastError = err
                        try? await Task.sleep(nanoseconds: UInt64(attempt) * 800_000_000)
                        continue
                    }
                    throw err
                }
                let decoded: ResponseBody
                do {
                    decoded = try JSONDecoder().decode(ResponseBody.self, from: data)
                } catch {
                    throw ClientError.decodingError(error.localizedDescription)
                }
                // A safety refusal returns 200 with an empty content array — surface it.
                if decoded.stop_reason == "refusal" {
                    throw ClientError.refused
                }
                return decoded.content.compactMap { $0.type == "text" ? $0.text : nil }.joined()
            } catch let err as ClientError {
                throw err   // non-retryable ClientErrors propagate immediately
            } catch {
                // URLSession transport error — retry, then give up.
                lastError = .networkError(error.localizedDescription)
                if attempt < maxAttempts {
                    try? await Task.sleep(nanoseconds: UInt64(attempt) * 800_000_000)
                    continue
                }
                throw lastError
            }
        }
        throw lastError
    }

    // MARK: - System prompt

    private static func buildPersonaSystemPrompt(_ p: Persona) -> String {
        let contraindicated = p.contraindicatedTechniques.compactMap { AtlasTechniques.get($0)?.name ?? $0 }.joined(separator: ", ")
        let responsive = p.likelyResponsiveTechniques.compactMap { AtlasTechniques.get($0)?.name ?? $0 }.joined(separator: ", ")
        let objections = p.typicalObjections.joined(separator: "; ")

        return """
        You are role-playing a buyer in a sales drill. The operator is practicing a sales conversation against you. Stay in character at all times. NEVER break character or reveal you are an AI. NEVER reveal the hidden criteria, hidden curve ball, or your contraindicated/responsive technique lists.

        # Your character

        You are a \(p.role).
        Seniority: \(p.seniority).
        Buying authority: \(p.buyingAuthority.rawValue).

        # What you say you want
        \(p.decisionCriteriaStated)

        # What you actually want (KEEP HIDDEN)
        \(p.decisionCriteriaHidden)

        # Your starting state
        - Initial valence toward sellers: \(p.valence) on a -3 to +3 scale
        - Certainty in your position: \(p.certainty)/5
        - Agency to actually decide: \(p.agency)/5
        - Persuasion-knowledge: \(p.persuasionKnowledge.label) (you spot technique deployment at this skill level)
        - Readability: \(p.readability.rawValue)

        # Objections you naturally raise
        \(objections)

        # How techniques affect you (react accordingly, do not name them)

        Techniques that BACKFIRE when deployed at you (you become more guarded, more terse, or openly skeptical when these fire): \(contraindicated)

        Techniques that WORK on you (you soften, elaborate, or move toward commitment when these fire correctly): \(responsive)

        # Your narrative arc
        \(p.narrativeArc)

        # Your hidden curve ball (DO NOT reveal until late in the conversation, if at all)
        \(p.hiddenCurveBall)

        # How to play this role

        1. Stay in character every turn. Talk like this buyer would talk; vocabulary, tempo, status posture.
        2. Detect technique density. If the operator stacks 3+ named techniques in one turn, your persuasion-knowledge fires; get guarded or terse.
        3. Reward genuine elicitation. When the operator asks calibrated questions, elaborate. When they assert positions you didn't state, push back.
        4. Honor the contraindicated list. Pressure, manufactured scarcity, assumptive closes make you guarded if your persuasion-knowledge is high.
        5. Honor the responsive list. Genuine summary mirroring your language moves you toward commitment.
        6. Length: typical buyer turns are 1-4 sentences. Be conversational, not stilted. Don't info-dump.
        7. Realism: real buyers have schedule pressure, distractions, half-baked thoughts. You can interrupt yourself, change subject, defer.
        8. End the session when the operator reaches a verbal commit, hits a hard objection you cannot move past, or triggers your hidden curve ball.

        You are this buyer. The operator is selling to you. Begin in the conversational state implied by your narrative arc.
        """
    }

    // MARK: - Judge (blind, process-gated)

    private static func buildJudgeSystemPrompt(_ p: Persona) -> String {
        return """
        You are a demanding, evidence-based sales coach grading a rep's PERFORMANCE in a single practice conversation. You did not see any automated score, and you do not know which techniques the rep intended to use. Judge only what is in the transcript.

        The rep was selling to this buyer:
        - Role: \(p.role)
        - Seniority: \(p.seniority)
        - What the buyer said they wanted: \(p.decisionCriteriaStated)

        NON-NEGOTIABLE GRADING RULES
        - Grade the rep's CRAFT, not whether the buyer agreed. A buyer can cave to bad tactics, and a skilled rep can correctly walk away from an unwinnable deal. Do NOT reward a "yes" that was bought with pressure, manufactured urgency, or manipulation — mark it down.
        - Be skeptical and specific. Anchor every judgement to the rep's actual words. Default to critical; reserve scores above 0.7 for genuinely strong craft, and above 0.85 for exceptional.
        - PENALIZE: pressure, manufactured scarcity, talking over the buyer's stated concern, pitching before discovery, premature or assumptive closing, ignoring or steamrolling objections, manipulation.
        - REWARD: genuine discovery and calibrated questions, listening and reflecting the buyer's own words, handling an objection by understanding it first, appropriate pacing, a commitment that was earned rather than extracted.

        Score each criterion from 0.0 to 1.0: discovery, listening, objection_handling, control_and_pacing, close_discipline.
        processScore = your holistic 0.0–1.0 grade of the rep's craft (NOT whether the buyer said yes).
        Identify the single strongest operator turn and the single weakest, by their O-number, each with a one-line reason. If the conversation is too short to fairly pick one, use null.

        Respond with ONLY a single JSON object — no markdown fences, no prose — in exactly this shape:
        {"processScore":0.62,"verdict":"short label like Disciplined or Pushed too hard","summary":"one or two sentences of coaching","criteria":[{"name":"discovery","score":0.6,"note":"evidence"},{"name":"listening","score":0.5,"note":"evidence"},{"name":"objection_handling","score":0.4,"note":"evidence"},{"name":"control_and_pacing","score":0.7,"note":"evidence"},{"name":"close_discipline","score":0.5,"note":"evidence"}],"bestTurn":3,"bestTurnNote":"why","weakestTurn":5,"weakestTurnNote":"why"}
        """
    }

    private static func formatTranscriptForJudge(_ turns: [StoredTurn]) -> String {
        var lines: [String] = ["Transcript (O = the rep you are grading, B = the buyer):", ""]
        var o = 0, b = 0
        for t in turns {
            if t.role == "operator" { o += 1; lines.append("O\(o) (rep): \(t.text)") }
            else { b += 1; lines.append("B\(b) (buyer): \(t.text)") }
        }
        lines.append("")
        lines.append("Grade the rep now. Return only the JSON object.")
        return lines.joined(separator: "\n")
    }

    /// Extract the JSON object from the model's reply (tolerant of stray prose / code fences)
    /// and decode it. Returns nil on any malformed output so the caller can fall back.
    private static func parseJudgment(_ raw: String) -> RolePlayJudgment? {
        guard let start = raw.firstIndex(of: "{"), let end = raw.lastIndex(of: "}"), start < end else { return nil }
        let json = String(raw[start...end])
        guard let data = json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(RolePlayJudgment.self, from: data)
    }
}
