import SwiftUI

struct LessonsTab: View {
    // Debug/screenshot hook (same pattern as FF_PUSH_MISSES): sim taps are TCC-walled,
    // so automation can deep-link a technique's detail via env var.
    @State private var pushTech: Technique? = AtlasTechniques.get(
        ProcessInfo.processInfo.environment["FF_PUSH_LESSON"] ?? "")

    var body: some View {
        NavigationStack {
            LessonIndexView()
                .navigationDestination(item: $pushTech) { LessonDetailView(technique: $0) }
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
            if let puzzle = Puzzles.get(solve.puzzleId), !puzzle.candidates.isEmpty {
                // Clamp BOTH branches into bounds — a future data update that shrinks
                // a puzzle's candidates must not trap on an old solve's stored index.
                let idx = solve.pickedIndex < 0 ? puzzle.bestIndex : solve.pickedIndex
                let chosen = puzzle.candidates[max(0, min(idx, puzzle.candidates.count - 1))]
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
                Text("Each lesson breaks down one move: how well it's studied, and where it shows up in the puzzles.")
                    .scaledFont(size: 13)
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(3)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .scaledFont(size: 14, weight: .semibold)
                        .foregroundStyle(Color.textMuted)
                    TextField("Search techniques", text: $search)
                        .scaledFont(size: 14)
                        .foregroundStyle(Color.textPrimary)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    if !search.isEmpty {
                        Button {
                            search = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .scaledFont(size: 14)
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
                            .scaledFont(size: 13)
                            .foregroundStyle(Color.brandGreen)
                        Text("\(encounteredIds.count) of \(AtlasTechniques.all.count) techniques encountered via puzzle solves")
                            .scaledFont(size: 12)
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
                                    Text("\(inCluster.count)").scaledFont(size: 11, weight: .semibold).foregroundStyle(Color.textMuted).monospacedDigit()
                                }
                                Text(cluster.definition)
                                    .scaledFont(size: 11)
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
                        .scaledFont(size: 13)
                        .foregroundStyle(Color.textMuted)
                        .italic()
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                Text("Well-studied means many studies back it up. Partial means it works in the lab but isn't proven on real calls yet. Untested means it's folklore, not science. Replication-failed means later studies couldn't repeat the result.")
                    .scaledFont(size: 11)
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
                Text(t.name).scaledFont(size: 15, weight: .bold).foregroundStyle(Color.textPrimary)
                if encountered {
                    Image(systemName: "checkmark.circle.fill")
                        .scaledFont(size: 12)
                        .foregroundStyle(Color.brandGreen)
                }
                Spacer()
            }
            Text(t.mechanism.split(separator: ";").first.map(String.init) ?? t.mechanism)
                .scaledFont(size: 12)
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
            .scaledFont(size: 9, weight: .heavy, design: .rounded)
            .kerning(0.4)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(RoundedRectangle(cornerRadius: 2, style: .continuous).fill(Color.white.opacity(0.06)))
    }
}
