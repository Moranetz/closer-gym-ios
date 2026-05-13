import SwiftUI

/// Read-Full-Transcript sheet presented after the user solves a puzzle.
/// Shows the real sourced excerpt where this move type was played by a
/// recognized practitioner. Brief fair-use quotation with source attribution.
struct TranscriptSheet: View {
    let transcript: Transcript

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Read full transcript").microLabel(Color.brandGreen)
                        Text("\(transcript.speaker): \(transcript.title)")
                            .font(AppFont.title)
                            .foregroundStyle(Color.textPrimary)
                        Text(transcript.source)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textMuted)
                            .lineSpacing(2)
                    }

                    // Scenario
                    Text(transcript.scenario)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(3)
                        .padding(.bottom, 8)
                        .overlay(alignment: .bottom) {
                            Rectangle().fill(Color.border).frame(height: 1)
                        }

                    // Turns
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(transcript.turns.enumerated()), id: \.offset) { i, turn in
                            turnRow(turn: turn, index: i)
                        }
                    }
                    .padding(.top, 6)

                    // Technique note
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Move sequence").microLabel(Color.brandGreen)
                        Text(transcript.techniqueNote)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.textSecondary)
                            .lineSpacing(3)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.bgRail)
                    .overlay(Rectangle().fill(Color.brandGreen).frame(width: 3), alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

                    // Paraphrased disclosure
                    if transcript.paraphrased {
                        Text("Paraphrased reconstruction. Not a verbatim recovered transcript. Sourced from the speaker's published teaching material plus widely-cited reconstructions.")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.warning)
                            .lineSpacing(3)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.warning.opacity(0.10))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    }

                    // Source link
                    Link(destination: URL(string: transcript.sourceUrl) ?? URL(string: "https://example.com")!) {
                        Text("View source →")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.brandGreen)
                    }
                    .padding(.top, 8)

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color.bgPage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    @ViewBuilder
    private func turnRow(turn: TranscriptTurn, index: Int) -> some View {
        switch turn.role {
        case .narrator:
            Text(turn.text)
                .font(.system(size: 12))
                .italic()
                .foregroundStyle(Color.textMuted)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 4)
        case .op:
            VStack(alignment: .trailing, spacing: 4) {
                Text("Operator").microLabel()
                Text(turn.text)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textPrimary)
                    .padding(10)
                    .background(Color.brandGreen.opacity(0.14))
                    .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).strokeBorder(Color.brandGreen.opacity(0.32), lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        case .buyer:
            VStack(alignment: .leading, spacing: 4) {
                Text("Counterparty").microLabel()
                Text(turn.text)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textSecondary)
                    .padding(10)
                    .background(Color.bgRail)
                    .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).strokeBorder(Color.borderStrong, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
