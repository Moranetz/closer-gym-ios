import SwiftUI

/// Live free-text sales drill against a buyer persona.
/// Web parity: src/app/play/[personaId]/live/page.tsx.
///
/// Layout (top → bottom):
///   • Opponent player card                         (44pt)
///   • [eval bar 28pt | chat transcript]            (fills)
///   • Composer (textfield + Send)                  (auto)
///
/// Per Send:
///   1. Append operator turn to transcript.
///   2. DetectorLocal.detect() → immediately update eval & firedTechniques set.
///      (Operator-deployed techniques shift eval toward operator by ~0.4 per
///       responsive hit, away by ~0.3 per contraindicated hit; greetings nil.)
///   3. Call AnthropicClient.sendPersonaTurn() → append buyer reply.
///   4. End conditions: 12 operator turns reached, operator types /end, OR
///      eval saturates at |2.5|. Navigate to SimpleReviewView.
struct LiveGameView: View {
    let botMeta: BotMeta
    let intentTechniques: [String]
    @Binding var path: [PlayRoute]

    @EnvironmentObject private var storage: Store
    @Environment(\.dismiss) private var dismiss

    @State private var transcript: [Turn] = []
    @State private var draft: String = ""
    @State private var eval: Double = 0.0           // -3 (buyer) .. +3 (operator)
    @State private var evalCurve: [Double] = [0.0]
    @State private var firedTechniques: Set<String> = []
    @State private var operatorTurnCount: Int = 0
    @State private var isAwaiting: Bool = false
    @State private var errorMsg: String? = nil
    @State private var finishedScore: Double? = nil
    @State private var startedAt: Date = .init()

    @FocusState private var inputFocused: Bool

    private var persona: Persona? { Personas.get(botMeta.personaId) }
    private let maxTurns = 12

    struct Turn: Identifiable, Hashable {
        let id = UUID()
        let role: String   // "operator" or "buyer"
        let text: String
        let firedHere: [String]   // techniques the detector fired this turn
    }

