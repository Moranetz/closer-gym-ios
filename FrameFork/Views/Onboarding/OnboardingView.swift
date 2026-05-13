import SwiftUI

/// First-run onboarding. Three screens, swipeable TabView, page indicators,
/// brand-green CTA. Saves a hasSeenOnboarding flag to UserDefaults so it
/// never reappears unless data is cleared.
struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var page = 0
    @EnvironmentObject private var storage: Store

    var body: some View {
        ZStack {
            Color.bgPage.ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $page) {
                    pageOne.tag(0)
                    pageTwo.tag(1)
                    pageThree.tag(2)
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
        .preferredColorScheme(.dark)
    }

    // MARK: - Pages

    private var pageOne: some View {
        OnboardingPage(
            symbol: "♛",
            symbolSize: 96,
            tag: "The gym for closers",
            title: "Chess.com, for sales.",
            bodyLines: [
                "Fifteen adversarial buyer bots. Glicko-2 closing ELO. Eval bar per move, blunder markers, opening repertoire.",
                "Cluely is the cheat code. We built the gym.",
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
                "Daily Drill puzzles in 30 seconds. 35 Atlas techniques cross-linked to every puzzle, transcript, and master move.",
                "Watch real-call replays from Voss, Klaff, Belfort, Cardone, Tracy. Free tier is fully offline, no API key needed.",
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
                "Solve in 30 seconds. Climb the Glicko-2 ladder. Three rating buckets: Game, Puzzle, Analysis.",
                "When you're ready, drop your Anthropic API key in Settings to unlock the bot ladder.",
            ]
        )
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(i == page ? Color.brandGreen : Color.borderStrong)
                    .frame(width: i == page ? 24 : 8, height: 8)
                    .animation(.snappy, value: page)
            }
        }
    }

    private var buttons: some View {
        VStack(spacing: 10) {
            PrimaryButton(
                title: page < 2 ? "Next" : "Start solving",
                symbol: page < 2 ? "arrow.right" : "play.fill",
                isEnabled: true,
                style: .green
            ) {
                if page < 2 {
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
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.textMuted)
            } else {
                Button("Skip") {
                    completeOnboarding()
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.textFaint)
            }
        }
    }

    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "framefork:hasSeenOnboarding:v1")
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

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(symbol)
                .font(.system(size: symbolSize, weight: .heavy))
                .foregroundStyle(Color.brandGreen)
                .padding(.bottom, 36)

            Text(tag.uppercased())
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .kerning(0.8)
                .foregroundStyle(Color.brandGreen)
                .padding(.bottom, 8)

            Text(title)
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 20)

            VStack(spacing: 14) {
                ForEach(bodyLines, id: \.self) { line in
                    Text(line)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                }
            }

            Spacer()
            Spacer()
        }
    }
}
