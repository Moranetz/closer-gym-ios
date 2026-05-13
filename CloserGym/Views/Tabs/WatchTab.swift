import SwiftUI

struct WatchTab: View {
    var body: some View {
        NavigationStack {
            MasterGameIndexView()
        }
    }
}

struct MasterGameIndexView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Annotated transcripts · click any move for the master's commentary · free, no API key")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textMuted)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                Text("Hand-authored games in the style of Voss, Klaff, Belfort, Cardone, and Burg. Each is a real position you can step through move-by-move. Eval values come from the same heuristic engine that scores your puzzles. The Cardone game is annotated as a LOSS — same moves, wrong buyer.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(3)
                    .padding(.horizontal, 16)

                ForEach(MasterGames.all) { game in
                    NavigationLink(destination: MasterGameViewer(game: game)) {
                        masterGameRow(game)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)

                Text("Inspired-by-style constructions, not verbatim quotes. Real transcripts from sales-instrument roll out with v0.2.")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.textFaint)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
            }
        }
        .background(Color.bgPage)
        .navigationTitle("Master Games")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
    }

    private func masterGameRow(_ game: MasterGame) -> some View {
        let curve = Eval.runningCurve(game.moves)
        let finalEval = curve.last?.value ?? 0
        let operatorMoves = game.moves.filter { $0.role == .op }.count

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(game.id.uppercased())
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .kerning(0.5)
                    .foregroundStyle(Color.textFaint)
                Spacer()
                Text(game.outcome.label)
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .kerning(0.6)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(game.outcome.color))
            }
            Text(game.speaker)
                .font(AppFont.titleSmall)
                .foregroundStyle(Color.textPrimary)
            Text("vs \(game.opponentRole)")
                .font(.system(size: 12))
                .foregroundStyle(Color.textMuted)
            Text(game.speakerStyle)
                .font(.system(size: 13))
                .italic()
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(2)
            HStack(spacing: 6) {
                Text("\(operatorMoves) moves").font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.textFaint).textCase(.uppercase).kerning(0.4)
                Text("·").foregroundStyle(Color.textFaint)
                Text(game.openingECO).font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.textFaint).textCase(.uppercase).kerning(0.4)
                Text("·").foregroundStyle(Color.textFaint)
                Text("final \(finalEval >= 0 ? "+" : "")\(String(format: "%.2f", finalEval))")
                    .font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.textFaint).monospacedDigit()
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 11, weight: .bold)).foregroundStyle(Color.textFaint)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }
}
