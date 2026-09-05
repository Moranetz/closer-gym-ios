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
    // Debug/screenshot hooks (same pattern as FF_INITIAL_TAB / FF_PUSH_MISSES).
    // FF_PUSH_PREGAME=<personaId> deep-links a pregame screen for headless verification.
    @State private var path: [PlayRoute] = {
        if ProcessInfo.processInfo.environment["FF_PUSH_SPARRING"] == "1" {
            return BotLadder.all.first.map { [.sparring($0)] } ?? []
        }
        if let pid = ProcessInfo.processInfo.environment["FF_PUSH_PREGAME"],
           let bot = BotLadder.get(pid) {
            return [.preGame(bot)]
        }
        // Fleet round 109 (2026-09-05): the live game itself had no hook, so the one screen a
        // Pro subscriber actually plays on had never been captured, and neither had any of the
        // five things it says when the API refuses. FF_PUSH_LIVE=<personaId>.
        if let pid = ProcessInfo.processInfo.environment["FF_PUSH_LIVE"],
           let bot = BotLadder.get(pid) {
            return [.live(bot, [])]
        }
        return []
    }()

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

    #if DEBUG
    // Debug/screenshot hook (same pattern as FF_AUTO_REVEAL): FF_SCROLL_BOTTOM=1
    // scrolls the ladder to the "Bring your own key" footer right after landing,
    // so the footer can be captured without a real drag (sim taps are TCC-walled /
    // no accessibility labels to drive by name). No effect in Release — never
    // reachable outside DEBUG.
    private let debugScrollBottom = ProcessInfo.processInfo.environment["FF_SCROLL_BOTTOM"] == "1"
    #endif

    private let tiers: [(name: String, min: Int, max: Int, rule: Color)] = [
        ("Beginner",     1200, 1499, .badgeLow),
        ("Intermediate", 1500, 1799, .badgeExp),
        ("Advanced",     1800, 2099, .badgeM),
        ("Expert",       2100, 2299, .badgeIM),
        ("Grandmaster",  2300, 9999, .badgeGM),
    ]

    private var playerRating: Int {
        // Game rating bucket. For v0 we use the puzzle rating as the placement.
        Int(storage.puzzleState.rating.rating)
    }

    var body: some View {
        ScrollViewReader { proxy in
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Pick an opponent from \(BotLadder.all.count) buyers, ELO \(BotLadder.all.first?.rating ?? 1200) to \(BotLadder.all.last?.rating ?? 2400). Beat one and the next 200 ELO of the ladder opens up.")
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
                                        botRow(bot: bot, unlocked: unlocked, ruleColor: tier.rule)
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

                if !hasKey {
                    proLockedFooter
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .id("play-footer")
                }

                Color.clear.frame(height: 8).id("play-bottom")
                Spacer(minLength: 32)
            }
        }
        .background(Color.bgPage)
        .navigationTitle("Play")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        #if DEBUG
        .onAppear {
            if debugScrollBottom {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    proxy.scrollTo("play-bottom", anchor: .bottom)
                }
            }
        }
        #endif
        }
    }

    private var proLockedFooter: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bring your own key").scaledFont(size: 13, weight: .bold).foregroundStyle(Color.textSecondary)
            Text("Sparring against these buyers works offline, no key or account needed. To chat freely with all \(BotLadder.all.count) buyers, add your own Anthropic key in Settings. Anthropic bills you directly for that usage.")
                .scaledFont(size: 12)
                .foregroundStyle(Color.textMuted)
                .lineSpacing(3)
            NavigationLink(destination: SettingsView()) {
                HStack(spacing: 6) {
                    Image(systemName: "gearshape.fill").scaledFont(size: 11)
                    Text("Open Settings").scaledFont(size: 12, weight: .semibold)
                }
                .foregroundStyle(Color.textSecondary)
                .padding(.horizontal, 12).padding(.vertical, 7)
                .background(Color.bgPanel)
                .overlay(Capsule().strokeBorder(Color.border, lineWidth: 1))
                .clipShape(Capsule())
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func botRow(bot: BotMeta, unlocked: Bool, ruleColor: Color) -> some View {
        let persona = Personas.get(bot.personaId)
        return HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(unlocked ? ruleColor : Color.textFaint)
                .frame(width: 4)
                .frame(maxHeight: .infinity)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("\(bot.rating)").scaledFont(size: 13, weight: .heavy, design: .rounded).monospacedDigit().foregroundStyle(unlocked ? Color.textPrimary : Color.textFaint)
                    if let p = persona {
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
