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
