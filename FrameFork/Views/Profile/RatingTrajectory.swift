import SwiftUI

/// The "progress you can't fake" hero card (research 2026-07): a monotone-smoothed
/// rating trajectory + the number translated into its meaning (momentum, distance to
/// the next class). Reads PuzzleState.ratingHistory. Only shown once there's a real
/// series to draw (>= 3 rated solves).
struct ProgressHeroCard: View {
    let history: [RatingPoint]
    let currentRating: Double

    private var band: EloBand { titleForRating(currentRating) }
    private var nextBand: EloBand? { EloBands.all.first { $0.min > Int(currentRating.rounded()) } }

    /// Rating delta over the trailing two weeks (or the whole series if younger),
    /// with an honest label for which window it is.
    private var window: (delta: Double, label: String) {
        guard let last = history.last else { return (0, "") }
        let twoWeeksAgo = last.at.addingTimeInterval(-14 * 86_400)
        let spansTwoWeeks = history.first.map { $0.at <= twoWeeksAgo } ?? false
        let start = history.first(where: { $0.at >= twoWeeksAgo }) ?? history.first!
        return (last.rating - start.rating, spansTwoWeeks ? "in two weeks" : "so far")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text("Puzzle rating").microLabel(Color.brandGreen)
                Spacer()
                Text("last \(countNoun(history.count, "solve"))")
                    .scaledFont(size: 11).foregroundStyle(Color.textMuted).monospacedDigit()
            }

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("\(Int(currentRating.rounded()))")
                    .scaledFont(size: 40, weight: .light, design: .rounded)
                    .monospacedDigit()
                    .foregroundStyle(Color.textPrimary)
                TitleBadgeView(label: band.label.replacingOccurrences(of: " Closer", with: ""), tier: band.tier)
                Spacer(minLength: 0)
            }
            .padding(.top, 4)

            // Momentum, translated into meaning — the impact line, not the raw number.
            HStack(spacing: 6) {
                let up = window.delta >= 0
                Text("\(up ? "▲" : "▼") \(up ? "+" : "")\(Int(window.delta.rounded()))")
                    .scaledFont(size: 13, weight: .heavy, design: .rounded)
                    .foregroundStyle(up ? Color.brandGreen : Color.dangerText)
                Text("\(window.label) · you earn a rating, you don't fake it")
                    .scaledFont(size: 12).foregroundStyle(Color.textMuted)
            }
            .padding(.top, 2)

            MonotoneSparkline(values: history.map(\.rating))
                .frame(height: 108)
                .padding(.top, 12)

            HStack {
                Text("\(Int((history.map(\.rating).min() ?? currentRating).rounded()))")
                    .scaledFont(size: 10).foregroundStyle(Color.textFaint).monospacedDigit()
                Spacer()
                if let next = nextBand {
                    Text("\(next.label.replacingOccurrences(of: " Closer", with: "")) at \(next.min) — \(next.min - Int(currentRating.rounded())) to go")
                        .scaledFont(size: 10, weight: .semibold).foregroundStyle(Color.brandGreen).monospacedDigit()
                } else {
                    Text("top of the ladder")
                        .scaledFont(size: 10, weight: .semibold).foregroundStyle(Color.brandGreen)
                }
            }
            .padding(.top, 3)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Puzzle rating \(Int(currentRating.rounded())), \(window.delta >= 0 ? "up" : "down") \(abs(Int(window.delta.rounded()))) \(window.label)")
    }
}

/// Monotone cubic (Fritsch–Carlson) sparkline with a gradient area and honest markers
/// — peaks land only on real data points, never overshoot (Marion's locked data-viz
/// standard: monotone, not Catmull-Rom).
struct MonotoneSparkline: View {
    let values: [Double]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let pad: CGFloat = 6
            let pts = points(in: CGSize(width: w, height: h), pad: pad)
            ZStack {
                if pts.count >= 2 {
                    let curve = monotonePath(pts)
                    // gradient area under the curve
                    curve.areaPath(bottom: h - pad)
                        .fill(LinearGradient(colors: [Color.brandGreen.opacity(0.22), Color.brandGreen.opacity(0)],
                                             startPoint: .top, endPoint: .bottom))
                    curve.linePath
                        .stroke(Color.brandGreen, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    // sparse markers (every ~4th point) — honest positions
                    ForEach(Array(stride(from: 0, to: pts.count - 1, by: max(1, pts.count / 4))), id: \.self) { i in
                        Circle().fill(Color.textMuted).frame(width: 4.5, height: 4.5)
                            .position(pts[i])
                    }
                    // end dot — where you are now
                    Circle().fill(Color.brandGreen).frame(width: 8, height: 8).position(pts[pts.count - 1])
                }
            }
        }
    }

    private func points(in size: CGSize, pad: CGFloat) -> [CGPoint] {
        guard values.count >= 2 else { return [] }
        let lo = values.min()!, hi = values.max()!
        let span = max(1, hi - lo)
        let stepX = (size.width - 2 * pad) / CGFloat(values.count - 1)
        return values.enumerated().map { i, v in
            CGPoint(x: pad + CGFloat(i) * stepX,
                    y: size.height - pad - CGFloat((v - lo) / span) * (size.height - 2 * pad))
        }
    }

    private struct MonotoneCurve { let linePath: Path; func areaPath(bottom: CGFloat) -> Path { var p = linePath; p.addLine(to: CGPoint(x: lastX, y: bottom)); p.addLine(to: CGPoint(x: firstX, y: bottom)); p.closeSubpath(); return p }; let firstX: CGFloat; let lastX: CGFloat }

    /// Fritsch–Carlson monotone cubic tangents → Hermite segments.
    private func monotonePath(_ p: [CGPoint]) -> MonotoneCurve {
        let n = p.count
        var d = [CGFloat](repeating: 0, count: n - 1)   // secant slopes
        for i in 0..<n - 1 { d[i] = (p[i + 1].y - p[i].y) / (p[i + 1].x - p[i].x) }
        var m = [CGFloat](repeating: 0, count: n)
        m[0] = d[0]; m[n - 1] = d[n - 2]
        for i in 1..<n - 1 { m[i] = (d[i - 1] + d[i]) / 2 }
        for i in 0..<n - 1 {
            if d[i] == 0 { m[i] = 0; m[i + 1] = 0; continue }
            let a = m[i] / d[i], b = m[i + 1] / d[i]
            let s = a * a + b * b
            if s > 9 { let t = 3 / s.squareRoot(); m[i] = t * a * d[i]; m[i + 1] = t * b * d[i] }
        }
        var path = Path()
        path.move(to: p[0])
        for i in 0..<n - 1 {
            let dx = p[i + 1].x - p[i].x
            let c1 = CGPoint(x: p[i].x + dx / 3, y: p[i].y + m[i] * dx / 3)
            let c2 = CGPoint(x: p[i + 1].x - dx / 3, y: p[i + 1].y - m[i + 1] * dx / 3)
            path.addCurve(to: p[i + 1], control1: c1, control2: c2)
        }
        return MonotoneCurve(linePath: path, firstX: p[0].x, lastX: p[n - 1].x)
    }
}
