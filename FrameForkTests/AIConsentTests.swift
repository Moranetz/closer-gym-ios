import XCTest
@testable import FrameFork

/// Locks the App Store Guideline 5.1.2(i) consent gate: default OFF, `grant()` persists,
/// `revoke()` clears. `AIConsent` is a thin wrapper over `UserDefaults.standard` (same
/// pattern as `framefork:hasSeenOnboarding:v1`) — snapshot/restore the ONE key it touches
/// so this never leaves the real device state dirty.
final class AIConsentTests: XCTestCase {

    private let key = "framefork:aiConsent:v1"
    private var original: Bool = false

    override func setUp() {
        super.setUp()
        original = UserDefaults.standard.bool(forKey: key)
        UserDefaults.standard.removeObject(forKey: key)
    }

    override func tearDown() {
        if original {
            UserDefaults.standard.set(true, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        super.tearDown()
    }

    func testDefault_isNotGranted() {
        XCTAssertFalse(AIConsent.granted, "a fresh install must not have consent granted")
    }

    func testGrant_persists() {
        AIConsent.grant()
        XCTAssertTrue(AIConsent.granted)
        XCTAssertTrue(UserDefaults.standard.bool(forKey: key), "grant() must persist under the versioned key")
    }

    func testRevoke_clears() {
        AIConsent.grant()
        XCTAssertTrue(AIConsent.granted)
        AIConsent.revoke()
        XCTAssertFalse(AIConsent.granted, "revoke() must clear a prior grant")
    }

    func testRevoke_beforeGrant_isSafe() {
        AIConsent.revoke()
        XCTAssertFalse(AIConsent.granted, "revoking with nothing granted must not throw or flip to true")
    }
}
