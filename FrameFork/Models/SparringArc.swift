import Foundation

/// Offline choice-based sparring: a multi-turn authored conversation against an
/// existing persona. Each user turn is a pick from 3 authored moves; buyer replies
/// are authored branches. No API, no key — the whole engine (verdict beats, eval,
/// Glicko) runs local. Content register + anti-tell rules per PUZZLE-DOCTRINE:
/// strong candidate position AND length are scattered; every candidate carries
/// techniqueTags (a wrong move still deploys a technique); evalDelta is never shown.
public struct SparringArc: Sendable {
    public let personaId: String
    public let botRating: Int
    public let openingBuyerLine: String
    public let startNode: String
    public let nodes: [String: SparringNode]
    public let endings: SparringEndings
}

public struct SparringNode: Sendable {
    public let buyerLine: String
    public let candidates: [SparringCandidate]
    /// The arc's curveball beat — lands with tension treatment (doctrine: the
    /// spike is a moment, not another turn).
    public var isSpike: Bool = false

    public init(buyerLine: String, candidates: [SparringCandidate], isSpike: Bool = false) {
        self.buyerLine = buyerLine
        self.candidates = candidates
        self.isSpike = isSpike
    }
}

public struct SparringCandidate: Sendable {
    public let text: String            // what the rep actually SAYS (spoken dialogue)
    public let evalDelta: Double       // authored; feeds the running eval — NEVER rendered
    public let techniqueTags: [String] // Atlas ids — debrief chips reuse Technique lookups
    public let next: String            // node id, or "end"
    public let rationale: String       // coach-voice one-liner, debrief only
}

public struct SparringEnding: Sendable {
    public let buyerLine: String
    public let debrief: String
}

public struct SparringEndings: Sendable {
    public let close: SparringEnding   // cumulative eval >= 1.5  → Glicko score 1.0
    public let stall: SparringEnding   // in between              → 0.5
    public let walk: SparringEnding    // cumulative eval <= -1.5 → 0.0
}
