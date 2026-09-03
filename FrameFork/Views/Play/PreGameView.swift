import SwiftUI

/// Pre-game intent registration. Pick the Atlas techniques you intend to deploy.
/// Mirrors web /play/[personaId]/page.tsx. After selection, Start game
/// navigates to the live game with the pre-registered techniques.
struct PreGameView: View {
    let botMeta: BotMeta
    @Binding var path: [PlayRoute]

    @EnvironmentObject private var storage: Store
    @State private var selectedTechniques: Set<String> = []

    private var persona: Persona? { Personas.get(botMeta.personaId) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                botCard
                if persona != nil {
                    // The persona's responsive/contraindicated lists are NOT shown here on purpose:
                    // reading the buyer IS the gameplay (DIAGNOSIS G5). They surface in the debrief.
                    intentSelector
                    startButton
                }
                Spacer(minLength: 32)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .background(Color.bgPage)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(botMeta.rating) · \(persona?.track.label ?? "")")
                    .scaledFont(size: 13, weight: .semibold)
                    .foregroundStyle(Color.textSecondary)
                    .monospacedDigit()
            }
        }
    }

    private var botCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("OPPONENT · ELO \(botMeta.rating)")
                .scaledFont(size: 10, weight: .heavy, design: .rounded)
                .kerning(0.6)
                .foregroundStyle(Color.textMuted)
            Text(persona?.role ?? botMeta.personaId)
                .scaledFont(size: 20, weight: .bold, design: .rounded)
                .foregroundStyle(Color.textPrimary)
            Text(botMeta.oneLineTagline)
                .scaledFont(size: 13)
                .italic()
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(3)
            if let p = persona {
                HStack(spacing: 14) {
                    stat(label: "Savvy", value: p.persuasionKnowledge.label)
                    stat(label: "Valence", value: "\(p.valence >= 0 ? "+" : "")\(p.valence)")
                    stat(label: "Readability", value: p.readability.rawValue)
                }
                .padding(.top, 4)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var intentSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("PRE-REGISTER YOUR INTENT")
                    .scaledFont(size: 11, weight: .heavy, design: .rounded)
                    .kerning(0.6)
                    .foregroundStyle(Color.brandGreen)
                Spacer()
                Text("\(selectedTechniques.count) selected")
                    .scaledFont(size: 11)
                    .foregroundStyle(Color.textMuted)
            }
            Text("Pick the Atlas techniques you intend to deploy. After the game, the detector compares what you intended against what actually fired.")
                .scaledFont(size: 12)
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(2)
            FlowLayout(spacing: 6, lineSpacing: 6) {
                ForEach(AtlasTechniques.all) { t in
                    Button {
                        Haptics.shared.selection()
                        if selectedTechniques.contains(t.id) {
                            selectedTechniques.remove(t.id)
                        } else {
                            selectedTechniques.insert(t.id)
                        }
                    } label: {
                        let isOn = selectedTechniques.contains(t.id)
                        Text(t.name)
                            .scaledFont(size: 11, weight: .semibold)
                            .foregroundStyle(isOn ? Color.brandGreen : Color.textSecondary)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(RoundedRectangle(cornerRadius: 4, style: .continuous).fill(isOn ? Color.brandGreen.opacity(0.14) : Color.bgRail))
                            .overlay(RoundedRectangle(cornerRadius: 4, style: .continuous).strokeBorder(isOn ? Color.brandGreen : Color.border, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    @ViewBuilder
    private var startButton: some View {
        if Arcs.get(personaId: botMeta.personaId) != nil {
            PrimaryButton(title: "Spar — offline", symbol: "figure.boxing", isEnabled: true, style: .green) {
                Haptics.shared.medium()
                path.append(.sparring(botMeta))
            }
            Text(Keychain.hasAPIKey()
                 ? "Authored conversation, fully offline. Or start a free-text live game below."
                 : "Authored conversation, fully offline — no API key needed.")
                .scaledFont(size: 11)
                .foregroundStyle(Color.textFaint)
        }
        PrimaryButton(title: "Start game", symbol: "play.fill", isEnabled: Keychain.hasAPIKey(), style: .green) {
            Haptics.shared.medium()
            path.append(.live(botMeta, Array(selectedTechniques)))
        }
        // The keyless dead-end fix: an arc-less persona with no key used to show ONE disabled
        // button and no way forward. Now it says why, and hands her a live road — the nearest-rated
        // persona that spars free.
        if !Keychain.hasAPIKey(), Arcs.get(personaId: botMeta.personaId) == nil {
            Text("Free-text live games run on your own Anthropic key — add one in Profile › Settings and this lights up.")
                .scaledFont(size: 11)
                .foregroundStyle(Color.textFaint)
            if let alt = Self.nearestSparBot(to: botMeta) {
                PrimaryButton(title: "Spar \(Personas.get(alt.personaId)?.role ?? "offline") · free",
                              symbol: "figure.boxing", isEnabled: true, style: .green) {
                    Haptics.shared.medium()
                    path.append(.sparring(alt))
                }
                Text("Authored conversation vs a \(alt.rating)-rated buyer — no key, fully offline.")
                    .scaledFont(size: 11)
                    .foregroundStyle(Color.textFaint)
            }
        }
    }

    /// The closest-rated persona that has an authored sparring arc — the road out of the dead-end.
    static func nearestSparBot(to bot: BotMeta) -> BotMeta? {
        BotLadder.all
            .filter { Arcs.get(personaId: $0.personaId) != nil }
            .min { abs($0.rating - bot.rating) < abs($1.rating - bot.rating) }
    }

    private func stat(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).scaledFont(size: 10, weight: .heavy, design: .rounded).kerning(0.4).foregroundStyle(Color.textMuted)
            Text(value).scaledFont(size: 12, weight: .semibold).foregroundStyle(Color.textPrimary)
        }
    }
}
