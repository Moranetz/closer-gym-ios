import SwiftUI

struct PuzzleSolveView: View {
    // Mutable so "Next Puzzle" can swap the position in-place rather than
    // pushing an ever-deeper navigation stack. Only the first puzzle in a
    // session can be the Daily Drill.
    #if DEBUG
    @State private var debugDidPick = false
    #endif
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
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
    // Read-step state (ported from framefork-game.html) — only touched when
    // puzzle.read != nil; every existing puzzle behaves exactly as before.
    @State private var readSelectedDisplayIdx: Int? = nil
    @State private var readCommitted = false
    @State private var confidence: Int? = nil   // 0 Hunch, 1 Fairly sure, 2 Certain
    // Element order matches Store.recordSolve's return so assignment doesn't implicitly reorder
    // (that reorder is a deprecation warning → future error). Access is by label, so callers are unaffected.
    @State private var ratingChange: (newRating: Double, delta: Double, newStreak: Int, rated: Bool)? = nil
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

    // MARK: - Read step

    private var hasRead: Bool { puzzle.read != nil }

    // Deterministic display shuffle for the read options, keyed by puzzle id so
    // option position never carries the answer (mirrors the HTML's seededOrder).
    private var readDisplayOrder: [Int] {
        guard let read = puzzle.read else { return [] }
        var idxs = Array(read.options.indices)
        var seed: UInt64 = 0
        for c in (puzzle.id + "|read").unicodeScalars { seed = seed &* 31 &+ UInt64(c.value) }
        var rng = SeededRNG(seed: seed)
        idxs.shuffle(using: &rng)
        return idxs
    }

    /// Whether the committed read named the actual driver (`isKey`). nil until a read
    /// puzzle's read has been committed.
    private var readHeld: Bool? {
        guard let read = puzzle.read, let displayIdx = readSelectedDisplayIdx else { return nil }
        let origIdx = readDisplayOrder[displayIdx]
        return read.options[origIdx].isKey
    }

