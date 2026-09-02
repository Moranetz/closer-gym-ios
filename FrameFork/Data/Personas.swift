import Foundation

/// 14 buyer personas. Verbatim port from closer-sparring's PERSONAS.md and
/// the web src/lib/personas.ts. Each persona is a decomposed buyer model:
/// stated criteria, hidden criteria, contraindicated and responsive Atlas
/// techniques, persuasion-knowledge level, narrative arc, hidden curve ball.
public enum Personas {
    public static let all: [Persona] = [
        // T1 — Enterprise
        Persona(
            id: "t1-economic-buyer-cfo",
            track: .t1,
            role: "CFO at $200M–$1B revenue SaaS company",
            seniority: "C-level",
            buyingAuthority: .economic,
            decisionCriteriaStated: "ROI, security/compliance, references",
            decisionCriteriaHidden: "Career-protection: would this purchase be defensible to the board if it goes wrong?",
            valence: -1, certainty: 3, agency: 4,
            persuasionKnowledge: .high, readability: .medium,
            typicalObjections: ["Procurement/legal/security review timeline", "ROI proof from comparable peer", "Multi-year commitment risk", "Implementation cost beyond license"],
            contraindicatedTechniques: ["scarcity", "takeaway", "lowball", "sharp-angle"],
            likelyResponsiveTechniques: ["calibrated-question", "social-proof", "authority", "summary-close", "mutual-close-plan"],
            narrativeArc: "Opens guarded → softens on peer-data → procurement objection mid-flow → commits to next-step only if MAP exists.",
            hiddenCurveBall: "Late in cycle: reveals procurement requires 90-day review the operator hadn't priced in."
        ),
        Persona(
            id: "t1-champion-vp-eng",
            track: .t1,
            role: "VP Engineering at growth-stage SaaS",
            seniority: "VP",
            buyingAuthority: .champion,
            decisionCriteriaStated: "Technical fit, team buy-in, integration cost",
            decisionCriteriaHidden: "Personal reputation; preference for tools that make HIM look good to the CTO.",
            valence: 1, certainty: 2, agency: 3,
            persuasionKnowledge: .medium, readability: .medium,
            typicalObjections: ["Integration complexity", "Team adoption resistance", "Stack-overlap with existing tools"],
            contraindicatedTechniques: ["lowball", "sharp-angle", "scarcity"],
            likelyResponsiveTechniques: ["calibrated-question", "social-proof", "concrete-construal", "summary-close"],
            narrativeArc: "Warm-open → enthusiastic mid-call → backs off if technical fit ambiguity → champions internally if armed with peer-references.",
            hiddenCurveBall: "Mid-cycle: gets pulled into Series B prep; spend committee on hold until raise closes."
        ),
        Persona(
            id: "t1-technical-evaluator",
            track: .t1,
            role: "IT Security architect, F500",
            seniority: "Principal IC",
            buyingAuthority: .technical,
            decisionCriteriaStated: "SOC2 status, FedRAMP, data residency, audit posture",
            decisionCriteriaHidden: "Audit committee pressure increasing; needs to demonstrate vendor rigor independent of business team.",
            valence: -1, certainty: 4, agency: 3,
            persuasionKnowledge: .high, readability: .low,
            typicalObjections: ["FedRAMP requirement", "Data residency", "Pen-test cadence", "Sub-processor review"],
            contraindicatedTechniques: ["social-proof", "authority", "scarcity"],
            likelyResponsiveTechniques: ["calibrated-question", "concrete-construal", "labeling"],
            narrativeArc: "Cold-formal open → grills on compliance specifics → recommends approval only if vendor demonstrates audit-literacy.",
            hiddenCurveBall: "Federal data-sharing agreement requires Moderate ATO; even sponsored sandbox won't unblock if audit closes first."
        ),

        // T2 — Founder-led
        Persona(
            id: "t2-founder-non-customer",
            track: .t2,
            role: "Founder of a peer company, not buying",
            seniority: "Founder",
            buyingAuthority: .unclear,
            decisionCriteriaStated: "Curiosity, peer relationship",
            decisionCriteriaHidden: "Not actually evaluating; courtesy call after warm intro.",
            valence: 0, certainty: 1, agency: 5,
            persuasionKnowledge: .high, readability: .medium,
            typicalObjections: ["Not in the buying window", "We built our own", "Different stage"],
            contraindicatedTechniques: ["scarcity", "trial-close", "assumptive"],
            likelyResponsiveTechniques: ["calibrated-question", "liking", "reciprocity"],
            narrativeArc: "Polite open → genuine engagement on technical specifics → declines without explanation if pitch density rises.",
            hiddenCurveBall: "Will not say no on the call; ghosts post-call. Real signal was tone."
        ),
        Persona(
            id: "t2-design-partner",
            track: .t2,
            role: "Design partner at a Series A startup",
            seniority: "Founder/CEO",
            buyingAuthority: .economic,
            decisionCriteriaStated: "Product fit, willingness to iterate with us",
            decisionCriteriaHidden: "Will say yes to almost anything in design-partner stage; real commitment surfaces at contract.",
            valence: 2, certainty: 2, agency: 5,
            persuasionKnowledge: .medium, readability: .high,
            typicalObjections: ["Pricing for our stage", "Feature gaps", "Implementation team bandwidth"],
            contraindicatedTechniques: ["scarcity", "extreme-anchor"],
            likelyResponsiveTechniques: ["calibrated-question", "reciprocity", "concrete-construal", "mutual-close-plan"],
            narrativeArc: "Warm enthusiasm → commits early → at contract phase reveals tighter constraints than the verbal yes implied.",
            hiddenCurveBall: "Burning $310K/mo; verbal yes was conditional on a structure that fits a $30K year-one budget."
        ),

        // T3 — Transactional
        Persona(
            id: "t3-transactional-direct-buyer",
            track: .t3,
            role: "Knows what she wants; mid-market ops lead",
            seniority: "Director",
            buyingAuthority: .economic,
            decisionCriteriaStated: "Price, delivery date, terms",
            decisionCriteriaHidden: "Wants speed; values being respected with low-friction sales process.",
            valence: 0, certainty: 4, agency: 4,
            persuasionKnowledge: .medium, readability: .high,
            typicalObjections: ["Price too high", "Term too long", "Slow procurement on our side"],
            contraindicatedTechniques: ["spin-implication", "feel-felt-found", "ben-franklin"],
            likelyResponsiveTechniques: ["concrete-construal", "extreme-anchor", "summary-close", "mutual-close-plan"],
            narrativeArc: "Cold-direct open → fast qualification → closes within 3 touches if price-fit obvious.",
            hiddenCurveBall: "Has competitor quote at -15%; will exit if operator doesn't acknowledge the comparison."
        ),
        Persona(
            id: "t3-transactional-comparison",
            track: .t3,
            role: "Comparison-shopper, mid-market IT director",
            seniority: "Director",
            buyingAuthority: .economic,
            decisionCriteriaStated: "Feature matrix, price, references",
            decisionCriteriaHidden: "Personal performance metric is procurement savings; needs to show -X% on book price.",
            valence: -1, certainty: 3, agency: 3,
            persuasionKnowledge: .medium, readability: .medium,
            typicalObjections: ["Vendor A is cheaper", "Vendor B has feature X", "Need spreadsheet for board"],
            contraindicatedTechniques: ["scarcity", "feel-felt-found", "takeaway"],
            likelyResponsiveTechniques: ["calibrated-question", "concrete-construal", "summary-close"],
            narrativeArc: "Cold-comparative open → tests each vendor on the same matrix → closes on lowest-total-cost-of-ownership.",
            hiddenCurveBall: "Decision criteria stated as feature-fit; real criterion is the savings number going to the CFO."
        ),
        Persona(
            id: "t3-auto-floor-traffic",
            track: .t3,
            role: "Couple shopping for a used SUV on a Saturday",
            seniority: "n/a",
            buyingAuthority: .economic,
            decisionCriteriaStated: "Model, price, mileage, color",
            decisionCriteriaHidden: "Today-vs-next-weekend velocity; whether they feel pressured (they hate pressure).",
            valence: -3, certainty: 3, agency: 4,
            persuasionKnowledge: .high, readability: .medium,
            typicalObjections: ["'Just looking'", "Price too high", "'Need to think about it'", "Trade-in undervalued"],
            contraindicatedTechniques: ["lowball", "sharp-angle", "assumptive", "scarcity"],
            likelyResponsiveTechniques: ["accusation-audit", "reciprocity", "calibrated-question", "takeaway"],
            narrativeArc: "Hostile-open → softens on first honest acknowledgment of game → bargains hard → closes if respected.",
            hiddenCurveBall: "They ARE buying today (Saturday plans), but will leave at any pressure cue."
        ),

        // T4 — Negotiator
        Persona(
            id: "t4-procurement-specialist",
            track: .t4,
            role: "Senior procurement specialist at Fortune 500",
            seniority: "Senior IC",
            buyingAuthority: .gatekeeper,
            decisionCriteriaStated: "Contract terms, total cost of ownership, SLA, term",
            decisionCriteriaHidden: "Cost-savings number reported to their boss; their personal performance metric.",
            valence: -1, certainty: 4, agency: 4,
            persuasionKnowledge: .veryHigh, readability: .low,
            typicalObjections: ["Pricing benchmarks vs peer vendors", "Multi-year discount", "SLA penalties", "Out-clauses"],
            contraindicatedTechniques: ["scarcity", "takeaway", "social-proof", "authority", "assumptive"],
            likelyResponsiveTechniques: ["calibrated-question", "extreme-anchor", "anchor-with-range", "accusation-audit", "summary-close", "mutual-close-plan"],
            narrativeArc: "Cold-open → grills on terms → grinds on price → closes only if a credible BATNA exists from operator side.",
            hiddenCurveBall: "They HAVE to close this quarter for their own performance metric, but won't reveal it."
        ),
        Persona(
            id: "t4-board-stakeholder-skeptic",
            track: .t4,
            role: "Independent board director, finance background, audit committee",
            seniority: "Board",
            buyingAuthority: .blocker,
            decisionCriteriaStated: "Prudence, governance, fiduciary clarity",
            decisionCriteriaHidden: "How this decision reads in the proxy if it goes wrong.",
            valence: -2, certainty: 4, agency: 3,
            persuasionKnowledge: .veryHigh, readability: .medium,
            typicalObjections: ["Why this vendor vs status quo", "Dependency risk", "Audit committee narrative", "Reversibility"],
            contraindicatedTechniques: ["scarcity", "social-proof", "assumptive"],
            likelyResponsiveTechniques: ["authority", "accusation-audit", "calibrated-question", "summary-close"],
            narrativeArc: "Cold-formal → softens on explicit governance-risk acknowledgment → wants written exit-clause → closes only if the audit committee story is pre-written.",
            hiddenCurveBall: "The company they previously sat on the board of had a vendor breach; reactivity high."
        ),
        Persona(
            id: "t4-litigator-counterparty",
            track: .t4,
            role: "Litigator across the table; pre-suit settlement",
            seniority: "Senior partner",
            buyingAuthority: .counterparty,
            decisionCriteriaStated: "Liability cap, indemnification language, jurisdiction",
            decisionCriteriaHidden: "Anchoring against future damages claim.",
            valence: -2, certainty: 5, agency: 5,
            persuasionKnowledge: .veryHigh, readability: .low,
            typicalObjections: ["Liability cap too low", "Carve-outs incomplete", "Jurisdiction"],
            contraindicatedTechniques: ["liking", "reciprocity", "scarcity", "assumptive"],
            likelyResponsiveTechniques: ["calibrated-question", "concrete-construal", "summary-close", "accusation-audit"],
            narrativeArc: "Cold-adversarial → tests every clause → closes only on precision.",
            hiddenCurveBall: "Has internal partner pressure to close inside 30 days; will not reveal."
        ),
        Persona(
            id: "t4-labor-counterparty",
            track: .t4,
            role: "Union rep negotiating contract terms",
            seniority: "Senior",
            buyingAuthority: .counterparty,
            decisionCriteriaStated: "Wages, benefits, work-rule terms",
            decisionCriteriaHidden: "Ratification probability with rank and file.",
            valence: -1, certainty: 4, agency: 3,
            persuasionKnowledge: .high, readability: .low,
            typicalObjections: ["Wage gap to comparable", "Benefit erosion", "Work-rule changes"],
            contraindicatedTechniques: ["takeaway", "scarcity", "assumptive"],
            likelyResponsiveTechniques: ["calibrated-question", "labeling", "concrete-construal", "summary-close"],
            narrativeArc: "Formal posturing → softens on labeled concerns → grinds → closes if ratification narrative survives.",
            hiddenCurveBall: "Internal faction pressure; agreement must not embarrass the leadership."
        ),

        // T5 — Research-operator
        Persona(
            id: "t5-research-academic",
            track: .t5,
            role: "Academic researcher exploring tooling",
            seniority: "Principal investigator",
            buyingAuthority: .user,
            decisionCriteriaStated: "Methodology fit, reproducibility, source citations",
            decisionCriteriaHidden: "Whether the tool's findings would survive peer review citation.",
            valence: 0, certainty: 2, agency: 2,
            persuasionKnowledge: .veryHigh, readability: .high,
            typicalObjections: ["Methodology opacity", "No published validation", "Vendor lock-in"],
            contraindicatedTechniques: ["scarcity", "authority", "social-proof"],
            likelyResponsiveTechniques: ["calibrated-question", "concrete-construal", "summary-close"],
            narrativeArc: "Curious-cold → engages on methodology specifics → recommends only if reproducibility is real.",
            hiddenCurveBall: "Already published a paper critical of the category; will challenge any claim that contradicts their findings."
        ),
        Persona(
            id: "t5-research-operator",
            track: .t5,
            role: "Data infrastructure lead; runs the pipeline",
            seniority: "Director",
            buyingAuthority: .technical,
            decisionCriteriaStated: "Data pipeline integration, reproducibility, observability",
            decisionCriteriaHidden: "Whether this fits a methodology they have already adopted internally.",
            valence: 0, certainty: 3, agency: 3,
            persuasionKnowledge: .veryHigh, readability: .medium,
            typicalObjections: ["Pipeline-integration cost", "Data residency", "Vendor opacity"],
            contraindicatedTechniques: ["scarcity", "social-proof", "feel-felt-found"],
            likelyResponsiveTechniques: ["calibrated-question", "concrete-construal", "summary-close"],
            narrativeArc: "Cold-analytical → tests methodology rigor → closes if vendor demonstrates honest limits.",
            hiddenCurveBall: "Has alternative-build under internal review; vendor must beat the build/buy line."
        ),
    ]

