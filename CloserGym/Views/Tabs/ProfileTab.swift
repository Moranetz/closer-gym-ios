import SwiftUI

struct ProfileTab: View {
    @EnvironmentObject private var storage: Store

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
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape").foregroundStyle(Color.textSecondary)
                    }
                }
            }
        }
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

            Text("\(solveCount) puzzles solved · \(storage.puzzleState.currentStreak)-day streak · longest \(storage.puzzleState.longestStreak)")
                .font(.system(size: 12))
                .foregroundStyle(Color.textMuted)
                .monospacedDigit()
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
            Text("Pro: Bot ladder (15 personas) + free-text play. Requires Anthropic key in Settings. Hosted Pro tier arrives in v0.2.")
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
            Text("closer.gym v0.1")
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
