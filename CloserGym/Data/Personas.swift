import Foundation

/// Minimal persona stubs — full personas + ELO + tagline live in
/// closer-sparring's web repo. The iOS v0.1 only references persona role
/// names through master-game and puzzle data; full bot ladder ships in v0.2
/// once Pro tier is wired up.
public enum Personas {
    public static let all: [String: String] = [
        "t1-economic-buyer-cfo":          "CFO at $200M–$1B SaaS",
        "t1-champion-vp-eng":             "VP Eng, growth-stage SaaS",
        "t1-technical-evaluator":         "Security architect",
        "t2-founder-non-customer":        "Founder of a peer co.",
        "t2-design-partner":              "Design partner",
        "t3-transactional-direct-buyer":  "Direct buyer",
        "t3-transactional-comparison":    "Comparison-shopper",
        "t3-auto-floor-traffic":          "Couple on the auto floor",
        "t4-procurement-specialist":      "Senior procurement specialist",
        "t4-procurement-counterparty":    "Procurement counterparty",
        "t4-board-stakeholder-skeptic":   "Independent board director",
        "t4-litigator-counterparty":      "Litigator across the table",
        "t4-labor-counterparty":          "Union representative",
        "t5-research-academic":           "Academic researcher",
        "t5-research-operator":           "Operator-researcher",
        "t5-keynote-buyer":               "Head of Sales Enablement",
        "t5-podcast-host-curator":        "Top-10 sales podcast host",
        "t5-fellow-author-positioning":   "Established sales author",
    ]
}