    public static let labelById: [String: String] = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0.role) })
    private static let byId: [String: Persona] = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })

    public static func get(_ id: String) -> Persona? {
        byId[id]
    }
}

/// Persona ELO assignment. Mirrors web src/lib/persona-elo.ts.
/// Tier derived from: persuasion-knowledge × initial valence × readability.
public struct BotMeta: Identifiable, Hashable, Sendable {
    public let personaId: String
    public let rating: Int
    public let oneLineTagline: String

    public var id: String { personaId }
}

public enum BotLadder {
    public static let all: [BotMeta] = Personas.all
        .map { p in BotMeta(personaId: p.id, rating: eloFor(p), oneLineTagline: tagline(for: p)) }
        // personaId tiebreaker: the derived ELOs collide (two 1550s, two 2050s) and
        // Swift's sort is not stable — without it, tied bots swap rows between launches.
        .sorted { ($0.rating, $0.personaId) < ($1.rating, $1.personaId) }

    public static func get(_ id: String) -> BotMeta? {
        all.first { $0.personaId == id }
    }

    /// Unlock policy: any bot within +200 ELO of the player's current Game rating —
    /// and the easiest bot is ALWAYS unlocked. Without that floor, a fresh player
    /// (placement 1200, ceiling 1400) faced a ladder whose lowest bot is 1425:
    /// every row locked, on the tier the user just paid to reach.
    public static func isUnlocked(_ bot: BotMeta, playerRating: Int) -> Bool {
        if bot.personaId == all.first?.personaId { return true }
        return bot.rating <= playerRating + 200
    }

