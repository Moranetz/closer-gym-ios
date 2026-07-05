import Foundation
import Combine

/// Persistent state — mirrors web src/lib/puzzle-storage.ts.
/// One source of truth for puzzle solves, streak, and Glicko-2 ratings.
/// Uses UserDefaults (private to app sandbox); JSON-encoded payloads.
@MainActor
public final class Store: ObservableObject {
    public static let shared = Store()

    @Published public var puzzleState: PuzzleState
    @Published public var gameState: GameState
    @Published public var companyProfile: CompanyProfile

    private let defaults: UserDefaults
    private let puzzleKey = "framefork:puzzles:v0.1"
    private let gameKey = "framefork:games:v0.1"
    private let companyKey = "framefork:company:v1"

    /// `defaults` is injectable so tests can run against an isolated suite —
    /// hosted tests share the app's REAL container, and a test that clears
    /// `.standard` wipes actual user history.
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        // Decode persisted state. If bytes EXIST but fail to decode (corruption or
        // an incompatible schema), preserve the raw bytes under a backup key instead
        // of silently wiping the user's history, then start fresh.
        if let data = defaults.data(forKey: puzzleKey) {
            if let decoded = try? JSONDecoder().decode(PuzzleState.self, from: data) {
                self.puzzleState = decoded
            } else {
                defaults.set(data, forKey: puzzleKey + ":corrupt-backup")
                self.puzzleState = PuzzleState()
            }
        } else {
            self.puzzleState = PuzzleState()
        }
        if let data = defaults.data(forKey: gameKey) {
            if let decoded = try? JSONDecoder().decode(GameState.self, from: data) {
                self.gameState = decoded
            } else {
                defaults.set(data, forKey: gameKey + ":corrupt-backup")
                self.gameState = GameState()
            }
        } else {
            self.gameState = GameState()
        }
        if let data = defaults.data(forKey: companyKey) {
            if let decoded = try? JSONDecoder().decode(CompanyProfile.self, from: data) {
                self.companyProfile = decoded
            } else {
                defaults.set(data, forKey: companyKey + ":corrupt-backup")  // preserve typed deal data
                self.companyProfile = CompanyProfile()
            }
        } else {
            self.companyProfile = CompanyProfile()
        }

