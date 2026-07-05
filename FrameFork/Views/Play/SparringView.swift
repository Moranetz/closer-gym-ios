import SwiftUI

/// Offline choice-based sparring — the "Focused turn + Peek stack" design Marion
/// locked (2026-07-04): opponent bar → momentum dots → collapsed last exchange
/// (tap to unfold full history) → buyer-line hero → 3 "YOU SAY" candidate cards.
/// Pick → verdict beat (haptic + tone) → buyer's authored reply becomes the next
/// hero. Arc end → ending line + debrief + Glicko commit (first completion rated;
/// replays recorded unrated — the puzzle re-solve lesson).
struct SparringView: View {
    let botMeta: BotMeta
    @Binding var path: [PlayRoute]

    @EnvironmentObject private var storage: Store

    private struct Exchange: Identifiable {
        let id = UUID()
        let buyerLine: String
        let opLine: String
        let tags: [String]
        let verdict: Verdict
        let evalAfter: Double
    }

    /// The pick beat is a choreographed sequence, not a state swap (JUICE-DOCTRINE):
    /// choosing → sent (card MORPHS into your message, verdict lands ON it, savor)
    /// → considering (she composes) → choosing(next). Cause and location stay under
    /// the user's finger the whole way.
    private enum TurnPhase: Equatable {
        case choosing
        case sent(text: String)
        case considering
    }

    @State private var phase: TurnPhase = .choosing
    @State private var sentVerdict: Verdict? = nil
    @State private var badgeShown = false
    @State private var beatGeneration = 0   // invalidates queued beats if the view resets
    @Namespace private var pickNS

    @State private var nodeId: String = ""
    @State private var history: [Exchange] = []
    @State private var eval: Double = 0
    @State private var unfolded = false
    @State private var ending: (SparringEnding, Double)? = nil   // ending + glicko score
    @State private var newRating: Double? = nil
    @State private var ratingDelta: Double? = nil
    @State private var wasRated = true
    @State private var startedAt: Date = .init()
    @State private var endingStage = 0   // staggered ending reveal (0=none … 4=all)

