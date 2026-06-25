import SwiftUI

struct PuzzlesTab: View {
    @EnvironmentObject private var storage: Store

    var body: some View {
        NavigationStack {
            PuzzleIndexView()
        }
    }
}

// MARK: - Index

struct PuzzleIndexView: View {
    @EnvironmentObject private var storage: Store
    @State private var expanded: Set<PuzzleTheme> = [.budget]

    private var dailyPuzzle: Puzzle {
        let id = Puzzles.dailyId()
        return Puzzles.get(id) ?? Puzzles.all[0]
    }

    private var themes: [PuzzleTheme] {
        // Stable order — matches web
        [.budget, .procurement, .stall, .renewal, .multistakeholder, .endgame, .coldOpen]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                statsHeader

                dailyHero

                ForEach(themes, id: \.self) { theme in
                    themeSection(theme)
                }

                Text("\(Puzzles.all.count) hand-authored positions calibrated against the Atlas literature. Adaptive difficulty + Puzzle Rush roll out with v1.1. Solving is fully offline, no API key required.")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.textFaint)
                    .lineSpacing(2)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
            }
        }
        .background(Color.bgPage)
        .navigationTitle("Puzzles")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
    }

    // MARK: - Stats header

    private var statsHeader: some View {
        let s = storage.puzzleState
        let title = titleForRating(s.rating.rating)
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                statCard(label: "Puzzle rating", value: "\(Int(s.rating.rating))", badge: TitleBadgeView(label: title.label.replacingOccurrences(of: " Closer", with: ""), tier: title.tier))
                statCard(label: "Current streak", value: "\(storage.effectiveCurrentStreak)d", accent: storage.effectiveCurrentStreak > 0 ? .brandGreen : nil)
                statCard(label: "Longest streak", value: "\(s.longestStreak)d")
                statCard(label: "Solved", value: "\(s.solves.filter(\.correct).count)")
            }
            .padding(.horizontal, 16)
        }
    }

    private func statCard(label: String, value: String, badge: TitleBadgeView? = nil, accent: Color? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).microLabel()
            HStack(spacing: 6) {
                Text(value)
                    .font(AppFont.tabular)
                    .foregroundStyle(accent ?? .textPrimary)
                if let badge { badge }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(minWidth: 130, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    // MARK: - Daily hero

    @ViewBuilder
    private var dailyHero: some View {
        if storage.dailyAttemptedToday {
            // One attempt per calendar day — show a completed state instead of a
            // live link so the daily can't be re-rolled for a clean streak.
            dailyHeroCard(done: true)
                .padding(.horizontal, 16)
        } else {
            NavigationLink(destination: PuzzleSolveView(puzzle: dailyPuzzle, isDaily: true)) {
                dailyHeroCard(done: false)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
        }
    }

    private func dailyHeroCard(done: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text("Daily Drill").microLabel(Color.brandGreen)
                Text(Store.todayKey())
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.textMuted)
                    .monospacedDigit()
            }
            Text(dailyPuzzle.theme.label)
                .font(AppFont.title)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)
            Text("\(dailyPuzzle.buyerRole) · ELO \(dailyPuzzle.difficulty)")
                .font(.system(size: 13))
                .foregroundStyle(Color.textSecondary)
            Text("“\(dailyPuzzle.buyerLine)”")
                .font(.system(size: 13))
                .italic()
                .foregroundStyle(Color.textMuted)
                .lineLimit(2)
            if done {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 13))
                    Text("Done today · back tomorrow")
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                }
                .foregroundStyle(Color.textMuted)
                .padding(.horizontal, 14).padding(.vertical, 10)
                .background(Capsule().fill(Color.bgRail))
            } else {
                Text("Solve today's drill")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(.bgPage)
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(Capsule().fill(Color.brandGreen))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: [.bgPanel, .bgRail], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(dailyPuzzle.theme.tint)
                .frame(width: 6)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
        .opacity(done ? 0.85 : 1.0)
    }

    // MARK: - Theme section

    @ViewBuilder
    private func themeSection(_ theme: PuzzleTheme) -> some View {
        let inTheme = Puzzles.all.filter { $0.theme == theme }
        if !inTheme.isEmpty {
            let solved = inTheme.filter { storage.isSolved($0.id) }.count
            let binding = Binding<Bool>(
                get: { expanded.contains(theme) },
                set: { newValue in
                    Haptics.shared.selection()
                    if newValue { expanded.insert(theme) } else { expanded.remove(theme) }
                }
            )
            DisclosureGroup(isExpanded: binding) {
                VStack(spacing: 8) {
                    ForEach(inTheme) { p in
                        NavigationLink(destination: PuzzleSolveView(puzzle: p, isDaily: false)) {
                            puzzleRow(p)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
            } label: {
                HStack(spacing: 8) {
                    Text(theme.label).microLabel(theme.tint)
                    Spacer()
                    if solved > 0 {
                        Text("\(solved)/\(inTheme.count)")
                            .font(.system(size: 11, weight: .heavy, design: .rounded))
                            .foregroundStyle(.brandGreen)
                            .monospacedDigit()
                    } else {
                        Text("\(inTheme.count) position\(inTheme.count == 1 ? "" : "s")")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.textMuted)
                            .monospacedDigit()
                    }
                }
                .padding(.bottom, 6)
                .overlay(alignment: .bottom) {
                    Rectangle().fill(theme.tint.opacity(0.25)).frame(height: 2)
                }
            }
            .tint(theme.tint)
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }

    private func puzzleRow(_ p: Puzzle) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(p.id.uppercased())
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .kerning(0.5)
                        .foregroundStyle(Color.textFaint)
                    Text("ELO \(p.difficulty)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.textMuted)
                        .monospacedDigit()
                    Text(difficultyTier(p.difficulty).rawValue)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.textMuted)
                        .textCase(.uppercase)
                        .kerning(0.4)
                    if storage.isSolved(p.id) {
                        Image(systemName: "checkmark.circle.fill").font(.system(size: 11)).foregroundStyle(.brandGreen)
                    }
                }
                Text(p.buyerRole)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
                Text("“\(p.buyerLine)”")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textMuted)
                    .italic()
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right").font(.system(size: 12, weight: .bold)).foregroundStyle(Color.textFaint)
        }
        .padding(14)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }
}
