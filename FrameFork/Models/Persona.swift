import Foundation

/// Buyer persona — schema mirrored from web's src/lib/types.ts → Persona.
public struct Persona: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let track: Track
    public let role: String
    public let seniority: String
    public let buyingAuthority: BuyingAuthority
    public let decisionCriteriaStated: String
    public let decisionCriteriaHidden: String
    public let valence: Int      // -3 to +3
    public let certainty: Int    // 0-5
    public let agency: Int       // 0-5
    public let persuasionKnowledge: PersuasionKnowledge
    public let readability: Readability
    public let typicalObjections: [String]
    public let contraindicatedTechniques: [String]
    public let likelyResponsiveTechniques: [String]
    public let narrativeArc: String
    public let hiddenCurveBall: String
}

public enum Track: String, Codable, CaseIterable, Sendable {
    case t1 = "T1"
    case t2 = "T2"
    case t3 = "T3"
    case t4 = "T4"
    case t5 = "T5"

    public var label: String {
        switch self {
        case .t1: return "Enterprise"
        case .t2: return "Founder-led"
        case .t3: return "Transactional"
        case .t4: return "Negotiator"
        case .t5: return "Research-led"
        }
    }
}

public enum BuyingAuthority: String, Codable, Sendable {
    case economic, technical, user, champion, mobilizer, blocker, gatekeeper, counterparty, unclear
}

public enum PersuasionKnowledge: String, Codable, Sendable {
    case low, lowMedium = "low-medium", medium, high, veryHigh = "very high"

    public var label: String {
        switch self {
        case .low: return "low"
        case .lowMedium: return "low-medium"
        case .medium: return "medium"
        case .high: return "high"
        case .veryHigh: return "very high"
        }
    }
}

public enum Readability: String, Codable, Sendable {
    case low, medium, high
}
