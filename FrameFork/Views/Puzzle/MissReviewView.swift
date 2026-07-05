import SwiftUI

/// Oldest-first queue of puzzles whose most-recent attempt was wrong.
/// Entry point: the "Misses" stat card on the Puzzles tab (hidden at zero).
/// A miss re-solves for FULL rating — `isSolved` counts only correct solves —
/// so this queue is the highest-value rep on the board; `Store.missedPuzzleIds`
/// computed it all along, this view finally consumes it.
struct MissReviewView: View {
    @EnvironmentObject private var storage: Store

    // Snapshot, not a live computed list: clearing a miss mid-solve would delete the
    // row's NavigationLink while its destination is presented and pop the user out of
    // the reveal (the dailyHero bug, again). onAppear re-fires when the solve pops
    // back, which is exactly when refreshing is safe.
    @State private var missed: [Puzzle] = []
    @State private var loaded = false   // first body pass runs before onAppear — never flash "Clean slate"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if missed.isEmpty && loaded {
                    emptyState
                } else {
                    Text("Positions you got wrong, oldest first. A miss re-solves for full rating — clear it while the read is fresh.")
                        .scaledFont(size: 13)
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(3)
                        .padding(.top, 4)

                    ForEach(missed) { p in
                        NavigationLink(destination: PuzzleSolveView(puzzle: p, isDaily: false)) {
                            missRow(p)
                        }
                        .buttonStyle(.plain)
                    }
                }
                Spacer(minLength: 32)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .onAppear {
            missed = storage.missedPuzzleIds.compactMap { Puzzles.get($0) }
            loaded = true
        }
        .background(Color.bgPage)
        .navigationTitle("Review your misses")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
    }

    private func missRow(_ p: Puzzle) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(p.theme.label.uppercased())
                        .scaledFont(size: 10, weight: .heavy, design: .rounded)
                        .kerning(0.5)
                        .foregroundStyle(p.theme.tint)
                    Text("ELO \(p.difficulty)")
                        .scaledFont(size: 10, weight: .semibold)
                        .foregroundStyle(Color.textMuted)
                        .monospacedDigit()
                    Text(p.id.uppercased())
                        .scaledFont(size: 10, weight: .heavy, design: .rounded)
                        .kerning(0.5)
                        .foregroundStyle(Color.textFaint)
                }
                Text(p.buyerRole)
                    .scaledFont(size: 14, weight: .semibold)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
                Text("“\(p.buyerLine)”")
                    .scaledFont(size: 12)
                    .foregroundStyle(Color.textMuted)
                    .italic()
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right")
                .scaledFont(size: 12, weight: .bold)
                .foregroundStyle(Color.textFaint)
        }
        .padding(14)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Color.border, lineWidth: 1)
        )
        .overlay(alignment: .leading) {
            Rectangle().fill(p.theme.tint).frame(width: 3)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .padding(.vertical, 10)
        }
    }

    /// Reached when the last miss was cleared while this screen is on the stack.
    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .scaledFont(size: 34)
                .foregroundStyle(Color.brandGreen)
            Text("Clean slate")
                .scaledFont(size: 17, weight: .heavy, design: .rounded)
                .foregroundStyle(Color.textPrimary)
            Text("No misses waiting. Every position you got wrong has been re-solved.")
                .scaledFont(size: 13)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}
