import Foundation

/// One persisted turn of a live role-play, so a finished game can be replayed and mined
/// (the content flywheel + the rich debrief). Previously transcripts were discarded at
/// game end — see DIAGNOSIS.md P2-3.
public struct StoredTurn: Codable, Hashable, Sendable {
    public let role: String          // "operator" or "buyer"
    public let text: String
    public let firedHere: [String]   // detector technique-ids fired on this operator turn
    public init(role: String, text: String, firedHere: [String]) {
        self.role = role
        self.text = text
        self.firedHere = firedHere
    }
}

/// The end-of-game grade from a SEPARATE, BLIND, process-gated LLM judge (DIAGNOSIS.md P2-1).
/// The judge never sees the live eval bar or the rep's pre-registered intent, and it grades
/// CRAFT — not whether the buyer agreed (a buyer can cave to bad tactics). This is what makes
/// the role-play score defensible enough to ever put on a manager dashboard.
public struct RolePlayJudgment: Codable, Hashable, Sendable {
    public struct Criterion: Codable, Hashable, Sendable {
        public let name: String      // e.g. "discovery", "listening"
        public let score: Double     // 0…1
        public let note: String      // one-line, evidence-anchored
        public init(name: String, score: Double, note: String) {
            self.name = name; self.score = score; self.note = note
        }
    }

    public let processScore: Double   // 0…1 holistic craft grade (NOT "did the buyer say yes")
    public let verdict: String        // short label, e.g. "Disciplined" / "Pushed too hard"
    public let summary: String        // one or two sentences
    public let criteria: [Criterion]
    public let bestTurn: Int?         // 1-based operator-turn number, or nil
    public let bestTurnNote: String?
    public let weakestTurn: Int?
    public let weakestTurnNote: String?

    public init(processScore: Double, verdict: String, summary: String, criteria: [Criterion],
                bestTurn: Int?, bestTurnNote: String?, weakestTurn: Int?, weakestTurnNote: String?) {
        self.processScore = processScore
        self.verdict = verdict
        self.summary = summary
        self.criteria = criteria
        self.bestTurn = bestTurn
        self.bestTurnNote = bestTurnNote
        self.weakestTurn = weakestTurn
        self.weakestTurnNote = weakestTurnNote
    }

    /// 0…1 fill for a conviction-style grade bar.
    public var fill: Double { max(0.0, min(1.0, processScore)) }
}

// Tolerant decoders so a mostly-good judgment isn't discarded when the model omits or
// malforms a single field (the all-or-nothing synthesized decode would otherwise nil the
// whole grade and silently fall back to the local eval score).
extension RolePlayJudgment {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        processScore    = (try? c.decodeIfPresent(Double.self, forKey: .processScore)) ?? 0.5
        verdict         = (try? c.decodeIfPresent(String.self, forKey: .verdict)) ?? "Graded"
        summary         = (try? c.decodeIfPresent(String.self, forKey: .summary)) ?? ""
        criteria        = (try? c.decodeIfPresent([Criterion].self, forKey: .criteria)) ?? []
        bestTurn        = (try? c.decodeIfPresent(Int.self, forKey: .bestTurn)) ?? nil
        bestTurnNote    = (try? c.decodeIfPresent(String.self, forKey: .bestTurnNote)) ?? nil
        weakestTurn     = (try? c.decodeIfPresent(Int.self, forKey: .weakestTurn)) ?? nil
        weakestTurnNote = (try? c.decodeIfPresent(String.self, forKey: .weakestTurnNote)) ?? nil
    }
}

extension RolePlayJudgment.Criterion {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name  = (try? c.decodeIfPresent(String.self, forKey: .name)) ?? "criterion"
        score = (try? c.decodeIfPresent(Double.self, forKey: .score)) ?? 0.5
        note  = (try? c.decodeIfPresent(String.self, forKey: .note)) ?? ""
    }
}
