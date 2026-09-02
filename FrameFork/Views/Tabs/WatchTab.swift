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
                Text("Call the master's move before you see it · free, no API key")
                    .scaledFont(size: 13)
                    .foregroundStyle(Color.textMuted)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                Text("Hand-authored deal studies in the style of Voss, Keenan (Gap Selling), Dixon (Challenger), Klaff and Burg — plus cautionary breakdowns of Belfort and Cardone. Step through a real deal, predict each pivotal move, then see what happened and why.")
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
                Text(game.id.uppercased())
                    .scaledFont(size: 10, weight: .heavy, design: .rounded)
                    .kerning(0.5)
                    .foregroundStyle(Color.textFaint)
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
                Text("·").foregroundStyle(Color.textFaint)
                Text(game.openingECO).scaledFont(size: 10, weight: .semibold).foregroundStyle(Color.textFaint).textCase(.uppercase).kerning(0.4)
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
