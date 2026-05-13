import Foundation

/// Engine helpers — opening detection + running eval curve.
/// Mirrors web src/lib/eval.ts (subset used by the iOS view layer).
public enum Eval {

    /// Detect a named opening from a sequence of operator turns' Atlas technique IDs.
    /// Returns nil until enough turns have fired to identify the pattern.
    public static func detectOpening(operatorTechniqueIdsPerTurn: [[String]]) -> (name: String, eco: String)? {
        guard operatorTechniqueIdsPerTurn.count >= 2 else { return nil }
        let flat = Set(operatorTechniqueIdsPerTurn.flatMap { $0 })

        func has(_ id: String) -> Bool { flat.contains(id) }

        if has("calibrated-question") && has("labeling")        { return ("Voss Open (Empathic Variation)", "VO1") }
        if has("calibrated-question") && has("spin-implication") { return ("SPIN Open", "RA1") }
        if has("calibrated-question") && has("mirroring")        { return ("Voss Open (Mirror Variation)", "VO2") }
        if has("loss-framing") || has("spin-implication")        { return ("Challenger Open", "CH1") }
        if has("liking") && has("reciprocity")                   { return ("Consultative Open (Cialdini Variation)", "CI1") }
        if has("calibrated-question")                            { return ("Consultative Open (Curiosity Variation)", "CO1") }
        if has("extreme-anchor") || has("precise-anchor")        { return ("Anchored Open", "AN1") }
        return ("Unnamed Opening", "—")
    }

    /// Convert running eval into 0-1 fill ratio for an eval bar.
    public static func evalToFillRatio(_ value: Double) -> Double {
        let clamped = max(-2.5, min(2.5, value))
        return 0.5 + clamped / 5
    }

    /// Numeric label for a running eval (e.g. "+0.8", "-1.2").
    public static func evalLabel(_ value: Double) -> String {
        let abs = Swift.abs(value)
        if abs < 0.05 { return "0.0" }
        return (value >= 0 ? "+" : "") + String(format: "%.1f", value)
    }

    /// Running eval curve for a master game — operator deltas accumulate, buyer turns hold value.
    public static func runningCurve(_ moves: [MasterMove]) -> [(turnIndex: Int, value: Double, role: MoveRole)] {
        var v: Double = 0
        return moves.enumerated().map { i, m in
            if m.role == .op, let d = m.delta { v += d }
            return (i, v, m.role)
        }
    }
}
