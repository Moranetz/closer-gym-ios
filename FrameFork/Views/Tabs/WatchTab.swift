import SwiftUI

struct WatchTab: View {
    #if DEBUG
    // Debug/screenshot hook (same pattern as FF_OPEN_PUZZLE): FF_OPEN_GAME=<id> opens
    // that master game's viewer on launch so it can be captured without tapping
    // through the index (the sim has no accessibility labels to drive by name).
    // No effect in Release — never reachable outside DEBUG, and a bad/missing id
    // is just a no-op.
    @State private var debugOpenGame: MasterGame? = {
        guard let id = ProcessInfo.processInfo.environment["FF_OPEN_GAME"] else { return nil }
        return MasterGames.get(id)
    }()
    #endif

    var body: some View {
        NavigationStack {
            MasterGameIndexView()
                #if DEBUG
                .navigationDestination(item: $debugOpenGame) { g in
                    MasterGameViewer(game: g)
                }
                #endif
        }
    }
}

struct MasterGameIndexView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Call the master's move before you see it · free, no API key")
                    .scaledFont(size: 13)
                    .foregroundStyle(Color.textMuted)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                Text("These deals are hand-authored in the style of real negotiators: Voss, Keenan's Gap Selling, Dixon's Challenger, Klaff, and Burg. A few are cautionary tales, done in the style of Belfort and Cardone. Step through a real deal, predict the next move, then see what happened and why.")
                    .scaledFont(size: 13)
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

                Text("Inspired-by-style constructions in the speaker's voice.")
                    .scaledFont(size: 11)
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
        let operatorMoves = game.moves.filter { $0.role == .op }.count

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Spacer()
                Text("GUESS THE MOVES")
                    .scaledFont(size: 9, weight: .heavy, design: .rounded).kerning(0.5)
                    .foregroundStyle(Color.brandGreen)
            }
            Text(game.speaker)
                .scaledFont(size: 20, weight: .bold, design: .rounded)
                .foregroundStyle(Color.textPrimary)
            Text("vs \(game.opponentRole)")
                .scaledFont(size: 12)
                .foregroundStyle(Color.textMuted)
            Text(game.speakerStyle)
                .scaledFont(size: 13)
                .italic()
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(2)
            HStack(spacing: 6) {
                Text("\(operatorMoves) moves").scaledFont(size: 10, weight: .semibold).foregroundStyle(Color.textFaint).textCase(.uppercase).kerning(0.4)
                Spacer()
                Image(systemName: "chevron.right").scaledFont(size: 11, weight: .bold).foregroundStyle(Color.textFaint)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }
}
