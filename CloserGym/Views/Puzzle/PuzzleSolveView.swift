import SwiftUI

struct PuzzleSolveView: View {
    let puzzle: Puzzle
    let isDaily: Bool

    @EnvironmentObject private var storage: Store
    @Environment(\.dismiss) private var dismiss

    // Reveal flow state
    @State private var pickedDisplayIdx: Int? = nil
    @State private var revealed = false
    @State private var secondsLeft: Int = 30
    @State private var timer: Timer? = nil
    @State private var ratingChange: (delta: Double, newRating: Double, newStreak: Int)? = nil
    @State private var shakeWrong = false
    @State private var startedAt: Date = .now

    private static let timerSec = 30

    // Deterministic display shuffle keyed by puzzle.id.
    private var displayOrder: [Int] {
        var idxs = Array(puzzle.candidates.indices)
        var seed: UInt64 = 0
        for c in puzzle.id.unicodeScalars { seed = seed &* 31 &+ UInt64(c.value) }
        var rng = SeededRNG(seed: seed)
        idxs.shuffle(using: &rng)
        return idxs
    }

    private var bestDisplayIdx: Int? {
        displayOrder.firstIndex(of: puzzle.bestIndex)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header

                positionCard

                candidatesStack

                if revealed, let change = ratingChange {
                    revealPanel(change: change)
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color.bgPage.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Text(puzzle.theme.label.uppercased())
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .kerning(0.6)
                        .foregroundStyle(puzzle.theme.tint)
                    Text("·  ELO \(puzzle.difficulty)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.textMuted)
                        .monospacedDigit()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                if !revealed { timerPill }
            }
        }
        .onAppear {
            startedAt = .now
            startTimer()
        }
        .onDisappear { timer?.invalidate() }
    }

    // MARK: - Header

    @ViewBuilder
    private var header: some View {
        if isDaily {
            HStack(spacing: 8) {
                Text("Daily Drill").microLabel(Color.brandGreen)
                Text(Store.todayKey())
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.textMuted)
                    .monospacedDigit()
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Position card

    private var positionCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Position · \(puzzle.buyerRole)").microLabel()
                Spacer()
            }
            Text(puzzle.setup)
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(3)

            HStack {
                Rectangle().fill(puzzle.theme.tint).frame(width: 3).cornerRadius(2)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Buyer says").microLabel()
                    Text("“\(puzzle.buyerLine)”")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .italic()
                        .foregroundStyle(Color.textPrimary)
                        .lineSpacing(3)
                }
                .padding(.leading, 8)
            }
            .padding(.top, 4)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [.bgPanel, .bgRail], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    // MARK: - Candidates stack

    private var candidatesStack: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(revealed ? "Choose your move · results" : "Choose your move").microLabel()

