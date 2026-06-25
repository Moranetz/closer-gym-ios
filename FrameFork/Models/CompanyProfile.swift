import Foundation

/// A sales team's own deal context — what they sell and the objections they actually face.
///
/// Two jobs:
///   1. RELEVANCE (today, on the existing key): injected as CONTEXT into the buyer persona so a
///      role-play argues with the team's real objections. This is the adoption hook — a tired rep
///      opens it because it's about their product, not a generic script.
///   2. The DATA FLYWHEEL (gated on the backend): a structured corpus of what real teams sell and
///      the objections they hit. Syncing it to improve Frame & Fork is a SEPARATE, CONSENTED step
///      that activates only when the server exists — nothing here leaves the device today.
///
/// Org-level by design (it describes the company, not the user), so once accounts land it is set
/// once by an admin and shared across the team.
public struct CompanyProfile: Codable, Equatable, Sendable {
    public var productName: String = ""
    public var productDescription: String = ""   // what you sell, 1–2 lines
    public var idealCustomer: String = ""        // ICP / segment
    public var objections: [String] = []         // the gold: objections deals actually stall on
    public var competitors: [String] = []
    public var differentiators: [String] = []

    public init() {}

    /// Tolerant decode so older installs (no profile, or a future added field) still load.
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        productName        = (try? c.decodeIfPresent(String.self, forKey: .productName)) ?? ""
        productDescription = (try? c.decodeIfPresent(String.self, forKey: .productDescription)) ?? ""
        idealCustomer      = (try? c.decodeIfPresent(String.self, forKey: .idealCustomer)) ?? ""
        objections         = (try? c.decodeIfPresent([String].self, forKey: .objections)) ?? []
        competitors        = (try? c.decodeIfPresent([String].self, forKey: .competitors)) ?? []
        differentiators    = (try? c.decodeIfPresent([String].self, forKey: .differentiators)) ?? []
    }

    /// Minimum that yields meaningful relevance: what you sell + at least one real objection.
    public var isConfigured: Bool {
        let hasObjection = objections.contains { !$0.trimmedNonEmpty.isEmpty }
        return !productName.trimmedNonEmpty.isEmpty
            && !productDescription.trimmedNonEmpty.isEmpty
            && hasObjection
    }

    /// Context block injected into the buyer persona. It sets WHAT the deal is about; it never
    /// overrides the persona's character or its hidden criteria (the system prompt re-states that).
    public var personaContext: String? {
        guard isConfigured else { return nil }
        let objs = objections.map { $0.trimmedNonEmpty }.filter { !$0.isEmpty }
        let comps = competitors.map { $0.trimmedNonEmpty }.filter { !$0.isEmpty }
        let diffs = differentiators.map { $0.trimmedNonEmpty }.filter { !$0.isEmpty }
        var lines: [String] = ["# Real-world deal context (make the conversation about this deal)"]
        lines.append("The rep is selling: \(productName.trimmedNonEmpty) — \(productDescription.trimmedNonEmpty).")
        if !idealCustomer.trimmedNonEmpty.isEmpty { lines.append("Typical buyer / segment: \(idealCustomer.trimmedNonEmpty).") }
        if !objs.isEmpty {
            lines.append("Raise these REAL objections naturally when they fit — they are the ones this rep's deals actually stall on:")
            for o in objs { lines.append("- \(o)") }
        }
        if !comps.isEmpty { lines.append("Competitors you might compare against: \(comps.joined(separator: ", ")).") }
        if !diffs.isEmpty { lines.append("Things that would genuinely move you, if the rep earns them: \(diffs.joined(separator: "; ")).") }
        lines.append("This only sets what the deal is about. Stay fully in your assigned character and keep every hidden-criteria and curveball rule above.")
        return lines.joined(separator: "\n")
    }
}

private extension String {
    var trimmedNonEmpty: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
