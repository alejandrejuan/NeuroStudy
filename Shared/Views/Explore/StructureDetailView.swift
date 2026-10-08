import SwiftUI

struct StructureDetailView: View {
    let structure: BrainStructure
    let progressStore: ProgressStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                header
                statsStrip

                section("Functions") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(structure.functions, id: \.self) { function in
                            Label {
                                Text(function).font(.body)
                            } icon: {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .foregroundStyle(structure.region.color)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .contentSurface()
                }

                section("Clinical Significance") {
                    Text(structure.clinicalSignificance)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .contentSurface()
                }

                if !structure.associatedDisorders.isEmpty {
                    section("Associated Disorders") {
                        FlowLayout(spacing: 8) {
                            ForEach(structure.associatedDisorders, id: \.self) { disorder in
                                Text(disorder)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 7)
                                    .contentSurface(cornerRadius: 100)
                            }
                        }
                    }
                }

                if !connectedStructures.isEmpty {
                    section("Connected Structures") {
                        FlowLayout(spacing: 8) {
                            ForEach(connectedStructures) { connected in
                                HStack(spacing: 6) {
                                    Circle().fill(connected.region.color).frame(width: 7, height: 7)
                                    Text(connected.name).font(.subheadline)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .contentSurface(cornerRadius: 100)
                            }
                        }
                    }
                }

                section("Details") {
                    VStack(spacing: 0) {
                        detailRow("Region", value: structure.region.displayName)
                        Divider().padding(.leading, 16)
                        detailRow("Lateralization", value: structure.lateralization.rawValue.capitalized)
                        Divider().padding(.leading, 16)
                        detailRow("Diagram View", value: structure.diagramView.rawValue.capitalized)
                        if let brodmann = structure.brodmannAreas, !brodmann.isEmpty {
                            Divider().padding(.leading, 16)
                            detailRow("Brodmann Areas", value: brodmann.map(String.init).joined(separator: ", "))
                        }
                    }
                    .contentSurface()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 28)
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .softScrollEdges()
        .background { AppBackground() }
        .navigationTitle(structure.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }

    private var connectedStructures: [BrainStructure] {
        structure.connections.compactMap { BrainStructureStore.structure(byID: $0) }
    }

    // MARK: - Header

    /// The large navigation title already carries the name, so the header leads with
    /// the region and goes straight into the description, App Store product-page style.
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                GlyphTile(systemName: structure.region.sfSymbol, color: structure.region.color, size: 44)
                VStack(alignment: .leading, spacing: 1) {
                    Text(structure.region.displayName.uppercased())
                        .font(.statLabel)
                        .foregroundStyle(.secondary)
                    if !structure.aliases.isEmpty {
                        Text(structure.aliases.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
                Spacer(minLength: 8)
                let progress = progressStore.progress(for: structure.id)
                if progress.totalAttempts > 0 {
                    ModernMasteryBadge(level: progress.masteryLevel)
                }
            }

            Text(structure.description)
                .font(.body)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 4)
    }

    // MARK: - Stats

    private var statsStrip: some View {
        let progress = progressStore.progress(for: structure.id)

        return Group {
            if progress.totalAttempts > 0 {
                HStack(spacing: 0) {
                    stat("Attempts", "\(progress.totalAttempts)")
                    Divider().padding(.vertical, 12)
                    stat("Accuracy", "\(Int(progress.accuracy * 100))%")
                    Divider().padding(.vertical, 12)
                    stat("Best Streak", "\(progress.streakBest)")
                }
            } else {
                HStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(Theme.violet)
                    Text("Not studied yet. Quiz yourself to start tracking it.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer(minLength: 0)
                }
                .padding(16)
            }
        }
        .contentSurface()
    }

    private func stat(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.statLabel)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.numeral(24))
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 14)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Building Blocks

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title)
            content()
        }
    }

    private func detailRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
        .font(.body)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
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
