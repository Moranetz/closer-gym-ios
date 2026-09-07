import SwiftUI

/// The ladder, as a record of what the player has actually seen.
///
/// Round 171. The app grades every move on nine tiers and the top two are deliberately scarce:
/// four of 129 positions can produce a Fork, one can produce a Sharp. That is a real variable
/// reward, built to this app's own juice doctrine — variance in the QUALITY of the reward rather
/// than in whether one arrives, which is the only form of it that survives an ethics gate.
///
/// It was also invisible. Verdicts were computed at solve time, shown for one screen, and never
/// written down, so a player could not know the Fork existed until they hit it, and could not
/// remember it afterwards. This is the record: the whole ladder, what has been earned, and what
/// is still out there. It pays nothing and it never nags — a rare thing you can SEE is missing
/// is the anticipation; a rare thing nobody names is just noise in the log.
struct VerdictLadder: View {
    let counts: [String: Int]

    private var earnedTiers: Int {
        Verdict.allCases.filter { (counts[$0.rawValue] ?? 0) > 0 }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("VERDICTS").microLabel(Color.textLabel)
                Spacer()
                Text("\(earnedTiers) of \(Verdict.allCases.count) seen")
                    .scaledFont(size: 10, weight: .semibold)
                    .foregroundStyle(Color.textMuted)
                    .monospacedDigit()
            }
            ForEach(Verdict.allCases, id: \.self) { v in
                let n = counts[v.rawValue] ?? 0
                HStack(spacing: 10) {
                    Text(v.glyph)
                        .scaledFont(size: 15, weight: .bold, design: .rounded)
                        .foregroundStyle(n > 0 ? v.color : Color.textFaint)
                        .frame(width: 26, alignment: .leading)
                        .accessibilityHidden(true)
                    Text(v.label)
                        .scaledFont(size: 13, weight: n > 0 ? .bold : .semibold)
                        .foregroundStyle(n > 0 ? Color.textPrimary : Color.textMuted)
                    Spacer()
                    // An unearned tier shows a dash rather than a zero: nothing was lost, it
                    // simply has not happened yet.
                    Text(n > 0 ? "\(n)" : "—")
                        .scaledFont(size: 13, weight: .semibold).monospacedDigit()
                        .foregroundStyle(n > 0 ? Color.textSecondary : Color.textFaint)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(n > 0 ? "\(v.label), earned \(countNoun(n, "time"))" : "\(v.label), not yet earned")
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.panelGround))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }
}
