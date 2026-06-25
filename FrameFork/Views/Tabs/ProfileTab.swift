import SwiftUI

struct ProfileTab: View {
    @EnvironmentObject private var storage: Store
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    identityCard
                    ratingsCard
                    freeProCard
                    foundationFooter
                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(Color.bgPage)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.bgPage, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    shareCardButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape").foregroundStyle(Color.textSecondary)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var shareCardButton: some View {
        let rating = storage.puzzleState.rating.rating
        let streak = storage.effectiveCurrentStreak
        let longest = storage.puzzleState.longestStreak
        let solved = storage.puzzleState.solves.filter(\.correct).count

        if let url = ShareCardRenderer.render(rating: rating, streak: streak, longestStreak: longest, solveCount: solved) {
            ShareLink(item: url, preview: SharePreview("My Frame & Fork rating: \(Int(rating))")) {
                Image(systemName: "square.and.arrow.up").foregroundStyle(Color.textSecondary)
            }
        }
    }

    /// Subtle, LinkedIn-direct flex: opens LinkedIn's post composer pre-filled with the rep's
    /// real rating + title (the image-card share via the toolbar covers the visual flex). The URL
    /// opens the LinkedIn app via universal link if installed, else LinkedIn on the web — either
    /// way it functions. (Verified: well-formed URL via URLComponents; the text pre-fill is
    /// LinkedIn's composer behavior — confirm the pre-fill on a real device.)
    @ViewBuilder
    private var addToLinkedInLink: some View {
        if let url = linkedInShareURL() {
            Button {
                Haptics.shared.light()
                openURL(url)
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "arrow.up.forward").font(.system(size: 10, weight: .bold))
                    Text("Add to LinkedIn").font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(Color(red: 0.04, green: 0.40, blue: 0.76))   // subtle LinkedIn blue
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
    }

    private func linkedInShareURL() -> URL? {
        let rating = Int(storage.puzzleState.rating.rating)
        let title = titleForRating(storage.puzzleState.rating.rating).label
        let text = "I'm sharpening my closing reflexes on Frame & Fork — currently \(title) (\(rating)). It pits you against AI buyers that fight back, then grades the craft. https://moranetz.github.io/apps/frame-fork/"
        var comps = URLComponents(string: "https://www.linkedin.com/feed/")
        comps?.queryItems = [
            URLQueryItem(name: "shareActive", value: "true"),
            URLQueryItem(name: "text", value: text),
        ]
        return comps?.url
    }

    // MARK: - Cards

    private var identityCard: some View {
        let rating = storage.puzzleState.rating.rating
        let title = titleForRating(rating)
        let solveCount = storage.puzzleState.solves.filter(\.correct).count

        return VStack(spacing: 12) {
            Circle()
                .fill(Color.brandGreen)
                .frame(width: 80, height: 80)
                .overlay(Image(systemName: "person.crop.circle.fill").font(.system(size: 48)).foregroundStyle(Color.bgPage))

            Text("You").font(AppFont.titleSmall).foregroundStyle(Color.textPrimary)

            HStack(spacing: 8) {
                Text("\(Int(rating))").font(AppFont.tabularLg).foregroundStyle(Color.textPrimary)
                TitleBadgeView(label: title.label.replacingOccurrences(of: " Closer", with: ""), tier: title.tier)
            }

            Text("\(solveCount) puzzles solved · \(storage.effectiveCurrentStreak)-day streak · longest \(storage.puzzleState.longestStreak)")
                .font(.system(size: 12))
                .foregroundStyle(Color.textMuted)
                .monospacedDigit()

            addToLinkedInLink
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var ratingsCard: some View {
        let rating = storage.puzzleState.rating.rating
        return VStack(alignment: .leading, spacing: 12) {
            Text("Ratings").microLabel()
            ratingRow("Game",     value: "—", note: "Pro · vs bots")
            Divider().background(Color.border)
            ratingRow("Puzzle",   value: "\(Int(rating))", note: "Provisional")
            Divider().background(Color.border)
            ratingRow("Analysis", value: "—", note: "Pro · uploaded calls")
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var freeProCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Free vs Pro").microLabel(Color.brandGreen)
            Text("Free: Puzzles, Lessons, Master Games. No API key required.")
                .font(.system(size: 13)).foregroundStyle(Color.textSecondary).lineSpacing(2)
            Text("Pro: Bot ladder (\(BotLadder.all.count) personas) + free-text play. Requires Anthropic key in Settings. Hosted Pro tier arrives in v0.2.")
                .font(.system(size: 13)).foregroundStyle(Color.textSecondary).lineSpacing(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var foundationFooter: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Closer Foundation").microLabel()
            Text("Frame & Fork · v1.0")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.textSecondary)
            Text("Cluely is the cheat code. We built the gym.")
                .italic()
                .font(.system(size: 13))
                .foregroundStyle(Color.textMuted)
        }
        .padding(.horizontal, 4)
        .padding(.top, 8)
    }

    private func ratingRow(_ name: String, value: String, note: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name).font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.textPrimary)
                Text(note).font(.system(size: 11)).foregroundStyle(Color.textFaint)
            }
            Spacer()
            Text(value).font(AppFont.tabular).foregroundStyle(Color.textPrimary)
        }
    }
}
