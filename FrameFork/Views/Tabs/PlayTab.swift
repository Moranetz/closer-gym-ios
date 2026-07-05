import SwiftUI

/// Routes for the Play flow. Value-based navigation so the post-game review's
/// "Done" can pop the whole stack back to the ladder in one transition instead
/// of dismissing onto the now-dead finished game screen.
enum PlayRoute: Hashable {
    case preGame(BotMeta)
    case live(BotMeta, [String])
    case sparring(BotMeta)
    case review(ReviewPayload)
}

struct ReviewPayload: Hashable {
    let botMeta: BotMeta
    let intentTechniques: [String]
    let firedTechniques: [String]
    let evalCurve: [Double]
    let score: Double           // local eval-derived fallback score
    let durationSec: Int
    let transcript: [StoredTurn]
}

struct PlayTab: View {
    @EnvironmentObject private var storage: Store
    @State private var hasKey: Bool = Keychain.hasAPIKey()
    // Debug/screenshot hook (same pattern as FF_INITIAL_TAB / FF_PUSH_MISSES).
    @State private var path: [PlayRoute] =
        ProcessInfo.processInfo.environment["FF_PUSH_SPARRING"] == "1"
            ? BotLadder.all.first.map { [.sparring($0)] } ?? []
            : []

    var body: some View {
        NavigationStack(path: $path) {
            BotLadderView(hasKey: $hasKey, path: $path)
                .onAppear { hasKey = Keychain.hasAPIKey() }
                .navigationDestination(for: PlayRoute.self) { route in
                    switch route {
                    case .preGame(let bot):
                        PreGameView(botMeta: bot, path: $path)
                    case .live(let bot, let intent):
                        LiveGameView(botMeta: bot, intentTechniques: intent, path: $path)
                    case .sparring(let bot):
                        SparringView(botMeta: bot, path: $path)
                    case .review(let payload):
                        SimpleReviewView(payload: payload, path: $path)
                    }
                }
        }
    }
}

struct BotLadderView: View {
    @Binding var hasKey: Bool
    @Binding var path: [PlayRoute]
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

                Text("Pick an opponent. \(BotLadder.all.count) adversarial buyer personas, ELO \(BotLadder.all.first?.rating ?? 1200) to \(BotLadder.all.last?.rating ?? 2400). Win rating to unlock bots up to 200 above you.")
                    .scaledFont(size: 13)
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
                                    .scaledFont(size: 11, weight: .semibold)
                                    .foregroundStyle(Color.textMuted)
                                    .monospacedDigit()
                            }
                            .padding(.bottom, 4)
                            .overlay(alignment: .bottom) {
                                Rectangle().fill(Color.border).frame(height: 1).offset(y: 4)
                            }

                            VStack(spacing: 8) {
                                ForEach(inTier) { bot in
                                    // Arc personas are playable OFFLINE — no key needed.
                                    let unlocked = BotLadder.isUnlocked(bot, playerRating: playerRating)
                                        && (hasKey || Arcs.get(personaId: bot.personaId) != nil)
                                    NavigationLink(value: PlayRoute.preGame(bot)) {
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
                    .scaledFont(size: 18)
                    .foregroundStyle(Color.warning)
                Text("Bring your own key").scaledFont(size: 15, weight: .bold).foregroundStyle(Color.textPrimary)
                Spacer()
            }
            Text("Sparring vs authored buyers works offline — no key, no account. For free-text play against all \(BotLadder.all.count) personas, connect your own Anthropic key in Settings; usage is billed by Anthropic, not by this app.")
                .scaledFont(size: 13)
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(3)
            NavigationLink(destination: SettingsView()) {
                HStack(spacing: 6) {
                    Image(systemName: "gearshape.fill").scaledFont(size: 12)
                    Text("Open Settings").scaledFont(size: 13, weight: .bold)
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
                    .scaledFont(size: 14, weight: .heavy, design: .rounded)
                    .foregroundStyle(unlocked ? Color.textPrimary : Color.textFaint)
            }
            .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("\(bot.rating)").scaledFont(size: 13, weight: .heavy, design: .rounded).monospacedDigit().foregroundStyle(unlocked ? Color.textPrimary : Color.textFaint)
                    if let p = persona {
                        Text("Track \(p.track.rawValue.dropFirst())").scaledFont(size: 10, weight: .semibold).foregroundStyle(Color.textMuted).lineLimit(1).minimumScaleFactor(0.75)
                        Text("·").foregroundStyle(Color.textFaint)
                        Text(p.track.label).scaledFont(size: 10, weight: .semibold).foregroundStyle(Color.textMuted).lineLimit(1).minimumScaleFactor(0.75)
                    }
                    if !unlocked { Image(systemName: "lock.fill").scaledFont(size: 10).foregroundStyle(Color.textFaint) }
                }
                Text(persona?.role ?? bot.personaId).scaledFont(size: 14, weight: .bold).foregroundStyle(unlocked ? Color.textPrimary : Color.textMuted).lineLimit(1)
                Text(bot.oneLineTagline).scaledFont(size: 11).foregroundStyle(Color.textMuted).lineSpacing(2).lineLimit(2)
            }
            Spacer()
            if unlocked {
                Image(systemName: "chevron.right").scaledFont(size: 11, weight: .bold).foregroundStyle(Color.textFaint)
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
