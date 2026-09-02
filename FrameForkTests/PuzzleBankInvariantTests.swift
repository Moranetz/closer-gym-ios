import XCTest
@testable import FrameFork

/// Facts frozen while the puzzle bank's PROSE (setup/buyerLine/candidate text/
/// rationale/themeHint) is rewritten into register. This test snapshots every
/// fact that must never move during a prose-only pass — id, theme, difficulty,
/// bestIndex, candidate count, evals, atlasTags — against a fixture generated
/// from the bank BEFORE the prose rewrite began. A red run here means a prose
/// edit accidentally changed a fact, not just wording.
///
/// To regenerate the fixture (only ever intentional — e.g. a puzzle is added,
/// removed, re-scored, or re-tagged on purpose): flip `regenerateFixture` to
/// true, run this one test, flip it back to false, and review the diff.
final class PuzzleBankInvariantTests: XCTestCase {
    private static let regenerateFixture = false

    struct PuzzleSnapshot: Codable, Equatable {
        let id: String
        let theme: String
        let difficulty: Int
        let bestIndex: Int
        let candidateCount: Int
        let evals: [Double]
        let atlasTags: [[String]]
    }

    static func liveSnapshot() -> [PuzzleSnapshot] {
        Puzzles.all.map { p in
            PuzzleSnapshot(
                id: p.id,
                theme: p.theme.rawValue,
                difficulty: p.difficulty,
                bestIndex: p.bestIndex,
                candidateCount: p.candidates.count,
                evals: p.candidates.map { $0.eval },
                atlasTags: p.candidates.map { $0.atlasTags }
            )
        }
    }

    private var fixtureURL: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures/puzzle-bank-invariants.json")
    }

    func testPuzzleBank_factsMatchFrozenSnapshot() throws {
        let live = Self.liveSnapshot()

        if Self.regenerateFixture {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(live)
            try data.write(to: fixtureURL, options: .atomic)
            XCTFail("Fixture regenerated at \(fixtureURL.path) — set regenerateFixture back to false.")
            return
        }

        let data = try Data(contentsOf: fixtureURL)
        let expected = try JSONDecoder().decode([PuzzleSnapshot].self, from: data)

        XCTAssertEqual(live.count, expected.count, "Puzzle count changed — bank was added to or trimmed, not just reworded.")

        let expectedByID = Dictionary(uniqueKeysWithValues: expected.map { ($0.id, $0) })
        for actual in live {
            guard let frozen = expectedByID[actual.id] else {
                XCTFail("Puzzle \(actual.id) is not in the frozen fixture — new id introduced during a prose-only pass.")
                continue
            }
            XCTAssertEqual(actual, frozen, "Puzzle \(actual.id) facts drifted from the frozen snapshot — a prose edit changed a fact.")
        }
    }
}
