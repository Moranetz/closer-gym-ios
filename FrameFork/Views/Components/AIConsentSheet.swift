import SwiftUI

/// App Store Guideline 5.1.2(i) consent gate. Shown once, before the FIRST turn of a rep's
/// first live game (or the first blind-judge grade), and again any time `AIConsent` has been
/// revoked from Settings. Names the provider, the exact data types sent, and the path the data
/// takes — no marketing language.
struct AIConsentSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Before your first live game")
                    .font(AppFont.titleSmall)
                    .foregroundStyle(Color.textPrimary)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Live games and the AI coach run on Anthropic, the maker of Claude.")
                        .scaledFont(size: 14)
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(3)

                    bulletRow("The lines you type in a live game.")
                    bulletRow("The buyer's replies and the rest of that game's transcript.")
                    bulletRow("Your Company Profile, if you filled one in.")

                    Text("This goes directly from your phone to Anthropic, using your own API key. Anthropic bills you for it. Frame & Fork runs no server of its own and never sees this data.")
                        .scaledFont(size: 13)
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(3)

                    Text("Offline sparring, puzzles, lessons, and master games send nothing anywhere.")
                        .scaledFont(size: 13)
                        .foregroundStyle(Color.textMuted)
                        .lineSpacing(3)
                }

                VStack(spacing: 10) {
                    PrimaryButton(title: "Send my lines to Anthropic", symbol: "arrow.up.right", isEnabled: true, style: .green) {
                        AIConsent.grant()
                        dismiss()
                    }
                    SecondaryButton(title: "Not now", symbol: nil) {
                        dismiss()
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.bgPage)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func bulletRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .scaledFont(size: 14, weight: .bold)
                .foregroundStyle(Color.brandGreen)
            Text(text)
                .scaledFont(size: 14)
                .foregroundStyle(Color.textPrimary)
                .lineSpacing(3)
        }
    }
}
