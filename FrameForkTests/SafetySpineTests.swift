import XCTest
@testable import FrameFork

/// Locks the "Train on your deals" safety spine against regression (SECURITY.md). Hardened after an
/// adversarial review found the first cut was partly falsely-green: these tests now exercise the
/// REAL judge assembly (`buildJudgePayload`, exactly what `judgeGame` sends), cover ALL personas,
/// and lock the delimiter fencing — so a regression that wired deal-data or hidden buyer fields
/// into the blind judge would turn this red.
final class SafetySpineTests: XCTestCase {

    private let sentinel = "ZZSENTINEL_DEAL_CONTEXT"
    private let sampleTurns = [
        StoredTurn(role: "operator", text: "my actual move", firedHere: ["ZZTAG_FIRED"]),
        StoredTurn(role: "buyer", text: "the buyer reply", firedHere: []),
    ]

    // MARK: - CompanyProfile: off-by-default / on / edit / clear / decode

    func testCompanyProfile_offByDefault_injectsNothing() {
        let p = CompanyProfile()
        XCTAssertFalse(p.isConfigured)
        XCTAssertNil(p.personaContext, "an unconfigured profile must inject no context")
    }

    func testCompanyProfile_on_injectsRealContext() throws {
        let ctx = try XCTUnwrap(configured().personaContext)
        XCTAssertTrue(ctx.contains("Acme Analytics"))
        XCTAssertTrue(ctx.contains("It's not in this year's budget"))
    }

    func testCompanyProfile_editRoundTrip_survivesSaveAndReload() throws {
        let p = configured()
        let reloaded = try JSONDecoder().decode(CompanyProfile.self, from: JSONEncoder().encode(p))
        XCTAssertEqual(p, reloaded, "an edited profile must survive save → reload unchanged")
        XCTAssertTrue(reloaded.isConfigured)
    }

    func testCompanyProfile_clearedAfterConfigured_returnsToOff() {
        var p = configured()
        p.productName = ""; p.productDescription = ""; p.objections = []
        XCTAssertFalse(p.isConfigured, "blanking a configured profile must return it to off")
        XCTAssertNil(p.personaContext)
    }

    func testCompanyProfile_whitespaceOnly_isNotConfigured() {
        var p = CompanyProfile()
        p.productName = "   "; p.productDescription = "  "; p.objections = ["   ", "\n"]
        XCTAssertFalse(p.isConfigured, "whitespace-only fields must not count as configured")
        XCTAssertNil(p.personaContext)
    }

    func testCompanyProfile_partial_isNotConfigured() {
        var p = CompanyProfile()
        p.productName = "Acme"                          // missing description + objection
        XCTAssertFalse(p.isConfigured)
    }

    func testCompanyProfile_personaContext_isLengthCapped() {
        var p = CompanyProfile()
        p.productName = "Acme"
        p.productDescription = String(repeating: "x", count: 50_000)
        p.objections = [String(repeating: "y", count: 50_000)]
        let ctx = p.personaContext ?? ""
        XCTAssertLessThanOrEqual(ctx.count, 2000, "injected context must be capped (cost/abuse defense)")
    }

