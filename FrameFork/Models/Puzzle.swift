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
    // Optional teaching-loop step (ported from framefork-game.html): commit a diagnosis of
    // the buyer's state BEFORE picking a move. nil on every pre-existing puzzle — the
    // Optional's synthesized Codable decodeIfPresent means old/decoded data with no "read"
    // key still decodes cleanly to nil, so this is additive, never breaking.
    public let read: PuzzleRead?

    public init(id: String, theme: PuzzleTheme, difficulty: Int, buyerRole: String, setup: String,
                buyerLine: String, candidates: [PuzzleCandidate], bestIndex: Int,
                themeHint: String? = nil, transcriptId: String? = nil, read: PuzzleRead? = nil) {
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
        self.read = read
    }
}

/// The read step: a diagnosis of the buyer's state committed BEFORE any move is shown.
/// Ported verbatim (content-wise) from framefork-game.html's `read`/`move.cue`/`move.contrast`.
public struct PuzzleRead: Hashable, Codable, Sendable {
    public struct ReadOption: Hashable, Codable, Sendable {
        public let text: String
        public let isKey: Bool
        public let why: String

        public init(text: String, isKey: Bool, why: String) {
            self.text = text
            self.isKey = isKey
            self.why = why
        }
    }

    public let question: String
    public let sub: String
    public let options: [ReadOption]
    public let cue: String?        // what the tell actually was
    public let contrast: String?   // the one-word change that would have made a different move right

    public init(question: String, sub: String, options: [ReadOption], cue: String? = nil, contrast: String? = nil) {
        self.question = question
        self.sub = sub
        self.options = options
        self.cue = cue
        self.contrast = contrast
    }
}

public struct PuzzleCandidate: Hashable, Codable, Sendable {
    public let text: String
    public let eval: Double         // -2.0 to +2.0
    public let rationale: String
    public let atlasTags: [String]
    // Move-quality flags on the BEST candidate only (JUICE-DOCTRINE §3): a Fork is
    // the scarce hero verdict (~2–5% of the bank), a Sharp is the strong-but-not-hero
    // tier. Defaults false so the existing 100-puzzle data compiles untouched — the
    // celebration pipeline (Verdict.from → hero haptic/triad tone/anticipation reveal)
    // has been wired end-to-end and waiting; flagging content is all that's left.
    public var isFork: Bool = false
    public var isSharp: Bool = false
    // The buyer's literal spoken reaction to this candidate line, ported from the
    // teaching-loop prototype's `react.line` (distinct from `rationale`, which carries
    // the why + narrated consequence — this is what the buyer actually SAYS back).
    // nil on every pre-existing candidate.
    public var buyerReply: String? = nil

    public init(text: String, eval: Double, rationale: String, atlasTags: [String],
                isFork: Bool = false, isSharp: Bool = false, buyerReply: String? = nil) {
        self.text = text; self.eval = eval; self.rationale = rationale
        self.atlasTags = atlasTags; self.isFork = isFork; self.isSharp = isSharp
        self.buyerReply = buyerReply
    }

    // Tolerant decode: the synthesized decoder REQUIRES isFork/isSharp keys despite
    // the defaults, which would break any future decode of pre-flag candidate JSON.
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        text      = try c.decode(String.self, forKey: .text)
        eval      = try c.decode(Double.self, forKey: .eval)
        rationale = (try? c.decodeIfPresent(String.self, forKey: .rationale)) ?? ""
        atlasTags = (try? c.decodeIfPresent([String].self, forKey: .atlasTags)) ?? []
        isFork    = (try? c.decodeIfPresent(Bool.self, forKey: .isFork)) ?? false
        isSharp   = (try? c.decodeIfPresent(Bool.self, forKey: .isSharp)) ?? false
        buyerReply = (try? c.decodeIfPresent(String.self, forKey: .buyerReply)) ?? nil
    }
}

public enum PuzzleTheme: String, Codable, CaseIterable, Sendable {
    case budget
    case procurement
    case stall
    case renewal
    case multistakeholder
    case endgame
    case coldOpen = "cold-open"
    case salesAssist = "sales-assist"
    case forecastCall = "forecast-call"

    public var label: String {
        switch self {
        case .budget:           return "Budget objections"
        case .procurement:      return "Procurement gauntlet"
        case .stall:            return "Stalls and silence"
        case .renewal:          return "Renewal saves"
        case .multistakeholder: return "Committee deals"
        case .endgame:          return "Endgame studies"
        case .coldOpen:         return "Cold opens"
        case .salesAssist:      return "Self-serve accounts"
        case .forecastCall:     return "Forecast calls"
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
        case .salesAssist:      return .themeSalesAssist
        case .forecastCall:     return .themeForecastCall
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
