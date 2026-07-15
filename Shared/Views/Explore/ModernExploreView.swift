import SwiftUI

// MARK: - Explore View with 3D Brain

struct ModernExploreView: View {
    let progressStore: ProgressStore
    @State private var brainMap = BrainMapViewModel()
    @State private var searchText = ""
    @State private var selectedRegionFilter: BrainRegion?
    @State private var showingDetail = false
    @State private var appeared = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var filteredStructures: [BrainStructure] {
        var structures = BrainStructureStore.all
        if let region = selectedRegionFilter {
            structures = structures.filter { $0.region == region }
        }
        if !searchText.isEmpty {
            structures = BrainStructureStore.search(searchText)
            if let region = selectedRegionFilter {
                structures = structures.filter { $0.region == region }
            }
        }
        return structures
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AdaptiveGradientBackground()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        brainMapSection
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 14)

                        regionFilterSection
                            .padding(.top, 14)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 8)

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
                            .padding(.top, 20)
                    }
                    .padding(.bottom, 28)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("Brain Atlas")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Structures, functions, disorders…"
            )
            #else
            .searchable(text: $searchText, prompt: "Structures, functions, disorders…")
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
            .task {
                try? await Task.sleep(nanoseconds: 100_000_000)
                withAnimation(.easeOut(duration: 0.55)) { appeared = true }
            }
        }
    }

    // MARK: - Brain Atlas Section

    private var brainMapSection: some View {
        VStack(spacing: 10) {
            // Header row: hint + lateral/medial toggle
            HStack {
                Image(systemName: "hand.tap")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                Text("Tap a region to explore")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                Spacer()
                BrainViewToggle(currentView: Binding(
                    get: { brainMap.currentView },
                    set: { brainMap.currentView = $0; brainMap.clearSelection() }
                ))
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)
            .opacity(appeared ? 1 : 0)

            // Brain Map
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

            // Quick stats
            if brainMap.selectedStructure == nil {
                quickStatsBar
                    .padding(.horizontal, 16)
                    .padding(.top, 6)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    private var quickStatsBar: some View {
        HStack(spacing: 8) {
            statPill(icon: "brain.head.profile.fill", value: "\(BrainStructureStore.all.count)",
                     label: "Structures", color: .blue)
            statPill(icon: "star.fill", value: "\(progressStore.masteredCount())",
                     label: "Mastered", color: .green)
            statPill(icon: "chart.bar.fill", value: "\(Int(progressStore.overallAccuracy() * 100))%",
                     label: "Accuracy", color: .orange)
        }
    }

    private func statPill(icon: String, value: String, label: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                Text(label)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7)
        .padding(.horizontal, 10)
        .background {
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(color.opacity(0.25), lineWidth: 0.5)
                }
        }
    }

    // MARK: - Region Filter

    private var regionFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(label: "All", region: nil)
                ForEach(BrainRegion.allCases) { region in
                    filterChip(label: region.displayName, region: region)
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    private func filterChip(label: String, region: BrainRegion?) -> some View {
        let isSelected = selectedRegionFilter == region
        return Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.68)) {
                selectedRegionFilter = region
            }
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            #endif
        } label: {
            HStack(spacing: 5) {
                if let r = region {
                    Image(systemName: r.sfSymbol)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(isSelected ? r.color : .secondary)
                }
                Text(label)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .medium, design: .rounded))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background {
                Capsule(style: .continuous)
                    .fill(isSelected ? (region?.color.opacity(0.18) ?? Color.accentColor.opacity(0.18)) : .clear)
                    .background(Capsule(style: .continuous).fill(.ultraThinMaterial))
            }
            .overlay {
                Capsule(style: .continuous)
                    .strokeBorder(
                        isSelected ? (region?.color ?? .accentColor) : .white.opacity(0.2),
                        lineWidth: isSelected ? 1.5 : 0.5
                    )
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.04 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
    }

    // MARK: - Selected Structure Card

    private func selectedStructureCard(_ structure: BrainStructure) -> some View {
        LiquidGlassCard(cornerRadius: 24, padding: 18, prominent: true) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    ModernRegionBadge(region: structure.region, style: .prominent)
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            brainMap.clearSelection()
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.secondary, .ultraThinMaterial)
                    }
                    .buttonStyle(.plain)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(structure.name)
                        .font(.cardTitle)
                    if let alias = structure.aliases.first {
                        Text(alias)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.tertiary)
                    }
                }

                Text(structure.description)
                    .font(.bodyText)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                if !structure.functions.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        Label("Key Functions", systemImage: "bolt.fill")
                            .font(.microText)
                            .foregroundStyle(.tertiary)
                            .textCase(.uppercase)

                        ForEach(structure.functions.prefix(2), id: \.self) { fn in
                            HStack(alignment: .firstTextBaseline, spacing: 6) {
                                Circle()
                                    .fill(structure.region.color)
                                    .frame(width: 4, height: 4)
                                    .offset(y: 1)
                                Text(fn)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        if structure.functions.count > 2 {
                            Text("+ \(structure.functions.count - 2) more")
                                .font(.system(size: 11))
                                .foregroundStyle(.tertiary)
                                .padding(.leading, 10)
                        }
                    }
                }

                // Clinical note
                if let disorder = structure.associatedDisorders.first {
                    HStack(spacing: 6) {
                        Image(systemName: "stethoscope")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.orange)
                        Text("Associated: \(disorder)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.orange.opacity(0.85))
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.orange.opacity(0.08))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(.orange.opacity(0.2), lineWidth: 0.5)
                            }
                    }
                }

                HStack(spacing: 10) {
                    Button {
                        showingDetail = true
                    } label: {
                        Label("Full Details", systemImage: "arrow.right.circle.fill")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    }
                    .glassButton(prominent: true)

                    Spacer()
                    let prog = progressStore.progress(for: structure.id)
                    ModernMasteryBadge(level: prog.masteryLevel, animated: true)
                }
                .padding(.top, 2)
            }
        }
    }

    // MARK: - Structure List

    private var structureListSection: some View {
        LazyVStack(alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
            Section {
                if horizontalSizeClass == .regular {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ], spacing: 10) {
                        ForEach(Array(filteredStructures.enumerated()), id: \.element.id) { idx, structure in
                            structureRow(structure)
                                .opacity(appeared ? 1 : 0)
                                .offset(y: appeared ? 0 : 8)
                                .animation(
                                    .spring(response: 0.4, dampingFraction: 0.8)
                                    .delay(Double(idx % 10) * 0.04),
                                    value: appeared
                                )
                        }
                    }
                } else {
                    ForEach(Array(filteredStructures.enumerated()), id: \.element.id) { idx, structure in
                        structureRow(structure)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 6)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.8)
                                .delay(Double(idx % 12) * 0.035),
                                value: appeared
                            )
                    }
                }
            } header: {
                HStack(spacing: 8) {
                    Text("All Structures")
                        .font(.sectionHeader)
                    Text("\(filteredStructures.count)")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background {
                            Capsule().fill(.quaternary)
                                .overlay { Capsule().strokeBorder(.tertiary.opacity(0.3), lineWidth: 0.5) }
                        }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
            }
        }
        .padding(.horizontal, 16)
        .animation(.spring(response: 0.35), value: filteredStructures.map(\.id))
    }

    private func structureRow(_ structure: BrainStructure) -> some View {
        let isSelected = brainMap.selectedID == structure.id
        let isHighlighted = brainMap.highlightedIDs.contains(structure.id)
        let prog = progressStore.progress(for: structure.id)

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                brainMap.select(structure.id)
            }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [
                                structure.region.color.opacity(isSelected ? 0.5 : isHighlighted ? 0.35 : 0.22),
                                structure.region.color.opacity(isSelected ? 0.28 : 0.12)
                            ],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(width: 38, height: 38)
                    Image(systemName: structure.region.sfSymbol)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(structure.region.color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(structure.name)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(structure.functions.first ?? "")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 6)

                HStack(spacing: 5) {
                    if prog.totalAttempts > 0 {
                        ModernMasteryBadge(level: prog.masteryLevel, showLabel: false)
                    }
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.quaternary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(
                        color: isSelected ? structure.region.color.opacity(0.22) : .black.opacity(0.04),
                        radius: isSelected ? 10 : 3, y: 2
                    )
            }
            .overlay {
                if isSelected || isHighlighted {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    structure.region.color.opacity(isSelected ? 0.7 : 0.4),
                                    structure.region.color.opacity(isSelected ? 0.35 : 0.15)
                                ],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            lineWidth: isSelected ? 2 : 1
                        )
                }
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.28, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
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
