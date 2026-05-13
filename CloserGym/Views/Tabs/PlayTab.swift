import SwiftUI

struct PlayTab: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    StubBanner(
                        title: "Bot Ladder — Pro",
                        subtitle: "15 adversarial buyer bots, ELO 1200–2400. Free-text play, live eval bar, blunder markers post-game.",
                        cta: "Requires Anthropic API key",
                        symbol: "lock.shield.fill"
                    )

                    InfoCard(
                        title: "What you'll do",
                        bullets: [
                            "Pick an opponent from a 1200–2400 ELO ladder",
                            "Pre-register the Atlas techniques you intend to deploy",
                            "Run a live conversation; eval bar moves per turn",
                            "Post-game: blunder markers + engine alternatives + Glicko-2 rating change"
                        ]
                    )

                    InfoCard(
                        title: "Why Pro",
                        bullets: [
                            "Buyer responses come from Claude — open-ended, in character",
                            "Live detector tags your moves with Atlas techniques as you play",
                            "Cost is ~$0.50/game on your key",
                            "Hosted Pro tier arrives in v0.2"
                        ]
                    )

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(Color.bgPage)
            .navigationTitle("Play")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.bgPage, for: .navigationBar)
        }
    }
}

// MARK: - Stub banner

struct StubBanner: View {
    let title: String
    let subtitle: String
    let cta: String
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: symbol)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.brandGreen)
                Text(title)
                    .font(AppFont.titleSmall)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
            }
            Text(subtitle)
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(2)
            Text(cta)
                .font(AppFont.microLabel)
                .foregroundStyle(Color.warning)
                .padding(.top, 4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [.bgPanel, .bgRail], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }
}

struct InfoCard: View {
    let title: String
    let bullets: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).microLabel()
            ForEach(bullets, id: \.self) { b in
                HStack(alignment: .top, spacing: 8) {
                    Circle().fill(Color.brandGreen).frame(width: 4, height: 4).padding(.top, 7)
                    Text(b).font(.system(size: 14)).foregroundStyle(Color.textSecondary).lineSpacing(2)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }
}
