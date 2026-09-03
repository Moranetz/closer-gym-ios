import XCTest
@testable import FrameFork

/// `Technique.plain` is the one-liner the Lessons card shows a founder or rep on
/// their phone — plain English, no lab-notes register. This locks the shape so a
/// future edit can't silently regress it back into jargon.
final class TechniquePlainTests: XCTestCase {
    func testEveryTechniqueHasNonEmptyPlain() {
        for t in AtlasTechniques.all {
            XCTAssertFalse(t.plain.trimmingCharacters(in: .whitespaces).isEmpty,
                            "\(t.id) has an empty plain line")
        }
    }

    func testPlainIsAtMostFourteenWords() {
        for t in AtlasTechniques.all {
            let wordCount = t.plain.split(separator: " ").count
            XCTAssertLessThanOrEqual(wordCount, 14,
                                      "\(t.id) plain line is \(wordCount) words: \"\(t.plain)\"")
        }
    }

    func testPlainAvoidsBannedConstructs() {
        for t in AtlasTechniques.all {
            XCTAssertFalse(t.plain.contains(";"), "\(t.id) plain line has a semicolon")
            XCTAssertFalse(t.plain.contains("—"), "\(t.id) plain line has an em-dash")
            XCTAssertFalse(t.plain.contains(" - "), "\(t.id) plain line has a spaced dash")
            XCTAssertFalse(t.plain.contains(", not "), "\(t.id) plain line uses the \"X, not Y\" pattern")
        }
    }

    func testNoTwoPlainLinesAreIdentical() {
        let all = AtlasTechniques.all.map { $0.plain }
        let unique = Set(all)
        XCTAssertEqual(all.count, unique.count, "Two or more techniques share an identical plain line")
    }
}

/// `Technique.plainFailure` is the one-liner the Lessons detail view shows under
/// "Primary failure mode" — plain English, no lab-notes register. `primaryFailureMode`
/// stays as the record underneath it. Locks the shape so a future edit can't
/// silently regress it back into jargon.
final class TechniquePlainFailureTests: XCTestCase {
    func testEveryTechniqueHasNonEmptyPlainFailure() {
        for t in AtlasTechniques.all {
            XCTAssertFalse(t.plainFailure.trimmingCharacters(in: .whitespaces).isEmpty,
                            "\(t.id) has an empty plainFailure line")
        }
    }

    func testPlainFailureIsAtMostSixteenWords() {
        for t in AtlasTechniques.all {
            let wordCount = t.plainFailure.split(separator: " ").count
            XCTAssertLessThanOrEqual(wordCount, 16,
                                      "\(t.id) plainFailure line is \(wordCount) words: \"\(t.plainFailure)\"")
        }
    }

    func testPlainFailureAvoidsBannedConstructs() {
        for t in AtlasTechniques.all {
            XCTAssertFalse(t.plainFailure.contains(";"), "\(t.id) plainFailure line has a semicolon")
            XCTAssertFalse(t.plainFailure.contains(" — "), "\(t.id) plainFailure line has an em-dash")
            XCTAssertFalse(t.plainFailure.contains(", not "), "\(t.id) plainFailure line uses the \"X, not Y\" pattern")
        }
    }

    func testNoTwoPlainFailureLinesAreIdentical() {
        let all = AtlasTechniques.all.map { $0.plainFailure }
        let unique = Set(all)
        XCTAssertEqual(all.count, unique.count, "Two or more techniques share an identical plainFailure line")
    }
}
