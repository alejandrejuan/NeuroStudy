import SwiftUI

struct BrainMapView: View {
    @Bindable var viewModel: BrainMapViewModel
    var onRegionTapped: ((String) -> Void)?

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            let rect = geo.frame(in: .local)

            ZStack {
                // Subtle ambient shadow behind brain
                if !reduceMotion {
                    Ellipse()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.85, green: 0.82, blue: 0.80).opacity(colorScheme == .dark ? 0.08 : 0.12),
                                    .clear
                                ],
                                center: .center,
                                startRadius: rect.width * 0.15,
                                endRadius: rect.width * 0.50
                            )
                        )
                        .frame(width: rect.width * 0.80, height: rect.height * 0.70)
                        .position(x: rect.midX, y: rect.midY)
                        .blur(radius: 20)
                }

                // Brain outline (enhanced 7-layer)
                brainOutline(in: rect)

                // Sulci decorative lines (enhanced depth)
                sulciLines(in: rect)

                // Tappable region shapes
                ForEach(viewModel.currentHotspots.sorted(by: { $0.zIndex < $1.zIndex })) { hotspot in
                    regionShape(hotspot: hotspot, in: rect)
                }

                // Labels
                if viewModel.showLabels, let selectedID = viewModel.selectedID {
                    ForEach(viewModel.currentHotspots.filter({ $0.structureID == selectedID })) { hotspot in
                        structureLabel(hotspot: hotspot, in: rect)
                    }
                }
            }
        }
        .aspectRatio(1.3, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Brain Outline (Enhanced)

    @ViewBuilder
    private func brainOutline(in rect: CGRect) -> some View {
        let outlinePath = viewModel.currentView == .lateral
            ? BrainPathData.lateralOutline(in: rect)
            : BrainPathData.medialOutline(in: rect)
        let isDark = colorScheme == .dark

        if reduceMotion {
            // Simplified rendering for reduce motion
            outlinePath
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.97, green: 0.92, blue: 0.88),
                            Color(red: 0.91, green: 0.85, blue: 0.81)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            outlinePath
                .stroke(
                    Color(red: 0.28, green: 0.26, blue: 0.24).opacity(isDark ? 0.65 : 0.55),
                    lineWidth: 1.8
                )
        } else {
            BrainOutlineEnhanced.enhancedFill(outlinePath: outlinePath, rect: rect, isDark: isDark)
        }
    }

    // MARK: - Sulci Lines (Enhanced)

    @ViewBuilder
    private func sulciLines(in rect: CGRect) -> some View {
        let majorPath = viewModel.currentView == .lateral
            ? BrainPathData.lateralSulci(in: rect)
            : BrainPathData.medialSulci(in: rect)
        let minorPath = viewModel.currentView == .lateral
            ? BrainPathData.lateralSulciMinor(in: rect)
            : BrainPathData.medialSulciMinor(in: rect)
        let isDark = colorScheme == .dark

        if reduceMotion {
            // Simplified sulci for reduce motion
            majorPath
                .stroke(
                    Color(red: 0.40, green: 0.35, blue: 0.32).opacity(isDark ? 0.35 : 0.28),
                    style: StrokeStyle(lineWidth: 1.0, lineCap: .round, lineJoin: .round)
                )
            minorPath
                .stroke(
                    Color(red: 0.45, green: 0.40, blue: 0.38).opacity(isDark ? 0.20 : 0.15),
                    style: StrokeStyle(lineWidth: 0.7, lineCap: .round, lineJoin: .round)
                )
        } else {
            SulcusDepthEffect.deepSulcus(path: majorPath, isDark: isDark, isMajor: true)
            SulcusDepthEffect.deepSulcus(path: minorPath, isDark: isDark, isMajor: false)
        }
    }

    // MARK: - Region Shape (Enhanced)

    @ViewBuilder
    private func regionShape(hotspot: BrainHotspot, in rect: CGRect) -> some View {
        let isSelected = viewModel.selectedID == hotspot.structureID
        let isHighlighted = viewModel.highlightedIDs.contains(hotspot.structureID)
        let shapePath = hotspot.path(in: rect)
        let baseColor = viewModel.regionBaseColor(for: hotspot.structureID)
        let opacityPair = viewModel.regionOpacity(for: hotspot.structureID, isSelected: isSelected, isHighlighted: isHighlighted)
        let renderStyle = viewModel.renderingStyle(for: hotspot.structureID)

        ZStack {
            switch renderStyle {
            case .ventricle:
                // Transparent blue fill with dashed border
                shapePath
                    .fill(Color.blue.opacity(0.12))
                shapePath
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(0.18),
                                Color.blue.opacity(0.08)
                            ],
                            center: .init(x: 0.4, y: 0.35),
                            startRadius: 1,
                            endRadius: 120
                        )
                    )
                shapePath
                    .stroke(
                        Color.blue.opacity(0.35),
                        style: StrokeStyle(lineWidth: 1.2, dash: [4, 3])
                    )

            case .whiteMatter:
                // Lighter, more subtle fill
                shapePath
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.92, green: 0.92, blue: 0.95).opacity(opacityPair.top),
                                Color(red: 0.88, green: 0.88, blue: 0.92).opacity(opacityPair.bottom)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                if !reduceMotion {
                    GyrusShading.specularHighlight(path: shapePath)
                        .opacity(0.5)
                }
                shapePath
                    .stroke(
                        viewModel.strokeColor(for: hotspot, isSelected: isSelected).opacity(0.3),
                        lineWidth: viewModel.strokeWidth(for: hotspot, isSelected: isSelected)
                    )

            case .nerve:
                // Diamond/nerve rendering — golden with slight glow
                shapePath
                    .fill(Color(red: 0.95, green: 0.85, blue: 0.45).opacity(opacityPair.top))
                shapePath
                    .stroke(
                        Color(red: 0.80, green: 0.70, blue: 0.30).opacity(0.5),
                        lineWidth: 1.0
                    )

            case .standard:
                // 1 — Convex gradient (replaces flat LinearGradient)
                GyrusShading.convexGradient(
                    path: shapePath,
                    baseColor: baseColor,
                    centerBrightness: opacityPair.top,
                    edgeBrightness: opacityPair.bottom
                )

                // 2-4 — Enhanced effects (only when not reduceMotion)
                if !reduceMotion {
                    // Subsurface scatter edge glow
                    GyrusShading.subsurfaceScatter(path: shapePath, isDark: colorScheme == .dark)

                    // Inner shadow for edge depth
                    GyrusShading.innerShadow(path: shapePath, isDark: colorScheme == .dark)

                    // Specular highlight
                    GyrusShading.specularHighlight(path: shapePath)
                }

                // 5 — Border stroke
                shapePath
                    .stroke(
                        viewModel.strokeColor(for: hotspot, isSelected: isSelected).opacity(0.4),
                        lineWidth: viewModel.strokeWidth(for: hotspot, isSelected: isSelected)
                    )
            }

            // Highlighted glow (connected regions)
            if isHighlighted && !isSelected {
                shapePath
                    .fill(baseColor.opacity(0.15))

                shapePath
                    .stroke(baseColor.opacity(0.5), lineWidth: 1.5)
            }

            // Selected effects
            if isSelected {
                // Brighter fill boost
                shapePath
                    .fill(baseColor.opacity(0.12))

                // Bold selection ring
                shapePath
                    .stroke(
                        baseColor,
                        lineWidth: 2.5
                    )

                // Soft outer glow
                if !reduceMotion {
                    shapePath
                        .stroke(baseColor.opacity(0.4), lineWidth: 4)
                        .blur(radius: 4)
                }
            }
        }
        // No .drawingGroup() here: it was rasterizing each hotspot into its own
        // offscreen buffer, up to 34 of them per render, which is the opposite of what
        // drawingGroup is for (one buffer around many elements, not one buffer each).
        .contentShape(shapePath)
        .onTapGesture {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                if let handler = onRegionTapped {
                    handler(hotspot.structureID)
                } else {
                    viewModel.select(hotspot.structureID)
                }
            }
            Haptics.lightImpact()
        }
        #if os(macOS)
        .onHover { hovering in
            viewModel.hover(hotspot.structureID, isHovering: hovering)
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
        #endif
    }

    // MARK: - Structure Label

    @ViewBuilder
    private func structureLabel(hotspot: BrainHotspot, in rect: CGRect) -> some View {
        if let structure = BrainStructureStore.structure(byID: hotspot.structureID) {
            let anchor = CGPoint(
                x: hotspot.labelAnchor.x * rect.width,
                y: hotspot.labelAnchor.y * rect.height
            )

            Text(structure.name)
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background {
                    Capsule(style: .continuous)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                }
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(.white.opacity(0.3), lineWidth: 0.5)
                }
                .position(x: anchor.x, y: max(anchor.y - 25, 20))
                .transition(.scale.combined(with: .opacity))
        }
    }
}

// MARK: - View Toggle

struct BrainViewToggle: View {
    @Binding var currentView: DiagramView

    var body: some View {
        Picker("View", selection: $currentView) {
            Text("Lateral").tag(DiagramView.lateral)
            Text("Medial").tag(DiagramView.medial)
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 200)
    }
}
