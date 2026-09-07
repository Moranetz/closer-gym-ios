import SwiftUI

/// First-run onboarding. Three screens, swipeable TabView, page indicators,
/// brand-green CTA. Saves a hasSeenOnboarding flag to UserDefaults so it
/// never reappears unless data is cleared.
struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var page: Int = {
        #if DEBUG
        // The card is sized by what it holds, so pages two and three must be photographed too.
        if let raw = ProcessInfo.processInfo.environment["FF_ONB_PAGE"], let n = Int(raw) { return n }
        #endif
        return 0
    }()

    /// Round 157: three grounds for the first screen a stranger sees, so the choice is made on
    /// the real screen rather than in the head. 0 flat page colour (what it was), 1 the drawn
    /// board every other page stands on, 2 one lit square of it, enlarged. DEBUG only.
    private var groundStyle: Int {
        #if DEBUG
        if let raw = ProcessInfo.processInfo.environment["FF_ONB_GROUND"], let n = Int(raw) { return n }
        #endif
        return 1
    }

    private var ground: AnyView {
        switch groundStyle {
        case 0:
            return AnyView(Color.pageGround.ignoresSafeArea())
        case 2:
            return AnyView(ZStack {
                Color.pageGround.ignoresSafeArea()
                RoundedRectangle(cornerRadius: 2)
                    .fill(World.current.isWorld ? World.current.panel : Color.panelGround)
                    .frame(width: 320, height: 320)
                    .rotationEffect(.degrees(-6))
                    .shadow(color: .black.opacity(0.25), radius: 18, x: 6, y: 10)
                    .offset(y: -120)
            })
        default:
            return AnyView(WorldGround().ignoresSafeArea())
        }
    }

    @EnvironmentObject private var storage: Store

    /// Round 168. First run read three pages of prose — about 120 words — before a stranger
    /// touched a position, then put them on a list of fourteen buyers with no idea which to
    /// open. Value-first onboarding says let them have the thing before it is explained, and
    /// this app's thing is a rated position that takes two minutes.
    ///
    /// `FF_FIRSTRUN` renders the three shapes that were compared:
    ///   0  one page, then the drill opens itself     (ships)
    ///   1  three pages, then the drill opens itself
    ///   2  three pages, then the puzzle list          (what shipped before)
    private var firstRunShape: Int {
        #if DEBUG
        return CaptureHooks.value("FF_FIRSTRUN").flatMap { Int($0) } ?? 0
        #else
        return 0
        #endif
    }
    private var pageCount: Int { firstRunShape == 0 ? 1 : 3 }
    private var opensDrill: Bool { firstRunShape != 2 }

    var body: some View {
        ZStack {
            ground

            VStack(spacing: 0) {
                TabView(selection: $page) {
                    pageOne.tag(0)
                    if pageCount == 3 {
                        pageTwo.tag(1)
                        pageThree.tag(2)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.snappy, value: page)

                pageIndicator
                    .padding(.bottom, 16)

                buttons
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }
        }
        // A fullScreenCover does not inherit the root's scheme, so on the board the status bar
        // stayed light-content and the clock sat white on light wood.
        .preferredColorScheme(World.current.isWorld ? .light : .dark)
    }

    // MARK: - Pages

    private var pageOne: some View {
        OnboardingPage(
            symbol: "♞",
            symbolSize: 96,
            tag: "Rated positions for the sales call",
            title: "A sparring app for sales.",
            bodyLines: [
                "A buyer says \u{201C}send me something in writing.\u{201D} Fourteen personas will test you like that, live. Every move earns an ELO that only climbs when you're right.",
                "There's no cheat code for a live buyer. You get the position and whatever you say next.",
            ]
        )
    }

    private var pageTwo: some View {
        OnboardingPage(
            symbol: "◇",
            symbolSize: 80,
            tag: "How it works",
            title: "Solve. Learn. Climb.",
            bodyLines: [
                "Solve wrong and the app names the exact technique you missed. It's one of forty, linked straight to the real transcript where it worked.",
                "Watch hand-authored deal studies drawn from Voss, Gap Selling, Challenger, Klaff, and Burg, plus two cautionary breakdowns of high-pressure tactics. Fully offline, no API key needed.",
            ]
        )
    }

    private var pageThree: some View {
        OnboardingPage(
            symbol: "▶",
            symbolSize: 72,
            tag: "Start now",
            title: "Today's Daily Drill is open.",
            bodyLines: [
                "Solve at your own pace. Your puzzle rating and your game rating climb separately, so one rough night against a live buyer never touches your puzzle streak.",
                "When you're ready, connect your own Anthropic API key in Settings and the bot ladder runs on your account.",
            ]
        )
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { i in
                Capsule()
                    .fill(i == page ? Color.accentInk : Color.borderStrong)
                    .frame(width: i == page ? 24 : 8, height: 8)
                    .animation(.snappy, value: page)
            }
        }
    }

    private var buttons: some View {
        VStack(spacing: 10) {
            PrimaryButton(
                title: page < pageCount - 1 ? "Next" : "Solve a position",
                symbol: page < pageCount - 1 ? "arrow.right" : "play.fill",
                isEnabled: true,
                style: .green
            ) {
                if page < pageCount - 1 {
                    withAnimation(.snappy) { page += 1 }
                } else {
                    completeOnboarding()
                }
            }
            if page > 0 {
                Button("Back") {
                    withAnimation(.snappy) { page -= 1 }
                    Haptics.shared.selection()
                }
                .scaledFont(size: 13, weight: .semibold)
                .foregroundStyle(World.current.isWorld ? World.current.inkMuted : Color.textMuted)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(World.current.isWorld ? World.current.rail : Color.clear)
                )
            } else {
                Button("Skip") {
                    completeOnboarding()
                }
                .scaledFont(size: 13, weight: .semibold)
                // On the board this sat on bare wood at the faintest tier in the app, and a
                // chequer has two grounds: the same ink measured Lc 62.1 on a maple square and
                // 22.1 on a walnut one, so where it could be read depended on where it landed.
                // It carries its own square now, and stays quiet by being small.
                .foregroundStyle(World.current.isWorld ? World.current.inkMuted : Color.textFaint)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(World.current.isWorld ? World.current.rail : Color.clear)
                )
            }
        }
    }

    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "framefork:hasSeenOnboarding:v1")
        // The drill opens itself once, on the first launch after onboarding. A stranger's first
        // act in this app is solving a position, not choosing one from fourteen.
        if opensDrill { UserDefaults.standard.set(true, forKey: FirstRun.openDrillKey) }
        Haptics.shared.success()
        withAnimation(.snappy) {
            isPresented = false
        }
    }
}

