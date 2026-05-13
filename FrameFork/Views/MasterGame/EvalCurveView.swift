import SwiftUI

/// Eval curve — operator deltas accumulating across a master game.
/// Visual analog of the web's SVG curve in ReviewClient.tsx. Uses SwiftUI Shape
/// + GeometryReader for full-width responsiveness.
struct EvalCurveView: View {
    let points: [(turnIndex: Int, value: Double, role: MoveRole)]

    private let yMin: Double = -2.5
    private let yMax: Double = 2.5

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let xMax = max(1, points.count - 1)
            let baselineY = h - ((0 - yMin) / (yMax - yMin)) * h

            ZStack {
                // Filled area above baseline (operator gain)
                Path { p in
                    guard !points.isEmpty else { return }
                    p.move(to: CGPoint(x: 0, y: baselineY))
                    for (i, pt) in points.enumerated() {
                        let x = CGFloat(i) / CGFloat(xMax) * w
                        let y = h - CGFloat((pt.value - yMin) / (yMax - yMin)) * h
                        p.addLine(to: CGPoint(x: x, y: y))
                    }
                    p.addLine(to: CGPoint(x: w, y: baselineY))
                    p.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [Color.brandGreen.opacity(0.35), Color.brandGreen.opacity(0.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                // Baseline
                Path { p in
                    p.move(to: CGPoint(x: 0, y: baselineY))
                    p.addLine(to: CGPoint(x: w, y: baselineY))
                }
                .stroke(Color.borderStrong, style: StrokeStyle(lineWidth: 1, dash: [3, 3]))

                // Line
                Path { p in
                    guard !points.isEmpty else { return }
                    for (i, pt) in points.enumerated() {
                        let x = CGFloat(i) / CGFloat(xMax) * w
                        let y = h - CGFloat((pt.value - yMin) / (yMax - yMin)) * h
                        if i == 0 { p.move(to: CGPoint(x: x, y: y)) }
                        else      { p.addLine(to: CGPoint(x: x, y: y)) }
                    }
                }
                .stroke(Color.brandGreen, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

                // Operator move dots
                ForEach(Array(points.enumerated()), id: \.offset) { i, pt in
                    if pt.role == .op {
                        let x = CGFloat(i) / CGFloat(xMax) * w
                        let y = h - CGFloat((pt.value - yMin) / (yMax - yMin)) * h
                        Circle().fill(Color.brandGreen).frame(width: 5, height: 5)
                            .position(x: x, y: y)
                    }
                }
            }
        }
    }
}
