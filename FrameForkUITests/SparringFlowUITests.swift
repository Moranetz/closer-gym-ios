import XCTest

/// Plays a complete offline sparring arc end-to-end through the REAL UI —
/// the one verification the simulator's walled input can't do by hand:
/// launch → 8 picks → ending + debrief + rating line render.
final class SparringFlowUITests: XCTestCase {

    @MainActor
    func testSparringArc_playsToTheEnd() {
        let app = XCUIApplication()
        app.launchEnvironment["FF_INITIAL_TAB"] = "play"
        app.launchEnvironment["FF_PUSH_SPARRING"] = "1"
        app.launch()

        // The hero card's "She says" label marks a live turn.
        let sheSays = app.staticTexts["SHE SAYS"]
        XCTAssertTrue(sheSays.waitForExistence(timeout: 10), "sparring screen never appeared")

        // Play all 8 turns: always tap the first candidate card ("You say" row).
        for turn in 1...8 {
            let candidate = app.staticTexts.matching(NSPredicate(format: "label ==[c] %@", "YOU SAY")).firstMatch
            XCTAssertTrue(candidate.waitForExistence(timeout: 6), "no candidate visible at turn \(turn)")
            candidate.tap()
            // Between turns either the next hero or the debrief must arrive.
            let progressed = sheSays.waitForExistence(timeout: 4)
                || app.staticTexts["DEBRIEF"].waitForExistence(timeout: 4)
            XCTAssertTrue(progressed, "UI did not advance after pick \(turn)")
            if app.staticTexts["DEBRIEF"].exists { break }
        }

        // Ending must render: debrief card, per-turn review, and a rating line.
        XCTAssertTrue(app.staticTexts["DEBRIEF"].waitForExistence(timeout: 8), "debrief never rendered")
        // The ending reveals in staged beats — wait, don't poll a single frame.
        XCTAssertTrue(app.staticTexts["YOUR MOVES"].waitForExistence(timeout: 5), "per-turn review missing")
        XCTAssertTrue(app.staticTexts["DELTA"].waitForExistence(timeout: 5), "rating line missing")

        // Done returns to the ladder.
        app.buttons["Done"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Bring your own key"].waitForExistence(timeout: 6)
                      || app.navigationBars["Play"].waitForExistence(timeout: 6),
                      "Done did not return to the Play ladder")
    }
}