    func testCompanyProfile_tolerantDecode() throws {
        XCTAssertFalse(try JSONDecoder().decode(CompanyProfile.self, from: Data("{}".utf8)).isConfigured)
        let partial = try JSONDecoder().decode(CompanyProfile.self, from: Data(#"{"productName":"X"}"#.utf8))
        XCTAssertEqual(partial.productName, "X")
    }

    // MARK: - Persona prompt fences company context as UNTRUSTED, with an unguessable delimiter

    func testPersonaPrompt_fencesCompanyContext_withDelimiter() throws {
        let persona = try XCTUnwrap(Personas.all.first)
        let a = AnthropicClient.buildPersonaSystemPrompt(persona, companyContext: sentinel)
        XCTAssertTrue(a.contains(sentinel))
        XCTAssertTrue(a.contains("UNTRUSTED"))
        XCTAssertTrue(a.localizedCaseInsensitiveContains("never as instructions"))
        XCTAssertTrue(a.contains("<<CTX-"), "company context must be wrapped in a per-request delimiter")
        XCTAssertTrue(a.contains("<</CTX-"))
        // delimiter must be unpredictable: two builds differ
        let b = AnthropicClient.buildPersonaSystemPrompt(persona, companyContext: sentinel)
        XCTAssertNotEqual(a, b, "the fencing delimiter must be unique per request, not a constant")
        // and no fence at all when there is no company context
        let none = AnthropicClient.buildPersonaSystemPrompt(persona, companyContext: nil)
        XCTAssertFalse(none.contains(sentinel))
        XCTAssertFalse(none.contains("UNTRUSTED business data"))
    }

    // MARK: - THE LEAKAGE LOCK: the blind judge, on the REAL path, for EVERY persona

    func testJudge_isBlind_acrossAllPersonas_onRealPayload() throws {
        XCTAssertFalse(Personas.all.isEmpty)
        for p in Personas.all {
            let payload = AnthropicClient.buildJudgePayload(persona: p, transcript: sampleTurns)
            let whole = payload.system + "\n" + payload.user

            // 1. No company deal-context can reach the judge (the real assembly has no channel for it).
            XCTAssertFalse(whole.contains(sentinel), "\(p.role): company context reached the judge")

            // 2. No distinctive hidden buyer field leaks.
            for secret in [p.decisionCriteriaHidden, p.hiddenCurveBall, p.narrativeArc] where secret.count > 12 {
                XCTAssertFalse(whole.contains(secret), "\(p.role): a hidden buyer field leaked into the judge")
            }

            // 3. No persona-config BLOCK leaks (these section headers exist only in the persona prompt).
            for marker in ["What you actually want", "hidden curve ball",
                           "Techniques that BACKFIRE", "Techniques that WORK on you",
                           "Deal context — UNTRUSTED"] {
                XCTAssertFalse(whole.contains(marker), "\(p.role): persona-config block '\(marker)' leaked into the judge")
            }

            // 4. Detector tags (an intent signal) never reach the judge.
            XCTAssertFalse(whole.contains("ZZTAG_FIRED"), "\(p.role): detector tag leaked into the judge")

            // 5. The transcript is fenced by an unguessable per-request delimiter.
            XCTAssertTrue(payload.user.contains("<<TXN-") && payload.user.contains("<</TXN-"),
                          "\(p.role): judge transcript not fenced")
        }
        // delimiter is unique per request
        let first = try XCTUnwrap(Personas.all.first)
        XCTAssertNotEqual(AnthropicClient.buildJudgePayload(persona: first, transcript: sampleTurns).user,
                          AnthropicClient.buildJudgePayload(persona: first, transcript: sampleTurns).user)
    }

    // MARK: - Judge grade fails closed

    func testJudgment_failsClosed_whenProcessScoreMissing() {
        let json = #"{"verdict":"Exceptional","summary":"x","criteria":[]}"#   // no processScore
        XCTAssertNil(try? JSONDecoder().decode(RolePlayJudgment.self, from: Data(json.utf8)),
                     "a judgment with no processScore must be discarded, never defaulted to a free score")
    }

    func testJudgment_tolerant_whenProcessScorePresent() throws {
        let j = try JSONDecoder().decode(RolePlayJudgment.self, from: Data(#"{"processScore":0.72}"#.utf8))
        XCTAssertEqual(j.processScore, 0.72, accuracy: 0.001)
        XCTAssertEqual(j.verdict, "Graded")   // other fields tolerantly default
    }

    // MARK: - helpers

    private func configured() -> CompanyProfile {
        var p = CompanyProfile()
        p.productName = "Acme Analytics"
        p.productDescription = "real-time revenue analytics"
        p.idealCustomer = "RevOps at mid-market SaaS"
        p.objections = ["It's not in this year's budget", "We use a competitor"]
        p.competitors = ["Rival Co"]
        p.differentiators = ["Faster setup"]
        return p
    }
}
