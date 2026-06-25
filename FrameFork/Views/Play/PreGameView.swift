import SwiftUI

/// Pre-game intent registration. Pick the Atlas techniques you intend to deploy.
/// Mirrors web /play/[personaId]/page.tsx. v0.2 will navigate to LiveGameView
/// after selection; v0.1 ships this screen as a planning surface and shows a
/// Pro-tier-coming banner.
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
                if let p = persona {
                    contraindicatedCard(persona: p)
                    responsiveCard(persona: p)
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
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)
                    .monospacedDigit()
            }
        }
    }

    private var botCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("OPPONENT · ELO \(botMeta.rating)")
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .kerning(0.6)
                .foregroundStyle(Color.textMuted)
            Text(persona?.role ?? botMeta.personaId)
                .font(AppFont.titleSmall)
                .foregroundStyle(Color.textPrimary)
            Text(botMeta.oneLineTagline)
                .font(.system(size: 13))
                .italic()
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(3)
            if let p = persona {
                HStack(spacing: 14) {
                    stat(label: "PK", value: p.persuasionKnowledge.label)
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

    private func contraindicatedCard(persona: Persona) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contraindicated · do not deploy").microLabel(Color.danger)
            HStack {
                FlowLayout(spacing: 6, lineSpacing: 6) {
                    ForEach(persona.contraindicatedTechniques, id: \.self) { tid in
                        chip(text: AtlasTechniques.name(for: tid), color: Color.danger)
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.danger.opacity(0.25), lineWidth: 1))
    }

    private func responsiveCard(persona: Persona) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Responsive · likely to land").microLabel(Color.brandGreen)
            HStack {
                FlowLayout(spacing: 6, lineSpacing: 6) {
                    ForEach(persona.likelyResponsiveTechniques, id: \.self) { tid in
                        chip(text: AtlasTechniques.name(for: tid), color: Color.brandGreen)
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.brandGreen.opacity(0.25), lineWidth: 1))
    }

    private var intentSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("PRE-REGISTER YOUR INTENT")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .kerning(0.6)
                    .foregroundStyle(Color.brandGreen)
                Spacer()
                Text("\(selectedTechniques.count) selected")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.textMuted)
            }
            Text("Pick the Atlas techniques you intend to deploy. After the game, the detector compares what you intended against what actually fired.")
                .font(.system(size: 12))
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
                            .font(.system(size: 11, weight: .semibold))
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

    private var startButton: some View {
        PrimaryButton(title: "Start game", symbol: "play.fill", isEnabled: true, style: .green) {
            Haptics.shared.medium()
            path.append(.live(botMeta, Array(selectedTechniques)))
        }
    }

    private func chip(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(RoundedRectangle(cornerRadius: 4, style: .continuous).fill(color.opacity(0.12)))
            .overlay(RoundedRectangle(cornerRadius: 4, style: .continuous).strokeBorder(color.opacity(0.3), lineWidth: 1))
    }

    private func stat(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.system(size: 10, weight: .heavy, design: .rounded)).kerning(0.4).foregroundStyle(Color.textMuted)
            Text(value).font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.textPrimary)
        }
    }
}