    private var arc: SparringArc? { Arcs.get(personaId: botMeta.personaId) }
    private var node: SparringNode? { arc?.nodes[nodeId] }
    private var totalTurns: Int { 8 }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                dots
                momentumBar
                if !history.isEmpty { peekStack }
                if let ending { endingCards(ending.0) } else { turnBody }
                Spacer(minLength: 28)
            }
        }
        .background(Color.bgPage)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        .toolbar { ToolbarItem(placement: .principal) { opponentTitle } }
        .onAppear {
            if nodeId.isEmpty, let arc {
                nodeId = arc.startNode
                startedAt = Date()
            }
        }
    }

    // MARK: - Chrome

    private var opponentTitle: some View {
        VStack(spacing: 1) {
            Text("vs \(Personas.get(botMeta.personaId)?.role.split(separator: ",").first.map(String.init) ?? botMeta.personaId)")
                .scaledFont(size: 13, weight: .semibold)
                .foregroundStyle(Color.textPrimary)
            Text("Turn \(min(history.count + 1, totalTurns)) / \(totalTurns) · \(evalLabel)")
                .scaledFont(size: 10)
                .foregroundStyle(Color.textMuted)
                .monospacedDigit()
        }
    }

    private var evalLabel: String {
        if eval > 2.0 { return "You're ascending" }
        if eval > 0.5 { return "You're ahead" }
        if eval > -0.5 { return "Even" }
        if eval > -2.0 { return "Buyer guarded" }
        return "Buyer disengaging"
    }

    private var dots: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalTurns, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(i < history.count ? Color.brandGreen : Color.bgRail)
                    .frame(height: 4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .accessibilityElement()
        .accessibilityLabel("Progress")
        .accessibilityValue("\(history.count) of \(totalTurns) turns")
    }

    /// The consequence channel: fortune, not progress. Fill = where the deal sits.
    private var momentumBar: some View {
        let fill = max(0.05, min(0.95, 0.5 + eval / 6.0))
        return VStack(spacing: 3) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.bgRail)
                    Capsule().fill(LinearGradient(colors: [.brandGreenDeep, .brandGreen],
                                                  startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * fill)
                        .animation(.spring(response: 0.7, dampingFraction: 0.85), value: fill)
                }
            }
            .frame(height: 5)
            .overlay(Capsule().strokeBorder(Color.border, lineWidth: 1))
            HStack {
                Text("BUYER").scaledFont(size: 8, weight: .heavy, design: .rounded).foregroundStyle(Color.textFaint)
                Spacer()
                Text("YOU").scaledFont(size: 8, weight: .heavy, design: .rounded).foregroundStyle(Color.textFaint)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 6)
        .padding(.bottom, 8)
        .accessibilityElement()
        .accessibilityLabel("Momentum")
        .accessibilityValue(evalLabel)
    }

    // MARK: - Peek stack (collapsed history; tap to unfold)

    private var peekStack: some View {
        Button {
            Haptics.shared.selection()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) { unfolded.toggle() }
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                if unfolded {
                    ForEach(history) { ex in exchangeRows(ex) }
                    Text("COLLAPSE")
                        .scaledFont(size: 9, weight: .heavy, design: .rounded)
                        .kerning(0.6)
                        .foregroundStyle(Color.textFaint)
                } else if let last = history.last {
                    Group {
                        bubble(last.buyerLine, isOp: false, compact: true)
                        bubble(last.opLine, isOp: true, compact: true)
                    }
                    .opacity(0.5)
                    .scaleEffect(0.96, anchor: .top)
                    if history.count > 1 {
                        Text("TAP TO UNFOLD · \(history.count) EARLIER TURN\(history.count == 1 ? "" : "S")")
                            .scaledFont(size: 9, weight: .heavy, design: .rounded)
                            .kerning(0.6)
                            .foregroundStyle(Color.textFaint)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .accessibilityLabel(unfolded ? "Collapse conversation history" : "Show conversation history")
    }

    @ViewBuilder
    private func exchangeRows(_ ex: Exchange) -> some View {
        bubble(ex.buyerLine, isOp: false, compact: false)
        VStack(alignment: .trailing, spacing: 4) {
            bubble(ex.opLine, isOp: true, compact: false)
            HStack(spacing: 4) {
                ForEach(ex.tags, id: \.self) { tid in
                    Text(AtlasTechniques.name(for: tid))
                        .scaledFont(size: 8, weight: .heavy, design: .rounded)
                        .foregroundStyle(Color.brandGreen)
                        .padding(.horizontal, 5).padding(.vertical, 1)
                        .background(Color.brandGreen.opacity(0.12))
                        .clipShape(Capsule())
                }
                Text(ex.verdict.glyph + " " + ex.verdict.label)
                    .scaledFont(size: 9, weight: .heavy, design: .rounded)
                    .foregroundStyle(ex.verdict.color)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private func bubble(_ text: String, isOp: Bool, compact: Bool) -> some View {
        Text(text)
            .scaledFont(size: compact ? 11 : 12.5)
            .lineLimit(compact ? 2 : nil)
            .foregroundStyle(isOp ? Color.textPrimary : Color.textSecondary)
            .padding(.horizontal, 11).padding(.vertical, 8)
            .background(isOp ? Color.brandGreen.opacity(0.16) : Color.bgPanel)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(isOp ? Color.brandGreen.opacity(0.35) : Color.border, lineWidth: 1))
            .frame(maxWidth: .infinity, alignment: isOp ? .trailing : .leading)
    }

    // MARK: - Current turn

    @ViewBuilder
    private var turnBody: some View {
        switch phase {
        case .considering:
            consideringIndicator
        case .choosing, .sent:
            if let node {
                heroCard(node)
                if case .sent(let text) = phase {
                    sentBubble(text)
                } else {
                    VStack(spacing: 8) {
                        ForEach(Array(displayOrder(for: node).enumerated()), id: \.offset) { i, cand in
                            candidateCard(cand, letter: String(UnicodeScalar(65 + min(i, 25))!))
                                .transition(.opacity.combined(with: .scale(scale: 0.97)))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
        }
    }

    private func heroCard(_ node: SparringNode) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(node.isSpike ? "She drops it" : "She says")
                .microLabel(node.isSpike ? Color.warning : Color.brandGreen)
            Text("“\(node.buyerLine)”")
                .scaledFont(size: 16, weight: .bold, design: .rounded)
                .italic()
                .foregroundStyle(Color.textPrimary)
                .lineSpacing(3)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [.bgPanel, .bgRail], startPoint: .topLeading, endPoint: .bottomTrailing))
        .overlay(alignment: .leading) {
            if node.isSpike { Rectangle().fill(Color.warning).frame(width: 4) }
        }
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
            .strokeBorder(node.isSpike ? Color.warning.opacity(0.4) : Color.border, lineWidth: 1))
        .padding(.horizontal, 16)
    }

    /// The picked line, now YOUR message — the card it came from morphs into this
    /// bubble (matched geometry), and the verdict lands on it where you're looking.
    private func sentBubble(_ text: String) -> some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text(text)
                .scaledFont(size: 12.5)
                .foregroundStyle(Color.textPrimary)
                .lineSpacing(2)
                .padding(.horizontal, 13).padding(.vertical, 10)
                .background(Color.brandGreen.opacity(0.16))
                .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .strokeBorder(Color.brandGreen.opacity(0.35), lineWidth: 1))
                .matchedGeometryEffect(id: text, in: pickNS)
            if let v = sentVerdict {
                HStack(spacing: 5) {
                    Text(v.glyph)
                        .scaledFont(size: 13, weight: .heavy)
                    Text(v.label)
                        .scaledFont(size: 11, weight: .heavy, design: .rounded)
                }
                .foregroundStyle(v.color)
                .padding(.horizontal, 9).padding(.vertical, 4)
                .background(v.color.opacity(0.13))
                .clipShape(Capsule())
                .overlay(Capsule().strokeBorder(v.color.opacity(0.35), lineWidth: 1))
                .scaleEffect(badgeShown ? 1 : 0.3)
                .opacity(badgeShown ? 1 : 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .accessibilityElement(children: .combine)
    }

    /// She's composing — the conversation gets a breath before her reply lands.
    private var consideringIndicator: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.textMuted)
                    .frame(width: 7, height: 7)
                    .opacity(0.35)
                    .modifier(PulseDot(delay: Double(i) * 0.18))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 22)
        .accessibilityElement()
        .accessibilityLabel("Buyer is replying")
    }

    /// Anti-tell: data order carries no signal by authoring, but never trust that —
    /// shuffle deterministically per node (same invariant as PuzzleSolveView).
    private func displayOrder(for node: SparringNode) -> [SparringCandidate] {
        var seed: UInt64 = 0
        for c in (botMeta.personaId + "#" + nodeId).unicodeScalars { seed = seed &* 31 &+ UInt64(c.value) }
        var rng = SeededRNG(seed: seed)
        return node.candidates.shuffled(using: &rng)
    }

    private func candidateCard(_ cand: SparringCandidate, letter: String) -> some View {
        Button { pick(cand) } label: {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(letter)
                        .scaledFont(size: 10, weight: .heavy, design: .rounded)
                        .foregroundStyle(Color.textMuted)
                        .frame(width: 18, height: 18)
                        .background(Color.bgRail)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 5, style: .continuous).strokeBorder(Color.borderStrong, lineWidth: 1))
                    Text("You say").microLabel()
                }
                Text(cand.text)
                    .scaledFont(size: 12.5)
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 13).padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.bgPanel)
            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
            .matchedGeometryEffect(id: cand.text, in: pickNS)
            .contentShape(Rectangle())
        }
        .buttonStyle(SquishButtonStyle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Option \(letter). Say: \(cand.text)")
        .accessibilityHint("Sends this reply")
    }

    // MARK: - State machine

    private func pick(_ cand: SparringCandidate) {
        guard ending == nil, phase == .choosing, let node else { return }
        let v = verdict(for: cand.evalDelta)
        let isLast = cand.next == "end" || history.count + 1 >= totalTurns || arc?.nodes[cand.next] == nil
        beatGeneration += 1
        let gen = beatGeneration

        // Beat 1 — the card becomes your message (anticipation: the morph travels).
        Haptics.shared.light()
        withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
            sentVerdict = v
            badgeShown = false
            phase = .sent(text: cand.text)
        }

        // Beat 2 — the verdict LANDS on the message (haptic fuses with tone, §4).
        after(0.38, gen) {
            Haptics.shared.verdict(v)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.014) { ToneSynth.shared.play(v) }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) { badgeShown = true }
        }

        // Beat 3 — savor, then commit the exchange and let her compose.
        after(1.25, gen) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                eval += cand.evalDelta
                history.append(Exchange(buyerLine: node.buyerLine, opLine: cand.text,
                                        tags: cand.techniqueTags, verdict: v, evalAfter: eval))
                unfolded = false
                sentVerdict = nil
                if isLast {
                    resolveEnding()
                } else {
                    phase = .considering
                    nodeId = cand.next
                }
            }
            guard !isLast else { return }
            // Beat 4 — her reply arrives. The curveball takes a longer breath and
            // lands with a warning lead: tension, not decoration.
            let nextIsSpike = arc?.nodes[cand.next]?.isSpike == true
            after(nextIsSpike ? 1.2 : 0.75, gen) {
                if nextIsSpike { Haptics.shared.warning() }
                withAnimation(.spring(response: nextIsSpike ? 0.55 : 0.45,
                                      dampingFraction: nextIsSpike ? 0.75 : 0.82)) { phase = .choosing }
            }
        }
    }

    /// Queued beat that dies quietly if the view was reset or re-entered.
    private func after(_ delay: Double, _ gen: Int, _ block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard gen == beatGeneration else { return }
            block()
        }
    }

    private func verdict(for delta: Double) -> Verdict {
        if delta >= 0.4 { return .best }
        if delta >= 0.15 { return .solid }
        if delta >= -0.1 { return .fine }
        if delta >= -0.4 { return .loose }
        return .tell
    }

    private func resolveEnding() {
        guard let arc, ending == nil else { return }
        let (end, score): (SparringEnding, Double) =
            eval >= 1.5 ? (arc.endings.close, 1.0)
            : eval <= -1.5 ? (arc.endings.walk, 0.0)
            : (arc.endings.stall, 0.5)
        // First completion per arc is rated; replays are recorded practice —
        // a known tree re-walked must not farm Glicko (the puzzle re-solve lesson).
        let rated = !storage.gameState.completedArcs.contains(arc.personaId)
        let result = storage.recordGame(
            botRating: arc.botRating, score: score, personaId: arc.personaId,
            evalCurve: [0.0] + history.map(\.evalAfter),
            intentTechniques: [], firedTechniques: Array(Set(history.flatMap(\.tags))),
            durationSec: Int(Date().timeIntervalSince(startedAt)),
            turns: history.flatMap { [StoredTurn(role: "buyer", text: $0.buyerLine, firedHere: []),
                                      StoredTurn(role: "operator", text: $0.opLine, firedHere: $0.tags)] },
            judgment: nil, rated: rated)
        if rated { storage.markArcCompleted(arc.personaId) }
        wasRated = rated
        newRating = result.newRating
        ratingDelta = result.delta
        phase = .choosing
        ending = (end, score)

        // The ending is the arc's earned moment — it arrives in beats, weighted by
        // outcome (close = hero; stall = solid weight; walk = heavy, never loud —
        // the doctrine forbids shame-motion).
        endingStage = 0
        let gen = beatGeneration
        after(0.15, gen) { withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { endingStage = 1 } }
        after(0.60, gen) {
            switch score {
            case 1.0:
                Haptics.shared.titlePromotion()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.014) { ToneSynth.shared.play(.fork) }
            case 0.0:
                Haptics.shared.error()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.014) { ToneSynth.shared.play(.tell) }
            default:
                Haptics.shared.medium()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.014) { ToneSynth.shared.play(.solid) }
            }
            withAnimation(.spring(response: 0.42, dampingFraction: score == 1.0 ? 0.62 : 0.85)) { endingStage = 2 }
        }
        after(1.00, gen) { withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { endingStage = 3 } }
        after(1.25, gen) { withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) { endingStage = 4 } }
    }

    // MARK: - Ending

    private var outcomeStamp: (label: String, color: Color, glyph: String) {
        switch ending?.1 ?? 0.5 {
        case 1.0:  return ("CLOSED", .brandGreen, "‼")
        case 0.0:  return ("SHE WALKED", .textMuted, "·")
        default:   return ("STALLED", .warning, "!?")
        }
    }

    @ViewBuilder
    private func endingCards(_ end: SparringEnding) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if endingStage >= 1 {
                bubble(end.buyerLine, isOp: false, compact: false)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            if endingStage >= 2 {
                HStack(spacing: 10) {
                    Text(outcomeStamp.glyph)
                        .scaledFont(size: 26, weight: .heavy, design: .rounded)
                        .foregroundStyle(outcomeStamp.color)
                    Text(outcomeStamp.label)
                        .scaledFont(size: 24, weight: .heavy, design: .rounded)
                        .kerning(1.0)
                        .foregroundStyle(outcomeStamp.color)
                    Spacer()
                }
                .padding(.vertical, 2)
                .transition(.scale(scale: 0.7).combined(with: .opacity))
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)
            }

            if endingStage >= 3 {
                ratingCard(end)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            if endingStage >= 4 {
                movesReview
                    .transition(.opacity.combined(with: .move(edge: .bottom)))

                PrimaryButton(title: "Done", symbol: "checkmark", isEnabled: true, style: .green) {
                    path.removeAll()
                }
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 16)
    }

    private func ratingCard(_ end: SparringEnding) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Debrief").microLabel(Color.brandGreen)
                Text(end.debrief)
                    .scaledFont(size: 13)
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(3)
                HStack(spacing: 16) {
                    if let newRating {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(wasRated ? "New ELO" : "ELO").microLabel()
                            Text("\(Int(newRating))")
                                .scaledFont(size: 15, weight: .heavy, design: .rounded)
                                .monospacedDigit()
                                .foregroundStyle(Color.textPrimary)
                        }
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Delta").microLabel()
                        Text(wasRated ? String(format: "%@%.1f", (ratingDelta ?? 0) >= 0 ? "+" : "", ratingDelta ?? 0)
                                      : "practice run")
                            .scaledFont(size: 15, weight: .heavy, design: .rounded)
                            .monospacedDigit()
                            .foregroundStyle(wasRated ? Color.textPrimary : Color.textMuted)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, 4)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.bgPanel)
            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    /// Per-turn coach lines — the authored rationales finally earn their keep.
    private var movesReview: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("Your moves").microLabel(Color.textSecondary)
            ForEach(Array(history.enumerated()), id: \.1.id) { i, ex in
                HStack(alignment: .top, spacing: 8) {
                    Text(ex.verdict.glyph)
                        .scaledFont(size: 12, weight: .heavy)
                        .foregroundStyle(ex.verdict.color)
                        .frame(width: 20)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Turn \(i + 1) · \(ex.verdict.label)")
                            .scaledFont(size: 11, weight: .bold)
                            .foregroundStyle(ex.verdict.color)
                        Text(rationale(for: ex))
                            .scaledFont(size: 11)
                            .foregroundStyle(Color.textMuted)
                            .lineSpacing(2)
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private func rationale(for ex: Exchange) -> String {
        // Find the authored rationale by matching the picked line back to its node.
        for node in (arc?.nodes ?? [:]).values {
            if let c = node.candidates.first(where: { $0.text == ex.opLine }) { return c.rationale }
        }
        return ""
    }
}

/// Staggered breathing pulse for the considering indicator.
private struct PulseDot: ViewModifier {
    let delay: Double
    @State private var up = false
    func body(content: Content) -> some View {
        content
            .opacity(up ? 0.9 : 0.3)
            .scaleEffect(up ? 1.15 : 0.9)
            .animation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true).delay(delay), value: up)
            .onAppear { up = true }
    }
}

/// Press-squish (the app-wide button feel).
struct SquishButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.16, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
