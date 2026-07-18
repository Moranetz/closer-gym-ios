import SwiftUI

/// Duolingo-style candidate row — full-width card with leading letter badge,
/// 2pt stroke + bottom depth plate. Reveal state flips color + shows eval +
/// rationale + Atlas tags + best-move ★.
struct PuzzleCandidateButton: View {
    @State private var openLesson: Technique?
    let candidate: PuzzleCandidate
    let letter: String
    let isPicked: Bool
    let isBest: Bool
    let isWrongPicked: Bool
    let revealed: Bool
    let shake: Bool

    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: revealed ? 10 : 0) {
                HStack(alignment: .top, spacing: 12) {
                    letterBadge
                    VStack(alignment: .leading, spacing: 6) {
                        Text(candidate.text)
                            .scaledFont(size: 14)
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(2)

                        if revealed {
                            revealMeta
                            if !candidate.atlasTags.isEmpty {
                                tagWrap
                            }
                            Text(candidate.rationale)
                                .scaledFont(size: 12)
                                .foregroundStyle(Color.textMuted)
                                .lineSpacing(2)
                        }
                    }
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(face)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .sheet(item: $openLesson) { t in
                NavigationStack { LessonDetailView(technique: t) }
            }
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(border, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .disabled(revealed)
        .modifier(ShakeIfTrue(shake: shake))
        .animation(.snappy(duration: 0.20), value: revealed)
        .animation(.snappy(duration: 0.14), value: isPicked)
    }

    private var letterBadge: some View {
        let badgeColor: Color = {
            if revealed && isBest { return .brandGreen }
            if revealed && isWrongPicked { return .danger }
            if isPicked { return .info }
            return .bgRail
        }()
        let badgeText: Color = (revealed && isBest) || (revealed && isWrongPicked) || isPicked ? .white : .textMuted
        return Text(letter)
            .scaledFont(size: 13, weight: .heavy, design: .rounded)
            .foregroundStyle(badgeText)
            .frame(width: 30, height: 30)
            .background(Circle().fill(badgeColor))
    }

    // One arbiter, no numbers: the move-quality glyph IS the rating (JUICE-DOCTRINE §1;
    // PUZZLE-DOCTRINE §0.3 — never render numeric evals to the player). Same Verdict
    // vocabulary as the reveal hero, so card and hero always agree.
    private var revealMeta: some View {
        let v = Verdict.from(pickedEval: candidate.eval, isBestPick: isBest,
                             isFork: isBest && candidate.isFork,
                             isSharp: isBest && candidate.isSharp)
        return HStack(spacing: 6) {
            Text(v.glyph)
                .scaledFont(size: 13, weight: .heavy, design: .rounded)
                .foregroundStyle(v.color)
            Text(isBest ? "BEST MOVE" : v.label.uppercased())
                .scaledFont(size: 10.5, weight: isBest ? .heavy : .semibold, design: .rounded)
                .kerning(isBest ? 0.6 : 0.3)
                .foregroundStyle(isBest ? Color.brandGreen : Color.textMuted)
        }
    }

    // Chips link into the Atlas: the content graph was hub-and-spoke (Lessons-only) — now every
    // revealed tag is a doorway to its lesson. Green text = tappable, this app's own convention.
    private var tagWrap: some View {
        FlowLayout(spacing: 4, lineSpacing: 4) {
            ForEach(candidate.atlasTags, id: \.self) { tag in
                Text(AtlasTechniques.name(for: tag))
                    .scaledFont(size: 10, weight: .semibold)
                    .kerning(0.4)
                    .foregroundStyle(AtlasTechniques.get(tag) != nil ? Color.brandGreen : Color.textMuted)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(RoundedRectangle(cornerRadius: 2, style: .continuous).fill(Color.white.opacity(0.06)))
                    .onTapGesture {
                        if let t = AtlasTechniques.get(tag) {
                            Haptics.shared.selection()
                            openLesson = t
                        }
                    }
                    .accessibilityAddTraits(AtlasTechniques.get(tag) != nil ? .isButton : [])
                    .accessibilityHint(AtlasTechniques.get(tag) != nil ? "Opens the lesson for this technique." : "")
            }
        }
    }

    private var face: Color {
        if revealed && isBest { return Color.brandGreen.opacity(0.10) }
        if revealed && isWrongPicked { return Color.danger.opacity(0.08) }
        return Color.bgPanel
    }

    private var border: Color {
        if revealed && isBest { return .brandGreen }
        if revealed && isWrongPicked { return .danger }
        if isPicked { return .info }
        return .borderStrong
    }
}

// MARK: - Shake modifier

private struct ShakeIfTrue: ViewModifier {
    let shake: Bool
    func body(content: Content) -> some View {
        content.offset(x: shake ? 6 : 0)
    }
}

// MARK: - FlowLayout — simple wrap for atlas tags

struct FlowLayout: Layout {
    let spacing: CGFloat
    let lineSpacing: CGFloat

    init(spacing: CGFloat = 4, lineSpacing: CGFloat = 4) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var rows: [[CGSize]] = [[]]
        var lineWidth: CGFloat = 0

        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if lineWidth + size.width > maxWidth && !rows[rows.count - 1].isEmpty {
                rows.append([])
                lineWidth = 0
            }
            rows[rows.count - 1].append(size)
            lineWidth += size.width + spacing
        }

        var totalH: CGFloat = 0
        for (rowIdx, row) in rows.enumerated() {
            let rowHeight: CGFloat = row.map(\.height).max() ?? 0
            totalH += rowHeight
            if rowIdx > 0 { totalH += lineSpacing }
        }
        var widestRow: CGFloat = 0
        for row in rows {
            let widths: CGFloat = row.map(\.width).reduce(0, +)
            let gaps: CGFloat = CGFloat(max(0, row.count - 1)) * spacing
            widestRow = max(widestRow, widths + gaps)
        }
        let totalW: CGFloat = widestRow
        return CGSize(width: min(totalW, maxWidth), height: totalH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var x = bounds.minX
        var y = bounds.minY
        var rowH: CGFloat = 0

        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > bounds.minX + maxWidth && x > bounds.minX {
                x = bounds.minX
                y += rowH + lineSpacing
                rowH = 0
            }
            sub.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowH = max(rowH, size.height)
        }
    }
}
