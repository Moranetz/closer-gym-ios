import SwiftUI

struct PuzzleSolveView: View {
    // Mutable so "Next Puzzle" can swap the position in-place rather than
    // pushing an ever-deeper navigation stack. Only the first puzzle in a
    // session can be the Daily Drill.
    @State private var puzzle: Puzzle
    @State private var isDaily: Bool

    @EnvironmentObject private var storage: Store
    @Environment(\.dismiss) private var dismiss

    init(puzzle: Puzzle, isDaily: Bool) {
        _puzzle = State(initialValue: puzzle)
        _isDaily = State(initialValue: isDaily)
    }

    // Reveal flow state
    @State private var pickedDisplayIdx: Int? = nil
    @State private var revealed = false
    @State private var ratingChange: (delta: Double, newRating: Double, newStreak: Int)? = nil
    @State private var shakeWrong = false
    @State private var transcriptOpen: Bool = false
    @State private var promotedTo: String? = nil   // set when this solve crosses a title band
    @State private var verdict: Verdict? = nil     // move-quality classification (JUICE-DOCTRINE)
    @State private var feedbackWork: [DispatchWorkItem] = []   // cancellable deferred reveal cues

    private var transcript: Transcript? {
        guard let id = puzzle.transcriptId else { return nil }
        return Transcripts.get(id)
    }

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
        ScrollViewReader { proxy in
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Color.clear.frame(height: 0).id("top")
                header

                positionCard

                candidatesStack

                if revealed, let change = ratingChange, let v = verdict {
                    revealPanel(change: change, v: v)
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .onChange(of: puzzle.id) { _, _ in
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo("top", anchor: .top)
            }
        }
        .onDisappear { cancelFeedback() }
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
        }
        }
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
                        letter: String(UnicodeScalar(65 + min(displayIdx, 25))!),
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
    private func revealPanel(change: (delta: Double, newRating: Double, newStreak: Int), v: Verdict) -> some View {
        let outcomeColor: Color = v.color
        let title = titleForRating(change.newRating)

        VStack(alignment: .leading, spacing: 14) {
            // Verdict hero — the move classification IS the reward (JUICE-DOCTRINE §1).
            HStack(alignment: .center, spacing: 14) {
                Text(v.glyph)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(outcomeColor)
                    .frame(minWidth: 44)
                VStack(alignment: .leading, spacing: 3) {
                    Text(v.label)
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
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

            ConvictionBar(fill: v.convictionFill)

            if let promotedTo {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.up.circle.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.brandGreen)
                    Text("PROMOTED")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .kerning(0.8)
                        .foregroundStyle(Color.brandGreen)
                    Text("→ \(promotedTo)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 12).padding(.vertical, 9)
                .background(Color.brandGreen.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 9, style: .continuous).strokeBorder(Color.brandGreen.opacity(0.4), lineWidth: 1))
                .transition(.scale(scale: 0.9).combined(with: .opacity))
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

            if let t = transcript {
                Divider().background(Color.border).padding(.top, 4)
                Button {
                    Haptics.shared.light()
                    transcriptOpen = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "text.bubble.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.brandGreen)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Read full transcript").microLabel(Color.brandGreen)
                            Text("\(t.speaker): \(t.title)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.textSecondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.textFaint)
                    }
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(outcomeColor.opacity(0.4), lineWidth: 1.5))
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .sheet(isPresented: $transcriptOpen) {
            if let t = transcript {
                TranscriptSheet(transcript: t)
            }
        }
    }

    // MARK: - Logic

    private func handlePick(displayIdx: Int) {
        Haptics.shared.light()
        withAnimation(.snappy(duration: 0.18, extraBounce: 0)) {
            pickedDisplayIdx = displayIdx
        }

        let origIdx = displayOrder[displayIdx]
        let picked = puzzle.candidates[origIdx]
        let correct = origIdx == puzzle.bestIndex
        // Future content can flag the best candidate as a Fork/Sharp; absent flags, the
        // top achievable verdict is Best.
        let v = Verdict.from(pickedEval: picked.eval, isBestPick: correct)

        // Capture rating + title BEFORE the solve so we can detect a rank-up. (recordSolve
        // commits the new rating before it returns, so we must snapshot here.)
        let oldRating = storage.puzzleState.rating.rating
        let oldTitle = titleForRating(oldRating).label

        let result = storage.recordSolve(
            puzzleId: puzzle.id,
            pickedIndex: origIdx,
            bestIndex: puzzle.bestIndex,
            pickedEval: picked.eval,
            puzzleDifficulty: puzzle.difficulty,
            timeRemainingSec: 0,   // no time limit; field retained for storage compatibility
            isDaily: isDaily,
            todayKey: isDaily ? Store.todayKey() : nil
        )

        let newTitle = titleForRating(result.newRating).label
        let didPromote = correct && newTitle != oldTitle && result.newRating > oldRating
        promotedTo = didPromote ? newTitle : nil
        let hitStreakMilestone = correct && [3, 7, 14, 30, 100].contains(result.newStreak)

        // Verdict feedback — haptic ~14ms before the tone so they fuse (JUICE-DOCTRINE §4).
        // The verdict's own haptic/sound carry the asymmetry; a Fork gets an anticipation
        // lead. All deferred work is cancellable so a fast "Next" can't fire the prior
        // verdict's sound/haptic on the next puzzle.
        let lead = (v.weight == .hero) ? 0.30 : 0.10
        scheduleFeedback(after: lead)          { Haptics.shared.verdict(v) }
        scheduleFeedback(after: lead + 0.014)  { ToneSynth.shared.play(v) }

        // Asymmetric reveal: the Fork holds then lands; a Tell settles slow and low —
        // weight, not a punish-shake (the doctrine forbids shame-motion); routine snaps in.
        let revealDelay: Double = (v.weight == .hero) ? 0.42 : 0.20
        let revealAnim: Animation
        switch v.weight {
        case .hero:  revealAnim = .spring(response: 0.50, dampingFraction: 0.72)
        case .heavy: revealAnim = .spring(response: 0.55, dampingFraction: 0.95)   // slow, no overshoot
        default:     revealAnim = .spring(response: 0.40, dampingFraction: 0.78)
        }
        withAnimation(revealAnim.delay(revealDelay)) {
            revealed = true
            ratingChange = result
            verdict = v
        }

        // The rank-up / streak beats are the only extra celebration; the Fork already
        // celebrates via its own hero haptic, so don't stack a second cue on it.
        if didPromote && v != .fork {
            scheduleFeedback(after: 0.6)  { Haptics.shared.titlePromotion() }
        } else if hitStreakMilestone && v != .fork {
            scheduleFeedback(after: 0.55) { Haptics.shared.streakMilestone() }
        }
    }

    /// Deferred reveal feedback, cancellable on puzzle swap / disappear so stale sound or
    /// haptics never land on a different puzzle (Swift-audit HIGH fix).
    private func scheduleFeedback(after delay: Double, _ block: @escaping () -> Void) {
        let item = DispatchWorkItem(block: block)
        feedbackWork.append(item)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
    }

    private func cancelFeedback() {
        feedbackWork.forEach { $0.cancel() }
        feedbackWork.removeAll()
    }

    private func advanceToNext() {
        // Adaptive next-puzzle pick: prefer an unsolved puzzle within +/-200 ELO
        // of the user's current puzzle rating. Falls back to sequential cycle if
        // no match exists (very early in user history or after exhaustion).
        let userRating = Int(storage.puzzleState.rating.rating)
        let solvedIds: Set<String> = Set(storage.puzzleState.solves.filter(\.correct).map(\.puzzleId))
        let inBand = Puzzles.all.filter { p in
            p.id != puzzle.id &&
            !solvedIds.contains(p.id) &&
            abs(p.difficulty - userRating) <= 200
        }
        let next: Puzzle
        if let candidate = inBand.min(by: { abs($0.difficulty - userRating) < abs($1.difficulty - userRating) }) {
            next = candidate
        } else if let i = Puzzles.all.firstIndex(where: { $0.id == puzzle.id }) {
            next = Puzzles.all[(i + 1) % Puzzles.all.count]
        } else {
            next = Puzzles.all[0]
        }
        loadPuzzle(next)
    }

    /// Swap the current position in-place and reset the full reveal flow.
    /// Avoids pushing a new view per puzzle (which previously did nothing because
    /// no value-based navigationDestination was registered) and keeps the back
    /// button returning to the puzzle index rather than a deep stack.
    private func loadPuzzle(_ p: Puzzle) {
        cancelFeedback()   // kill any in-flight reveal cues from the puzzle we're leaving
        withAnimation(.easeInOut(duration: 0.2)) {
            revealed = false
            ratingChange = nil
        }
        pickedDisplayIdx = nil
        shakeWrong = false
        transcriptOpen = false
        promotedTo = nil
        verdict = nil
        isDaily = false              // only the entry puzzle can be the Daily Drill
        puzzle = p                   // drives displayOrder + onChange scroll-to-top
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

/// The eval bar, sales-style: your conviction fills from the left, the buyer's from the
/// right. It animates from even (0.5) to the move's implied state on reveal — the advantage
/// is paid out visually (JUICE-DOCTRINE §2).
private struct ConvictionBar: View {
    let fill: Double          // 0…1 — your conviction
    @State private var animated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.bgRail)
                    Capsule()
                        .fill(LinearGradient(colors: [.brandGreenDeep, .brandGreen],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * (animated ? fill : 0.5))
                }
            }
            .frame(height: 7)
            .overlay(Capsule().strokeBorder(Color.border, lineWidth: 1))
            HStack {
                Text("BUYER").font(.system(size: 8, weight: .heavy, design: .rounded)).kerning(0.5).foregroundStyle(Color.textFaint)
                Spacer()
                Text("YOU").font(.system(size: 8, weight: .heavy, design: .rounded)).kerning(0.5).foregroundStyle(Color.textFaint)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.85).delay(0.15)) { animated = true }
        }
    }
}
