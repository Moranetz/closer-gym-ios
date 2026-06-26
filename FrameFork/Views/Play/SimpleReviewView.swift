import SwiftUI

/// Post-game review for a free-text drill.
/// • Headline score + ELO delta (Glicko-2, Game bucket).
/// • Eval curve (running -3..+3 across operator turns).
/// • Intent vs Fired: pre-registered techniques vs detector hits.
/// • Persona-relative deployment: which fired techniques landed in the
///   responsive list vs the contraindicated list for this buyer.
///
/// On appear, calls Store.recordGame() once to commit the rating change.
struct SimpleReviewView: View {
    let botMeta: BotMeta
    let intentTechniques: [String]
    let firedTechniques: [String]
    let evalCurve: [Double]
    let score: Double
    let durationSec: Int
    let transcript: [StoredTurn]
    @Binding var path: [PlayRoute]

    init(payload: ReviewPayload, path: Binding<[PlayRoute]>) {
        self.botMeta = payload.botMeta
        self.intentTechniques = payload.intentTechniques
        self.firedTechniques = payload.firedTechniques
        self.evalCurve = payload.evalCurve
        self.score = payload.score
        self.durationSec = payload.durationSec
        self.transcript = payload.transcript
        self._path = path
    }

    @EnvironmentObject private var storage: Store
    @State private var ratingDelta: Double? = nil
    @State private var newRating: Double = 1500
    @State private var didCommit: Bool = false
    @State private var grading: Bool = false
    @State private var judgment: RolePlayJudgment? = nil
    @State private var judgeAttempted: Bool = false

