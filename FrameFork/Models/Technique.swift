import Foundation

/// One technique from the Atlas taxonomy. Web mirror: src/lib/types.ts → Technique.
/// Minimal subset for iOS — full schema lives in the web detector + scoring code.
public struct Technique: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let name: String
    public let cluster: AtlasCluster
    public let mechanism: String
    /// One plain-English sentence for a founder or rep on their phone — no jargon,
    /// no lab-notes register. `mechanism` stays verbatim (Atlas evidence record,
    /// shown in the detail view); `plain` is what the Lessons card shows.
    public let plain: String
    public let atlasVerdict: AtlasVerdict
    public let folkloreRisk: FolkloreRisk
    public let canonicalSource: String
    /// One plain-English sentence for the failure mode a founder or rep can actually
    /// picture (≤16 words, no lab-notes register). `primaryFailureMode` stays verbatim
    /// (Atlas evidence record, shown beneath it in smaller ink in the detail view).
    public let plainFailure: String
    public let primaryFailureMode: String
    public let contraindication: String
    // Evidence grading (2026-07 empirical re-anchor). `evidenceTier` = strength of the
    // support (A academic meta > B analyst > C vendor-call-data > D trade-book assertion);
    // `evidenceBand` drives how much the Atlas trusts it (Core = teach as the answer;
    // Supporting = real mechanism, sales-outcome unproven, use as color; Flagged = folklore
    // or has a documented backfire, caveat it). `evidenceSource` = one citation URL.
    public let evidenceTier: EvidenceTier?
    public let evidenceBand: EvidenceBand
    public let evidenceSource: String

    public init(id: String, name: String, cluster: AtlasCluster, mechanism: String, plain: String,
                plainFailure: String, atlasVerdict: AtlasVerdict, folkloreRisk: FolkloreRisk,
                canonicalSource: String = "", primaryFailureMode: String = "",
                contraindication: String = "",
                evidenceTier: EvidenceTier? = nil, evidenceBand: EvidenceBand = .supporting,
                evidenceSource: String = "") {
        self.id = id
        self.name = name
        self.cluster = cluster
        self.mechanism = mechanism
        self.plain = plain
        self.plainFailure = plainFailure
        self.atlasVerdict = atlasVerdict
        self.folkloreRisk = folkloreRisk
        self.canonicalSource = canonicalSource
        self.primaryFailureMode = primaryFailureMode
        self.contraindication = contraindication
        self.evidenceTier = evidenceTier
        self.evidenceBand = evidenceBand
        self.evidenceSource = evidenceSource
    }
}

public enum EvidenceTier: String, Codable, Sendable {
    case a = "A", b = "B", c = "C", d = "D"
    public var label: String {
        switch self {
        case .a: return "Peer-reviewed"
        case .b: return "Analyst data"
        case .c: return "Call-analytics"
        case .d: return "Practitioner claim"
        }
    }
    /// Short honesty blurb about what this tier of evidence can and can't say.
    public var blurb: String {
        switch self {
        case .a: return "Academic meta-analysis — strongest, but often older and modest in effect."
        case .b: return "Large analyst survey — real method, commercially adjacent."
        case .c: return "Vendor call-analytics — huge real-call N, but correlational and self-interested."
        case .d: return "Trade-book assertion — popular, no independent data."
        }
    }
}

public enum EvidenceBand: String, Codable, Sendable {
    case core, supporting, flagged
    public var label: String {
        switch self {
        case .core:       return "Evidence-backed"
        case .supporting: return "Mechanism only"
        case .flagged:    return "Handle with care"
        }
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
            return "How a price or fact is worded changes how big it feels."
        case .compliance:
            return "Small steps get said yes to first, and the big ask gets easier."
        case .negotiationAnchor:
            return "The first number said in a negotiation pulls every later number toward it."
        case .structuralClose:
            return "Moves that narrow the choice down to a plain yes or no."
        case .postObjection:
            return "Response patterns once the buyer has stated a concern."
        case .closingEnvironment:
            return "Steps that keep a slow multi-person deal from stalling out."
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