            VStack(spacing: 10) {
                ForEach(Array(displayOrder.enumerated()), id: \.offset) { displayIdx, origIdx in
                    PuzzleCandidateButton(
                        candidate: puzzle.candidates[origIdx],
                        letter: ["A", "B", "C", "D"][displayIdx],
                        isPicked: pickedDisplayIdx == displayIdx,
                        isBest: revealed && origIdx == puzzle.bestIndex,
                        isWrongPicked: revealed && pickedDisplayIdx == displayIdx && origIdx != puzzle.bestIndex,
                        revealed: revealed,
                        shake: shakeWrong && pickedDisplayIdx == displayIdx
                    ) {
                        guard !revealed else { return }
                        handlePick(displayIdx: displayIdx)
                    }
                }
            }
        }
    }

    // MARK: - Reveal panel

    @ViewBuilder
    private func revealPanel(change: (delta: Double, newRating: Double, newStreak: Int)) -> some View {
        let correct = pickedDisplayIdx == bestDisplayIdx
        let outcomeColor: Color = correct ? .brandGreen : .danger
        let title = titleForRating(change.newRating)

        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(outcomeColor)
                VStack(alignment: .leading, spacing: 2) {
                    Text(correct ? "Solved" : "Missed")
                        .font(AppFont.titleSmall)
                        .foregroundStyle(outcomeColor)
                    HStack(spacing: 8) {
                        Text("\(change.delta >= 0 ? "+" : "")\(Int(change.delta.rounded())) ELO")
                            .font(AppFont.tabular)
                            .foregroundStyle(change.delta >= 0 ? .brandGreen : .danger)
                        Text("· \(Int(change.newRating))").font(AppFont.tabular).foregroundStyle(Color.textMuted)
                        TitleBadgeView(label: title.label.replacingOccurrences(of: " Closer", with: ""), tier: title.tier)
                    }
                }
                Spacer()
                if isDaily {
                    VStack(spacing: 2) {
                        Image(systemName: "flame.fill").font(.system(size: 18)).foregroundStyle(Color.warning)
                        Text("\(change.newStreak)d").font(AppFont.tabular).foregroundStyle(Color.textPrimary)
                    }
                }
            }

            if let hint = puzzle.themeHint {
                Divider().background(Color.border)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Theme").microLabel(Color.brandGreen)
                    Text(hint).font(.system(size: 13)).foregroundStyle(Color.textSecondary).italic().lineSpacing(2)
                }
            }

            HStack(spacing: 10) {
                PrimaryButton(title: "Next Puzzle", symbol: "arrow.right", isEnabled: true, style: .green) {
                    advanceToNext()
                }
                SecondaryButton(title: "Back", symbol: "chevron.left") {
                    dismiss()
                }
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(outcomeColor.opacity(0.4), lineWidth: 1.5))
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: - Timer pill

    private var timerPill: some View {
        let danger = secondsLeft <= 10
        return Text(String(format: "%02ds", secondsLeft))
            .font(.system(size: 16, weight: .heavy, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(Color.textPrimary)
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(Capsule().fill(danger ? Color.danger : Color.borderStrong))
            .overlay(Capsule().strokeBorder(danger ? Color.danger : Color.borderStrong, lineWidth: 1))
    }

    // MARK: - Logic

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { t in
            Task { @MainActor in
                let elapsed = Date.now.timeIntervalSince(startedAt)
                let remaining = max(0, Int(ceil(Double(Self.timerSec) - elapsed)))
                if remaining != secondsLeft {
                    if remaining <= 5 && remaining > 0 && remaining < secondsLeft {
                        Haptics.shared.selection()
                    }
                    secondsLeft = remaining
                }
                if remaining == 0 && !revealed && pickedDisplayIdx == nil {
                    t.invalidate()
                    handleTimeout()
                }
            }
        }
    }

    private func handlePick(displayIdx: Int) {
        Haptics.shared.light()
        withAnimation(.snappy(duration: 0.18, extraBounce: 0)) {
            pickedDisplayIdx = displayIdx
        }

        let origIdx = displayOrder[displayIdx]
        let picked = puzzle.candidates[origIdx]
        let correct = origIdx == puzzle.bestIndex
        let elapsed = Date.now.timeIntervalSince(startedAt)
        let remaining = max(0, Int(ceil(Double(Self.timerSec) - elapsed)))

        let result = storage.recordSolve(
            puzzleId: puzzle.id,
            pickedIndex: origIdx,
            bestIndex: puzzle.bestIndex,
            pickedEval: picked.eval,
            puzzleDifficulty: puzzle.difficulty,
            timeRemainingSec: remaining,
            isDaily: isDaily,
            todayKey: isDaily ? Store.todayKey() : nil
        )

        timer?.invalidate()

        // Haptic + reveal sequence
        if correct {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                Haptics.shared.success()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                Haptics.shared.error()
            }
            withAnimation(.linear(duration: 0.08).repeatCount(4, autoreverses: true)) {
                shakeWrong = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
                shakeWrong = false
            }
        }

        withAnimation(.spring(response: 0.40, dampingFraction: 0.78).delay(0.20)) {
            revealed = true
            ratingChange = result
        }

        // Streak milestone celebration (3/7/14/30 etc.)
        if correct && [3, 7, 14, 30, 100].contains(result.newStreak) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                Haptics.shared.streakMilestone()
            }
        }
    }

    private func handleTimeout() {
        Haptics.shared.error()
        // Record as wrong (picked = -1 sentinel, fallback to first display)
        let result = storage.recordSolve(
            puzzleId: puzzle.id,
            pickedIndex: -1,
            bestIndex: puzzle.bestIndex,
            pickedEval: 0,
            puzzleDifficulty: puzzle.difficulty,
            timeRemainingSec: 0,
            isDaily: isDaily,
            todayKey: isDaily ? Store.todayKey() : nil
        )
        withAnimation(.spring(response: 0.40, dampingFraction: 0.78)) {
            revealed = true
            ratingChange = result
        }
    }

    private func advanceToNext() {
        guard let i = Puzzles.all.firstIndex(where: { $0.id == puzzle.id }) else { return }
        let next = Puzzles.all[(i + 1) % Puzzles.all.count]
        // Replace current screen with next puzzle by navigating.
        // The cleanest pattern is to pop + push the next; for simplicity,
        // reset state in-place if the puzzle is different.
        // Better: dismiss + open from list. For v0, dismiss; the user navigates back to the list.
        // Use NavigationLink-via-push:
        navigateTo = next
    }

    @State private var navigateTo: Puzzle? = nil

    private var hiddenNavLink: some View {
        // Trigger programmatic navigation when navigateTo is set.
        Group {
            if let p = navigateTo {
                NavigationLink(value: p) { EmptyView() }
                    .opacity(0)
            }
        }
    }
}

// Seeded RNG for deterministic shuffle by puzzle id.
struct SeededRNG: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { self.state = seed == 0 ? 1 : seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
