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
        if let data = defaults.data(forKey: puzzleKey),
           let decoded = try? JSONDecoder().decode(PuzzleState.self, from: data) {
            self.puzzleState = decoded
        } else {
            self.puzzleState = PuzzleState()
        }
        if let data = defaults.data(forKey: gameKey),
           let decoded = try? JSONDecoder().decode(GameState.self, from: data) {
            self.gameState = decoded
        } else {
            self.gameState = GameState()
        }
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
                           durationSec: Int) -> (newRating: Double, delta: Double) {
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
            durationSec: durationSec
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
            if correct {
                let yesterday = Self.yesterdayKey(todayKey)
                if lastDailyDate == yesterday || lastDailyDate == todayKey {
                    currentStreak = lastDailyDate == todayKey ? currentStreak : currentStreak + 1
                } else {
                    currentStreak = 1
                }
                longestStreak = max(longestStreak, currentStreak)
                if !solvedDailyDates.contains(todayKey) {
                    solvedDailyDates.append(todayKey)
                }
                lastDailyDate = todayKey
            } else {
                currentStreak = 0
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

    public static func todayKey(date: Date = Date()) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: date)
    }

    public static func yesterdayKey(_ todayKey: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: todayKey + "T00:00:00Z") else {
            return ""
        }
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: yesterday)
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
}

public struct GameRecord: Codable, Hashable, Sendable {
    public let personaId: String
    public let botRating: Int
    public let score: Double            // 1 win, 0.5 draw, 0 loss
    public let ratingAfter: Double
    public let delta: Double
    public let evalCurve: [Double]      // running -3..+3 per operator turn
    public let intentTechniques: [String]
    public let firedTechniques: [String]
    public let playedAt: Date
    public let durationSec: Int
}