        // Reconcile a stale streak on launch: if the last daily was neither today
        // nor yesterday, the streak is broken and must read as 0 everywhere — not
        // just at the next solve. (Persisted on the next save.)
        if let last = puzzleState.lastDailyDate {
            let today = Self.todayKey()
            if last != today && last != Self.yesterdayKey(today) {
                puzzleState.currentStreak = 0
            }
        }
    }

    /// The streak as it should display *right now*. The stored `currentStreak` is
    /// only refreshed at solve time; this stays correct between sessions.
    public var effectiveCurrentStreak: Int {
        guard let last = puzzleState.lastDailyDate else { return 0 }
        let today = Self.todayKey()
        return (last == today || last == Self.yesterdayKey(today)) ? puzzleState.currentStreak : 0
    }

    /// True once today's Daily Drill has been attempted (correct OR wrong). Used to
    /// lock the daily to one attempt per calendar day.
    public var dailyAttemptedToday: Bool {
        puzzleState.lastDailyDate == Self.todayKey()
    }

    public func savePuzzleState() {
        if let data = try? JSONEncoder().encode(puzzleState) {
            defaults.set(data, forKey: puzzleKey)
        }
    }

    public func saveGameState() {
        if let data = try? JSONEncoder().encode(gameState) {
            defaults.set(data, forKey: gameKey)
        }
    }

    public func saveCompanyProfile() {
        if let data = try? JSONEncoder().encode(companyProfile) {
            defaults.set(data, forKey: companyKey)
        }
    }

    /// Record a finished game against a bot.
    /// Returns (newRating, delta).
    public func recordGame(botRating: Int,
                           score: Double,
                           personaId: String,
                           evalCurve: [Double],
                           intentTechniques: [String],
                           firedTechniques: [String],
                           durationSec: Int,
                           turns: [StoredTurn] = [],
                           judgment: RolePlayJudgment? = nil,
                           rated: Bool = true) -> (newRating: Double, delta: Double) {
        // Glicko-2 is only defined for scores in 0…1 — clamp here so no future
        // caller (e.g. a raw judge processScore) can corrupt the rating unboundedly.
        let score = max(0.0, min(1.0, score))
        // Unrated games (e.g. under 2 operator turns) are RECORDED but don't move the
        // rating: the user paid tokens for those turns — dropping the transcript was
        // silent data loss; skipping only the Glicko update kills the farm just as well.
        var newState = gameState.rating
        var delta: Double = 0
        if rated {
            let opponent = GlickoState(rating: Double(botRating), rd: initialRD * 0.4, volatility: initialVolatility)
            let result = Glicko2.applyMatch(gameState.rating, opponent: opponent, score: score)
            newState = result.state
            delta = result.delta
        }
        gameState.rating = newState
        gameState.games.append(GameRecord(
            personaId: personaId,
            botRating: botRating,
            score: score,
            ratingAfter: newState.rating,
            delta: delta,
            evalCurve: evalCurve,
            intentTechniques: intentTechniques,
            firedTechniques: firedTechniques,
            playedAt: Date(),
            durationSec: durationSec,
            turns: turns,
            judgment: judgment,
            rated: rated
        ))
        saveGameState()
        return (newState.rating, delta)
    }

    public func markArcCompleted(_ personaId: String) {
        guard !gameState.completedArcs.contains(personaId) else { return }
        gameState.completedArcs.append(personaId)
        saveGameState()
    }

    /// Record a puzzle solve. Returns new rating + delta + streak, and whether the
    /// solve was RATED (a re-solve of an already-solved puzzle is practice: recorded,
    /// but the rating doesn't move — callers should say so instead of showing "+0").
    public func recordSolve(puzzleId: String,
                             pickedIndex: Int,
                             bestIndex: Int,
                             pickedEval: Double,
                             puzzleDifficulty: Int,
                             timeRemainingSec: Int,
                             isDaily: Bool,
                             todayKey: String?) -> (newRating: Double, delta: Double, newStreak: Int, rated: Bool) {
        let correct = pickedIndex == bestIndex

        // Durable backstop against a second SCORED attempt on the same calendar day.
        // The UI locks the daily after one attempt, but any re-entry that slips
        // through (deep link, a solve view held open across midnight) must not
        // re-score a just-revealed answer nor touch the streak already settled today.
        if isDaily, let todayKey, puzzleState.lastDailyDate == todayKey {
            return (puzzleState.rating.rating, 0, puzzleState.currentStreak, false)
        }

        // A puzzle already solved CORRECTLY is practice on a known answer: record
        // the attempt for history/analytics, but leave the rating untouched so
        // re-solving can't farm ELO (which also gates bot unlocks). A puzzle failed
        // once can still be re-solved rated — bounded to one ~net-zero Glicko
        // round-trip per puzzle, so it isn't farmable.
        let rated = !isSolved(puzzleId)
        let score: Double = correct ? 1.0 : (pickedEval > 0 ? 0.5 : 0.0)
        var ratedState = puzzleState.rating
        var delta: Double = 0
        if rated {
            let opponent = GlickoState(rating: Double(puzzleDifficulty), rd: initialRD * 0.4, volatility: initialVolatility)
            let result = Glicko2.applyMatch(puzzleState.rating, opponent: opponent, score: score)
            ratedState = result.state
            delta = result.delta
        }

        var currentStreak = puzzleState.currentStreak
        var longestStreak = puzzleState.longestStreak
        var solvedDailyDates = puzzleState.solvedDailyDates
        var lastDailyDate = puzzleState.lastDailyDate

        if isDaily, let todayKey {
            if correct {
                let yesterday = Self.yesterdayKey(todayKey)
                currentStreak = (lastDailyDate == yesterday) ? currentStreak + 1 : 1
                longestStreak = max(longestStreak, currentStreak)
                if !solvedDailyDates.contains(todayKey) {
                    solvedDailyDates.append(todayKey)
                }
            } else {
                currentStreak = 0
            }
            // Stamp the attempt on BOTH outcomes so a failed daily counts as
            // "used today" and can't be retried for a clean streak.
            lastDailyDate = todayKey
        }

        puzzleState.rating = ratedState
        if rated {
            // Rating-history series — the un-fakeable progress signal (research 2026-07).
            // Appended only on rated solves; capped so it can't grow unbounded.
            puzzleState.ratingHistory.append(RatingPoint(rating: ratedState.rating, at: Date()))
            if puzzleState.ratingHistory.count > 500 {
                puzzleState.ratingHistory.removeFirst(puzzleState.ratingHistory.count - 500)
            }
        }
        puzzleState.solves.append(PuzzleSolve(
            puzzleId: puzzleId,
            pickedIndex: pickedIndex,
            correct: correct,
            evalGained: pickedEval,
            solvedAt: Date(),
            timeRemainingSec: timeRemainingSec
        ))
        puzzleState.solvedDailyDates = solvedDailyDates
        puzzleState.currentStreak = currentStreak
        puzzleState.longestStreak = longestStreak
        puzzleState.lastDailyDate = lastDailyDate
        savePuzzleState()
        return (ratedState.rating, delta, currentStreak, rated)
    }

    /// Ids of puzzles solved correctly at least once. Build this ONCE per body pass
    /// on screens that check many puzzles — `isSolved` per row is O(solves) each.
    public var solvedIdSet: Set<String> {
        Set(puzzleState.solves.lazy.filter(\.correct).map(\.puzzleId))
    }

    /// Distinct puzzles solved correctly — the user-facing "Solved" number. Raw
    /// `solves` keeps every attempt (including practice re-solves), so counting
    /// rows would read "137 solved" against a 100-puzzle library.
    public var solvedUniqueCount: Int {
        solvedIdSet.count
    }

    public func isSolved(_ puzzleId: String) -> Bool {
        puzzleState.solves.contains { $0.puzzleId == puzzleId && $0.correct }
    }

    // MARK: - Training analytics
    // Pure read-only views over `solves` — the data backbone for weakness reports,
    // per-theme drills, and spaced-repetition review of misses. (See TRAINING-IMPROVEMENTS.md)

    public struct ThemeStat: Identifiable, Sendable {
        public let theme: PuzzleTheme
        public let attempts: Int
        public let correct: Int
        public var rate: Double { attempts == 0 ? 0 : Double(correct) / Double(attempts) }
        public var id: String { theme.rawValue }
    }

    /// Per-theme accuracy, weakest first — only themes the user has actually attempted.
    public func themeStats() -> [ThemeStat] {
        var byTheme: [PuzzleTheme: (attempts: Int, correct: Int)] = [:]
        for solve in puzzleState.solves {
            guard let theme = Puzzles.get(solve.puzzleId)?.theme else { continue }
            var e = byTheme[theme] ?? (0, 0)
            e.attempts += 1
            if solve.correct { e.correct += 1 }
            byTheme[theme] = e
        }
        return byTheme
            .map { ThemeStat(theme: $0.key, attempts: $0.value.attempts, correct: $0.value.correct) }
            .sorted { $0.rate < $1.rate }
    }

    /// Puzzles whose most-recent attempt was wrong (and not since re-solved), oldest miss
    /// first — the queue for a spaced-repetition "review your misses" drill.
    public var missedPuzzleIds: [String] {
        var latest: [String: PuzzleSolve] = [:]
        for s in puzzleState.solves {
            if let cur = latest[s.puzzleId] {
                if s.solvedAt > cur.solvedAt { latest[s.puzzleId] = s }
            } else {
                latest[s.puzzleId] = s
            }
        }
        return latest.values
            .filter { !$0.correct }
            .sorted { $0.solvedAt < $1.solvedAt }
            .map { $0.puzzleId }
    }

    /// `yyyy-MM-dd` in the user's LOCAL time zone. Using `ISO8601DateFormatter`
    /// before defaulted to UTC, so for any user west of UTC the "day" flipped in
    /// the afternoon — breaking one-daily-per-day, streaks, and the displayed date.
    nonisolated private static func dayFormatter() -> DateFormatter {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }

    nonisolated public static func todayKey(date: Date = Date()) -> String {
        dayFormatter().string(from: date)
    }

    nonisolated public static func yesterdayKey(_ todayKey: String) -> String {
        // Anchor the math at NOON, not midnight: parsing "yyyy-MM-dd" to a midnight
        // Date returns nil on spring-forward days in timezones whose DST jump erases
        // midnight (Chile, Cuba…), which silently reset streaks the following day.
        let parts = todayKey.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return "" }
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .current
        let comps = DateComponents(year: parts[0], month: parts[1], day: parts[2], hour: 12)
        guard let noon = cal.date(from: comps),
              let yesterday = cal.date(byAdding: .day, value: -1, to: noon) else { return "" }
        return dayFormatter().string(from: yesterday)
    }
}

