import SwiftUI

// MARK: - Atlas

struct ModernExploreView: View {
    let progressStore: ProgressStore
    @State private var brainMap = BrainMapViewModel()
    @State private var searchText = ""
    @State private var selectedRegionFilter: BrainRegion?
    @State private var showingDetail = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var filteredStructures: [BrainStructure] {
        var structures = searchText.isEmpty ? BrainStructureStore.all : BrainStructureStore.search(searchText)
        if let region = selectedRegionFilter {
            structures = structures.filter { $0.region == region }
        }
        return structures
    }

    /// Browsing with no search or filter groups the list by region, like Sports groups
    /// games by league. A search or filter collapses it into one list of results.
    private var isBrowsing: Bool { searchText.isEmpty && selectedRegionFilter == nil }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        brainMapSection

                        regionFilterSection
                            .padding(.top, 14)

                        if let structure = brainMap.selectedStructure {
                            selectedStructureCard(structure)
                                .padding(.top, 16)
                                .padding(.horizontal, 16)
                                .transition(
                                    .asymmetric(
                                        insertion: .scale(scale: 0.93).combined(with: .opacity).combined(with: .move(edge: .top)),
                                        removal: .scale(scale: 0.97).combined(with: .opacity)
                                    )
                                )
                        }

                        structureListSection
                            .padding(.top, 28)
                            .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 28)
                    .frame(maxWidth: horizontalSizeClass == .regular ? 900 : .infinity)
                    .frame(maxWidth: .infinity)
                }
                .scrollDismissesKeyboard(.interactively)
                .softScrollEdges()
            }
            .navigationTitle("Atlas")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Structures, functions, disorders"
            )
            #else
            .searchable(text: $searchText, prompt: "Structures, functions, disorders")
            #endif
            .sheet(isPresented: $showingDetail) {
                if let structure = brainMap.selectedStructure {
                    NavigationStack {
                        ModernStructureDetailView(structure: structure, progressStore: progressStore)
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Done") { showingDetail = false }
                                        .glassButton(prominent: true, controlSize: .small)
                                }
                            }
                    }
                    #if os(iOS)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    #endif
                }
            }
        }
    }

    // MARK: - Brain Map

    private var brainMapSection: some View {
        VStack(spacing: 10) {
            HStack {
                Label("Tap a region", systemImage: "hand.tap")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
                Spacer()
                BrainViewToggle(currentView: Binding(
                    get: { brainMap.currentView },
                    set: { brainMap.currentView = $0; brainMap.clearSelection() }
                ))
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)

            BrainMapView(
                viewModel: brainMap,
                onRegionTapped: { structureID in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        brainMap.select(structureID)
                    }
                }
            )
            .padding(.horizontal, 16)
            .frame(maxHeight: horizontalSizeClass == .regular ? 500 : 340)
        }
    }

    // MARK: - Region Filter

    private var regionFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            // Grouped so the chips' glass shapes blend into one another as they scroll.
            GlassGroup(spacing: 8) {
                HStack(spacing: 8) {
                    filterChip(label: "All", region: nil)
                    ForEach(BrainRegion.allCases) { region in
                        filterChip(label: region.displayName, region: region)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    private func filterChip(label: String, region: BrainRegion?) -> some View {
        let isSelected = selectedRegionFilter == region
        let tint = region?.color ?? Theme.violet
        return Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                selectedRegionFilter = region
            }
            Haptics.softImpact()
        } label: {
            HStack(spacing: 6) {
                if let region {
                    Circle()
                        .fill(region.color)
                        .frame(width: 7, height: 7)
                }
                Text(label)
                    .font(.subheadline.weight(isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .glassSurface(
                in: Capsule(style: .continuous),
                tint: isSelected ? tint : nil,
                interactive: true,
                shadowRadius: 6,
                shadowY: 2
            )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    // MARK: - Selected Structure Card

    /// The one piece of content that floats on glass: it is transient, it hovers over
    /// the list, and it dismisses. Everything else on the screen is a content surface.
    private func selectedStructureCard(_ structure: BrainStructure) -> some View {
        SurfaceCard(cornerRadius: 28, padding: 20, floating: true) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top, spacing: 12) {
                    GlyphTile(systemName: structure.region.sfSymbol, color: structure.region.color, size: 40)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(structure.region.displayName.uppercased())
                            .font(.statLabel)
                            .foregroundStyle(.secondary)
                        Text(structure.name)
                            .font(.title3.weight(.bold))
                        if let alias = structure.aliases.first {
                            Text(alias)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer(minLength: 0)

                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            brainMap.clearSelection()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.footnote.weight(.bold))
                            .foregroundStyle(.secondary)
                            .frame(width: 30, height: 30)
                            .background(.quaternary, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close")
                }

                Text(structure.description)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                if !structure.functions.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(structure.functions.prefix(2), id: \.self) { fn in
                            Label {
                                Text(fn)
                                    .font(.subheadline)
                            } icon: {
                                Image(systemName: "bolt.fill")
                                    .font(.caption2)
                                    .foregroundStyle(structure.region.color)
                            }
                        }
                    }
                }

                if let disorder = structure.associatedDisorders.first {
                    Label("Associated with \(disorder)", systemImage: "stethoscope")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .softChip(tint: .orange, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                HStack(spacing: 10) {
                    Button {
                        showingDetail = true
                    } label: {
                        Text("Full Details")
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 6)
                    }
                    .glassButton(prominent: true)

                    Spacer()

                    ModernMasteryBadge(level: progressStore.progress(for: structure.id).masteryLevel, animated: true)
                }
            }
        }
    }

    // MARK: - Structure List

    @ViewBuilder
    private var structureListSection: some View {
        let structures = filteredStructures

        if structures.isEmpty {
            ContentUnavailableView.search(text: searchText)
                .padding(.top, 20)
        } else if isBrowsing {
            LazyVStack(alignment: .leading, spacing: 26) {
                ForEach(BrainRegion.allCases) { region in
                    let inRegion = structures.filter { $0.region == region }
                    if !inRegion.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            // The region's icon lives on the header once, not on all
                            // nine rows beneath it.
                            HStack(spacing: 10) {
                                GlyphTile(systemName: region.sfSymbol, color: region.color, size: 26)
                                SectionHeader(region.displayName) {
                                    Text("\(inRegion.count)")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                        .monospacedDigit()
                                }
                                .padding(.leading, -4)
                            }
                            .padding(.leading, 4)
                            structureGroup(inRegion, showsGlyph: false)
                        }
                    }
                }
            }
        } else {
            VStack(alignment: .leading, spacing: 10) {
                SectionHeader(searchText.isEmpty ? (selectedRegionFilter?.displayName ?? "Structures") : "Results") {
                    Text("\(structures.count)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                structureGroup(structures, showsGlyph: true)
            }
        }
    }

    @ViewBuilder
    private func structureGroup(_ structures: [BrainStructure], showsGlyph: Bool) -> some View {
        let inset: CGFloat = showsGlyph ? 58 : 14
        if horizontalSizeClass == .regular {
            // iPad: two balanced columns, each its own grouped surface.
            let mid = (structures.count + 1) / 2
            HStack(alignment: .top, spacing: 14) {
                GroupedList(data: Array(structures[..<mid]), separatorInset: inset) { structureRow($0, showsGlyph: showsGlyph) }
                if mid < structures.count {
                    GroupedList(data: Array(structures[mid...]), separatorInset: inset) { structureRow($0, showsGlyph: showsGlyph) }
                } else {
                    Color.clear.frame(maxWidth: .infinity)
                }
            }
        } else {
            GroupedList(data: structures, separatorInset: inset) { structureRow($0, showsGlyph: showsGlyph) }
        }
    }

    private func structureRow(_ structure: BrainStructure, showsGlyph: Bool) -> some View {
        let isSelected = brainMap.selectedID == structure.id
        let isHighlighted = brainMap.highlightedIDs.contains(structure.id)
        let prog = progressStore.progress(for: structure.id)

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                brainMap.select(structure.id)
            }
        } label: {
            HStack(spacing: 14) {
                if showsGlyph {
                    GlyphTile(systemName: structure.region.sfSymbol, color: structure.region.color)
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text(structure.name)
                        .font(.body.weight(isSelected ? .semibold : .regular))
                        .foregroundStyle(.primary)
                    if let function = structure.functions.first {
                        Text(function)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 8)

                if prog.totalAttempts > 0 {
                    ModernMasteryBadge(level: prog.masteryLevel, showLabel: false)
                }
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                if isSelected || isHighlighted {
                    structure.region.color.opacity(isSelected ? 0.16 : 0.08)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Structure Detail View Wrapper

struct ModernStructureDetailView: View {
    let structure: BrainStructure
    let progressStore: ProgressStore

    var body: some View {
        StructureDetailView(structure: structure, progressStore: progressStore)
    }
}
