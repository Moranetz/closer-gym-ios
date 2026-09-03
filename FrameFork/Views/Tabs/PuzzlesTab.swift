import SwiftUI

struct PuzzlesTab: View {
    @EnvironmentObject private var storage: Store
    // Debug/screenshot hook (same pattern as FF_INITIAL_TAB): sim taps are often
    // TCC-walled, so automation pushes the miss queue via env var instead.
    @State private var showMisses = ProcessInfo.processInfo.environment["FF_PUSH_MISSES"] == "1"

    #if DEBUG
    // Debug/screenshot hook: FF_OPEN_PUZZLE=<id> opens that puzzle's PuzzleSolveView on
    // launch so the read step can be photographed without tapping through the index
    // (the sim has no accessibility labels to drive by name). No effect in Release —
    // never reachable outside DEBUG, and a bad/missing id is just a no-op.
    @State private var debugOpenPuzzle: Puzzle? = {
        guard let id = ProcessInfo.processInfo.environment["FF_OPEN_PUZZLE"] else { return nil }
        return Puzzles.get(id)
    }()
    #endif

    var body: some View {
        NavigationStack {
            // The destination is registered at STACK level and driven by state, so the
            // Misses card can appear/disappear freely without popping a presented queue.
            PuzzleIndexView(showMisses: $showMisses)
                .navigationDestination(isPresented: $showMisses) { MissReviewView() }
                #if DEBUG
                .navigationDestination(item: $debugOpenPuzzle) { p in
                    PuzzleSolveView(puzzle: p, isDaily: false)
                }
                #endif
        }
    }
}

// MARK: - Index

struct PuzzleIndexView: View {
    @EnvironmentObject private var storage: Store
    @Environment(\.sizeCategory) private var sizeCategory
    @Binding var showMisses: Bool
    @State private var expanded: Set<PuzzleTheme> = [.budget]

    private var dailyPuzzle: Puzzle {
        let id = Puzzles.dailyId()
        return Puzzles.get(id) ?? Puzzles.all[0]
    }

    private var themes: [PuzzleTheme] {
        // Stable order — matches web
        [.budget, .procurement, .stall, .renewal, .multistakeholder, .endgame, .coldOpen, .salesAssist, .forecastCall]
    }

    var body: some View {
        ScrollViewReader { proxy in
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                statsHeader

                dailyHero

                weaknessRow(proxy: proxy)

                // One solved-set for all ~100 rows — per-row isSolved is O(solves) each.
                let solvedIds = storage.solvedIdSet
                ForEach(themes, id: \.self) { theme in
                    themeSection(theme, solvedIds: solvedIds)
                        .id(theme)
                }

                Text("\(Puzzles.all.count) hand-authored positions built straight from the Atlas plays. Solving is fully offline, no API key required.")
                    .scaledFont(size: 11)
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
    }

    // MARK: - Weakest-theme pull

    /// themeStats() is weakest-first; only pull once the sample is real (≥4
    /// attempts) and there's genuine headroom (<80%) — never nag a clean slate.
    private var weakestTheme: Store.ThemeStat? {
        storage.themeStats().first { $0.attempts >= 4 && $0.rate < 0.8 }
    }

    @ViewBuilder
    private func weaknessRow(proxy: ScrollViewProxy) -> some View {
        if let weak = weakestTheme {
            Button {
                Haptics.shared.selection()
                expanded.insert(weak.theme)
                withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                    proxy.scrollTo(weak.theme, anchor: .top)
                }
            } label: {
                HStack(spacing: 10) {
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.bgRail)
                        Capsule().fill(Color.warning)
                            .frame(width: 34 * max(0.08, weak.rate))
                    }
                    .frame(width: 34, height: 5)
                    // Labels run long ("Procurement gauntlet") — keep the stat clause
                    // terse so nothing truncates at two lines.
                    (Text("\(weak.theme.label) is your weakest theme")
                        .scaledFont(size: 13, weight: .bold, sizeCategory: sizeCategory)
                        .foregroundStyle(Color.textPrimary)
                     + Text(" — \(Int((weak.rate * 100).rounded()))% · \(weak.attempts) tries")
                        .scaledFont(size: 12, sizeCategory: sizeCategory)
                        .foregroundStyle(Color.textSecondary))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 8)
                    Text("Drill →")
                        .scaledFont(size: 12, weight: .heavy, design: .rounded)
                        .foregroundStyle(Color.brandGreen)
                }
                .padding(.horizontal, 13)
                .padding(.vertical, 11)
                .background(Color.bgPanel)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Stats header