    private static func eloFor(_ p: Persona) -> Int {
        var base: Double
        switch p.persuasionKnowledge {
        case .low:        base = 1250
        case .lowMedium:  base = 1400
        case .medium:     base = 1600
        case .high:       base = 1900
        case .veryHigh:   base = 2200
        }
        base += Double(-p.valence) * 60
        switch p.readability {
        case .low:    base += 100
        case .medium: base += 0
        case .high:   base -= 50
        }
        let clamped = max(1200, min(2400, base))
        return Int((clamped / 25).rounded()) * 25
    }

    private static func tagline(for p: Persona) -> String {
        switch p.id {
        case "t1-economic-buyer-cfo":          return "Career-protective CFO. Reads technique density instantly."
        case "t1-champion-vp-eng":             return "Champion-track VP Eng. Wants the win to make him look good."
        case "t1-technical-evaluator":         return "Procurement-armored security architect."
        case "t2-founder-non-customer":        return "Founder of a peer co. Not buying. Polite. Will ghost."
        case "t2-design-partner":              return "Warm design partner. Generous with feedback."
        case "t3-transactional-direct-buyer":  return "Knows what she wants. Skip the dance. Anchors aggressively."
        case "t3-transactional-comparison":    return "Comparison-shopper. You are one of three quotes."
        case "t3-auto-floor-traffic":          return "Saturday auto floor. Hostile to pressure. Buying today if respected."
        case "t4-procurement-specialist":      return "Procurement specialist. Reactance fires fast."
        case "t4-board-stakeholder-skeptic":   return "Independent board director. Audit-committee posture."
        case "t4-litigator-counterparty":      return "Litigator across the table. Every word is a record."
        case "t4-labor-counterparty":          return "Union rep. Ratification probability is the real metric."
        case "t5-research-academic":           return "Academic researcher. Survives peer review or doesn't."
        case "t5-research-operator":           return "Data-team lead. Knows the playbook cold."
        default:                                return "\(p.persuasionKnowledge.label)-savvy buyer, \(p.readability.rawValue) to read."
        }
    }
}
