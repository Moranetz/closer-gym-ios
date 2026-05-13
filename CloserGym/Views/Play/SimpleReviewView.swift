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

    @EnvironmentObject private var storage: Store
    @Environment(\.dismiss) private var dismiss
    @State private var ratingDelta: Double? = nil
    @State private var newRating: Double = 1500
    @State private var didCommit: Bool = false

    private var persona: Persona? { Personas.get(botMeta.personaId) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                headlineCard
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
        .onAppear {
            guard !didCommit else { return }
            let result = storage.recordGame(
                botRating: botMeta.rating,
                score: score,
                personaId: botMeta.personaId,
                evalCurve: evalCurve,
                intentTechniques: intentTechniques,
                firedTechniques: firedTechniques,
                durationSec: durationSec
            )
            newRating = result.newRating
            ratingDelta = result.delta
            didCommit = true
        }
    }

    private var headlineCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(outcomeLabel)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(outcomeColor)
            HStack(spacing: 16) {
                stat(label: "New ELO", value: String(format: "%.0f", newRating))
                if let d = ratingDelta {
                    stat(label: "Delta", value: String(format: "%@%.1f", d >= 0 ? "+" : "", d))
                }
                stat(label: "Length", value: "\(durationSec / 60)m \(durationSec % 60)s")
                Spacer(minLength: 0)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
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
                Text("Operator +3").font(.system(size: 10, weight: .heavy, design: .rounded)).foregroundStyle(Color.textFaint)
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
            dismiss()
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
