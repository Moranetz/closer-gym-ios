import XCTest
@testable import FrameFork

/// Locks the 2026-07-03 audit fixes against regression: scoring exploits
/// (re-solve/daily/short-game rating farms), the local-vs-UTC daily key, the
/// lossy history decode, the bot-ladder floor unlock, and the puzzle-data
/// invariants the reveal UI depends on.
final class RegressionTests: XCTestCase {

    // MARK: - Store fixture
    // Isolated suite, NEVER UserDefaults.standard: these tests are hosted inside
    // FrameFork.app, where .standard is the app's real container — clearing it
    // would destroy actual on-device progress on every ⌘U.

    private static let suiteName = "framefork-regression-tests"

    @MainActor
    private func freshStore() -> Store {
        let suite = UserDefaults(suiteName: Self.suiteName)!
        suite.removePersistentDomain(forName: Self.suiteName)
        return Store(defaults: suite)
    }

    override func tearDown() {
        UserDefaults(suiteName: Self.suiteName)?.removePersistentDomain(forName: Self.suiteName)
        super.tearDown()
    }

    @discardableResult
    @MainActor
    private func solve(_ store: Store, id: String = "p001", correct: Bool = true,
                       isDaily: Bool = false, todayKey: String? = nil)
    -> (newRating: Double, delta: Double, newStreak: Int, rated: Bool) {
        store.recordSolve(puzzleId: id,
                          pickedIndex: correct ? 0 : 1,
                          bestIndex: 0,
                          pickedEval: correct ? 1.0 : -0.5,
                          puzzleDifficulty: 1600,
                          timeRemainingSec: 0,
                          isDaily: isDaily,
                          todayKey: todayKey)
    }

    // MARK: - Rating-farm locks

    @MainActor
    func testReSolve_isUnrated() {
        let store = freshStore()
        let first = solve(store)
        XCTAssertTrue(first.rated)
        XCTAssertGreaterThan(first.delta, 0, "a first correct solve must move the rating")

        let second = solve(store)
        XCTAssertFalse(second.rated, "re-solving a revealed puzzle must not be rated")
        XCTAssertEqual(second.delta, 0)
        XCTAssertEqual(second.newRating, first.newRating, accuracy: 0.001)
        XCTAssertEqual(store.puzzleState.solves.count, 2, "practice re-solves still recorded for history")
    }

    @MainActor
    func testDaily_secondAttemptSameDay_isNeitherScoredNorRecorded() {
        let store = freshStore()
        // Fixed date — a live todayKey() computed twice can straddle midnight and flake.
        let today = Store.todayKey(date: Date(timeIntervalSinceReferenceDate: 772_000_000))
        let first = solve(store, isDaily: true, todayKey: today)
        XCTAssertEqual(first.newStreak, 1)

        let replay = solve(store, isDaily: true, todayKey: today)
        XCTAssertFalse(replay.rated)
        XCTAssertEqual(replay.delta, 0)
        XCTAssertEqual(replay.newStreak, 1, "a same-day re-entry must not touch the settled streak")
        XCTAssertEqual(store.puzzleState.solves.count, 1, "a same-day daily re-entry must not append history")
    }

    @MainActor
    func testDaily_failedAttempt_locksTheDayAndZeroesStreak() {
        let store = freshStore()
        // dailyAttemptedToday compares against the LIVE todayKey, so this one test
        // must use it too; the assertion pair executes in the same instant for
        // practical purposes, and a midnight straddle only skips the lock check.
        let today = Store.todayKey()
        let miss = solve(store, correct: false, isDaily: true, todayKey: today)
        XCTAssertEqual(miss.newStreak, 0)
        XCTAssertEqual(store.puzzleState.lastDailyDate, today, "a failed daily must still consume the day")
    }

    @MainActor
    func testRecordGame_clampsScoreInto0to1() {
        let store = freshStore()
        let sane = store.recordGame(botRating: 1600, score: 1.0, personaId: "x",
                                    evalCurve: [], intentTechniques: [], firedTechniques: [], durationSec: 60)
        let store2 = freshStore()
        let wild = store2.recordGame(botRating: 1600, score: 7.0, personaId: "x",
                                     evalCurve: [], intentTechniques: [], firedTechniques: [], durationSec: 60)
        XCTAssertEqual(wild.newRating, sane.newRating, accuracy: 0.001,
                       "an out-of-range score must be clamped, not amplify the rating unboundedly")
    }

