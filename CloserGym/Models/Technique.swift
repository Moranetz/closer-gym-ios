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
    public let canonicalSource: String
    public let primaryFailureMode: String
    public let contraindication: String

    public init(id: String, name: String, cluster: AtlasCluster, mechanism: String,
                atlasVerdict: AtlasVerdict, folkloreRisk: FolkloreRisk,
                canonicalSource: String = "", primaryFailureMode: String = "",
                contraindication: String = "") {
        self.id = id
        self.name = name
        self.cluster = cluster
        self.mechanism = mechanism
        self.atlasVerdict = atlasVerdict
        self.folkloreRisk = folkloreRisk
        self.canonicalSource = canonicalSource
        self.primaryFailureMode = primaryFailureMode
        self.contraindication = contraindication
    }
}

public extension AtlasCluster {
    /// One-sentence definition of each cluster — shown in the Lessons index header.
    var definition: String {
        switch self {
        case .questionForm:
            return "Open-ended question patterns that convert demands into shared problems."
        case .cialdini:
            return "Six classical influence principles cataloged by Robert Cialdini."
        case .framing:
            return "Cognitive framing moves that exploit asymmetric weighting of gains, losses, and reference points."
        case .compliance:
            return "Sequential request structures that exploit consistency norms and reciprocity."
        case .negotiationAnchor:
            return "First-move number tactics that bias the counterparty's adjustment."
        case .structuralClose:
            return "Bookend moves that compress decision space and force commitment."
        case .postObjection:
            return "Response patterns once the buyer has stated a concern."
        case .closingEnvironment:
            return "Procedural commitments and multi-stakeholder structures that reduce drift."
        }
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
