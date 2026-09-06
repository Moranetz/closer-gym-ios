import XCTest
@testable import FrameFork

/// Locks the fresh-install copy (PRESENT-BUT-BLANK fix, 2026-09-02): a day-one user
/// must read a sentence that says what fills the number, never "0 puzzles solved ·
/// 0-day streak · longest 0".
final class FirstRunStringsTests: XCTestCase {

    // MARK: - Profile identity line

    func testFirstRunSummary_zeroSolved_returnsExplainerSentence() {
        XCTAssertEqual(firstRunSummary(solved: 0, streak: 0, longest: 0),
                        "Solve one puzzle and this line starts counting.")
    }

    func testFirstRunSummary_solvedButNoStreak_returnsStreakPrompt() {
        XCTAssertEqual(firstRunSummary(solved: 3, streak: 0, longest: 2),
                        "3 puzzles solved. One today starts a streak.")
    }

    func testFirstRunSummary_realStreak_returnsNilSoCallerUsesNormalLine() {
        XCTAssertNil(firstRunSummary(solved: 5, streak: 2, longest: 4))
    }

    // MARK: - Puzzles tab "Today" card

    func testFirstRunDrillLine_noDrillsYet_returnsPlainLine() {
        XCTAssertEqual(firstRunDrillLine(drillsToday: 0),
                        "Your rating starts moving with today's drill.")
    }

    func testFirstRunDrillLine_oneDrill_isSingular() {
        XCTAssertEqual(firstRunDrillLine(drillsToday: 1), "1 drill today")
    }

    func testFirstRunDrillLine_multipleDrills_isPlural() {
        XCTAssertEqual(firstRunDrillLine(drillsToday: 3), "3 drills today")
    }

    // MARK: - Provisional gate

    func testGlickoState_coldStart_isProvisional() {
        XCTAssertTrue(GlickoState().isProvisional, "the 1200/RD350 cold start must not read as an earned class")
    }

    func testGlickoState_lowRD_isNotProvisional() {
        let calibrated = GlickoState(rating: 1450, rd: 120, volatility: initialVolatility)
        XCTAssertFalse(calibrated.isProvisional)
    }

    // Fleet round 143. The suite tested this function at 0, 3 and 5 solves and stepped over 1,
    // which is the only value that breaks it and the first one a real player reaches.
    func testExactlyOneSolveReadsAsOnePuzzle() {
        XCTAssertEqual(firstRunSummary(solved: 1, streak: 0, longest: 0),
                       "1 puzzle solved. One today starts a streak.")
    }

    func testCountNounAgreesAtOneAndAtMany() {
        XCTAssertEqual(countNoun(1, "puzzle"), "1 puzzle")
        XCTAssertEqual(countNoun(2, "puzzle"), "2 puzzles")
        XCTAssertEqual(countNoun(0, "puzzle"), "0 puzzles")
    }

    func testCountNounTakesAnIrregularPlural() {
        XCTAssertEqual(countNoun(1, "try", plural: "tries"), "1 try")
        XCTAssertEqual(countNoun(4, "try", plural: "tries"), "4 tries")
    }

    func testANegativeCountStillReadsAsAPlural() {
        XCTAssertEqual(countNoun(-1, "solve"), "-1 solves")
    }
}