    private var persona: Persona? { Personas.get(botMeta.personaId) }
    private var operatorTurnCount: Int { transcript.filter { $0.role == "operator" }.count }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                gradeCard
                if !transcript.isEmpty { transcriptCard }
                curveCard
                techniqueCard
                deploymentCard
                doneButton
                Spacer(minLength: 32)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .background(Color.bgPage)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Game review")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .task { await judgeAndCommit() }
    }

    /// Run the blind judge (if a key + enough turns), then commit the game ONCE with the
    /// judge's process grade as the Glicko score — or the local eval score as a fallback.
    private func judgeAndCommit() async {
        guard !didCommit else { return }
        didCommit = true   // claim the commit up front so a re-entry can't double-record (Store is @MainActor)
        var judged: RolePlayJudgment? = nil
        if operatorTurnCount >= 2, Keychain.hasAPIKey(), let p = persona {
            judgeAttempted = true
            grading = true
            judged = try? await AnthropicClient.judgeGame(persona: p, transcript: transcript)
            grading = false
        }
        let finalScore = judged.map { max(0.0, min(1.0, $0.processScore)) } ?? score
        let result = storage.recordGame(
            botRating: botMeta.rating,
            score: finalScore,
            personaId: botMeta.personaId,
            evalCurve: evalCurve,
            intentTechniques: intentTechniques,
            firedTechniques: firedTechniques,
            durationSec: durationSec,
            turns: transcript,
            judgment: judged
        )
        newRating = result.newRating
        ratingDelta = result.delta
        judgment = judged
    }

    // MARK: - Grade card (the blind coach)

    private var gradeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            if grading {
                HStack(spacing: 10) {
                    ProgressView().tint(Color.brandGreen)
                    Text("Coach is grading your craft…")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else if let j = judgment {
                Text("COACH'S GRADE").microLabel(Color.textSecondary)
                HStack(alignment: .firstTextBaseline) {
                    Text(j.verdict)
                        .font(.system(size: 21, weight: .heavy, design: .rounded))
                        .foregroundStyle(gradeColor(j.fill))
                    Spacer()
                    Text("\(Int((j.fill * 100).rounded()))")
                        .font(.system(size: 28, weight: .light, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(Color.textPrimary)
                    + Text("/100").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(Color.textMuted)
                }
                GradeBar(fill: j.fill, color: gradeColor(j.fill))
                Text(j.summary)
                    .font(.system(size: 13)).foregroundStyle(Color.textSecondary).lineSpacing(2)
                VStack(spacing: 7) {
                    ForEach(Array(j.criteria.enumerated()), id: \.offset) { _, c in criterionRow(c) }
                }
                .padding(.top, 2)
                ratingLine
            } else {
                Text(outcomeLabel)
                    .font(.system(size: 21, weight: .heavy, design: .rounded))
                    .foregroundStyle(outcomeColor)
                ratingLine
                Text(judgeAttempted
                     ? "Coach grade unavailable for this game — the grader didn't respond. Scored on the live read."
                     : "Full AI craft grade needs a Pro key (Settings → Pro). Scored on the live read this game.")
                    .font(.system(size: 11)).foregroundStyle(Color.textFaint)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var ratingLine: some View {
        HStack(spacing: 16) {
            stat(label: "New ELO", value: String(format: "%.0f", newRating))
            if let d = ratingDelta {
                stat(label: "Delta", value: String(format: "%@%.1f", d >= 0 ? "+" : "", d))
            }
            stat(label: "Length", value: "\(durationSec / 60)m \(durationSec % 60)s")
            Spacer(minLength: 0)
        }
        .padding(.top, 2)
    }

    private func criterionRow(_ c: RolePlayJudgment.Criterion) -> some View {
        HStack(spacing: 10) {
            Text(prettyCriterion(c.name))
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .frame(width: 96, alignment: .leading)
            GradeBar(fill: max(0, min(1, c.score)), color: gradeColor(c.score))
                .frame(width: 54)
            Text(c.note)
                .font(.system(size: 11)).foregroundStyle(Color.textMuted)
                .lineLimit(2)
            Spacer(minLength: 0)
        }
    }

    private func prettyCriterion(_ raw: String) -> String {
        raw.replacingOccurrences(of: "_", with: " ").capitalized
    }

    private func gradeColor(_ s: Double) -> Color {
        if s >= 0.7 { return .brandGreen }
        if s >= 0.45 { return .warning }
        return .danger
    }

    // MARK: - Transcript replay (best/weakest turn highlighted)

    private struct ReplayItem: Identifiable { let id: Int; let turn: StoredTurn; let oNum: Int? }
    private var replayItems: [ReplayItem] {
        var out: [ReplayItem] = []
        var o = 0
        for (i, t) in transcript.enumerated() {
            var n: Int? = nil
            if t.role == "operator" { o += 1; n = o }
            out.append(ReplayItem(id: i, turn: t, oNum: n))
        }
        return out
    }

    private var transcriptCard: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("Replay").microLabel(Color.textSecondary)
            ForEach(replayItems) { item in replayRow(item) }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    @ViewBuilder
    private func replayRow(_ item: ReplayItem) -> some View {
        let isOp = item.turn.role == "operator"
        let isBest = item.oNum != nil && item.oNum == judgment?.bestTurn
        let isWeak = item.oNum != nil && item.oNum == judgment?.weakestTurn
        let mark: (String, Color)? = isBest ? ("STRONGEST", .brandGreen) : (isWeak ? ("WEAKEST", .warning) : nil)
        HStack(alignment: .top) {
            if isOp { Spacer(minLength: 28) }
            VStack(alignment: isOp ? .trailing : .leading, spacing: 4) {
                if let mark {
                    Text(mark.0)
                        .font(.system(size: 8.5, weight: .heavy, design: .rounded)).kerning(0.5)
                        .foregroundStyle(mark.1)
                }
                Text(item.turn.text)
                    .font(.system(size: 12.5))
                    .foregroundStyle(Color.textPrimary)
                    .padding(.horizontal, 10).padding(.vertical, 7)
                    .background(isOp ? Color.brandGreen.opacity(0.12) : Color.bgRail)
                    .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .strokeBorder(mark?.1 ?? (isOp ? Color.brandGreen.opacity(0.25) : Color.border),
                                          lineWidth: mark == nil ? 1 : 1.5)
                    )
                if isBest, let note = judgment?.bestTurnNote {
                    noteLabel(note, .brandGreen, trailing: isOp)
                } else if isWeak, let note = judgment?.weakestTurnNote {
                    noteLabel(note, .warning, trailing: isOp)
                }
            }
            if !isOp { Spacer(minLength: 28) }
        }
    }

    private func noteLabel(_ text: String, _ color: Color, trailing: Bool) -> some View {
        Text(text)
            .font(.system(size: 10.5)).italic()
            .foregroundStyle(color)
            .frame(maxWidth: 220, alignment: trailing ? .trailing : .leading)
            .multilineTextAlignment(trailing ? .trailing : .leading)
    }

    private var curveCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Eval curve").microLabel(Color.textSecondary)
            EvalSparkline(values: evalCurve)
                .frame(height: 64)
                .padding(.top, 2)
            HStack {
                Text("Buyer −3").font(.system(size: 10, weight: .heavy, design: .rounded)).foregroundStyle(Color.textFaint)
                Spacer()
                Text("Even 0").font(.system(size: 10, weight: .heavy, design: .rounded)).foregroundStyle(Color.textFaint)
                Spacer()
                Text("You +3").font(.system(size: 10, weight: .heavy, design: .rounded)).foregroundStyle(Color.textFaint)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var techniqueCard: some View {
        let intent = Set(intentTechniques)
        let fired = Set(firedTechniques)
        let matched = intent.intersection(fired)
        let intendedMissed = intent.subtracting(fired)
        let unintendedFired = fired.subtracting(intent)

        return VStack(alignment: .leading, spacing: 10) {
            Text("Intent vs fired").microLabel(Color.textSecondary)
            Text("Pre-registered \(intent.count) · fired \(fired.count) · matched \(matched.count)")
                .font(.system(size: 12))
                .foregroundStyle(Color.textMuted)
                .monospacedDigit()
            techniqueRow(title: "Landed as planned", ids: Array(matched), color: Color.brandGreen)
            techniqueRow(title: "Intended, did not fire", ids: Array(intendedMissed), color: Color.warning)
            techniqueRow(title: "Fired without intent", ids: Array(unintendedFired), color: Color.info)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var deploymentCard: some View {
        guard let p = persona else { return AnyView(EmptyView()) }
        let fired = Set(firedTechniques)
        let landed = fired.intersection(Set(p.likelyResponsiveTechniques))
        let backfired = fired.intersection(Set(p.contraindicatedTechniques))
        return AnyView(
            VStack(alignment: .leading, spacing: 10) {
                Text("Persona response").microLabel(Color.textSecondary)
                techniqueRow(title: "Likely landed", ids: Array(landed), color: Color.brandGreen)
                techniqueRow(title: "Likely backfired", ids: Array(backfired), color: Color.danger)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.bgPanel)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
        )
    }

    private func techniqueRow(title: String, ids: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .kerning(0.4)
                .foregroundStyle(color)
            if ids.isEmpty {
                Text("none")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.textFaint)
            } else {
                FlowLayout(spacing: 5, lineSpacing: 5) {
                    ForEach(ids, id: \.self) { tid in
                        Text(AtlasTechniques.name(for: tid))
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(color)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(color.opacity(0.12))
                            .overlay(RoundedRectangle(cornerRadius: 4, style: .continuous).strokeBorder(color.opacity(0.3), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    }
                }
            }
        }
    }

    private var doneButton: some View {
        PrimaryButton(title: "Done", symbol: "checkmark", isEnabled: true, style: .green) {
            path.removeAll()   // pop the whole Play flow back to the bot ladder
        }
    }

    private func stat(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.system(size: 10, weight: .heavy, design: .rounded)).kerning(0.4).foregroundStyle(Color.textMuted)
            Text(value).font(.system(size: 13, weight: .heavy, design: .rounded)).monospacedDigit().foregroundStyle(Color.textPrimary)
        }
    }

    private var outcomeLabel: String {
        if score >= 1.0 { return "Closed favorably" }
        if score <= 0.0 { return "Buyer disengaged" }
        return "Inconclusive"
    }

    private var outcomeColor: Color {
        if score >= 1.0 { return Color.brandGreen }
        if score <= 0.0 { return Color.danger }
        return Color.warning
    }
}

/// Horizontal grade bar for the coach's process score / per-criterion scores.
private struct GradeBar: View {
    let fill: Double          // 0…1
    let color: Color
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.bgRail)
                Capsule().fill(color.opacity(0.9))
                    .frame(width: max(3, geo.size.width * CGFloat(max(0, min(1, fill)))))
            }
        }
        .frame(height: 6)
        .overlay(Capsule().strokeBorder(Color.border, lineWidth: 1))
    }
}