    // MARK: - Day-key consistency (the UTC daily bug)

    func testDailyId_isStableAcrossOneLocalDay() {
        // Under the old ISO8601/UTC key, noon and 18:00 local (west of UTC) straddled
        // UTC midnight and served two different "dailies" on one local day.
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .current
        let noon = cal.date(from: DateComponents(year: 2026, month: 7, day: 3, hour: 12))!
        let evening = cal.date(from: DateComponents(year: 2026, month: 7, day: 3, hour: 18))!
        let lateNight = cal.date(from: DateComponents(year: 2026, month: 7, day: 3, hour: 23, minute: 50))!
        XCTAssertEqual(Puzzles.dailyId(for: noon), Puzzles.dailyId(for: evening))
        XCTAssertEqual(Puzzles.dailyId(for: noon), Puzzles.dailyId(for: lateNight))
        XCTAssertEqual(Store.todayKey(date: noon), "2026-07-03")
    }

    func testYesterdayKey() {
        XCTAssertEqual(Store.yesterdayKey("2026-07-03"), "2026-07-02")
        XCTAssertEqual(Store.yesterdayKey("2026-01-01"), "2025-12-31")
        XCTAssertEqual(Store.yesterdayKey("garbage"), "")
    }

    // MARK: - Lossy history decode

    func testPuzzleStateDecode_dropsOnlyTheCorruptSolve() throws {
        let good = #"{"puzzleId":"p001","pickedIndex":0,"correct":true,"evalGained":1.0,"solvedAt":772000000,"timeRemainingSec":0}"#
        let corrupt = #"{"puzzleId":"p002","pickedIndex":0,"correct":true,"evalGained":1.0,"solvedAt":"not-a-date","timeRemainingSec":0}"#
        let good2 = good.replacingOccurrences(of: "p001", with: "p003")
        let json = #"{"solves":[\#(good),\#(corrupt),\#(good2)],"currentStreak":4}"#
        let state = try JSONDecoder().decode(PuzzleState.self, from: Data(json.utf8))
        XCTAssertEqual(state.solves.map(\.puzzleId), ["p001", "p003"],
                       "one corrupt record must drop only itself, never the whole history")
        XCTAssertEqual(state.currentStreak, 4)
    }

    @MainActor
    func testRecordGame_unratedIsRecordedButRatingFixed() {
        let store = freshStore()
        let before = store.gameState.rating.rating
        let r = store.recordGame(botRating: 1600, score: 1.0, personaId: "x",
                                 evalCurve: [0, 1], intentTechniques: [], firedTechniques: [],
                                 durationSec: 30, turns: [], judgment: nil, rated: false)
        XCTAssertEqual(r.newRating, before, accuracy: 0.0001, "unrated game must not move the rating")
        XCTAssertEqual(r.delta, 0)
        XCTAssertEqual(store.gameState.games.count, 1, "unrated game must still be recorded")
        XCTAssertFalse(store.gameState.games[0].rated)
    }

    // MARK: - Miss queue (backbone of the Review-your-misses screen)

    @MainActor
    func testMissedPuzzleIds_oldestFirst_andClearedByReSolve() {
        let store = freshStore()
        solve(store, id: "p012", correct: false)   // oldest miss
        solve(store, id: "p046", correct: false)
        solve(store, id: "p001", correct: true)    // correct → never in the queue
        solve(store, id: "p017", correct: false)   // newest miss
        XCTAssertEqual(store.missedPuzzleIds, ["p012", "p046", "p017"])

        solve(store, id: "p046", correct: true)    // clearing a miss removes it
        XCTAssertEqual(store.missedPuzzleIds, ["p012", "p017"])

        solve(store, id: "p012", correct: false)   // re-missing keeps it queued
        XCTAssertTrue(store.missedPuzzleIds.contains("p012"))
    }

    // MARK: - Bot ladder

    func testBotLadder_lowestBotAlwaysUnlocked() {
        let cheapest = BotLadder.all.first!
        XCTAssertTrue(BotLadder.isUnlocked(cheapest, playerRating: 1200),
                      "a fresh player (1200) must always have at least one opponent")
        XCTAssertTrue(BotLadder.isUnlocked(cheapest, playerRating: 0))
        XCTAssertEqual(BotLadder.all.map(\.rating), BotLadder.all.map(\.rating).sorted(),
                       "ladder must be ascending so .first is the cheapest bot")
    }

