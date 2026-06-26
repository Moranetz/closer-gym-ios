import SwiftUI

/// "Guess the move" master study. You step through a real deal; at the master's pivotal moves the
/// line is hidden and you predict it, then the master's actual move lands with the earned verdict
/// + the plain why. Active, earned, no handed answers, no numeric evals, outcome hidden until the
/// end. (Replaces the old passive annotated wall — see master-study.html / the redesign.)
struct MasterGameViewer: View {
    @State private var game: MasterGame
    @State private var revealedCount: Int = 0           // moves shown so far
    @State private var activeGuess: Int? = nil          // move index currently being guessed
    @State private var awaitingContinue: Bool = false   // just answered; show Continue
    @State private var results: [Int: Bool] = [:]       // guess move index → matched the master
    @State private var matched: Int = 0
    @State private var attempted: Int = 0
    @State private var finished: Bool = false

    init(game: MasterGame) { _game = State(initialValue: game) }

    private var guessTotal: Int { game.moves.filter { $0.isGuessPoint }.count }

    private var momentum: Double {
        let running = game.moves.prefix(revealedCount).compactMap { $0.role == .op ? $0.delta : nil }.reduce(0, +)
        return max(0.05, min(0.95, 0.5 + running / 6.0))
    }

    private var nextGameId: String {
        let i = MasterGames.all.firstIndex(where: { $0.id == game.id }) ?? 0
        return MasterGames.all[(i + 1) % MasterGames.all.count].id
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Color.clear.frame(height: 0).id("mg-top")
                    header
                    momentumBar
                    transcript
                    if let g = activeGuess { guessCard(moveIndex: g) }
                    if awaitingContinue { continueButton }
                    if finished { summaryCard }
                    Color.clear.frame(height: 8).id("mg-bottom")
                }
                .padding(.horizontal, 16).padding(.top, 12).padding(.bottom, 28)
                .onChange(of: revealedCount) { _, _ in
                    withAnimation(.easeOut(duration: 0.25)) { proxy.scrollTo("mg-bottom", anchor: .bottom) }
                }
                .onChange(of: game.id) { _, _ in proxy.scrollTo("mg-top", anchor: .top) }
            }
            .background(Color.bgPage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.bgPage, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(game.speaker).font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.textPrimary).lineLimit(1)
                }
            }
            .onAppear { if revealedCount == 0 && activeGuess == nil && !finished { advance() } }
        }
    }

    // MARK: - Header (no outcome spoiler)

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("MASTER STUDY · GUESS THE MOVE").microLabel(Color.brandGreen)
            Text("vs \(game.opponentRole)").font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.textPrimary)
            Text(game.scenario).font(.system(size: 13)).foregroundStyle(Color.textSecondary).lineSpacing(2)
            Text("Style: \(game.speakerStyle)").font(.system(size: 12)).italic().foregroundStyle(Color.textMuted)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var momentumBar: some View {
        VStack(alignment: .leading, spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.bgRail)
                    Capsule().fill(LinearGradient(colors: [.brandGreenDeep, .brandGreen], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * momentum)
                        .animation(.spring(response: 0.7, dampingFraction: 0.85), value: momentum)
                }
            }
            .frame(height: 6)
            .overlay(Capsule().strokeBorder(Color.border, lineWidth: 1))
            HStack {
                Text("BUYER").font(.system(size: 8, weight: .heavy, design: .rounded)).foregroundStyle(Color.textFaint)
                Spacer()
                Text("\(game.speaker.split(separator: " ").first.map(String.init)?.uppercased() ?? "YOU")")
                    .font(.system(size: 8, weight: .heavy, design: .rounded)).foregroundStyle(Color.textFaint)
            }
        }
    }

    // MARK: - Transcript (revealed moves)

    private var transcript: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(game.moves.prefix(revealedCount).enumerated()), id: \.offset) { i, m in
                moveRow(turnIndex: i, move: m).id("turn-\(i)")
            }
        }
    }

    @ViewBuilder
    private func moveRow(turnIndex: Int, move: MasterMove) -> some View {
        let isOperator = move.role == .op
        let speakerShort = isOperator ? (game.speaker.split(separator: " ").first.map(String.init) ?? "Op") : "Buyer"
        VStack(alignment: isOperator ? .trailing : .leading, spacing: 6) {
            HStack {
                if isOperator { Spacer(minLength: 28) }
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(speakerShort) · turn \(turnIndex + 1)".uppercased())
                        .font(.system(size: 9, weight: .heavy, design: .rounded)).kerning(0.4).foregroundStyle(Color.textMuted)
                    Text(move.text).font(.system(size: 14)).foregroundStyle(isOperator ? Color.textPrimary : Color.textSecondary).lineSpacing(2)
                }
                .padding(11)
                .frame(maxWidth: 300, alignment: .leading)
                .background(isOperator ? Color.brandGreen.opacity(0.13) : Color.bgPanel)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 9, style: .continuous).strokeBorder(isOperator ? Color.brandGreen.opacity(0.3) : Color.borderStrong, lineWidth: 1))
                if !isOperator { Spacer(minLength: 28) }
            }
            if isOperator, let annotation = move.annotation, let delta = move.delta {
                if let matchedHere = results[turnIndex] {
                    Text(matchedHere ? "✓ You played it like \(speakerShort)" : "You went another way — \(speakerShort) played the above")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundStyle(matchedHere ? Color.brandGreen : Color.warning)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                annotationCard(annotation: annotation, delta: delta)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    private func annotationCard(annotation: String, delta: Double) -> some View {
        let q = classifyMove(delta)
        return VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 6) {
                if !q.glyph.isEmpty {
                    Text(q.glyph).font(.system(size: 13, weight: .heavy)).foregroundStyle(q.color)
                    Text(q.label).font(.system(size: 10, weight: .heavy, design: .rounded)).foregroundStyle(q.color)
                }
            }
            Text(annotation).font(.system(size: 12)).foregroundStyle(Color.textSecondary).lineSpacing(2)
        }
        .padding(10)
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.bgRail.overlay(Rectangle().fill(q.color.opacity(0.8)).frame(width: 3), alignment: .leading))
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }

    // MARK: - Guess card

    @ViewBuilder
    private func guessCard(moveIndex: Int) -> some View {
        let opts = options(for: moveIndex)
        let speakerShort = game.speaker.split(separator: " ").first.map(String.init) ?? "the master"
        VStack(alignment: .leading, spacing: 10) {
            Text("YOU'RE \(speakerShort.uppercased()) · WHAT'S YOUR MOVE?").microLabel(Color.brandGreen)
            ForEach(Array(opts.items.enumerated()), id: \.offset) { i, text in
                Button {
                    pick(optionIndex: i, realIndex: opts.realIndex, moveIndex: moveIndex)
                } label: {
                    HStack(alignment: .top, spacing: 9) {
                        Text(String(UnicodeScalar(65 + i)!))
                            .font(.system(size: 11, weight: .heavy, design: .rounded)).foregroundStyle(Color.textMuted)
                            .frame(width: 20, height: 20)
                            .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color.bgRail))
                        Text(text).font(.system(size: 13)).foregroundStyle(Color.textPrimary).multilineTextAlignment(.leading).lineSpacing(2)
                        Spacer(minLength: 0)
                    }
                    .padding(11)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.bgPanel)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.brandGreen.opacity(0.35), lineWidth: 1))
    }

    private var continueButton: some View {
        Button {
            awaitingContinue = false
            advance()
        } label: {
            Text("Continue →").font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(Color.bgPage).frame(maxWidth: .infinity).frame(height: 46)
                .background(Color.brandGreen).clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Summary

    private var summaryCard: some View {
        let isLoss = game.outcome == .loss
        return VStack(alignment: .leading, spacing: 12) {
            Text(game.outcome.label).font(.system(size: 11, weight: .heavy, design: .rounded)).kerning(0.7)
                .foregroundStyle(.white).padding(.horizontal, 8).padding(.vertical, 3)
                .background(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(game.outcome.color))
            Text(isLoss
                 ? "You walked into \(shortSpeaker)'s trap on \(matched) of \(attempted) — the point is feeling why these backfire."
                 : "You played it like \(shortSpeaker) on \(matched) of \(attempted) key moves.")
                .font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundStyle(Color.textPrimary).lineSpacing(2)
            Text(game.outcomeNote).font(.system(size: 12.5)).foregroundStyle(Color.textSecondary).lineSpacing(2)
            Divider().background(Color.border)
            Text("Study takeaway").microLabel(Color.brandGreen)
            Text(game.studyHint).font(.system(size: 13)).foregroundStyle(Color.textSecondary).lineSpacing(3)
            Button {
                loadNext()
            } label: {
                Text("Next master game →").font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.bgPage).frame(maxWidth: .infinity).frame(height: 48)
                    .background(Color.brandGreen).clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain).padding(.top, 4)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(game.outcome.color.opacity(0.4), lineWidth: 1.5))
    }

    private var shortSpeaker: String { game.speaker.split(separator: " ").first.map(String.init) ?? "the master" }

    // MARK: - Logic

    /// Reveal non-guess moves until the next guess point or the end.
    private func advance() {
        while revealedCount < game.moves.count && !game.moves[revealedCount].isGuessPoint {
            revealedCount += 1
        }
        if revealedCount < game.moves.count {
            activeGuess = revealedCount               // pause at the guess point (not yet revealed)
        } else {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { finished = true }
        }
    }

    private func pick(optionIndex: Int, realIndex: Int, moveIndex: Int) {
        let didMatch = optionIndex == realIndex
        results[moveIndex] = didMatch
        attempted += 1
        if didMatch { matched += 1 }
        let q = classifyMove(game.moves[moveIndex].delta ?? 0)
        if didMatch && q.glyph == "!!" { Haptics.shared.titlePromotion() }
        else if didMatch { Haptics.shared.correctReveal() }
        else { Haptics.shared.selection() }
        activeGuess = nil
        awaitingContinue = true
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            revealedCount += 1                         // reveal the master's actual move + its result
        }
    }

    /// Deterministic shuffle of [real + decoys] so the answer position is stable per move.
    private func options(for moveIndex: Int) -> (items: [String], realIndex: Int) {
        let m = game.moves[moveIndex]
        var items = [m.text] + (m.alternatives ?? [])
        var seed: UInt64 = 0
        for c in (game.id + "#\(moveIndex)").unicodeScalars { seed = seed &* 31 &+ UInt64(c.value) }
        var rng = SeededRNG(seed: seed)
        items.shuffle(using: &rng)
        return (items, items.firstIndex(of: m.text) ?? 0)
    }

    private func loadNext() {
        guard let next = MasterGames.get(nextGameId) else { return }
        Haptics.shared.light()
        revealedCount = 0; activeGuess = nil; awaitingContinue = false
        results = [:]; matched = 0; attempted = 0; finished = false
        withAnimation(.easeInOut(duration: 0.2)) { game = next }
        advance()
    }
}
