import SwiftUI

/// Lesson detail — full technique reference plus every cross-reference
/// across puzzles, transcripts, and master games.
struct LessonDetailView: View {
    let technique: Technique

    @State private var openTranscript: Transcript? = nil

    private var relatedPuzzles: [Puzzle] {
        Puzzles.all.filter { p in
            p.candidates.contains { $0.atlasTags.contains(technique.id) }
        }
    }

    private var relatedTranscripts: [Transcript] {
        Transcripts.all.filter { $0.techniqueIds.contains(technique.id) }
    }

    private var relatedMasterMoves: [(game: MasterGame, move: MasterMove, turnIndex: Int)] {
        var out: [(MasterGame, MasterMove, Int)] = []
        for g in MasterGames.all {
            for (i, m) in g.moves.enumerated() {
                if let ids = m.techniqueIds, ids.contains(technique.id) {
                    out.append((g, m, i))
                }
            }
        }
        return out
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                evidenceBlock
                if let drillPuzzle = relatedPuzzles.first {
                    NavigationLink(destination: PuzzleSolveView(puzzle: drillPuzzle, isDaily: false)) {
                        HStack(spacing: 10) {
                            Image(systemName: "play.fill")
                                .scaledFont(size: 14, weight: .bold)
                                .foregroundStyle(Color.bgPage)
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Drill this technique now").scaledFont(size: 14, weight: .bold).foregroundStyle(Color.bgPage)
                                Text("ELO \(drillPuzzle.difficulty) · \(drillPuzzle.theme.label)")
                                    .scaledFont(size: 11, weight: .semibold)
                                    .foregroundStyle(Color.bgPage.opacity(0.75))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 14).padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.brandGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
                if !technique.canonicalSource.isEmpty || !technique.primaryFailureMode.isEmpty {
                    referenceFields
                }
                if !relatedPuzzles.isEmpty { puzzlesSection }
                if !relatedTranscripts.isEmpty { transcriptsSection }
                if !relatedMasterMoves.isEmpty { masterMovesSection }
                if relatedPuzzles.isEmpty && relatedTranscripts.isEmpty && relatedMasterMoves.isEmpty {
                    Text("No puzzles, transcripts, or master moves are tagged with this technique yet.")
                        .scaledFont(size: 13)
                        .italic()
                        .foregroundStyle(Color.textMuted)
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.bgRail)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
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
                Text(technique.name)
                    .scaledFont(size: 14, weight: .semibold)
                    .foregroundStyle(Color.textPrimary)
            }
        }
        .sheet(item: $openTranscript) { t in
            TranscriptSheet(transcript: t)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(technique.cluster.label).microLabel()
            Text(technique.name)
                .scaledFont(size: 22, weight: .heavy, design: .rounded)
                .foregroundStyle(Color.textPrimary)
            Text(technique.plain)
                .scaledFont(size: 15, weight: .semibold)
                .foregroundStyle(Color.textPrimary)
                .lineSpacing(4)
                .padding(.top, 4)
            VStack(alignment: .leading, spacing: 4) {
                Text("Mechanism").microLabel()
                Text(technique.mechanism)
                    .scaledFont(size: 13)
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(4)
            }
            .padding(.top, 8)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    // MARK: - Evidence (move-quality grade)

    private var bandColor: Color {
        switch technique.evidenceBand {
        case .core:       return .brilliant
        case .supporting: return .textMuted
        case .flagged:    return .warning
        }
    }
    private var bandGlyph: String {
        switch technique.evidenceBand {
        case .core:       return "◆◆"
        case .supporting: return "◆"
        case .flagged:    return "?!"
        }
    }

    private var evidenceBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(bandGlyph)
                    .scaledFont(size: 26, weight: .heavy, design: .rounded)
                    .foregroundStyle(bandColor)
                    .frame(width: 42)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(technique.evidenceBand.label)
                        .scaledFont(size: 15, weight: .heavy)
                        .foregroundStyle(bandColor)
                    Text(technique.evidenceTier.map { "\($0.label) evidence" } ?? "classic principle")
                        .scaledFont(size: 11)
                        .foregroundStyle(Color.textMuted)
                }
                Spacer(minLength: 0)
            }
            if !technique.contraindication.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text(technique.evidenceBand == .flagged ? "Why flagged" : "When to be careful").microLabel(bandColor)
                    Text(technique.contraindication)
                        .scaledFont(size: 12.5)
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(3)
                }
            }
            HStack(spacing: 6) {
                legendCell("◆◆", "CORE", "evidence-backed", .brilliant, technique.evidenceBand == .core)
                legendCell("◆", "SUPPORTING", "mechanism only", .textMuted, technique.evidenceBand == .supporting)
                legendCell("?!", "FLAGGED", "handle w/ care", .warning, technique.evidenceBand == .flagged)
            }
            if !technique.evidenceSource.isEmpty, let url = URL(string: technique.evidenceSource), url.scheme?.hasPrefix("http") == true {
                Link(destination: url) {
                    HStack(spacing: 5) {
                        Text("Source").scaledFont(size: 11, weight: .semibold)
                        Image(systemName: "arrow.up.right").scaledFont(size: 9, weight: .bold)
                    }
                    .foregroundStyle(Color.info)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(bandColor.opacity(0.25), lineWidth: 1))
    }

    private func legendCell(_ g: String, _ t: String, _ s: String, _ c: Color, _ active: Bool) -> some View {
        VStack(spacing: 3) {
            Text(g).scaledFont(size: 15, weight: .heavy).foregroundStyle(c)
            Text(t).scaledFont(size: 8.5, weight: .heavy).kerning(0.3).foregroundStyle(active ? c : Color.textMuted)
            Text(s).scaledFont(size: 8, weight: .semibold).foregroundStyle(Color.textFaint).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7).padding(.horizontal, 3)
        .background(active ? c.opacity(0.10) : Color.bgRail)
        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous).strokeBorder(active ? c.opacity(0.4) : Color.border, lineWidth: 1))
    }

    private var referenceFields: some View {
        VStack(spacing: 8) {
            if !technique.primaryFailureMode.isEmpty {
                fieldCard(label: "Primary failure mode", body: technique.primaryFailureMode)
            }
            if !technique.canonicalSource.isEmpty {
                fieldCard(label: "Canonical source", body: technique.canonicalSource)
            }
        }
    }

    private func fieldCard(label: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).microLabel()
            Text(body).scaledFont(size: 13).foregroundStyle(Color.textSecondary).lineSpacing(3)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var puzzlesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Drill in puzzles (\(relatedPuzzles.count))").microLabel(Color.brandGreen)
            VStack(spacing: 8) {
                ForEach(relatedPuzzles) { p in
                    NavigationLink(destination: PuzzleSolveView(puzzle: p, isDaily: false)) {
                        puzzleRow(p)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func puzzleRow(_ p: Puzzle) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("ELO \(p.difficulty)").scaledFont(size: 10, weight: .semibold).foregroundStyle(Color.textMuted).monospacedDigit()
                    Text(p.theme.label.uppercased()).scaledFont(size: 10, weight: .semibold).foregroundStyle(p.theme.tint).kerning(0.3)
                }
                Text(p.buyerRole).scaledFont(size: 13, weight: .semibold).foregroundStyle(Color.textPrimary).lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right").scaledFont(size: 11, weight: .bold).foregroundStyle(Color.textFaint)
        }
        .padding(12)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var transcriptsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Demonstrated in transcripts (\(relatedTranscripts.count))").microLabel(Color.brandGreen)
            VStack(spacing: 8) {
                ForEach(relatedTranscripts) { t in
                    Button {
                        Haptics.shared.light()
                        openTranscript = t
                    } label: {
                        transcriptRow(t)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func transcriptRow(_ t: Transcript) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(t.speaker): \(t.title)")
                    .scaledFont(size: 13, weight: .bold)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                if t.paraphrased {
                    Text("paraphrased")
                        .scaledFont(size: 9, weight: .heavy, design: .rounded)
                        .kerning(0.4)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.warning)
                        .padding(.horizontal, 5).padding(.vertical, 1)
                        .overlay(RoundedRectangle(cornerRadius: 2, style: .continuous).strokeBorder(Color.warning.opacity(0.4), lineWidth: 1))
                }
            }
            Text(t.scenario)
                .scaledFont(size: 12)
                .foregroundStyle(Color.textMuted)
                .lineSpacing(2)
                .lineLimit(3)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var masterMovesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Master-game moves (\(relatedMasterMoves.count))").microLabel(Color.brandGreen)
            VStack(spacing: 8) {
                ForEach(Array(relatedMasterMoves.enumerated()), id: \.offset) { idx, item in
                    NavigationLink(destination: MasterGameViewer(game: item.game)) {
                        masterMoveRow(game: item.game, move: item.move, turnIndex: item.turnIndex)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func masterMoveRow(game: MasterGame, move: MasterMove, turnIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(game.speaker) · turn \(turnIndex + 1)")
                    .scaledFont(size: 12, weight: .bold)
                    .foregroundStyle(Color.textSecondary)
                Spacer()
                if let d = move.delta {
                    let q = classifyMove(d)
                    if !q.glyph.isEmpty {
                        Text(q.glyph).scaledFont(size: 12, weight: .heavy).foregroundStyle(q.color)
                    }
                }
            }
            Text("\u{201C}\(move.text)\u{201D}")
                .scaledFont(size: 13)
                .italic()
                .foregroundStyle(Color.textPrimary)
                .lineSpacing(2)
                .lineLimit(3)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

}
