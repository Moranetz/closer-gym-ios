import Foundation
import SwiftUI

/// ELO band → title progression (Patzer → Grandmaster Closer).
/// Mirrors web src/lib/tokens.ts → ELO_BANDS + titleForRating.
public struct EloBand: Sendable {
    public let min: Int
    public let max: Int
    public let label: String
    public let tier: BadgeTier
}

public enum BadgeTier: String, Sendable {
    case low, exp, m, im, gm

    public var color: Color {
        switch self {
        case .low: return .badgeLow
        case .exp: return .badgeExp
        case .m:   return .badgeM
        case .im:  return .badgeIM
        case .gm:  return .badgeGM
        }
    }

    public var textColor: Color {
        switch self {
        case .low, .gm:        return .white
        case .exp, .m, .im:    return .bgPage
        }
    }
}

public enum EloBands {
    public static let all: [EloBand] = [
        EloBand(min: 0,    max: 1199, label: "Patzer",                   tier: .low),
        EloBand(min: 1200, max: 1399, label: "Class D Closer",           tier: .low),
        EloBand(min: 1400, max: 1599, label: "Class C Closer",           tier: .low),
        EloBand(min: 1600, max: 1799, label: "Class B Closer",           tier: .low),
        EloBand(min: 1800, max: 1999, label: "Class A Closer",           tier: .exp),
        EloBand(min: 2000, max: 2199, label: "Expert",                   tier: .exp),
        EloBand(min: 2200, max: 2299, label: "Master",                   tier: .m),
        EloBand(min: 2300, max: 2399, label: "International Master",     tier: .im),
        EloBand(min: 2400, max: 9999, label: "Grandmaster Closer",       tier: .gm),
    ]
}

public func titleForRating(_ rating: Double) -> EloBand {
    // Clamp into the defined band range so a sub-zero rating (possible on a long
    // loss streak — Glicko-2 has no floor) or a >9999 rating still resolves to a
    // real band instead of falling through to the Patzer fallback. Also guards NaN.
    let raw = rating.isFinite ? Int(rating.rounded()) : Int(initialRating)
    let r = max(0, min(9999, raw))
    return EloBands.all.first { r >= $0.min && r <= $0.max } ?? EloBands.all[0]
}

/// Initial Glicko-2 state — provisional 1200, high RD until calibrated.
public let initialRating: Double = 1200
public let initialRD: Double = 350
public let initialVolatility: Double = 0.06

/// RD at/above this is still a cold-start guess, not an earned tier — below it the
/// player has enough rated puzzles behind the number to trust a class label. Chosen
/// roughly midway between the 350 cold start and Glicko's own well-calibrated floor,
/// which this app's puzzle opponent RD (140, see `initialRD * 0.4` in Storage.swift)
/// reaches after a handful of rated solves.
public let provisionalRD: Double = 200

/// A count and its noun, agreeing.
///
/// Fleet round 143: `firstRunDrillLine` right below this pluralizes and is tested at 0, 1 and 3.
/// `firstRunSummary` did not, and its test went 0 to 3 to 5 — stepping over the only value that
/// breaks it. A player who has solved exactly one puzzle read "1 puzzles solved", on the first
/// screen the app shows after their first solve.
public func countNoun(_ n: Int, _ singular: String, plural: String? = nil) -> String {
    "\(n) \(n == 1 ? singular : (plural ?? singular + "s"))"
}

/// First-run summary line for the Profile identity card. Fresh install reads a
/// sentence, not three zeros; a solved puzzle with no streak yet still doesn't fake
/// a "0-day streak" as if a streak were ever attempted. Once there's a real streak,
/// this returns nil and the caller falls back to its normal three-stat line.
public func firstRunSummary(solved: Int, streak: Int, longest: Int) -> String? {
    if solved == 0 {
        return "Solve one puzzle and this line starts counting."
    }
    if streak == 0 {
        return "\(countNoun(solved, "puzzle")) solved. One today starts a streak."
    }
    return nil
}

/// First-run line for the Puzzles tab's stat row, replacing the streak pair while
/// there's no solve history yet to make a streak meaningful.
public func firstRunDrillLine(drillsToday: Int) -> String {
    drillsToday > 0
        ? "\(drillsToday) drill\(drillsToday == 1 ? "" : "s") today"
        : "Your rating starts moving with today's drill."
}