    // MARK: - Sparring arc invariants

    func testSparringArcs_invariants() {
        XCTAssertFalse(Arcs.all.isEmpty)
        for arc in Arcs.all {
            XCTAssertNotNil(Personas.get(arc.personaId), "\(arc.personaId): arc for unknown persona")
            XCTAssertNotNil(arc.nodes[arc.startNode], "\(arc.personaId): dangling startNode")
            var endReachable = false
            for (id, node) in arc.nodes {
                XCTAssertEqual(node.candidates.count, 3, "\(arc.personaId)/\(id): must have exactly 3 candidates")
                for c in node.candidates {
                    XCTAssertTrue(c.next == "end" || arc.nodes[c.next] != nil, "\(arc.personaId)/\(id): dangling next '\(c.next)'")
                    XCTAssertTrue((-0.6...0.5).contains(c.evalDelta), "\(arc.personaId)/\(id): evalDelta out of band")
                    XCTAssertFalse(c.techniqueTags.isEmpty, "\(arc.personaId)/\(id): untagged candidate (tag-presence tell)")
                    if c.next == "end" { endReachable = true }
                }
                // Anti-tell: the strong candidate must not always be the longest option.
            }
            XCTAssertTrue(endReachable, "\(arc.personaId): no path reaches 'end'")
            let strongLongest = arc.nodes.values.filter { n in
                let best = n.candidates.max(by: { $0.evalDelta < $1.evalDelta })!
                return best.text.count > n.candidates.filter { $0.text != best.text }.map(\.text.count).max() ?? 0
            }.count
            XCTAssertLessThan(strongLongest, arc.nodes.count / 2 + 1,
                              "\(arc.personaId): strong candidate is longest in \(strongLongest)/\(arc.nodes.count) nodes — length tell")
        }
    }

    func testForkFlags_scarceAndOnBestOnly() {
        // 2-of-3 blind-consensus Forks (2026-07-04 panel): scarcity 2–5% of the bank,
        // flags only ever on the best candidate, and the verdict pipeline honors them.
        let forks = Puzzles.all.filter { $0.candidates.contains(where: \.isFork) }
        XCTAssertTrue((2...5).contains(forks.count), "Fork count \(forks.count) outside scarcity band")
        for p in Puzzles.all {
            for (i, c) in p.candidates.enumerated() where c.isFork || c.isSharp {
                XCTAssertEqual(i, p.bestIndex, "\(p.id): hero flag on a non-best candidate")
            }
        }
        XCTAssertEqual(Verdict.from(pickedEval: 0.8, isBestPick: true, isFork: true), .fork)
        XCTAssertEqual(Verdict.from(pickedEval: 0.8, isBestPick: true, isSharp: true), .sharp)
        XCTAssertEqual(Verdict.from(pickedEval: 0.8, isBestPick: false, isFork: true), Verdict.from(pickedEval: 0.8, isBestPick: false), "flags must not leak onto wrong picks")
    }

    // MARK: - Puzzle data invariants (referenced by the Puzzles.swift header)

    func testPuzzleData_invariants() {
        XCTAssertEqual(Puzzles.all.count, Set(Puzzles.all.map(\.id)).count, "duplicate puzzle ids")
        for p in Puzzles.all {
            XCTAssertEqual(p.candidates.count, 4, "\(p.id): must have exactly 4 candidates")
            XCTAssertTrue(p.candidates.indices.contains(p.bestIndex), "\(p.id): bestIndex out of bounds")
            let bestEval = p.candidates[p.bestIndex].eval
            for (i, c) in p.candidates.enumerated() where i != p.bestIndex {
                XCTAssertGreaterThan(bestEval, c.eval, "\(p.id): best move must have the strictly-top eval")
            }
            XCTAssertTrue((1200...2400).contains(p.difficulty), "\(p.id): difficulty out of band")
            if let t = p.transcriptId {
                XCTAssertNotNil(Transcripts.get(t), "\(p.id): dangling transcriptId \(t)")
            }
        }
    }
}
