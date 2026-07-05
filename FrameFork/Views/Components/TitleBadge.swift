import SwiftUI

/// Compact title-tier pill (Patzer / Class D / Expert / Master / IM / GM).
/// Matches the web `.title-badge` styling — tiny upper-case label inside a
/// rounded rect tinted by the tier color.
struct TitleBadgeView: View {
    let label: String
    let tier: BadgeTier

    var body: some View {
        Text(label)
            .scaledFont(size: 10, weight: .heavy, design: .rounded)
            .kerning(0.6)
            .textCase(.uppercase)
            .foregroundStyle(tier.textColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(tier.color))
    }
}

#Preview {
    VStack(spacing: 8) {
        TitleBadgeView(label: "Patzer", tier: .low)
        TitleBadgeView(label: "Expert", tier: .exp)
        TitleBadgeView(label: "Master", tier: .m)
        TitleBadgeView(label: "International Master", tier: .im)
        TitleBadgeView(label: "Grandmaster", tier: .gm)
    }
    .padding()
    .background(Color.bgPage)
}
