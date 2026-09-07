import Foundation

/// One flag, written when onboarding finishes and consumed the first time the Puzzles tab
/// appears, so the app's first act is a position rather than a list of fourteen.
///
/// Round 168. It is read-and-clear on purpose: a first run happens once, and a door that keeps
/// opening itself is a different feature with a worse name.
enum FirstRun {
    static let openDrillKey = "framefork:firstRun:openDrill:v1"

    /// The position a stranger meets first.
    ///
    /// Round 168 opened today's drill here and photographed the result: a provisional 1200 was
    /// handed a procurement gauntlet rated 1,900, which is a first rated move they lose. The
    /// daily drill is the hook for someone who already plays; a first position should sit where
    /// the player is. This takes the lowest-rated position in the bank, and the daily drill stays
    /// exactly where it was — on the card, and in the notification that now goes out.
    static func starterPuzzle() -> Puzzle? {
        Puzzles.all.min { $0.difficulty < $1.difficulty }
    }

    /// True exactly once, then never again.
    static func consumeOpenDrill() -> Bool {
        guard UserDefaults.standard.bool(forKey: openDrillKey) else { return false }
        UserDefaults.standard.set(false, forKey: openDrillKey)
        return true
    }
}
