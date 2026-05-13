import Foundation

/// Minimal Atlas technique lookup for the iOS app. v0 only uses id→name display
/// (for puzzle-candidate tags + master-game move-list labels). Full schema +
/// mechanism + folklore-risk lives in the web detector; ports if/when needed.
public enum AtlasTechniques {
    public static let all: [Technique] = [
        // A · Compliance
        Technique(id: "fitd",     name: "Foot-in-the-door",  cluster: .compliance, mechanism: "Small initial compliance creates self-perception of being a compliant person.", atlasVerdict: .wellStudied, folkloreRisk: .low),
        Technique(id: "ditf",     name: "Door-in-the-face",  cluster: .compliance, mechanism: "Large initial request creates perception of concession when retreating.", atlasVerdict: .partiallyStudied, folkloreRisk: .medium),
        Technique(id: "lowball",  name: "Low-ball",          cluster: .compliance, mechanism: "Initial small commitment binds participant; raised price is harder to refuse.", atlasVerdict: .partiallyStudied, folkloreRisk: .mediumHigh),
        Technique(id: "tna",      name: "That's-not-all",    cluster: .compliance, mechanism: "Sequential added bonuses activate reciprocity and value-anchoring.", atlasVerdict: .partiallyStudied, folkloreRisk: .medium),
        Technique(id: "disrupt-then-reframe", name: "Disrupt-then-reframe", cluster: .compliance, mechanism: "Unexpected disruption + reframe bypasses critical evaluation.", atlasVerdict: .replicationFailed, folkloreRisk: .high),

        // B · Cialdini six
        Technique(id: "reciprocity",   name: "Reciprocity",                 cluster: .cialdini, mechanism: "Norm of reciprocation creates obligation following an unsolicited gift.", atlasVerdict: .wellStudied, folkloreRisk: .low),
        Technique(id: "scarcity",      name: "Scarcity",                    cluster: .cialdini, mechanism: "Loss-aversion + reactance: limited availability raises perceived value.", atlasVerdict: .wellStudied, folkloreRisk: .lowMedium),
        Technique(id: "authority",     name: "Authority cues",              cluster: .cialdini, mechanism: "Heuristic deference to expertise/status reduces deliberation cost.", atlasVerdict: .partiallyStudied, folkloreRisk: .medium),
        Technique(id: "social-proof",  name: "Social proof",                cluster: .cialdini, mechanism: "Uncertainty resolved by observing others' behavior.", atlasVerdict: .wellStudied, folkloreRisk: .low),
        Technique(id: "liking",        name: "Liking / similarity / rapport", cluster: .cialdini, mechanism: "Affect transfer from liked source to evaluated offer.", atlasVerdict: .partiallyStudied, folkloreRisk: .medium),
        Technique(id: "commitment-consistency", name: "Commitment & consistency", cluster: .cialdini, mechanism: "Prior public stance creates pressure to act consistently.", atlasVerdict: .partiallyStudied, folkloreRisk: .medium),

        // C · Framing
        Technique(id: "loss-framing",    name: "Loss-aversion framing",       cluster: .framing, mechanism: "Asymmetric weighting of losses vs. gains.", atlasVerdict: .wellStudied, folkloreRisk: .low),
        Technique(id: "gain-framing",    name: "Gain framing",                cluster: .framing, mechanism: "Outcome-positive framing matches promotion-focus regulatory state.", atlasVerdict: .partiallyStudied, folkloreRisk: .medium),
        Technique(id: "regulatory-fit",  name: "Regulatory fit",              cluster: .framing, mechanism: "Matching buyer's regulatory focus to message frame increases persuasion.", atlasVerdict: .wellStudied, folkloreRisk: .low),
        Technique(id: "concrete-construal", name: "Concrete-vs-abstract framing", cluster: .framing, mechanism: "Psychologically-near framing matches near-construal of immediate decisions.", atlasVerdict: .wellStudied, folkloreRisk: .low),

        // D · Structural close
        Technique(id: "assumptive",         name: "Assumptive close",         cluster: .structuralClose, mechanism: "Default-option psychology — reframes 'if' to 'which'.", atlasVerdict: .untested, folkloreRisk: .high),
        Technique(id: "alternative-choice", name: "Alternative-choice close", cluster: .structuralClose, mechanism: "Narrows decision space; default option reduces overwhelm.", atlasVerdict: .untested, folkloreRisk: .high),
        Technique(id: "summary-close",      name: "Summary close",            cluster: .structuralClose, mechanism: "Explicit summary of agreed value reduces decision uncertainty.", atlasVerdict: .partiallyStudied, folkloreRisk: .lowMedium),
        Technique(id: "trial-close",        name: "Trial close",              cluster: .structuralClose, mechanism: "Elicits intermediate commitment; surfaces objections early.", atlasVerdict: .partiallyStudied, folkloreRisk: .medium),
        Technique(id: "takeaway",           name: "Takeaway close",           cluster: .structuralClose, mechanism: "Activates reactance and loss aversion; creates pursuit dynamic.", atlasVerdict: .untested, folkloreRisk: .mediumHigh),
        Technique(id: "ben-franklin",       name: "Ben Franklin close",       cluster: .structuralClose, mechanism: "Systematic enumeration favors seller's framing.", atlasVerdict: .untested, folkloreRisk: .high),
        Technique(id: "puppy-dog",          name: "Puppy-dog close",          cluster: .structuralClose, mechanism: "Endowment effect after possession.", atlasVerdict: .partiallyStudied, folkloreRisk: .lowMedium),
        Technique(id: "sharp-angle",        name: "Sharp-angle close",        cluster: .structuralClose, mechanism: "Locks objection into commitment via conditional concession.", atlasVerdict: .untested, folkloreRisk: .high),

        // E · Question-form
        Technique(id: "calibrated-question", name: "Calibrated question",     cluster: .questionForm, mechanism: "Open-ended how/what invites elaboration; converts no-stance to problem-solving.", atlasVerdict: .wellStudied, folkloreRisk: .low),
        Technique(id: "labeling",            name: "Affect labeling",         cluster: .questionForm, mechanism: "Verbalizing emotion reduces amygdala activation; signals empathy.", atlasVerdict: .wellStudied, folkloreRisk: .low),
        Technique(id: "mirroring",           name: "Mirroring",               cluster: .questionForm, mechanism: "Last-3-words echo signals attention; minimal-encourager extends turn.", atlasVerdict: .partiallyStudied, folkloreRisk: .medium),
        Technique(id: "accusation-audit",    name: "Accusation audit",        cluster: .questionForm, mechanism: "Preemptively naming buyer's likely objections inoculates against them.", atlasVerdict: .untested, folkloreRisk: .medium),
        Technique(id: "spin-implication",    name: "SPIN implication question", cluster: .questionForm, mechanism: "Elicits buyer-generated cost of the problem.", atlasVerdict: .partiallyStudied, folkloreRisk: .lowMedium),
        Technique(id: "spin-need-payoff",    name: "SPIN need-payoff question", cluster: .questionForm, mechanism: "Elicits buyer-generated benefits; pre-commits buyer to rationale.", atlasVerdict: .partiallyStudied, folkloreRisk: .lowMedium),

        // F · Negotiation-anchor
        Technique(id: "extreme-anchor",    name: "Extreme anchor",     cluster: .negotiationAnchor, mechanism: "Initial number anchors counterparty's adjustment.", atlasVerdict: .wellStudied, folkloreRisk: .low),
        Technique(id: "precise-anchor",    name: "Precise number anchor", cluster: .negotiationAnchor, mechanism: "Precise numbers signal information; counterparty adjusts less.", atlasVerdict: .wellStudied, folkloreRisk: .low),
        Technique(id: "anchor-with-range", name: "Range anchor",       cluster: .negotiationAnchor, mechanism: "Range anchors with backed-bottom outperform point anchors.", atlasVerdict: .partiallyStudied, folkloreRisk: .lowMedium),
        Technique(id: "bracketing",        name: "Bracketing",         cluster: .negotiationAnchor, mechanism: "Offers a range that brackets the target; counterparty meets in middle.", atlasVerdict: .untested, folkloreRisk: .medium),

        // G · Post-objection
        Technique(id: "feel-felt-found",     name: "Feel-felt-found",         cluster: .postObjection, mechanism: "Validates concern, then social-proof reframes.", atlasVerdict: .untested, folkloreRisk: .high),
        Technique(id: "isolate-and-conquer", name: "Isolate-the-objection",  cluster: .postObjection, mechanism: "Elicits commitment that this is the only objection.", atlasVerdict: .untested, folkloreRisk: .medium),
        Technique(id: "reverse-objection",   name: "Boomerang / reverse objection", cluster: .postObjection, mechanism: "Reframes objection as a reason to buy.", atlasVerdict: .untested, folkloreRisk: .high),

        // H · Closing environment
        Technique(id: "silence",          name: "Strategic silence after offer", cluster: .closingEnvironment, mechanism: "Discomfort-with-silence pushes counterparty to fill it.", atlasVerdict: .untested, folkloreRisk: .medium),
        Technique(id: "mutual-close-plan", name: "Mutual close plan (MAP)",      cluster: .closingEnvironment, mechanism: "Explicit shared timeline reduces stalls.", atlasVerdict: .untested, folkloreRisk: .lowMedium),
        Technique(id: "multi-threading",   name: "Multi-threading",              cluster: .closingEnvironment, mechanism: "Parallel relationships across stakeholders prevents single-point-of-failure.", atlasVerdict: .untested, folkloreRisk: .lowMedium),
    ]

    private static let byId: [String: Technique] = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })

    public static func get(_ id: String) -> Technique? {
        byId[id]
    }

    /// Friendly display name for an Atlas technique id; falls back to the raw id if unknown.
    public static func name(for id: String) -> String {
        byId[id]?.name ?? id
    }
}
