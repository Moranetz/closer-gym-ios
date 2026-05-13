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
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Browse the Atlas taxonomy. Each entry shows mechanism, evidence verdict, folklore risk, and every puzzle + transcript + master move that demonstrates it.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(3)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                ForEach(clusterOrder, id: \.self) { cluster in
                    let inCluster = AtlasTechniques.all.filter { $0.cluster == cluster }
                    if !inCluster.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(cluster.label).microLabel(Color.textSecondary)
                                Spacer()
                                Text("\(inCluster.count)").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.textMuted).monospacedDigit()
                            }
                            .padding(.bottom, 6)
                            .overlay(alignment: .bottom) {
                                Rectangle().fill(Color.border).frame(height: 1).offset(y: 4)
                            }
                            VStack(spacing: 8) {
                                ForEach(inCluster) { t in
                                    NavigationLink(destination: LessonDetailView(technique: t)) {
                                        techniqueRow(t)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                    }
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

    private func techniqueRow(_ t: Technique) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(t.name).font(.system(size: 15, weight: .bold)).foregroundStyle(Color.textPrimary)
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
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
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
