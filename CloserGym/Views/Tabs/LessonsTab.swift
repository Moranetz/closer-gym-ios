import SwiftUI

struct LessonsTab: View {
    private let tracks: [(name: String, description: String, lessons: Int)] = [
        ("Beginner's Repertoire", "The five openings every closer needs. ECO codes CO1 through CH1.", 5),
        ("Tactical Patterns", "All 40 Atlas techniques as one lesson each. Concept → 2 master games → 3 puzzles → 1 sparring round.", 40),
        ("Defense — objection handling", "How to play losing positions well. Stall detection. Recovery patterns.", 12),
        ("Endgame Mastery", "Closes. Forced sequences. Multi-stakeholder MAP construction.", 14),
        ("Strategy — long sales cycles", "Multi-threading. Champion installation. Mutual close plans.", 8),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Curriculum trees · concept → examples → puzzles → sparring → unlock")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textMuted)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)

                    VStack(spacing: 12) {
                        ForEach(tracks, id: \.name) { t in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(t.name).font(AppFont.titleSmall).foregroundStyle(Color.textPrimary)
                                Text(t.description).font(.system(size: 13)).foregroundStyle(Color.textSecondary).lineSpacing(2)
                                HStack {
                                    Text("\(t.lessons) lessons").font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(Color.textMuted)
                                        .monospacedDigit()
                                    Spacer()
                                    Text("v0.2").font(AppFont.microLabel)
                                        .foregroundStyle(Color.warning)
                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                        .background(Capsule().fill(Color.warning.opacity(0.15)))
                                }
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.bgPanel)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 16)

                    Text("Lessons surface is scaffolded in v0.1; full lesson tree with checkpoint puzzles rolls out with v0.2.")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.textFaint)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                }
            }
            .background(Color.bgPage)
            .navigationTitle("Lessons")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.bgPage, for: .navigationBar)
        }
    }
}
