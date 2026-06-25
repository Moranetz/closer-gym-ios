import SwiftUI

/// Move-quality verdict for a solved puzzle — the sales port of chess.com's move
/// classification (see JUICE-DOCTRINE.md). The verdict, not a binary right/wrong, is the
/// reward. Derived from "expected-points lost" = bestEval − pickedEval, plus optional
/// per-candidate flags for the two scarce overrides.
public enum Verdict: Sendable {
    case fork      // ‼  the scarce "Brilliant": a sound concession that wins on two fronts
    case sharp     // !   the only line that held/swung the deal
    case best      // ◆  the model's #1 move
    case solid     // ✓  a near-best alternative
    case fine      // ·   reasonable, gave a little up
    case loose     // ?!  inaccuracy
    case slip      // ?   mistake
    case missed    // ✕  failed to punish the buyer's opening (flag-driven)
    case tell      // ??  blunder

    /// Map a pick to a verdict. `isBestPick` = the chosen candidate is the model's best.
    /// `isFork`/`isSharp` are optional content flags on the best candidate.
    ///
    /// For a non-best pick the verdict is keyed off the move's own eval using the SAME bands
    /// as `classifyMove(_:)` (MasterGame.swift), so the reveal hero and the picked card's
    /// glyph always tell the same story (good→Solid, neutral→Fine, inaccuracy→Loose,
    /// mistake→Slip, blunder→Tell).
    public static func from(pickedEval: Double, isBestPick: Bool,
                            isFork: Bool = false, isSharp: Bool = false) -> Verdict {
        if isBestPick {
            if isFork { return .fork }
            if isSharp { return .sharp }
            return .best
        }
        if pickedEval >= 0.30  { return .solid }   // "good"
        if pickedEval >= -0.15 { return .fine }    // "neutral"
        if pickedEval >= -0.50 { return .loose }   // "inaccuracy"
        if pickedEval >= -1.00 { return .slip }    // "mistake"
        return .tell                               // "blunder"
    }

    public var glyph: String {
        switch self {
        case .fork:   return "‼"
        case .sharp:  return "!"
        case .best:   return "◆"
        case .solid:  return "✓"
        case .fine:   return "·"
        case .loose:  return "?!"
        case .slip:   return "?"
        case .missed: return "✕"
        case .tell:   return "??"
        }
    }

    public var label: String {
        switch self {
        case .fork:   return "The Fork"
        case .sharp:  return "Sharp"
        case .best:   return "Best"
        case .solid:  return "Solid"
        case .fine:   return "Fine"
        case .loose:  return "Loose"
        case .slip:   return "Slip"
        case .missed: return "Missed"
        case .tell:   return "Tell"
        }
    }

    public var color: Color {
        switch self {
        case .fork:            return Color(red: 0.31, green: 0.72, blue: 0.69)   // cool teal — scarce
        case .sharp:           return Color(red: 0.36, green: 0.55, blue: 0.94)   // steel blue
        case .best, .solid:    return .brandGreen
        case .fine:            return .brandGreen
        case .loose, .slip:    return .warning
        case .missed:          return .textMuted
        case .tell:            return .danger
        }
    }

    public var isWin: Bool { self == .fork || self == .sharp || self == .best }

    /// How much celebration the moment earns — governs the reveal choreography.
    public enum Weight: Sendable { case routine, elevated, heavy, hero }
    public var weight: Weight {
        switch self {
        case .fork:                 return .hero       // full anticipation → land → savor
        case .sharp, .best:         return .elevated   // a notch above routine
        case .solid, .fine,
             .loose, .slip:         return .routine    // fast, quiet
        case .missed, .tell:        return .heavy      // slow, low, muted (never flash)
        }
    }

    /// 0…1 conviction-bar fill (your side) the bar animates to on reveal. A routine correct
    /// move barely moves it — the model already priced the best line in, so only a genuine
    /// find (Best/Sharp/Fork) or a real loss (Tell/Slip) swings it (JUICE-DOCTRINE §2).
    public var convictionFill: Double {
        switch self {
        case .fork:   return 0.90
        case .sharp:  return 0.80
        case .best:   return 0.72
        case .solid:  return 0.55   // barely above even — "already priced in"
        case .fine:   return 0.50
        case .loose:  return 0.40
        case .missed: return 0.34
        case .slip:   return 0.30
        case .tell:   return 0.18
        }
    }
}
