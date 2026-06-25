import SwiftUI

struct LessonsTab: View {
    var body: some View {
        NavigationStack {
            LessonIndexView()
        }
    }
}

private let clusterOrder: [AtlasCluster] = [
    .questionForm, .cialdini, .framing, .compliance,
    .negotiationAnchor, .structuralClose, .postObjection, .closingEnvironment,
]

private func verdictColor(_ v: AtlasVerdict) -> Color {
    switch v {
    case .wellStudied:        return .brandGreen
    case .partiallyStudied:   return .warning
    case .replicationFailed:  return .danger
    case .untested:           return .textMuted
    }
}

private func verdictLabel(_ v: AtlasVerdict) -> String {
    switch v {
    case .wellStudied:       return "well-studied"
    case .partiallyStudied:  return "partial"
    case .replicationFailed: return "replication-failed"
    case .untested:          return "untested"
    }
}

private func riskColor(_ r: FolkloreRisk) -> Color {
    switch r {
    case .high:       return .danger
    case .mediumHigh: return .warning
    default:          return .textMuted
    }
}

struct LessonIndexView: View {
    @EnvironmentObject private var storage: Store
    @State private var search: String = ""

    /// Atlas techniques the user has encountered via a correctly-solved puzzle.
    private var encounteredIds: Set<String> {
        var ids = Set<String>()
        for solve in storage.puzzleState.solves where solve.correct {
            if let puzzle = Puzzles.get(solve.puzzleId) {
                let chosen = puzzle.candidates[solve.pickedIndex < 0 ? puzzle.bestIndex : min(solve.pickedIndex, puzzle.candidates.count - 1)]
                for tag in chosen.atlasTags {
                    ids.insert(tag)
                }
            }
        }
        return ids
    }

    private func filtered(_ list: [Technique]) -> [Technique] {
        guard !search.isEmpty else { return list }
        let q = search.lowercased()
        return list.filter { t in
            t.name.lowercased().contains(q) ||
            t.id.lowercased().contains(q) ||
            t.mechanism.lowercased().contains(q) ||
            t.cluster.label.lowercased().contains(q)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Browse the Atlas taxonomy. Each entry shows mechanism, evidence verdict, folklore risk, and every puzzle, transcript, and master move that demonstrates it.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(3)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.textMuted)
                    TextField("Search techniques", text: $search)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.textPrimary)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    if !search.isEmpty {
                        Button {
                            search = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.textFaint)
                        }
                    }
                }
                .padding(.horizontal, 12).padding(.vertical, 10)
                .background(Color.bgPanel)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
                .padding(.horizontal, 16)

                if !encounteredIds.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.brandGreen)
                        Text("\(encounteredIds.count) of \(AtlasTechniques.all.count) techniques encountered via puzzle solves")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textMuted)
                    }
                    .padding(.horizontal, 16)
                }

                ForEach(clusterOrder, id: \.self) { cluster in
                    let inCluster = filtered(AtlasTechniques.all.filter { $0.cluster == cluster })
                    if !inCluster.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(cluster.label).microLabel(Color.textSecondary)
                                    Spacer()
                                    Text("\(inCluster.count)").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.textMuted).monospacedDigit()
                                }
                                Text(cluster.definition)
                                    .font(.system(size: 11))
                                    .italic()
                                    .foregroundStyle(Color.textFaint)
                                    .lineSpacing(2)
                            }
                            .padding(.bottom, 6)
                            .overlay(alignment: .bottom) {
                                Rectangle().fill(Color.border).frame(height: 1).offset(y: 4)
                            }
                            VStack(spacing: 8) {
                                ForEach(inCluster) { t in
                                    NavigationLink(destination: LessonDetailView(technique: t)) {
                                        techniqueRow(t, encountered: encounteredIds.contains(t.id))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                    }
                }

                if !search.isEmpty && filtered(AtlasTechniques.all).isEmpty {
                    Text("No techniques match \"\(search)\".")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textMuted)
                        .italic()
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                Text("Verdict: well-studied means multiple replications across contexts; partial means lab evidence with weak field replication; untested means folklore-only; replication-failed means published failures of the canonical study.")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.textFaint)
                    .lineSpacing(3)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
            }
        }
        .background(Color.bgPage)
        .navigationTitle("Lessons · Atlas")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color.bgPage, for: .navigationBar)
    }

    private func techniqueRow(_ t: Technique, encountered: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(t.name).font(.system(size: 15, weight: .bold)).foregroundStyle(Color.textPrimary)
                if encountered {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.brandGreen)
                }
                Spacer()
            }
            Text(t.mechanism.split(separator: ";").first.map(String.init) ?? t.mechanism)
                .font(.system(size: 12))
                .foregroundStyle(Color.textMuted)
                .lineSpacing(2)
                .lineLimit(3)
            HStack(spacing: 6) {
                pill(text: verdictLabel(t.atlasVerdict), color: verdictColor(t.atlasVerdict))
                if t.folkloreRisk == .high || t.folkloreRisk == .mediumHigh {
                    pill(text: "folklore: \(t.folkloreRisk.rawValue)", color: riskColor(t.folkloreRisk))
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(encountered ? Color.brandGreen.opacity(0.35) : Color.border, lineWidth: 1))
    }

    private func pill(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .heavy, design: .rounded))
            .kerning(0.4)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(RoundedRectangle(cornerRadius: 2, style: .continuous).fill(Color.white.opacity(0.06)))
    }
}
