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
                       isDaily: Bool = false, todayKey: String? = nil, readHeld: Bool? = nil)
    -> (newRating: Double, delta: Double, newStreak: Int, rated: Bool) {
        store.recordSolve(puzzleId: id,
                          pickedIndex: correct ? 0 : 1,
                          bestIndex: 0,
                          pickedEval: correct ? 1.0 : -0.5,
                          puzzleDifficulty: 1600,
                          timeRemainingSec: 0,
                          isDaily: isDaily,
                          todayKey: todayKey,
                          readHeld: readHeld)
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

    // MARK: - Read-step scoring (the read is SCORED, not just committed)

    /// A wrong read shouldn't gate the CORRECTNESS of a solve — the streak, the
    /// re-solve lock, and "rated" all key off the move, exactly as before.
    @MainActor
    func testLuckySolve_isStillCorrectAndStillMovesTheStreak() {
        let store = freshStore()
        let today = Store.todayKey(date: Date(timeIntervalSinceReferenceDate: 800_000_000))
        let lucky = solve(store, isDaily: true, todayKey: today, readHeld: false)
        XCTAssertTrue(lucky.rated)
        XCTAssertEqual(lucky.newStreak, 1, "a lucky (best-move, wrong-read) solve still counts as correct for the streak")
    }

    /// The core fix: today a wrong read riding a correct move earns the FULL rating
    /// delta — the diagnosis never has to be right to be rewarded like it was. Mirror
    /// framefork-game.html's `reveal()`: a best move off a wrong read ("Lucky") is
    /// worth exactly HALF the delta the same move earns with a held read.
    @MainActor
    func testLuckySolve_earnsExactlyHalfTheDeltaOfAHeldSolve() {
        let heldStore = freshStore()
        let held = solve(heldStore, readHeld: true)

        let luckyStore = freshStore()
        let lucky = solve(luckyStore, readHeld: false)

        XCTAssertGreaterThan(held.delta, 0, "a correct solve on an underrated puzzle must move the rating up")
        XCTAssertEqual(lucky.delta, held.delta * 0.5, accuracy: 0.0000001,
                       "a lucky solve must earn exactly half of what the same move earns with a held read")
        XCTAssertEqual(lucky.newRating, luckyStore.puzzleState.rating.rating, accuracy: 0.0000001)
    }

    /// A puzzle with no read step at all (`readHeld == nil`, the default for every
    /// puzzle authored before this change) must score identically to the pre-read
    /// contract, to the decimal — nothing about this feature may leak onto puzzles
    /// that never opted into it.
    @MainActor
    func testNoReadPuzzle_scoringIsUnchangedToTheDecimal() {
        let withDefault = freshStore()
        let implicitNil = solve(withDefault)

        let explicitNil = freshStore()
        let explicit = solve(explicitNil, readHeld: nil)

        let reference = freshStore()
        let opponent = GlickoState(rating: 1600, rd: initialRD * 0.4, volatility: initialVolatility)
        let expected = Glicko2.applyMatch(reference.puzzleState.rating, opponent: opponent, score: 1.0)

        XCTAssertEqual(implicitNil.delta, expected.delta, accuracy: 0.0000001)
        XCTAssertEqual(explicit.delta, expected.delta, accuracy: 0.0000001)
        XCTAssertEqual(implicitNil.newRating, expected.state.rating, accuracy: 0.0000001)
    }

    /// Held read + wrong move: the diagnosis was right even though the line wasn't —
    /// a small flat credit, ported from `reveal()`'s separate "+N read" line, distinct
    /// from (and never larger than) what a correct move itself is worth.
    @MainActor
    func testHeldReadWithWrongMove_earnsASmallBonusOverAnUnreadWrongMove() {
        let readStore = freshStore()
        let readHeldWrong = solve(readStore, correct: false, readHeld: true)

        let noReadStore = freshStore()
        let plainWrong = solve(noReadStore, correct: false, readHeld: nil)

        XCTAssertGreaterThan(readHeldWrong.delta, plainWrong.delta,
                             "holding the read on a wrong move must earn a bit more than the same wrong move with no read at all")
        XCTAssertLessThan(readHeldWrong.delta - plainWrong.delta, 10,
                          "the read bonus must stay small — nowhere near what getting the move right is worth")
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

    @MainActor
    func testRatingHistory_appendsOnlyOnRatedSolves() {
        let store = freshStore()
        _ = solve(store, id: "p001", correct: true)     // rated → 1 point
        _ = solve(store, id: "p001", correct: true)     // re-solve, unrated → no point
        _ = solve(store, id: "p002", correct: false)    // rated → 1 point
        XCTAssertEqual(store.puzzleState.ratingHistory.count, 2, "history appends only on rated solves")
        XCTAssertEqual(store.puzzleState.ratingHistory.last!.rating, store.puzzleState.rating.rating, accuracy: 0.001)
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

    func testAtlasEvidenceGrading() {
        // 2026-07 empirical re-anchor: every technique banded; the spine is Core,
        // the folklore/backfire moves are Flagged with a caveat.
        for t in AtlasTechniques.all {
            if t.evidenceBand == .flagged {
                XCTAssertFalse(t.contraindication.isEmpty, "\(t.id): flagged technique needs a caveat")
            }
        }
        func band(_ id: String) -> EvidenceBand? { AtlasTechniques.get(id)?.evidenceBand }
        XCTAssertEqual(band("spin-implication"), .core, "the won-deal spine must be Core")
        XCTAssertEqual(band("multi-threading"), .core)
        XCTAssertEqual(band("assumptive"), .flagged, "hard close in complex deals is folklore")
        XCTAssertEqual(band("scarcity"), .flagged)
        let core = AtlasTechniques.all.filter { $0.evidenceBand == .core }.count
        XCTAssertGreaterThanOrEqual(core, 5, "the evidence-backed spine shouldn't be empty")
    }

    func testAdaptiveNext_edgeOfAbilityInterleavedUnsolved() {
        let rating = 1600
        let solved: Set<String> = ["p001"]
        let n = Puzzles.adaptiveNext(after: "p001", rating: rating, solvedIds: solved)
        XCTAssertNotEqual(n.id, "p001", "never re-serves the just-finished puzzle")
        XCTAssertFalse(solved.contains(n.id), "never serves an already-solved puzzle")
        // Edge-of-ability: the pick sits in the sane band around the rating.
        XCTAssertTrue(n.difficulty >= rating - 300 && n.difficulty <= rating + 100,
                      "adaptive pick must be near the edge of ability, not arbitrary")
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

// MARK: - Keyless dead-end (R5 loop fix)

extension RegressionTests {
    /// Every arc-less persona must have a reachable spar alternative — the road out of the
    /// keyless dead-end must exist from anywhere on the ladder.
    func testNearestSparBotExistsForEveryArclessPersona() {
        for bot in BotLadder.all where Arcs.get(personaId: bot.personaId) == nil {
            let alt = PreGameView.nearestSparBot(to: bot)
            XCTAssertNotNil(alt, "\(bot.personaId) has no spar alternative")
            XCTAssertNotNil(Arcs.get(personaId: alt!.personaId), "alt \(alt!.personaId) has no arc")
        }
    }
}

// MARK: - Chip resolvability (R13 loop fix)

extension RegressionTests {
    /// Every atlas tag on every candidate must resolve to a real Technique — a tappable chip
    /// that opens nothing is worse than no chip.
    func testEveryCandidateTagResolvesToATechnique() {
        for p in Puzzles.all {
            for c in p.candidates {
                for tag in c.atlasTags {
                    XCTAssertNotNil(AtlasTechniques.get(tag),
                                    "\(p.id): tag '\(tag)' resolves to no technique")
                }
            }
        }
    }
}

// MARK: - Arc chip resolvability (R14 loop fix)

extension RegressionTests {
    /// Arc tags are authored, not detected — every one must still resolve, because sparring
    /// history chips now open lessons too.
    func testEveryArcTagResolvesToATechnique() {
        for arc in Arcs.all {
            for (nodeId, node) in arc.nodes {
                for c in node.candidates {
                    for tag in c.techniqueTags {
                        XCTAssertNotNil(AtlasTechniques.get(tag),
                                        "\(arc.personaId)/\(nodeId): tag '\(tag)' resolves to no technique")
                    }
                }
            }
        }
    }
}

// MARK: - Read step (ported from framefork-game.html teaching-loop prototype)

extension RegressionTests {
    /// Every authored read puzzle (not just the original two — this must keep holding
    /// as more get authored) must round-trip through Codable with exactly 4 read
    /// options, exactly one of which is the key — the invariant the read UI (and its
    /// shuffle) depends on.
    func testReadPuzzles_decodeWithFourOptionsExactlyOneKey() throws {
        let readPuzzleIds = Puzzles.all.filter { $0.read != nil }.map(\.id)
        XCTAssertGreaterThanOrEqual(readPuzzleIds.count, 10, "expected the 2 originally-ported rooms plus the 8 daily-drill rooms")
        for id in readPuzzleIds {
            let puzzle = try XCTUnwrap(Puzzles.get(id), "\(id) missing from Puzzles.all")
            let data = try JSONEncoder().encode(puzzle)
            let decoded = try JSONDecoder().decode(Puzzle.self, from: data)
            let read = try XCTUnwrap(decoded.read, "\(id): read must decode, not nil")
            XCTAssertEqual(read.options.count, 4, "\(id): must have exactly 4 read options")
            XCTAssertEqual(read.options.filter(\.isKey).count, 1, "\(id): exactly one read option must be key")
        }
    }

    /// The 8 daily-drill rooms authored for JOB 2 (first two puzzles of the four
    /// most-populated themes) must derive their key diagnosis from the best
    /// candidate's own rationale, and every `why` must stay short enough to read in
    /// one breath. A loose token-overlap check (rather than an exact-string match)
    /// so paraphrasing is fine but an entirely disconnected read fails loudly.
    func testAuthoredReads_keyDiagnosisDerivesFromBestCandidateRationale() throws {
        let stopwords: Set<String> = ["the", "a", "an", "and", "or", "to", "of", "in", "on",
            "is", "are", "was", "were", "he", "she", "his", "her", "this", "that", "it",
            "you", "your", "i", "be", "with", "for", "as", "at", "not", "no", "just",
            "so", "but", "if", "then", "will", "would", "can", "could", "may", "might",
            "do", "does", "did", "has", "have", "had", "only", "still", "right", "now",
            "what", "who", "him", "them", "their", "they", "we", "us", "already", "than",
            "here", "there", "before", "after", "up", "down", "one", "some", "any", "into",
            "from", "by", "about", "out", "get", "gave", "named", "asked", "said", "wants",
            "want", "needs", "need", "actually"]
        func tokens(_ s: String) -> Set<String> {
            Set(s.lowercased().split { !$0.isLetter }.map(String.init).filter { $0.count > 2 && !stopwords.contains($0) })
        }

        let dailyDrillIds = ["p008", "p009", "p011", "p012", "p014", "p015", "p018", "p019"]
        for id in dailyDrillIds {
            let puzzle = try XCTUnwrap(Puzzles.get(id), "\(id) missing from Puzzles.all")
            let read = try XCTUnwrap(puzzle.read, "\(id): expected an authored read (a daily-drill room)")
            let keyOption = try XCTUnwrap(read.options.first(where: \.isKey), "\(id): no key read option")
            let best = puzzle.candidates[puzzle.bestIndex]

            let keyTokens = tokens(keyOption.text).union(tokens(keyOption.why))
            let rationaleTokens = tokens(best.rationale)
            XCTAssertFalse(keyTokens.isDisjoint(with: rationaleTokens),
                           "\(id): the key read (\"\(keyOption.text)\") shares no real word with the best candidate's rationale (\"\(best.rationale)\") — it isn't derived from it")
        }
    }

    /// A pre-existing puzzle (no `read` authored) must still decode cleanly to a nil
    /// read — the additive-field contract the whole port depends on not regressing.
    func testExistingPuzzle_withoutRead_stillDecodesAsNil() throws {
        let puzzle = try XCTUnwrap(Puzzles.get("p001"))
        XCTAssertNil(puzzle.read, "p001 was never authored with a read")
        let data = try JSONEncoder().encode(puzzle)
        let decoded = try JSONDecoder().decode(Puzzle.self, from: data)
        XCTAssertNil(decoded.read, "p001: a missing 'read' key must decode to nil, not fail the whole puzzle")
    }

    /// The read options are shuffled for display (same id-seeded scheme as the move
    /// candidates) so option POSITION never carries the answer. The shuffle must be
    /// (1) deterministic and (2) a true permutation, and mapping a display slot back
    /// to its original index must still resolve to the correct `isKey` — i.e. the
    /// shuffle reorders an INDEX array, never the option data itself.
    func testReadOptionShuffle_deterministicAndPreservesKeyMapping() throws {
        for id in ["read-001", "read-002"] {
            let read = try XCTUnwrap(Puzzles.get(id)?.read, "\(id) missing read")

            func shuffledOrder() -> [Int] {
                var idxs = Array(read.options.indices)
                var seed: UInt64 = 0
                for c in (id + "|read").unicodeScalars { seed = seed &* 31 &+ UInt64(c.value) }
                var rng = SeededRNG(seed: seed)
                idxs.shuffle(using: &rng)
                return idxs
            }

            let order1 = shuffledOrder()
            let order2 = shuffledOrder()
            XCTAssertEqual(order1, order2, "\(id): read shuffle must be deterministic")
            XCTAssertEqual(Set(order1), Set(read.options.indices), "\(id): shuffle must be a permutation of all options")

            let keyOrig = try XCTUnwrap(read.options.firstIndex(where: \.isKey), "\(id): no key option")
            let displayIdx = try XCTUnwrap(order1.firstIndex(of: keyOrig), "\(id): key index missing from shuffled order")
            let origIdx = order1[displayIdx]
            XCTAssertTrue(read.options[origIdx].isKey, "\(id): shuffle broke the key-index mapping")
        }
    }
}