    var body: some View {
        VStack(spacing: 0) {
            opponentBar
            Divider().background(Color.border)
            HStack(spacing: 0) {
                evalBar
                conversation
            }
            composer
        }
        .background(Color.bgPage)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("vs \(persona?.role.split(separator: ",").first.map(String.init) ?? botMeta.personaId)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    endGame(score: scoreFromEval())
                } label: {
                    Text("End")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.warning)
                }
                .disabled(transcript.isEmpty || finishedScore != nil || isAwaiting)
            }
        }
        .onAppear {
            startedAt = Date()
            inputFocused = true
        }
    }

    // MARK: - Opponent bar

    private var opponentBar: some View {
        HStack(spacing: 10) {
            let initials = (persona?.role.split(separator: " ").prefix(2).map { String($0.first ?? Character("?")) }.joined() ?? "??").uppercased()
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color.bgPanel)
                Text(initials)
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
            }
            .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 1) {
                Text(persona?.role ?? botMeta.personaId)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text("\(botMeta.rating)")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(Color.textMuted)
                    if let p = persona {
                        Text("·").foregroundStyle(Color.textFaint)
                        Text("PK \(p.persuasionKnowledge.label)")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Color.textMuted)
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 1) {
                Text("Turn \(operatorTurnCount) / \(maxTurns)")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .kerning(0.4)
                    .monospacedDigit()
                    .foregroundStyle(Color.textMuted)
                Text(evalLabel)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color.bgPanel)
    }

    // MARK: - Eval bar (vertical, chess.com style)

    private var evalBar: some View {
        GeometryReader { geo in
            let h = geo.size.height
            let ratio = Eval.evalToFillRatio(eval)
            let operatorH = h * ratio
            ZStack(alignment: .top) {
                Rectangle().fill(Color(red: 0.15, green: 0.15, blue: 0.14))  // buyer side (dark)
                Rectangle().fill(Color(red: 0.93, green: 0.92, blue: 0.89))  // operator side (light)
                    .frame(height: operatorH)
                    .frame(maxWidth: .infinity, alignment: .top)
                Rectangle().fill(Color.brandGreen.opacity(0.7))
                    .frame(height: 1)
                    .offset(y: operatorH - 0.5)
            }
        }
        .frame(width: 28)
        .overlay(alignment: .trailing) {
            Rectangle().fill(Color.border).frame(width: 1)
        }
    }

    private var evalLabel: String {
        if eval > 2.0 { return "You're ascending" }
        if eval > 0.5 { return "You're ahead" }
        if eval > -0.5 { return "Even" }
        if eval > -2.0 { return "Buyer guarded" }
        return "Buyer disengaging"
    }

    // MARK: - Conversation transcript

    private var conversation: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(transcript) { turn in
                        turnBubble(turn)
                            .id(turn.id)
                    }
                    if isAwaiting {
                        thinkingRow
                    }
                    if let err = errorMsg {
                        errorRow(err)
                    }
                    if transcript.isEmpty {
                        emptyState
                    }
                    Color.clear.frame(height: 12).id("bottom")
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
            }
            .onChange(of: transcript.count) { _, _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
        }
    }

    private func turnBubble(_ turn: Turn) -> some View {
        let isOperator = turn.role == "operator"
        return HStack(alignment: .top) {
            if isOperator { Spacer(minLength: 32) }
            VStack(alignment: isOperator ? .trailing : .leading, spacing: 4) {
                Text(turn.text)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(isOperator ? Color.brandGreen.opacity(0.16) : Color.bgPanel)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(isOperator ? Color.brandGreen.opacity(0.35) : Color.border, lineWidth: 1)
                    )
                if isOperator, !turn.firedHere.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(turn.firedHere, id: \.self) { tid in
                            Text(AtlasTechniques.name(for: tid))
                                .font(.system(size: 9, weight: .heavy, design: .rounded))
                                .kerning(0.3)
                                .foregroundStyle(Color.brandGreen)
                                .padding(.horizontal, 5).padding(.vertical, 1)
                                .background(Color.brandGreen.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            if !isOperator { Spacer(minLength: 32) }
        }
    }

    private var thinkingRow: some View {
        HStack(spacing: 6) {
            ProgressView().scaleEffect(0.6).tint(Color.textMuted)
            Text("Buyer thinking…")
                .font(.system(size: 12))
                .foregroundStyle(Color.textMuted)
        }
        .padding(.leading, 4)
    }

    private func errorRow(_ msg: String) -> some View {
        Text(msg)
            .font(.system(size: 12))
            .foregroundStyle(Color.danger)
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.danger.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("OPEN THE CONVERSATION").microLabel(Color.textMuted)
            Text("First turn is yours. Read the buyer, choose your opening, then Send.")
                .font(.system(size: 12))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(3)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    // MARK: - Composer

    private var composer: some View {
        VStack(spacing: 0) {
            Divider().background(Color.border)
            HStack(spacing: 8) {
                TextField("Your turn…", text: $draft, axis: .vertical)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textPrimary)
                    .tint(Color.brandGreen)
                    .lineLimit(1...5)
                    .focused($inputFocused)
                    .padding(.horizontal, 10).padding(.vertical, 8)
                    .background(Color.bgPanel)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
                    .disabled(isAwaiting || finishedScore != nil)
                Button {
                    Task { await send() }
                } label: {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 14, weight: .heavy))
                        .foregroundStyle(canSend ? Color.bgPage : Color.textFaint)
                        .frame(width: 36, height: 36)
                        .background(canSend ? Color.brandGreen : Color.bgPanel)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .disabled(!canSend)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.bgPage)
        }
    }

    private var canSend: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !isAwaiting
            && finishedScore == nil
    }

    // MARK: - Send pipeline

    // Defense-in-depth cap on a single turn's length. The real enforcement must live in the
    // server proxy (the client is untrusted), but this blunts casual cost-amplification and
    // keeps the composer sane. See SECURITY.md.
    private static let maxTurnChars = 2000

    @MainActor
    private func send() async {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        let text = String(trimmed.prefix(LiveGameView.maxTurnChars))
        guard !text.isEmpty else { return }
        Haptics.shared.selection()

        if text.lowercased() == "/end" {
            draft = ""
            endGame(score: scoreFromEval())
            return
        }

        // 1. Local detector on operator's turn.
        let recentBuyer = transcript.last { $0.role == "buyer" }?.text
        let detection = DetectorLocal.detect(text, recentBuyerTurn: recentBuyer)
        for tid in detection.techniqueIds { firedTechniques.insert(tid) }
        applyEvalShift(detection.techniqueIds)
        evalCurve.append(eval)

        let operatorTurn = Turn(role: "operator", text: text, firedHere: detection.techniqueIds)
        transcript.append(operatorTurn)
        operatorTurnCount += 1
        draft = ""
        errorMsg = nil

        if abs(eval) >= 2.5 {
            endGame(score: scoreFromEval())
            return
        }
        if operatorTurnCount >= maxTurns {
            endGame(score: scoreFromEval())
            return
        }
        guard let p = persona else {
            errorMsg = "Persona missing."
            return
        }

        // 2. Buyer turn via Anthropic.
        isAwaiting = true
        defer { isAwaiting = false }
        let history = transcript.dropLast().map { t in
            AnthropicClient.ChatMessage(role: t.role == "operator" ? "user" : "assistant", content: t.text)
        }
        do {
            let reply = try await AnthropicClient.sendPersonaTurn(
                persona: p,
                history: Array(history),
                operatorTurn: text,
                companyContext: storage.companyProfile.personaContext
            )
            let cleaned = reply.trimmingCharacters(in: .whitespacesAndNewlines)
            transcript.append(Turn(role: "buyer", text: cleaned.isEmpty ? "…" : cleaned, firedHere: []))
        } catch let err as AnthropicClient.ClientError {
            errorMsg = err.errorDescription
        } catch {
            errorMsg = "Buyer turn failed: \(error.localizedDescription)"
        }
    }

    private func applyEvalShift(_ techniqueIds: [String]) {
        guard let p = persona else { return }
        let responsive = Set(p.likelyResponsiveTechniques)
        let contraind = Set(p.contraindicatedTechniques)
        var delta: Double = 0
        for tid in techniqueIds {
            if responsive.contains(tid) { delta += 0.40 }
            if contraind.contains(tid) { delta -= 0.30 }
        }
        // Persuasion-knowledge: high-PK buyers penalize stacking.
        if techniqueIds.count >= 3 {
            switch p.persuasionKnowledge {
            case .high, .veryHigh: delta -= 0.25
            case .medium: delta -= 0.10
            default: break
            }
        }
        // Mild drift toward neutral when no technique fires (the conversation moves).
        if techniqueIds.isEmpty { delta += eval > 0 ? -0.05 : 0.05 }
        eval = max(-3.0, min(3.0, eval + delta))
    }

    private func scoreFromEval() -> Double {
        if eval >= 1.5 { return 1.0 }
        if eval <= -1.5 { return 0.0 }
        return 0.5
    }

    private func endGame(score: Double) {
        guard finishedScore == nil else { return }   // ignore double-tap / re-entry
        finishedScore = score
        Haptics.shared.success()
        let stored = transcript.map { StoredTurn(role: $0.role, text: $0.text, firedHere: $0.firedHere) }
        path.append(.review(ReviewPayload(
            botMeta: botMeta,
            intentTechniques: intentTechniques,
            firedTechniques: Array(firedTechniques),
            evalCurve: evalCurve,
            score: score,
            durationSec: Int(Date().timeIntervalSince(startedAt)),
            transcript: stored
        )))
    }
}
