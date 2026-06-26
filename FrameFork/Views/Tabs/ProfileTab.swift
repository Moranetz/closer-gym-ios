import SwiftUI

struct ProfileTab: View {
    @EnvironmentObject private var storage: Store

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    identityCard
                    ratingsCard
                    if !storage.gameState.games.isEmpty { gameHistoryCard }
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

    /// Subtle "Add to LinkedIn": shares the rendered Closer Card image + a caption through the
    /// native share sheet, where LinkedIn is one tap. This is the RELIABLE path — LinkedIn does
    /// not support a prefilled-image deep link from a third-party app, and its /feed/?text= deep
    /// link does not reliably populate the composer, so a URL-only link would be a dead-end flex.
    /// The share sheet carries the actual rating card (the flex) and always works.
    @ViewBuilder
    private var addToLinkedInLink: some View {
        let rating = storage.puzzleState.rating.rating
        let streak = storage.effectiveCurrentStreak
        let longest = storage.puzzleState.longestStreak
        let solved = storage.puzzleState.solves.filter(\.correct).count
        if let url = ShareCardRenderer.render(rating: rating, streak: streak, longestStreak: longest, solveCount: solved) {
            ShareLink(item: url,
                      message: Text(linkedInCaption(rating: rating)),
                      preview: SharePreview("Frame & Fork — \(titleForRating(rating).label)")) {
                HStack(spacing: 5) {
                    Image(systemName: "arrow.up.forward").font(.system(size: 10, weight: .bold))
                    Text("Add to LinkedIn").font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(Color(red: 0.04, green: 0.40, blue: 0.76))   // subtle LinkedIn blue
            }
            .padding(.top, 4)
        }
    }

    private func linkedInCaption(rating: Double) -> String {
        let title = titleForRating(rating).label
        return "I'm sharpening my closing reflexes on Frame & Fork — currently \(title) (\(Int(rating))). It pits you against AI buyers that fight back, then grades the craft. https://moranetz.github.io/apps/frame-fork/"
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
        let puzzle = storage.puzzleState.rating.rating
        let games = storage.gameState.games
        return VStack(alignment: .leading, spacing: 12) {
            Text("Ratings").microLabel()
            ratingRow("Game", value: games.isEmpty ? "—" : "\(Int(storage.gameState.rating.rating))",
                      note: games.isEmpty ? "Play a role-play to start" : "\(games.count) game\(games.count == 1 ? "" : "s") vs personas")
            Divider().background(Color.border)
            ratingRow("Puzzle", value: "\(Int(puzzle))", note: "Provisional")
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var gameHistoryCard: some View {
        let games = Array(storage.gameState.games.suffix(12).reversed())
        return VStack(alignment: .leading, spacing: 10) {
            Text("Game history").microLabel(Color.brandGreen)
            ForEach(Array(games.enumerated()), id: \.offset) { _, g in
                NavigationLink { GameHistoryDetailView(record: g) } label: { gameHistoryRow(g) }
                    .buttonStyle(.plain)
                if g.playedAt != games.last?.playedAt { Divider().background(Color.border) }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private func gameHistoryRow(_ g: GameRecord) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(Personas.get(g.personaId)?.role ?? g.personaId)
                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.textPrimary).lineLimit(1)
                Text(g.judgment?.verdict ?? "Scored on live read")
                    .font(.system(size: 11)).foregroundStyle(Color.textMuted).lineLimit(1)
            }
            Spacer(minLength: 8)
            if let j = g.judgment {
                Text("\(Int((j.fill * 100).rounded()))")
                    .font(.system(size: 15, weight: .heavy, design: .rounded)).monospacedDigit()
                    .foregroundStyle(gradeColor(j.fill))
            }
            Image(systemName: "chevron.right").font(.system(size: 11, weight: .bold)).foregroundStyle(Color.textFaint)
        }
        .padding(.vertical, 7)
        .contentShape(Rectangle())
    }

    private func gradeColor(_ s: Double) -> Color {
        if s >= 0.7 { return .brandGreen }
        if s >= 0.45 { return .warning }
        return .danger
    }

    private var freeProCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Free vs Pro").microLabel(Color.brandGreen)
            Text("Free: Puzzles, Lessons, Master Games. No API key required.")
                .font(.system(size: 13)).foregroundStyle(Color.textSecondary).lineSpacing(2)
            Text("Pro: Bot ladder (\(BotLadder.all.count) personas) + free-text play. Requires your own Anthropic key in Settings.")
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
