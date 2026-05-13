import SwiftUI

struct MasterGameViewer: View {
    let game: MasterGame

    @State private var selectedTurn: Int? = nil
    @State private var showMoveList = false

    private var operatorMoves: [(idx: Int, move: MasterMove)] {
        game.moves.enumerated().compactMap { i, m in m.role == .op ? (i, m) : nil }
    }

    private var curve: [(turnIndex: Int, value: Double, role: MoveRole)] {
        Eval.runningCurve(game.moves)
    }

    private var finalEval: Double { curve.last?.value ?? 0 }

    private var nextGameId: String {
        let i = MasterGames.all.firstIndex(where: { $0.id == game.id }) ?? 0
        return MasterGames.all[(i + 1) % MasterGames.all.count].id
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    headerCard

                    evalCurveCard

                    openingBanner

                    transcript

                    studyHint

                    actions
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 32)
                .onChange(of: selectedTurn) { _, new in
                    if let id = new {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            proxy.scrollTo("turn-\(id)", anchor: .center)
                        }
                    }
                }
            }
            .background(Color.bgPage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.bgPage, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(game.speaker)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(1)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Haptics.shared.light()
                        showMoveList.toggle()
                    } label: {
                        Image(systemName: "list.bullet.rectangle")
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }
            .sheet(isPresented: $showMoveList) {
                MoveListSheet(operatorMoves: operatorMoves, opening: (game.openingName, game.openingECO), selected: $selectedTurn) {
                    showMoveList = false
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }

    // MARK: - Header

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(game.outcome.label)
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .kerning(0.7)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(game.outcome.color))
                Text("\(operatorMoves.count) moves").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.textMuted)
                Text("· final \(finalEval >= 0 ? "+" : "")\(String(format: "%.2f", finalEval))")
                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.textMuted).monospacedDigit()
                Spacer()
            }
            Text("vs \(game.opponentRole)").font(.system(size: 14, weight: .semibold)).foregroundStyle(Color.textPrimary)
            Text(game.scenario).font(.system(size: 13)).foregroundStyle(Color.textSecondary).lineSpacing(2)
            Text("Style: \(game.speakerStyle)").font(.system(size: 12)).italic().foregroundStyle(Color.textMuted)
            Divider().background(Color.border).padding(.vertical, 4)
            HStack {
                Text("Opening").microLabel(Color.brandGreen)
                Text(game.openingName).font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.textPrimary)
                Text("(\(game.openingECO))").font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.textMuted).monospacedDigit()
                Spacer()
            }
            Text(game.outcomeNote).font(.system(size: 12)).foregroundStyle(Color.textMuted).lineSpacing(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var evalCurveCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Eval curve · \(finalEval >= 0 ? "operator dominates" : "buyer dominates")").microLabel()
            EvalCurveView(points: curve)
                .frame(height: 100)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    private var openingBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "book.closed.fill").font(.system(size: 12)).foregroundStyle(.brandGreen)
            Text(game.openingName).font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.textSecondary)
            Spacer()
            Text(game.openingECO).font(.system(size: 12, weight: .semibold)).foregroundStyle(Color.textMuted).monospacedDigit()
            Button {
                showMoveList = true
            } label: {
                Image(systemName: "list.bullet.rectangle.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
                    .padding(6)
                    .background(Circle().fill(Color.bgRail))
            }
        }
        .padding(.horizontal, 12).padding(.vertical, 6)
        .background(Color.bgBanner)
        .overlay(Rectangle().fill(Color.border).frame(height: 1), alignment: .bottom)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }

    // MARK: - Transcript

    private var transcript: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(game.moves.enumerated()), id: \.offset) { i, m in
                bubbleRow(turnIndex: i, move: m)
                    .id("turn-\(i)")
            }
        }
    }

    @ViewBuilder
    private func bubbleRow(turnIndex: Int, move: MasterMove) -> some View {
        let isOperator = move.role == .op
        let isSelected = selectedTurn == turnIndex

        let speakerShort: String = {
            if isOperator {
                if let first = game.speaker.split(separator: " ").first { return String(first) }
                return "Op"
            }
            return "Buyer"
        }()
        let metaLabel = "\(speakerShort) · turn \(turnIndex + 1)"

        VStack(alignment: isOperator ? .trailing : .leading, spacing: 8) {
            HStack {
                if isOperator { Spacer() }
                VStack(alignment: .leading, spacing: 4) {
                    Text(metaLabel)
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .kerning(0.4)
                        .foregroundStyle(Color.textMuted)
                        .textCase(.uppercase)
                    Text(move.text)
                        .font(.system(size: 14))
                        .foregroundStyle(isOperator ? Color.textPrimary : Color.textSecondary)
                        .lineSpacing(2)
                    if let tags = move.techniqueIds, !tags.isEmpty {
                        FlowLayout(spacing: 4, lineSpacing: 4) {
                            ForEach(tags, id: \.self) { tag in
                                Text(AtlasTechniques.name(for: tag))
                                    .font(.system(size: 10, weight: .semibold))
                                    .kerning(0.4)
                                    .foregroundStyle(Color.textMuted)
                                    .padding(.horizontal, 6).padding(.vertical, 2)
                                    .background(RoundedRectangle(cornerRadius: 2, style: .continuous).fill(Color.white.opacity(0.06)))
                            }
                        }
                    }
                }
                .padding(12)
                .frame(maxWidth: 320, alignment: .leading)
                .background(isOperator ? Color.brandGreen.opacity(0.14) : Color.bgPanel)
                .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(isOperator ? Color.brandGreen.opacity(0.32) : Color.borderStrong, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(isSelected ? Color.info : .clear, lineWidth: 2).padding(-4))
                if !isOperator { Spacer() }
            }

            if isOperator, let annotation = move.annotation, let delta = move.delta {
                annotationCard(annotation: annotation, delta: delta)
                    .frame(maxWidth: 320, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .onTapGesture {
            Haptics.shared.selection()
            withAnimation { selectedTurn = turnIndex }
        }
    }

    private func annotationCard(annotation: String, delta: Double) -> some View {
        let q = classifyMove(delta)
        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text("Annotation").microLabel(Color.brandGreen)
                if !q.glyph.isEmpty {
                    HStack(spacing: 3) {
                        Text(q.glyph).font(.system(size: 12, weight: .heavy)).foregroundStyle(q.color)
                        Text(q.label).font(.system(size: 10, weight: .semibold)).foregroundStyle(Color.textMuted)
                    }
                }
                Text("\(delta >= 0 ? "+" : "")\(String(format: "%.2f", delta))")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(delta > 0.15 ? .brandGreen : delta < -0.15 ? .danger : .textMuted)
                    .padding(.horizontal, 6).padding(.vertical, 1)
                    .background(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(
                        delta > 0.15 ? Color.brandGreen.opacity(0.18) : delta < -0.15 ? Color.danger.opacity(0.18) : Color.bgRail
                    ))
            }
            Text(annotation)
                .font(.system(size: 12.5))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(2)
        }
        .padding(10)
        .background(
            Color.bgRail
                .overlay(Rectangle().fill(q.color.opacity(0.8)).frame(width: 3), alignment: .leading)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }

    // MARK: - Study hint

    private var studyHint: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Study takeaway").microLabel(Color.brandGreen)
            Text(game.studyHint)
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(3)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color.border, lineWidth: 1))
    }

    // MARK: - Actions

    private var actions: some View {
        HStack(spacing: 10) {
            NavigationLink(destination: MasterGameViewer(game: MasterGames.get(nextGameId)!)) {
                Text("Next master game →")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .kerning(0.3)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity).frame(height: 48)
                    .background(Color.brandGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Move list sheet

private struct MoveListSheet: View {
    let operatorMoves: [(idx: Int, move: MasterMove)]
    let opening: (name: String, eco: String)
    @Binding var selected: Int?
    let dismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Operator moves").microLabel(Color.brandGreen)
                Spacer()
                Text(opening.eco).font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.textMuted)
            }
            .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 12)

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(operatorMoves.enumerated()), id: \.offset) { i, item in
                        let m = item.move
                        let q = m.delta.map(classifyMove)
                        let label = (m.techniqueIds ?? []).prefix(2).map(AtlasTechniques.name(for:)).joined(separator: " + ")
                        Button {
                            Haptics.shared.selection()
                            selected = item.idx
                            dismiss()
                        } label: {
                            HStack(spacing: 10) {
                                Text("\(i + 1).")
                                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                                    .foregroundStyle(Color.textMuted)
                                    .frame(width: 28, alignment: .trailing)
                                Text(label.isEmpty ? "—" : label)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                    .lineLimit(1)
                                if let q, !q.glyph.isEmpty {
                                    Text(q.glyph).font(.system(size: 12, weight: .heavy)).foregroundStyle(q.color)
                                }
                                Spacer()
                                if let d = m.delta {
                                    Text("\(d >= 0 ? "+" : "")\(String(format: "%.2f", d))")
                                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                                        .monospacedDigit()
                                        .foregroundStyle(d > 0.15 ? .brandGreen : d < -0.15 ? .danger : .textMuted)
                                }
                            }
                            .padding(.horizontal, 16).padding(.vertical, 10)
                            .background(selected == item.idx ? Color.info.opacity(0.18) : .clear)
                        }
                        .buttonStyle(.plain)
                        Divider().background(Color.border)
                    }
                }
            }
        }
        .background(Color.bgPanel)
    }
}
