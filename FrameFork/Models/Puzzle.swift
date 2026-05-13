import Foundation
import SwiftUI

/// Single-position drill. Mirrors web src/lib/puzzles.ts → Puzzle.
public struct Puzzle: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let theme: PuzzleTheme
    public let difficulty: Int
    public let buyerRole: String
    public let setup: String
    public let buyerLine: String
    public let candidates: [PuzzleCandidate]
    public let bestIndex: Int
    public let themeHint: String?
    public let transcriptId: String?   // ID into Transcripts; surfaces a Read Full Transcript sheet on solve

    public init(id: String, theme: PuzzleTheme, difficulty: Int, buyerRole: String, setup: String,
                buyerLine: String, candidates: [PuzzleCandidate], bestIndex: Int,
                themeHint: String? = nil, transcriptId: String? = nil) {
        self.id = id
        self.theme = theme
        self.difficulty = difficulty
        self.buyerRole = buyerRole
        self.setup = setup
        self.buyerLine = buyerLine
        self.candidates = candidates
        self.bestIndex = bestIndex
        self.themeHint = themeHint
        self.transcriptId = transcriptId
    }
}

public struct PuzzleCandidate: Hashable, Codable, Sendable {
    public let text: String
    public let eval: Double         // -2.0 to +2.0
    public let rationale: String
    public let atlasTags: [String]
}

public enum PuzzleTheme: String, Codable, CaseIterable, Sendable {
    case budget
    case procurement
    case stall
    case renewal
    case multistakeholder
    case endgame
    case coldOpen = "cold-open"

    public var label: String {
        switch self {
        case .budget:           return "Budget objections"
        case .procurement:      return "Procurement gauntlet"
        case .stall:            return "Stall / silence"
        case .renewal:          return "Renewal saves"
        case .multistakeholder: return "Multi-stakeholder"
        case .endgame:          return "Endgame studies"
        case .coldOpen:         return "Cold opens"
        }
    }

    public var tint: Color {
        switch self {
        case .budget:           return .themeBudget
        case .procurement:      return .themeProcurement
        case .stall:            return .themeStall
        case .renewal:          return .themeRenewal
        case .multistakeholder: return .themeMulti
        case .endgame:          return .themeEndgame
        case .coldOpen:         return .themeColdOpen
        }
    }
}

public enum DifficultyTier: String, Sendable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
}

public func difficultyTier(_ rating: Int) -> DifficultyTier {
    if rating < 1500 { return .beginner }
    if rating < 1800 { return .intermediate }
    if rating < 2100 { return .advanced }
    return .expert
}