/// Minimal sparkline for the running eval curve.
struct EvalSparkline: View {
    let values: [Double]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                // Zero line
                Rectangle()
                    .fill(Color.border)
                    .frame(height: 1)
                    .offset(y: 0)
                Path { p in
                    p.move(to: CGPoint(x: 0, y: h / 2))
                    p.addLine(to: CGPoint(x: w, y: h / 2))
                }
                .stroke(Color.border, lineWidth: 1)

                // Curve
                Path { p in
                    guard values.count > 1 else { return }
                    let stepX = w / CGFloat(values.count - 1)
                    for (i, v) in values.enumerated() {
                        let x = CGFloat(i) * stepX
                        let y = h / 2 - CGFloat(v) / 3.0 * (h / 2)
                        if i == 0 { p.move(to: CGPoint(x: x, y: y)) }
                        else { p.addLine(to: CGPoint(x: x, y: y)) }
                    }
                }
                .stroke(Color.brandGreen, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

                // Dot at the end
                if let last = values.last, values.count > 0 {
                    let x = w
                    let y = h / 2 - CGFloat(last) / 3.0 * (h / 2)
                    Circle()
                        .fill(Color.brandGreen)
                        .frame(width: 5, height: 5)
                        .position(x: x - 2.5, y: y)
                }
            }
        }
    }
}