public struct RatingPoint: Codable, Hashable, Sendable {
    public let rating: Double
    public let at: Date
    public init(rating: Double, at: Date) { self.rating = rating; self.at = at }
}

public struct PuzzleState: Codable, Sendable {
    public var rating: GlickoState = GlickoState()
    public var solves: [PuzzleSolve] = []
    public var solvedDailyDates: [String] = []
    public var currentStreak: Int = 0
    public var longestStreak: Int = 0
    public var lastDailyDate: String? = nil
    public var ratingHistory: [RatingPoint] = []

    public init() {}

    // Tolerant decoding: missing keys fall back to defaults rather than failing the
    // whole decode (Swift's synthesized decoder otherwise hard-fails on any added
    // field, wiping the user's history on the next app update).
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        rating = (try? c.decodeIfPresent(GlickoState.self, forKey: .rating)) ?? GlickoState()
        solves = ((try? c.decodeIfPresent(LossyArray<PuzzleSolve>.self, forKey: .solves))?.elements) ?? []
        solvedDailyDates = (try? c.decodeIfPresent([String].self, forKey: .solvedDailyDates)) ?? []
        currentStreak = (try? c.decodeIfPresent(Int.self, forKey: .currentStreak)) ?? 0
        longestStreak = (try? c.decodeIfPresent(Int.self, forKey: .longestStreak)) ?? 0
        lastDailyDate = (try? c.decodeIfPresent(String.self, forKey: .lastDailyDate)) ?? nil
        ratingHistory = ((try? c.decodeIfPresent(LossyArray<RatingPoint>.self, forKey: .ratingHistory))?.elements) ?? []
    }
}

