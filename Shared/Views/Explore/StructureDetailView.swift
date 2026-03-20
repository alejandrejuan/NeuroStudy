import SwiftUI

struct StructureDetailView: View {
    let structure: BrainStructure
    let progressStore: ProgressStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                header

                // Functions
                sectionCard(title: "Functions", sfSymbol: "gearshape.2.fill") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(structure.functions, id: \.self) { function in
                            HStack(alignment: .top, spacing: 8) {
                                Circle()
                                    .fill(structure.region.color)
                                    .frame(width: 6, height: 6)
                                    .padding(.top, 6)
                                Text(function)
                                    .font(.bodyText)
                            }
                        }
                    }
                }

                // Clinical Significance
                sectionCard(title: "Clinical Significance", sfSymbol: "stethoscope") {
                    Text(structure.clinicalSignificance)
                        .font(.bodyText)
                        .foregroundStyle(.secondary)
                }

                // Associated Disorders
                if !structure.associatedDisorders.isEmpty {
                    sectionCard(title: "Associated Disorders", sfSymbol: "exclamationmark.triangle.fill") {
                        FlowLayout(spacing: 8) {
                            ForEach(structure.associatedDisorders, id: \.self) { disorder in
                                Text(disorder)
                                    .font(.system(.caption, design: .rounded, weight: .medium))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background {
                                        Capsule(style: .continuous)
                                            .fill(.red.opacity(0.1))
                                    }
                                    .overlay {
                                        Capsule(style: .continuous)
                                            .strokeBorder(.red.opacity(0.2), lineWidth: 0.5)
                                    }
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }

                // Connections
                if !structure.connections.isEmpty {
                    sectionCard(title: "Connected Structures", sfSymbol: "link") {
                        FlowLayout(spacing: 8) {
                            ForEach(structure.connections, id: \.self) { connectionID in
                                if let connected = BrainStructureStore.structure(byID: connectionID) {
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(connected.region.color)
                                            .frame(width: 8, height: 8)
                                        Text(connected.name)
                                            .font(.system(.caption, design: .rounded))
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background {
                                        Capsule(style: .continuous)
                                            .fill(.ultraThinMaterial)
                                    }
                                }
                            }
                        }
                    }
                }

                // Details
                detailsCard

                // Study Progress
                progressCard
            }
            .padding()
        }
        .background { AdaptiveGradientBackground() }
        .navigationTitle(structure.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }

    // MARK: - Header

    private var header: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    RegionBadge(region: structure.region)
                    Spacer()
                    if let brodmann = structure.brodmannAreas, !brodmann.isEmpty {
                        Text("BA \(brodmann.map(String.init).joined(separator: ", "))")
                            .font(.detailLabel)
                            .foregroundStyle(.secondary)
                    }
                }

                Text(structure.name)
                    .font(.structureTitle)

                if !structure.aliases.isEmpty {
                    Text(structure.aliases.joined(separator: " | "))
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.tertiary)
                }

                Text(structure.description)
                    .font(.bodyText)
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)
            }
        }
    }

    // MARK: - Section Card

    private func sectionCard<Content: View>(title: String, sfSymbol: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: sfSymbol)
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(structure.region.color)
                    Text(title)
                        .font(.sectionHeader)
                }

                content()
            }
        }
    }

    // MARK: - Details Card

    private var detailsCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(structure.region.color)
                    Text("Details")
                        .font(.sectionHeader)
                }

                LabeledContent("Lateralization") {
                    Text(structure.lateralization.rawValue.capitalized)
                        .font(.structureSubtitle)
                }

                LabeledContent("Diagram View") {
                    Text(structure.diagramView.rawValue.capitalized)
                        .font(.structureSubtitle)
                }
            }
        }
    }

    // MARK: - Progress Card

    private var progressCard: some View {
        GlassCard {
            let progress = progressStore.progress(for: structure.id)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundStyle(structure.region.color)
                    Text("Study Progress")
                        .font(.sectionHeader)
                    Spacer()
                    MasteryBadge(level: progress.masteryLevel)
                }

                if progress.totalAttempts > 0 {
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(progress.totalAttempts)")
                                .font(.system(.title3, design: .rounded, weight: .bold))
                            Text("Attempts")
                                .font(.detailLabel)
                                .foregroundStyle(.secondary)
                        }

                        VStack {
                            Text("\(Int(progress.accuracy * 100))%")
                                .font(.system(.title3, design: .rounded, weight: .bold))
                            Text("Accuracy")
                                .font(.detailLabel)
                                .foregroundStyle(.secondary)
                        }

                        VStack {
                            Text("\(progress.streakBest)")
                                .font(.system(.title3, design: .rounded, weight: .bold))
                            Text("Best Streak")
                                .font(.detailLabel)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    Text("Not yet studied. Start a quiz to track progress!")
                        .font(.bodyText)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: ProposedViewSize(bounds.size), subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }

        return (CGSize(width: maxX, height: y + rowHeight), positions)
    }
}
