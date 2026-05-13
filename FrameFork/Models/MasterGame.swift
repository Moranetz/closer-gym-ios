import Foundation
import SwiftUI

/// Annotated master game. Mirrors web src/lib/master-games.ts → MasterGame.
public struct MasterGame: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let speaker: String
    public let speakerStyle: String
    public let opponentRole: String
    public let scenario: String
    public let outcome: GameOutcome
    public let outcomeNote: String
    public let openingName: String
    public let openingECO: String
    public let moves: [MasterMove]
    public let studyHint: String
}

public struct MasterMove: Hashable, Codable, Sendable {
    public let role: MoveRole
    public let text: String
    public let techniqueIds: [String]?
    public let annotation: String?
    public let delta: Double?
}

public enum MoveRole: String, Codable, Sendable {
    case op = "operator"   // 'operator' is a reserved keyword in Swift; raw value preserves web JSON compat
    case buyer
}

public enum GameOutcome: String, Codable, Sendable {
    case win, draw, loss

    public var label: String {
        switch self {
        case .win:  return "WIN"
        case .draw: return "DRAW"
        case .loss: return "LOSS"
        }
    }

    public var color: Color {
        switch self {
        case .win:  return .brandGreen
        case .draw: return .warning
        case .loss: return .danger
        }
    }
}

/// Move-quality classification (chess.com glyphs: !!, !, ?!, ?, ??).
public enum MoveQuality: Sendable {
    case brilliant, good, neutral, inaccuracy, mistake, blunder

    public var glyph: String {
        switch self {
        case .brilliant:  return "!!"
        case .good:       return "!"
        case .neutral:    return ""
        case .inaccuracy: return "?!"
        case .mistake:    return "?"
        case .blunder:    return "??"
        }
    }

    public var label: String {
        switch self {
        case .brilliant:  return "Brilliant"
        case .good:       return "Good"
        case .neutral:    return "Book"
        case .inaccuracy: return "Inaccuracy"
        case .mistake:    return "Mistake"
        case .blunder:    return "Blunder"
        }
    }

    public var color: Color {
        switch self {
        case .brilliant:  return .brilliant
        case .good:       return .brandGreen
        case .neutral:    return .textMuted
        case .inaccuracy: return .warning
        case .mistake:    return Color(red: 0.906, green: 0.518, blue: 0.137)
        case .blunder:    return .danger
        }
    }
}

public func classifyMove(_ delta: Double) -> MoveQuality {
    if delta >= 0.8 { return .brilliant }
    if delta >= 0.3 { return .good }
    if delta >= -0.15 { return .neutral }
    if delta >= -0.5 { return .inaccuracy }
    if delta >= -1.0 { return .mistake }
    return .blunder
}
