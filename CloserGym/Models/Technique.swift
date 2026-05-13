import Foundation

/// One technique from the Atlas taxonomy. Web mirror: src/lib/types.ts → Technique.
/// Minimal subset for iOS — full schema lives in the web detector + scoring code.
public struct Technique: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let name: String
    public let cluster: AtlasCluster
    public let mechanism: String
    public let atlasVerdict: AtlasVerdict
    public let folkloreRisk: FolkloreRisk

    public init(id: String, name: String, cluster: AtlasCluster, mechanism: String, atlasVerdict: AtlasVerdict, folkloreRisk: FolkloreRisk) {
        self.id = id
        self.name = name
        self.cluster = cluster
        self.mechanism = mechanism
        self.atlasVerdict = atlasVerdict
        self.folkloreRisk = folkloreRisk
    }
}

public enum AtlasCluster: String, Codable, CaseIterable, Sendable {
    case compliance
    case cialdini
    case framing
    case structuralClose = "structural-close"
    case questionForm = "question-form"
    case negotiationAnchor = "negotiation-anchor"
    case postObjection = "post-objection"
    case closingEnvironment = "closing-environment"

    public var label: String {
        switch self {
        case .compliance:           return "Compliance-gaining"
        case .cialdini:             return "Cialdini's six"
        case .framing:              return "Framing"
        case .structuralClose:      return "Structural close"
        case .questionForm:         return "Question form"
        case .negotiationAnchor:    return "Negotiation anchor"
        case .postObjection:        return "Post-objection"
        case .closingEnvironment:   return "Closing environment"
        }
    }
}

public enum AtlasVerdict: String, Codable, Sendable {
    case wellStudied = "well-studied"
    case partiallyStudied = "partially-studied"
    case untested = "untested-in-database"
    case replicationFailed = "replication-failed"
}

public enum FolkloreRisk: String, Codable, Sendable {
    case low = "low"
    case lowMedium = "low-medium"
    case medium = "medium"
    case mediumHigh = "medium-high"
    case high = "high"
}
