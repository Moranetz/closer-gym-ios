import SwiftUI

/// Read-only replay of a past role-play, opened from Profile history. It does NOT record or
/// re-judge — the game already happened; this resurfaces the stored grade + transcript so the
/// moat's output no longer vanishes the moment you tap Done (DIAGNOSIS G2).
struct GameHistoryDetailView: View {
    let record: GameRecord
    private var persona: Persona? { Personas.get(record.personaId) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                gradeCard
                if !record.turns.isEmpty { transcriptCard }
                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16).padding(.top, 12)
        }
        .background(Color.bgPage)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Past game").font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.textSecondary)
            }
        }
    }

    private var gradeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(persona?.role ?? record.personaId)
                .font(.system(size: 18, weight: .heavy, design: .rounded)).foregroundStyle(Color.textPrimary)
            HStack(spacing: 16) {
                stat("ELO after", String(format: "%.0f", record.ratingAfter))
                stat("Delta", String(format: "%@%.1f", record.delta >= 0 ? "+" : "", record.delta))
                stat("Length", "\(record.durationSec / 60)m \(record.durationSec % 60)s")
                Spacer(minLength: 0)
            }
            if let j = record.judgment {
                Divider().background(Color.border)
                HStack(alignment: .firstTextBaseline) {
                    Text(j.verdict).font(.system(size: 18, weight: .heavy, design: .rounded)).foregroundStyle(gradeColor(j.fill))
                    Spacer()
                    Text("\(Int((j.fill * 100).rounded()))/100").font(.system(size: 14, weight: .light, design: .rounded))
                        .monospacedDigit().foregroundStyle(Color.textMuted)
                }
                Text(j.summary).font(.system(size: 13)).foregroundStyle(Color.textSecondary).lineSpacing(2)
                ForEach(Array(j.criteria.enumerated()), id: \.offset) { _, c in
                    HStack(spacing: 8) {
                        Text(c.name.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(.system(size: 11, weight: .heavy, design: .rounded)).foregroundStyle(Color.textSecondary)
                            .frame(width: 100, alignment: .leading)
                        Text(c.note).font(.system(size: 11)).foregroundStyle(Color.textMuted).lineLimit(2)
                        Spacer(minLength: 0)
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var transcriptCard: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("Transcript").microLabel(Color.textSecondary)
            ForEach(Array(record.turns.enumerated()), id: \.offset) { _, t in
                let isOp = t.role == "operator"
                HStack {
                    if isOp { Spacer(minLength: 28) }
                    Text(t.text)
                        .font(.system(size: 12.5)).foregroundStyle(Color.textPrimary)
                        .padding(.horizontal, 10).padding(.vertical, 7)
                        .background(isOp ? Color.brandGreen.opacity(0.12) : Color.bgRail)
                        .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .strokeBorder(isOp ? Color.brandGreen.opacity(0.25) : Color.border, lineWidth: 1))
                    if !isOp { Spacer(minLength: 28) }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private func stat(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.system(size: 10, weight: .heavy, design: .rounded)).kerning(0.4).foregroundStyle(Color.textMuted)
            Text(value).font(.system(size: 13, weight: .heavy, design: .rounded)).monospacedDigit().foregroundStyle(Color.textPrimary)
        }
    }

    private func gradeColor(_ s: Double) -> Color {
        if s >= 0.7 { return .brandGreen }
        if s >= 0.45 { return .warning }
        return .danger
    }
}