    private var statsHeader: some View {
        let s = storage.puzzleState
        let title = titleForRating(s.rating.rating)
        let isProvisional = s.rating.isProvisional
        let solvedCount = storage.solvedUniqueCount
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                statCard(label: "Puzzle rating", value: "\(Int(s.rating.rating))",
                         // Not yet a class letter until the RD has come down — see
                         // isProvisional (same gate as Profile).
                         badge: TitleBadgeView(label: isProvisional ? "Provisional" : title.label.replacingOccurrences(of: " Closer", with: ""),
                                                tier: isProvisional ? .low : title.tier))
                missesCard
                if solvedCount == 0 {
                    // Day one: a streak that never started isn't a stat, it's two
                    // zeros. Show what's actually true — today's drill count — instead.
                    todayCard
                } else {
                    statCard(label: "Current streak", value: "\(storage.effectiveCurrentStreak)d", accent: storage.effectiveCurrentStreak > 0 ? .brandGreen : nil)
                    statCard(label: "Longest streak", value: "\(s.longestStreak)d")
                }
                statCard(label: "Solved", value: "\(solvedCount)")
            }
            .padding(.horizontal, 16)
        }
    }

    /// Live miss-queue stat — appears only while misses are waiting. The queue
    /// (`missedPuzzleIds`) is oldest-first and a miss re-solves for full rating,
    /// so this is the one header stat that's also a call to action.
    @ViewBuilder
    private var missesCard: some View {
        let missCount = storage.missedPuzzleIds.count
        if missCount > 0 {
            Button {
                Haptics.shared.selection()
                showMisses = true
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Misses").microLabel(Color.warning)
                    HStack(spacing: 6) {
                        Text("\(missCount)")
                            .scaledFont(size: 16, weight: .bold, design: .rounded).monospacedDigit()
                            .foregroundStyle(Color.warning)
                        Text("review →")
                            .scaledFont(size: 11, weight: .semibold)
                            .foregroundStyle(Color.textFaint)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(minWidth: 130, alignment: .leading)
                .background(Color.bgPanel)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.warning.opacity(0.45), lineWidth: 1))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }

    /// Day-one replacement for the streak pair: a streak that never started reads
    /// as two zeros, not a stat. Shows today's drill count once there is one, else a
    /// plain line saying what starts the rating moving.
    private var todayCard: some View {
        let drillsToday = storage.puzzleState.solves.filter { Calendar.current.isDateInToday($0.solvedAt) }.count
        let line = firstRunDrillLine(drillsToday: drillsToday)
        return VStack(alignment: .leading, spacing: 4) {
            Text("Today").microLabel()
            Text(line)
                .scaledFont(size: drillsToday > 0 ? 16 : 12, weight: drillsToday > 0 ? .bold : .semibold, design: .rounded)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(width: 190, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private func statCard(label: String, value: String, badge: TitleBadgeView? = nil, accent: Color? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).microLabel()
            HStack(spacing: 6) {
                Text(value)
                    .scaledFont(size: 16, weight: .bold, design: .rounded).monospacedDigit()
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

    private var dailyHero: some View {
        // One attempt per calendar day — disabled (not removed) once attempted. The link
        // must stay in the hierarchy: `recordSolve` stamps the attempt at pick time, and
        // removing the link here while its destination is presented pops the user out of
        // the solve before the reveal ever lands.
        NavigationLink(destination: PuzzleSolveView(puzzle: dailyPuzzle, isDaily: true)) {
            dailyHeroCard(done: storage.dailyAttemptedToday)
        }
        .buttonStyle(.plain)
        .disabled(storage.dailyAttemptedToday)
        .padding(.horizontal, 16)
    }

    private func dailyHeroCard(done: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text("Daily Drill").microLabel(Color.brandGreen)
                Text(Store.todayKey())
                    .scaledFont(size: 11, weight: .semibold)
                    .foregroundStyle(Color.textMuted)
                    .monospacedDigit()
            }
            Text(dailyPuzzle.theme.label)
                .scaledFont(size: 22, weight: .heavy, design: .rounded)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)
            Text("\(dailyPuzzle.buyerRole) · ELO \(dailyPuzzle.difficulty)")
                .scaledFont(size: 13)
                .foregroundStyle(Color.textSecondary)
            Text("“\(dailyPuzzle.buyerLine)”")
                .scaledFont(size: 13)
                .italic()
                .foregroundStyle(Color.textMuted)
                .lineLimit(2)
            if done {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill").scaledFont(size: 13)
                    Text("Done today · back tomorrow")
                        .scaledFont(size: 14, weight: .heavy, design: .rounded)
                }
                .foregroundStyle(Color.textMuted)
                .padding(.horizontal, 14).padding(.vertical, 10)
                .background(Capsule().fill(Color.bgRail))
            } else {
                Text("Solve today's drill")
                    .scaledFont(size: 14, weight: .heavy, design: .rounded)
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
    private func themeSection(_ theme: PuzzleTheme, solvedIds: Set<String>) -> some View {
        let inTheme = Puzzles.all.filter { $0.theme == theme }
        if !inTheme.isEmpty {
            let solved = inTheme.filter { solvedIds.contains($0.id) }.count
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
                            .scaledFont(size: 11, weight: .heavy, design: .rounded)
                            .foregroundStyle(.brandGreen)
                            .monospacedDigit()
                    } else {
                        Text("\(inTheme.count) position\(inTheme.count == 1 ? "" : "s")")
                            .scaledFont(size: 11, weight: .semibold)
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
                    Text("ELO \(p.difficulty)")
                        .scaledFont(size: 10, weight: .semibold)
                        .foregroundStyle(Color.textMuted)
                        .monospacedDigit()
                    Text(difficultyTier(p.difficulty).rawValue)
                        .scaledFont(size: 10, weight: .semibold)
                        .foregroundStyle(Color.textMuted)
                        .textCase(.uppercase)
                        .kerning(0.4)
                    if storage.isSolved(p.id) {
                        Image(systemName: "checkmark.circle.fill").scaledFont(size: 11).foregroundStyle(.brandGreen)
                    }
                }
                Text(p.buyerRole)
                    .scaledFont(size: 14, weight: .semibold)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
                Text("“\(p.buyerLine)”")
                    .scaledFont(size: 12)
                    .foregroundStyle(Color.textMuted)
                    .italic()
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right").scaledFont(size: 12, weight: .bold).foregroundStyle(Color.textFaint)
        }
        .padding(14)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }
}
