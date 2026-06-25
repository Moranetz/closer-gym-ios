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

    private let defaults = UserDefaults.standard
    private let puzzleKey = "framefork:puzzles:v0.1"
    private let gameKey = "framefork:games:v0.1"

    public init() {
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
                           judgment: RolePlayJudgment? = nil) -> (newRating: Double, delta: Double) {
        let opponent = GlickoState(rating: Double(botRating), rd: initialRD * 0.4, volatility: initialVolatility)
        let result = Glicko2.applyMatch(gameState.rating, opponent: opponent, score: score)
        gameState.rating = result.state
        gameState.games.append(GameRecord(
            personaId: personaId,
            botRating: botRating,
            score: score,
            ratingAfter: result.state.rating,
            delta: result.delta,
            evalCurve: evalCurve,
            intentTechniques: intentTechniques,
            firedTechniques: firedTechniques,
            playedAt: Date(),
            durationSec: durationSec,
            turns: turns,
            judgment: judgment
        ))
        saveGameState()
        return (result.state.rating, result.delta)
    }

    /// Record a puzzle solve. Returns new rating + delta + streak.
    public func recordSolve(puzzleId: String,
                             pickedIndex: Int,
                             bestIndex: Int,
                             pickedEval: Double,
                             puzzleDifficulty: Int,
                             timeRemainingSec: Int,
                             isDaily: Bool,
                             todayKey: String?) -> (newRating: Double, delta: Double, newStreak: Int) {
        let correct = pickedIndex == bestIndex
        let score: Double = correct ? 1.0 : (pickedEval > 0 ? 0.5 : 0.0)
        let opponent = GlickoState(rating: Double(puzzleDifficulty), rd: initialRD * 0.4, volatility: initialVolatility)
        let result = Glicko2.applyMatch(puzzleState.rating, opponent: opponent, score: score)

        var currentStreak = puzzleState.currentStreak
        var longestStreak = puzzleState.longestStreak
        var solvedDailyDates = puzzleState.solvedDailyDates
        var lastDailyDate = puzzleState.lastDailyDate

        if isDaily, let todayKey {
            // Guard against a second scored attempt on the same calendar day. The UI
            // locks the daily after one attempt, but this is the durable backstop so
            // a re-entry can neither inflate nor zero a streak already settled today.
            let alreadyAttemptedToday = (lastDailyDate == todayKey)
            if !alreadyAttemptedToday {
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
        }

        puzzleState.rating = result.state
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
        return (result.state.rating, result.delta, currentStreak)
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
    private static func dayFormatter() -> DateFormatter {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }

    public static func todayKey(date: Date = Date()) -> String {
        dayFormatter().string(from: date)
    }

    public static func yesterdayKey(_ todayKey: String) -> String {
        let f = dayFormatter()
        guard let date = f.date(from: todayKey) else { return "" }
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
        return f.string(from: yesterday)
    }
}

public struct PuzzleState: Codable, Sendable {
    public var rating: GlickoState = GlickoState()
    public var solves: [PuzzleSolve] = []
    public var solvedDailyDates: [String] = []
    public var currentStreak: Int = 0
    public var longestStreak: Int = 0
    public var lastDailyDate: String? = nil

    public init() {}

    // Tolerant decoding: missing keys fall back to defaults rather than failing the
    // whole decode (Swift's synthesized decoder otherwise hard-fails on any added
    // field, wiping the user's history on the next app update).
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        rating = (try? c.decodeIfPresent(GlickoState.self, forKey: .rating)) ?? GlickoState()
        solves = (try? c.decodeIfPresent([PuzzleSolve].self, forKey: .solves)) ?? []
        solvedDailyDates = (try? c.decodeIfPresent([String].self, forKey: .solvedDailyDates)) ?? []
        currentStreak = (try? c.decodeIfPresent(Int.self, forKey: .currentStreak)) ?? 0
        longestStreak = (try? c.decodeIfPresent(Int.self, forKey: .longestStreak)) ?? 0
        lastDailyDate = (try? c.decodeIfPresent(String.self, forKey: .lastDailyDate)) ?? nil
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

    public init() {}

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        rating = (try? c.decodeIfPresent(GlickoState.self, forKey: .rating)) ?? GlickoState()
        games = (try? c.decodeIfPresent([GameRecord].self, forKey: .games)) ?? []
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
    }
}