public struct PuzzleSolve: Codable, Hashable, Sendable {
    public let puzzleId: String
    public let pickedIndex: Int
    public let correct: Bool
    public let evalGained: Double
    public let solvedAt: Date
    public let timeRemainingSec: Int
}

public struct GameState: Codable, Sendable {
    public var rating: GlickoState = GlickoState()
    public var games: [GameRecord] = []
    // Sparring arcs completed at least once — first completion is rated, replays
    // are recorded practice (a known tree re-walked must not farm Glicko).
    public var completedArcs: [String] = []

    public init() {}

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        rating = (try? c.decodeIfPresent(GlickoState.self, forKey: .rating)) ?? GlickoState()
        games = ((try? c.decodeIfPresent(LossyArray<GameRecord>.self, forKey: .games))?.elements) ?? []
        completedArcs = (try? c.decodeIfPresent([String].self, forKey: .completedArcs)) ?? []
    }
}

public struct GameRecord: Codable, Hashable, Sendable {
    public let personaId: String
    public let botRating: Int
    public let score: Double            // recorded game score (0…1) — the judge's process grade when available
    public let ratingAfter: Double
    public let delta: Double
    public let evalCurve: [Double]      // running -3..+3 per operator turn
    public let intentTechniques: [String]
    public let firedTechniques: [String]
    public let playedAt: Date
    public let durationSec: Int
    public var turns: [StoredTurn] = []            // full transcript — replay + content flywheel
    public var judgment: RolePlayJudgment? = nil   // blind LLM judge grade (nil if it couldn't run)
    public var rated: Bool = true                  // false = recorded but no Glicko update (e.g. <2 turns)
}

extension GameRecord {
    /// Tolerant decode so games saved before `turns`/`judgment` existed still load.
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        personaId        = try c.decode(String.self, forKey: .personaId)
        botRating        = try c.decode(Int.self, forKey: .botRating)
        score            = try c.decode(Double.self, forKey: .score)
        ratingAfter      = try c.decode(Double.self, forKey: .ratingAfter)
        delta            = try c.decode(Double.self, forKey: .delta)
        evalCurve        = (try? c.decodeIfPresent([Double].self, forKey: .evalCurve)) ?? []
        intentTechniques = (try? c.decodeIfPresent([String].self, forKey: .intentTechniques)) ?? []
        firedTechniques  = (try? c.decodeIfPresent([String].self, forKey: .firedTechniques)) ?? []
        playedAt         = (try? c.decodeIfPresent(Date.self, forKey: .playedAt)) ?? Date()
        durationSec      = (try? c.decodeIfPresent(Int.self, forKey: .durationSec)) ?? 0
        turns            = (try? c.decodeIfPresent([StoredTurn].self, forKey: .turns)) ?? []
        judgment         = (try? c.decodeIfPresent(RolePlayJudgment.self, forKey: .judgment)) ?? nil
        rated            = (try? c.decodeIfPresent(Bool.self, forKey: .rated)) ?? true
    }
}

/// Decodes an array element-by-element, dropping only the elements that fail.
/// The plain `[T].self` decode is all-or-nothing: one corrupt/incompatible record
/// (e.g. after a version rollback) silently wiped the user's ENTIRE history array
/// while the outer state decode "succeeded" — so no corrupt-backup was taken.
private struct LossyArray<Element: Decodable>: Decodable {
    var elements: [Element] = []

    init(from decoder: Decoder) throws {
        var c = try decoder.unkeyedContainer()
        while !c.isAtEnd {
            if let e = try? c.decode(Element.self) {
                elements.append(e)
            } else {
                // Consume the bad element so the loop advances past it.
                _ = try? c.decode(DiscardedElement.self)
            }
        }
    }

    /// Always decodes successfully without reading anything — used to skip a slot.
    private struct DiscardedElement: Decodable {
        init(from decoder: Decoder) throws {}
    }
}