    var body: some View {
        ScrollViewReader { proxy in
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Color.clear.frame(height: 0).id("top")
                header

                positionCard

                if hasRead && !readCommitted {
                    readPhaseBlock
                } else {
                    candidatesStack

                    if hasRead && !revealed {
                        confidenceRow
                        PrimaryButton(title: "Make the move", symbol: "arrow.right",
                                      isEnabled: pickedDisplayIdx != nil && confidence != nil,
                                      style: .green) {
                            if let idx = pickedDisplayIdx { handlePick(displayIdx: idx) }
                        }
                    }
                }

                if revealed, let change = ratingChange, let v = verdict {
                    revealPanel(change: change, v: v).id("reveal")
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
        // Fleet round 105 (2026-09-05): the first capture ever taken of this screen showed
        // the payoff off screen. Making the move computes the verdict, the rating delta, the
        // streak and any promotion, and then left the viewport wherever it was, so the answer
        // to "what did that cost me" sat below the fold. It comes to the reader now. The delay
        // lets the panel exist before it is scrolled to; the animation is skipped under
        // Reduce Motion, where a jump is the honest behaviour.
        .onChange(of: revealed) { _, isRevealed in
            guard isRevealed else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                if reduceMotion {
                    proxy.scrollTo("reveal", anchor: .top)
                } else {
                    withAnimation(.easeOut(duration: 0.35)) {
                        proxy.scrollTo("reveal", anchor: .top)
                    }
                }
            }
        }
        #if DEBUG
        // Debug/screenshot hook (same pattern as FF_OPEN_PUZZLE): FF_SOLVE_PICK=best|wrong
        // drives a real solve so the reveal panel can be photographed. The app's emotional
        // payoff, the screen a daily user hits every day, had never been captured once,
        // because there was no way to reach it without tapping. It calls handlePick, so the
        // rating, verdict, streak and promotion are all computed the way a player's tap
        // computes them. No effect in Release.
        .task {
            // Fires once per view, never per appearance: a second run would replay the same
            // puzzle, and a replay is unrated, so the panel would read "Unrated practice"
            // beside a rating that had visibly moved. An instrument that stages a defect is
            // worse than no instrument.
            guard !debugDidPick,
                  let want = ProcessInfo.processInfo.environment["FF_SOLVE_PICK"],
                  let best = bestDisplayIdx else { return }
            debugDidPick = true
            try? await Task.sleep(for: .milliseconds(700))
            readCommitted = true
            confidence = 1
            let idx = want == "wrong"
                ? (displayOrder.indices.first { $0 != best } ?? best)
                : best
            handlePick(displayIdx: idx)
        }
        #endif
        .onDisappear { cancelFeedback() }
        .background(Color.bgPage.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Text(puzzle.theme.label.uppercased())
                        .scaledFont(size: 11, weight: .heavy, design: .rounded)
                        .kerning(0.6)
                        .foregroundStyle(puzzle.theme.tint)
                    Text("·  ELO \(puzzle.difficulty)")
                        .scaledFont(size: 11, weight: .semibold)
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
                    .scaledFont(size: 11, weight: .semibold)
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
                .scaledFont(size: 14)
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(3)

            HStack {
                Rectangle().fill(puzzle.theme.tint).frame(width: 3).cornerRadius(2)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Buyer says").microLabel()
                    Text("“\(puzzle.buyerLine)”")
                        .scaledFont(size: 18, weight: .bold, design: .rounded)
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
                        if hasRead {
                            // Read puzzles gate on confidence too — select only, "Make
                            // the move" commits (mirrors the HTML's showMoveOptions()).
                            Haptics.shared.light()
                            withAnimation(.snappy(duration: 0.18, extraBounce: 0)) {
                                pickedDisplayIdx = displayIdx
                            }
                        } else {
                            handlePick(displayIdx: displayIdx)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Read phase

    @ViewBuilder
    private var readPhaseBlock: some View {
        if let read = puzzle.read {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(read.question)
                        .scaledFont(size: 16, weight: .bold, design: .rounded)
                        .foregroundStyle(Color.textPrimary)
                    Text(read.sub)
                        .scaledFont(size: 12)
                        .foregroundStyle(Color.textMuted)
                }

                VStack(spacing: 10) {
                    ForEach(Array(readDisplayOrder.enumerated()), id: \.offset) { displayIdx, origIdx in
                        ReadOptionButton(
                            option: read.options[origIdx],
                            letter: String(UnicodeScalar(65 + min(displayIdx, 25))!),
                            isPicked: readSelectedDisplayIdx == displayIdx
                        ) {
                            Haptics.shared.light()
                            withAnimation(.snappy(duration: 0.18, extraBounce: 0)) {
                                readSelectedDisplayIdx = displayIdx
                            }
                        }
                    }
                }

                PrimaryButton(title: "Commit your read", symbol: "checkmark", isEnabled: readSelectedDisplayIdx != nil, style: .green) {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        readCommitted = true
                    }
                }
            }
        }
    }

    // MARK: - Confidence row

    private var confidenceRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How sure are you?").microLabel()
            HStack(spacing: 8) {
                confidenceButton(0, title: "Hunch", sub: "guessing")
                confidenceButton(1, title: "Fairly sure", sub: "lean")
                confidenceButton(2, title: "Certain", sub: "locked")
            }
        }
    }

