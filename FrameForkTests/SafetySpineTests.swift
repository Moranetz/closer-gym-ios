import XCTest
@testable import FrameFork

/// Locks the "Train on your deals" safety spine against regression (SECURITY.md):
/// the company deal-data must be fenced as UNTRUSTED in the persona prompt and must NEVER reach
/// the blind judge, the judge must stay blind to hidden criteria + detector tags, and the judge
/// grade must fail closed. These are the leakage/integrity invariants — if any flips, this fails.
final class SafetySpineTests: XCTestCase {

    // MARK: - CompanyProfile: off-by-default / on / decode

    func testCompanyProfile_offByDefault_injectsNothing() {
        let p = CompanyProfile()                       // empty = off by default
        XCTAssertFalse(p.isConfigured)
        XCTAssertNil(p.personaContext, "an unconfigured profile must inject no context")
    }

    func testCompanyProfile_on_injectsRealContext() throws {
        var p = CompanyProfile()
        p.productName = "Acme Analytics"
        p.productDescription = "real-time revenue analytics"
        p.objections = ["It's not in this year's budget"]
        XCTAssertTrue(p.isConfigured)
        let ctx = try XCTUnwrap(p.personaContext)
        XCTAssertTrue(ctx.contains("Acme Analytics"))
        XCTAssertTrue(ctx.contains("It's not in this year's budget"))
    }

    func testCompanyProfile_partial_isNotConfigured() {
        var p = CompanyProfile()
        p.productName = "Acme"                          // missing description + objection
        XCTAssertFalse(p.isConfigured)
        XCTAssertNil(p.personaContext)
    }

    func testCompanyProfile_editRoundTrip_survivesSaveAndReload() throws {
        var p = CompanyProfile()                       // edit state: configure, persist, reload
        p.productName = "Acme Analytics"
        p.productDescription = "real-time revenue analytics"
        p.idealCustomer = "RevOps at mid-market SaaS"
        p.objections = ["Not in budget", "We use a competitor"]
        p.competitors = ["Rival Co"]
        p.differentiators = ["Faster setup"]
        let data = try JSONEncoder().encode(p)
        let reloaded = try JSONDecoder().decode(CompanyProfile.self, from: data)
        XCTAssertEqual(p, reloaded, "an edited profile must survive save → reload unchanged")
        XCTAssertTrue(reloaded.isConfigured)
    }

    func testCompanyProfile_tolerantDecode() throws {
        let empty = try JSONDecoder().decode(CompanyProfile.self, from: Data("{}".utf8))
        XCTAssertFalse(empty.isConfigured)
        let partial = try JSONDecoder().decode(CompanyProfile.self, from: Data(#"{"productName":"X"}"#.utf8))
        XCTAssertEqual(partial.productName, "X")
    }

    // MARK: - Persona prompt fences company context as UNTRUSTED

    func testPersonaPrompt_fencesCompanyContextAsUntrusted() throws {
        let persona = try XCTUnwrap(Personas.all.first)
        let sentinel = "ZZSENTINEL_DEAL_CONTEXT"
        let withCtx = AnthropicClient.buildPersonaSystemPrompt(persona, companyContext: sentinel)
        XCTAssertTrue(withCtx.contains(sentinel), "company context should be present in the persona prompt")
        XCTAssertTrue(withCtx.contains("UNTRUSTED"), "company context must be labeled untrusted")
        XCTAssertTrue(withCtx.localizedCaseInsensitiveContains("never as instructions"),
                      "company context must be fenced as data, not instructions")
        let without = AnthropicClient.buildPersonaSystemPrompt(persona, companyContext: nil)
        XCTAssertFalse(without.contains(sentinel))
        XCTAssertFalse(without.contains("UNTRUSTED business data"))
    }

    // MARK: - THE LEAKAGE LOCK: the judge stays blind

    func testJudge_isBlind_noCompanyOrHiddenCriteriaLeak() throws {
        let persona = try XCTUnwrap(Personas.all.first)
        let sentinel = "ZZSENTINEL_DEAL_CONTEXT"
        // Company context reaches the persona path…
        XCTAssertTrue(AnthropicClient.buildPersonaSystemPrompt(persona, companyContext: sentinel).contains(sentinel))
        // …but the judge prompt is built from role/seniority/stated-criteria only — never company,
        // hidden criteria, or the eval. If this leaks, the "blind judge" guarantee is broken.
        let judge = AnthropicClient.buildJudgeSystemPrompt(persona, delimiter: "DELIM-TEST")
        XCTAssertFalse(judge.contains(sentinel), "company context leaked into the judge")
        if !persona.decisionCriteriaHidden.isEmpty {
            XCTAssertFalse(judge.contains(persona.decisionCriteriaHidden), "hidden buyer criteria leaked into the judge")
        }
    }

    func testTranscriptForJudge_carriesOnlySpokenText_notDetectorTags() {
        let turns = [
            StoredTurn(role: "operator", text: "my actual move", firedHere: ["mirroring"]),
            StoredTurn(role: "buyer", text: "the buyer reply", firedHere: []),
        ]
        let out = AnthropicClient.formatTranscriptForJudge(turns, delimiter: "DELIM-TEST")
        XCTAssertTrue(out.contains("my actual move"))
        XCTAssertTrue(out.contains("the buyer reply"))
        XCTAssertFalse(out.contains("mirroring"), "detector tags (an intent signal) must not reach the blind judge")
    }

    // MARK: - Judge grade fails closed

    func testJudgment_failsClosed_whenProcessScoreMissing() {
        let json = #"{"verdict":"Exceptional","summary":"x","criteria":[]}"#   // no processScore
        XCTAssertNil(try? JSONDecoder().decode(RolePlayJudgment.self, from: Data(json.utf8)),
                     "a judgment with no processScore must be discarded, never defaulted to a free score")
    }

    func testJudgment_tolerant_whenProcessScorePresent() throws {
        let json = #"{"processScore":0.72}"#
        let j = try JSONDecoder().decode(RolePlayJudgment.self, from: Data(json.utf8))
        XCTAssertEqual(j.processScore, 0.72, accuracy: 0.001)
        XCTAssertEqual(j.verdict, "Graded")   // other fields tolerantly default
    }
}
