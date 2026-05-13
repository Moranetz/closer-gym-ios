import SwiftUI

struct PlayTab: View {
    @EnvironmentObject private var storage: Store
    @State private var hasKey: Bool = Keychain.hasAPIKey()

    var body: some View {
        NavigationStack {
            BotLadderView(hasKey: $hasKey)
                .onAppear { hasKey = Keychain.hasAPIKey() }
        }
    }
}

struct BotLadderView: View {
    @Binding var hasKey: Bool
    @EnvironmentObject private var storage: Store

    private let tiers: [(name: String, min: Int, max: Int)] = [
        ("Beginner",     1200, 1499),
        ("Intermediate", 1500, 1799),
        ("Advanced",     1800, 2099),
        ("Expert",       2100, 2299),
        ("Grandmaster",  2300, 9999),
    ]

    private var playerRating: Int {
        // Game rating bucket. For v0 we use the puzzle rating as the placement.
        Int(storage.puzzleState.rating.rating)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if !hasKey {
                    proLockedBanner
                }

                Text("Pick an opponent. 15 adversarial buyer personas, ELO 1200 to 2400. Beat one tier to unlock the next.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(3)
                    .padding(.horizontal, 16)

                ForEach(tiers, id: \.name) { tier in
                    let inTier = BotLadder.all.filter { $0.rating >= tier.min && $0.rating <= tier.max }
                    if !inTier.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(tier.name).microLabel(Color.textSecondary)
                                Spacer()
                                Text("ELO \(tier.min)–\(min(tier.max, 2400))")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(Color.textMuted)
                                    .monospacedDigit()
                            }
                            .padding(.bottom, 4)
                            .overlay(alignment: .bottom) {
                                Rectangle().fill(Color.border).frame(height: 1).offset(y: 4)
                            }

                            VStack(spacing: 8) {
                                ForEach(inTier) { bot in
                                    let unlocked = BotLadder.isUnlocked(bot, playerRating: playerRating) && hasKey
                                    NavigationLink(destination: PreGameView(botMeta: bot)) {
                                        botRow(bot: bot, unlocked: unlocked)
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(!unlocked)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                    }
                }

                Spacer(minLength: 32)
            }
        }
        .background(Color.bgPage)
        .navigationTitle("Play")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
    }

    private var proLockedBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.warning)
                Text("Pro tier locked").font(.system(size: 15, weight: .bold)).foregroundStyle(Color.textPrimary)
                Spacer()
            }
            Text("The bot ladder requires an Anthropic API key. Add yours in Settings to unlock all 15 personas. Each game costs roughly $0.50 on your key.")
                .font(.system(size: 13))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(3)
            NavigationLink(destination: SettingsView()) {
                HStack(spacing: 6) {
                    Image(systemName: "gearshape.fill").font(.system(size: 12))
                    Text("Open Settings").font(.system(size: 13, weight: .bold))
                }
                .foregroundStyle(Color.bgPage)
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Color.warning)
                .clipShape(Capsule())
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.warning.opacity(0.4), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 16)
    }

    private func botRow(bot: BotMeta, unlocked: Bool) -> some View {
        let persona = Personas.get(bot.personaId)
        let initials = persona.map { $0.role.split(separator: " ").prefix(2).map { String($0.first ?? Character("?")) }.joined().uppercased() } ?? "??"
        return HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color.bgPanel)
                Text(initials)
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(unlocked ? Color.textPrimary : Color.textFaint)
            }
            .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("\(bot.rating)").font(.system(size: 13, weight: .heavy, design: .rounded)).monospacedDigit().foregroundStyle(unlocked ? Color.textPrimary : Color.textFaint)
                    if let p = persona {
                        Text("Track \(p.track.rawValue.dropFirst())").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.textMuted)
                        Text("·").foregroundStyle(Color.textFaint)
                        Text(p.track.label).font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.textMuted)
                    }
                    if !unlocked { Image(systemName: "lock.fill").font(.system(size: 10)).foregroundStyle(Color.textFaint) }
                }
                Text(persona?.role ?? bot.personaId).font(.system(size: 14, weight: .bold)).foregroundStyle(unlocked ? Color.textPrimary : Color.textMuted).lineLimit(1)
                Text(bot.oneLineTagline).font(.system(size: 11)).foregroundStyle(Color.textMuted).lineSpacing(2).lineLimit(2)
            }
            Spacer()
            if unlocked {
                Image(systemName: "chevron.right").font(.system(size: 11, weight: .bold)).foregroundStyle(Color.textFaint)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
        .opacity(unlocked ? 1.0 : 0.55)
    }
}