private struct OnboardingPage: View {
    let symbol: String
    let symbolSize: CGFloat
    let tag: String
    let title: String
    let bodyLines: [String]
    /// Round 157: on the drawn board, body text ran across light and dark squares and the dark
    /// ones ate it. The page's words sit on a card of the world's own material now — the same
    /// card every other screen in this app uses — sized by what it holds.
    var onCard: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            if !onCard || !World.current.isWorld { Spacer() }
            Text(symbol)
                .scaledFont(size: symbolSize, weight: .heavy)
                .foregroundStyle(Color.accentInk)
                .padding(.bottom, 36)

            Text(tag.uppercased())
                .scaledFont(size: 11, weight: .heavy, design: .rounded)
                .kerning(0.8)
                .foregroundStyle(Color.accentInk)
                .padding(.bottom, 8)

            Text(title)
                .scaledFont(size: 32, weight: .heavy, design: .rounded)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 20)

            VStack(spacing: 14) {
                ForEach(bodyLines, id: \.self) { line in
                    Text(line)
                        .scaledFont(size: 15)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                }
            }

            if !onCard || !World.current.isWorld {
                Spacer()
                Spacer()
            }
        }
        .modifier(OnboardingCard(active: onCard && World.current.isWorld))
        .frame(maxHeight: .infinity)
    }
}

/// The card the onboarding words stand on when the app is in a world.
private struct OnboardingCard: ViewModifier {
    let active: Bool
    func body(content: Content) -> some View {
        if active {
            content
                .padding(.vertical, 28)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(World.current.panel)
                        .shadow(color: .black.opacity(0.22), radius: 12, x: 4, y: 8)
                )
                .padding(.horizontal, 18)
        } else {
            content
        }
    }
}
