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

                let hotspots = viewModel.currentHotspots.sorted(by: { $0.zIndex < $1.zIndex })

                // Region tints, as ONE layer: each shape is painted opaque, then the
                // group is faded together, so overlapping shapes no longer stack into
                // darker patches. A light blur softens the geometric edges into areas,
                // and the clip keeps colour inside the brain's silhouette. One blur
                // pass for the whole map, not an effect per shape.
                ZStack {
                    ForEach(hotspots.filter { viewModel.renderingStyle(for: $0.structureID) == .standard }) { hotspot in
                        regionTint(hotspot: hotspot, in: rect)
                    }
                }
                .compositingGroup()
                .opacity(viewModel.isQuizMode ? 0.22 : 0.30)
                .blur(radius: reduceMotion ? 0 : 2.5)
                .clipShape(outlinePath(in: rect))

                // Ventricles, white matter and the chiasm keep their own rendering.
                ForEach(hotspots.filter { viewModel.renderingStyle(for: $0.structureID) != .standard }) { hotspot in
                    regionShape(hotspot: hotspot, in: rect)
                }

                // Sulci go on top of the tints, not under them. Drawn first, the
                // regions' fills buried every fold and the brain read as a quilt of
                // coloured blobs; on top, the folds show through and it reads as a brain.
                sulciLines(in: rect)
                    .allowsHitTesting(false)

                // Selection and connection highlights sit above everything, crisp.
                ForEach(hotspots.filter { isEmphasized($0) }) { hotspot in
                    emphasis(hotspot: hotspot, in: rect)
                }
                .allowsHitTesting(false)

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

    // MARK: - Region Tint

    private func outlinePath(in rect: CGRect) -> Path {
        viewModel.currentView == .lateral
            ? BrainPathData.lateralOutline(in: rect)
            : BrainPathData.medialOutline(in: rect)
    }

    /// An opaque fill in the region's colour; the enclosing layer sets the opacity.
    private func regionTint(hotspot: BrainHotspot, in rect: CGRect) -> some View {
        let shapePath = hotspot.path(in: rect)
        return shapePath
            .fill(viewModel.regionBaseColor(for: hotspot.structureID))
            .modifier(RegionInteraction(hotspot: hotspot, path: shapePath, viewModel: viewModel, onRegionTapped: onRegionTapped))
    }

    private func isEmphasized(_ hotspot: BrainHotspot) -> Bool {
        hotspot.structureID == viewModel.selectedID
            || viewModel.highlightedIDs.contains(hotspot.structureID)
            || hotspot.structureID == viewModel.hoveredID
    }

    /// The selected region gets a stronger tint and a ring; connected regions a light
    /// tint and a thin outline.
    @ViewBuilder
    private func emphasis(hotspot: BrainHotspot, in rect: CGRect) -> some View {
        let shapePath = hotspot.path(in: rect)
        let color = viewModel.regionBaseColor(for: hotspot.structureID)
        if hotspot.structureID == viewModel.selectedID {
            ZStack {
                shapePath.fill(color.opacity(0.38))
                if !reduceMotion {
                    shapePath.stroke(color.opacity(0.4), lineWidth: 4).blur(radius: 4)
                }
                shapePath.stroke(color, lineWidth: 2.5)
            }
        } else if viewModel.highlightedIDs.contains(hotspot.structureID) {
            ZStack {
                shapePath.fill(color.opacity(0.16))
                shapePath.stroke(color.opacity(0.55), lineWidth: 1.2)
            }
        } else {
            shapePath.fill(color.opacity(0.14))
        }
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
                            Color(red: 0.96, green: 0.89, blue: 0.87),
                            Color(red: 0.88, green: 0.78, blue: 0.77)
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
                // A soft tint over the tissue. No per-region outline or specular spot
                // at rest: on 34 overlapping shapes those made the map look like
                // plastic patchwork rather than one organ.
                GyrusShading.convexGradient(
                    path: shapePath,
                    baseColor: baseColor,
                    centerBrightness: opacityPair.top,
                    edgeBrightness: opacityPair.bottom
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
        .modifier(RegionInteraction(hotspot: hotspot, path: shapePath, viewModel: viewModel, onRegionTapped: onRegionTapped))
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
                .font(.system(.caption, weight: .semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background {
                    Capsule(style: .continuous)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                }
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(.primary.opacity(0.12), lineWidth: 0.5)
                }
                .position(x: anchor.x, y: max(anchor.y - 25, 20))
                .transition(.scale.combined(with: .opacity))
        }
    }
}

// MARK: - Region Interaction

/// Tap, VoiceOver and hover behaviour shared by every region, whichever way it is drawn.
private struct RegionInteraction: ViewModifier {
    let hotspot: BrainHotspot
    let path: Path
    @Bindable var viewModel: BrainMapViewModel
    var onRegionTapped: ((String) -> Void)?

    func body(content: Content) -> some View {
        let isSelected = viewModel.selectedID == hotspot.structureID
        content
        .contentShape(path)
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
        // Every region is a VoiceOver button. Without this the whole atlas is a
        // single silent image and the app's core interaction is unusable non-visually.
        .accessibilityElement()
        .accessibilityLabel(BrainStructureStore.structure(byID: hotspot.structureID)?.name ?? hotspot.structureID)
        .accessibilityHint(viewModel.isQuizMode ? "Double tap to answer" : "Double tap to view details")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
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