    private func confidenceButton(_ c: Int, title: String, sub: String) -> some View {
        let isSel = confidence == c
        return Button {
            Haptics.shared.light()
            withAnimation(.snappy(duration: 0.15, extraBounce: 0)) { confidence = c }
        } label: {
            VStack(spacing: 2) {
                Text(title).scaledFont(size: 12, weight: .bold, design: .rounded)
                Text(sub).scaledFont(size: 10).foregroundStyle(isSel ? Color.brandGreen.opacity(0.8) : Color.textFaint)
            }
            .foregroundStyle(isSel ? Color.brandGreen : Color.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSel ? Color.brandGreen.opacity(0.16) : Color.bgPanel)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(isSel ? Color.brandGreen : Color.border, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Reveal panel

    @ViewBuilder
    private func revealPanel(change: (newRating: Double, delta: Double, newStreak: Int, rated: Bool), v: Verdict) -> some View {
        let outcomeColor: Color = v.color
        let title = titleForRating(change.newRating)

        VStack(alignment: .leading, spacing: 14) {
            // Verdict hero — the move classification IS the reward (JUICE-DOCTRINE §1).
            HStack(alignment: .center, spacing: 14) {
                Text(v.glyph)
                    .scaledFont(size: 36, weight: .bold, design: .rounded)
                    .foregroundStyle(outcomeColor)
                    .frame(minWidth: 44)
                    .accessibilityHidden(true)   // punctuation glyph; v.label beside it carries the meaning
                VStack(alignment: .leading, spacing: 3) {
                    Text(v.label)
                        .scaledFont(size: 22, weight: .heavy, design: .rounded)
                        .foregroundStyle(outcomeColor)
                    HStack(spacing: 8) {
                        if change.rated {
                            Text("\(change.delta >= 0 ? "+" : "")\(Int(change.delta.rounded())) ELO")
                                .scaledFont(size: 16, weight: .bold, design: .rounded).monospacedDigit()
                                .foregroundStyle(change.delta >= 0 ? .brandGreen : .dangerText)
                        } else {
                            // Honest state for a re-solve: the answer was already
                            // revealed once, so no rating moves — never a green "+0".
                            // On a daily whose puzzle was solved before via its theme
                            // list, the streak still counts — say that, not "practice",
                            // or the copy contradicts the flame incrementing beside it.
                            Text(isDaily ? "Rating unchanged" : "Unrated practice")
                                .scaledFont(size: 12, weight: .semibold)
                                .foregroundStyle(Color.textMuted)
                        }
                        Text("· \(Int(change.newRating))").scaledFont(size: 16, weight: .bold, design: .rounded).monospacedDigit().foregroundStyle(Color.textMuted)
                        // Same provisional gate as Profile/Puzzles — a first solve
                        // must not be handed a class letter the RD hasn't earned yet.
                        TitleBadgeView(label: storage.puzzleState.rating.isProvisional ? "Provisional" : title.label.replacingOccurrences(of: " Closer", with: ""),
                                       tier: storage.puzzleState.rating.isProvisional ? .low : title.tier)
                    }
                }
                Spacer()
                if isDaily {
                    VStack(spacing: 2) {
                        Image(systemName: "flame.fill").scaledFont(size: 18).foregroundStyle(Color.warning)
                        Text("\(change.newStreak)d").scaledFont(size: 16, weight: .bold, design: .rounded).monospacedDigit().foregroundStyle(Color.textPrimary)
                    }
                }
            }

            ConvictionBar(fill: v.convictionFill)

            readVerdictLine

            if let promotedTo {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.up.circle.fill")
                        .scaledFont(size: 16, weight: .bold)
                        .foregroundStyle(Color.brandGreen)
                    Text("PROMOTED")
                        .scaledFont(size: 10, weight: .heavy, design: .rounded)
                        .kerning(0.8)
                        .foregroundStyle(Color.brandGreen)
                    Text("→ \(promotedTo)")
                        .scaledFont(size: 13, weight: .bold)
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
                    Text(hint).scaledFont(size: 13).foregroundStyle(Color.textSecondary).italic().lineSpacing(2)
                }
            }

            readRecapSection

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
                            .scaledFont(size: 13)
                            .foregroundStyle(Color.brandGreen)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Read full transcript").microLabel(Color.brandGreen)
                            Text("\(t.speaker): \(t.title)")
                                .scaledFont(size: 13, weight: .semibold)
                                .foregroundStyle(Color.textSecondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .scaledFont(size: 12, weight: .bold)
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

    // MARK: - Read verdict (reveal-time)

    /// "Read held" / "Lucky" / "Wrong read, wrong move" — reported alongside the move
    /// verdict, never before it, so the read's suspense survives the move (the HTML's
    /// move-phase copy is literally "play it out and we'll see if it holds").
    /// Plain (non-ViewBuilder) helper — an if/else chain that only assigns locals
    /// confuses @ViewBuilder into requiring every branch to itself produce a View.
    private func readVerdictCopy() -> (text: String, color: Color)? {
        guard let held = readHeld else { return nil }
        if held {
            return ("Read held — you saw it before you played it.", .brandGreen)
        }
        if verdict?.isWin ?? false {
            return ("Lucky — right line, wrong read.", .warning)
        }
        return ("Wrong read, wrong move.", .danger)
    }

    @ViewBuilder
    private var readVerdictLine: some View {
        if let copy = readVerdictCopy() {
            Text(copy.text)
                .scaledFont(size: 13, weight: .bold, design: .rounded)
                .foregroundStyle(copy.color)
        }
    }

    /// Full read recap: the cue, the contrast (the one-word change that flips the right
    /// move), and all four read options with their `why` — ported from the HTML's
    /// "Every line, and why" treatment, applied here to the read instead of the move.
    @ViewBuilder
    private var readRecapSection: some View {
        if let read = puzzle.read {
            Divider().background(Color.border)
            VStack(alignment: .leading, spacing: 8) {
                Text("Your read").microLabel(Color.brandGreen)
                if let cue = read.cue {
                    Text(cue).scaledFont(size: 13).foregroundStyle(Color.textSecondary).lineSpacing(2)
                }
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(readDisplayOrder.enumerated()), id: \.offset) { displayIdx, origIdx in
                        let opt = read.options[origIdx]
                        let picked = readSelectedDisplayIdx == displayIdx
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: opt.isKey ? "checkmark.circle.fill" : (picked ? "xmark.circle.fill" : "circle"))
                                .scaledFont(size: 12)
                                .foregroundStyle(opt.isKey ? Color.brandGreen : (picked ? Color.danger : Color.textFaint))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(opt.text)
                                    .scaledFont(size: 12, weight: (picked || opt.isKey) ? .bold : .regular)
                                    .foregroundStyle(Color.textPrimary)
                                Text(opt.why)
                                    .scaledFont(size: 11)
                                    .foregroundStyle(Color.textMuted)
                                    .lineSpacing(2)
                            }
                        }
                    }
                }
                if let contrast = read.contrast {
                    Text(contrast)
                        .scaledFont(size: 12)
                        .foregroundStyle(Color.textMuted)
                        .italic()
                        .lineSpacing(2)
                        .padding(.top, 2)
                }
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
        let v = Verdict.from(pickedEval: picked.eval, isBestPick: correct,
                             isFork: correct && picked.isFork,
                             isSharp: correct && picked.isSharp)

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
            todayKey: isDaily ? Store.todayKey() : nil,
            readHeld: readHeld
        )

        let newTitle = titleForRating(result.newRating).label
        let didPromote = correct && newTitle != oldTitle && result.newRating > oldRating
        promotedTo = didPromote ? newTitle : nil
        // Daily-only: recordSolve returns the UNCHANGED streak for non-daily solves,
        // so without the gate a 7-day streak replayed the milestone haptic on every
        // correct puzzle in a grind session — devaluing the earned beat.
        let hitStreakMilestone = isDaily && correct && [3, 7, 14, 30, 100].contains(result.newStreak)

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
        let next = Puzzles.adaptiveNext(
            after: puzzle.id,
            rating: Int(storage.puzzleState.rating.rating),
            solvedIds: storage.solvedIdSet)
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
        readSelectedDisplayIdx = nil
        readCommitted = false
        confidence = nil
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

/// A read-step diagnosis option — deliberately plain (no eval glyph, no rationale-on-
/// reveal) so it reads as a different kind of choice than a move candidate. Correctness
/// is never shown here; it lands later, in the reveal panel, alongside the move.
private struct ReadOptionButton: View {
    let option: PuzzleRead.ReadOption
    let letter: String
    let isPicked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Text(letter)
                    .scaledFont(size: 12, weight: .heavy, design: .rounded)
                    .foregroundStyle(isPicked ? Color.bgPage : Color.textMuted)
                    .frame(width: 22, height: 22)
                    .background(Circle().fill(isPicked ? Color.brandGreen : Color.bgRail))
                Text(option.text)
                    .scaledFont(size: 14)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.bgPanel)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(isPicked ? Color.brandGreen : Color.border, lineWidth: isPicked ? 1.5 : 1))
        }
        .buttonStyle(.plain)
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
                Text("BUYER").scaledFont(size: 8, weight: .heavy, design: .rounded).kerning(0.5).foregroundStyle(Color.textFaint)
                Spacer()
                Text("YOU").scaledFont(size: 8, weight: .heavy, design: .rounded).kerning(0.5).foregroundStyle(Color.textFaint)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.85).delay(0.15)) { animated = true }
        }
    }
}
