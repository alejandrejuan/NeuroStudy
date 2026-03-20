import SwiftUI

// MARK: - Lobe Colors

private enum LobeColors {
    static let frontal    = Color(red: 0.91, green: 0.70, blue: 0.62)   // warm salmon
    static let parietal   = Color(red: 0.88, green: 0.82, blue: 0.58)   // warm cream
    static let temporal   = Color(red: 0.62, green: 0.78, blue: 0.72)   // sage green
    static let occipital  = Color(red: 0.60, green: 0.70, blue: 0.85)   // slate blue
    static let cerebellum = Color(red: 0.84, green: 0.76, blue: 0.65)   // sandy tan
    static let brainstem  = Color(red: 0.72, green: 0.62, blue: 0.70)   // muted mauve
    static let sulcal     = Color(red: 0.38, green: 0.30, blue: 0.28)   // dark warm brown
    static let outline    = Color(red: 0.30, green: 0.23, blue: 0.22)   // darker outline
}

// MARK: - Region → Lobe Mapping

private extension BrainRegion {
    /// Maps any BrainRegion to its closest visible lobe on a 2D lateral view.
    var lateralLobe: BrainRegion {
        switch self {
        case .frontalLobe:   return .frontalLobe
        case .parietalLobe:  return .parietalLobe
        case .temporalLobe:  return .temporalLobe
        case .occipitalLobe: return .occipitalLobe
        case .cerebellum:    return .cerebellum
        case .brainstem:     return .brainstem
        case .limbicSystem:  return .temporalLobe   // hippocampus/amygdala sit in temporal area
        case .basalGanglia:  return .frontalLobe    // deep to frontal cortex
        case .diencephalon:  return .parietalLobe   // thalamus is central/parietal
        case .whiteTracts:   return .frontalLobe    // corpus callosum approximates frontal
        }
    }
}

// MARK: - Brain Paths

/// All path coordinates are defined in a 440×380 reference space
/// and scaled to the actual view size via sx/sy multipliers.
private enum BrainPaths {

    // MARK: Lobe Regions

    static func outerBrain(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            p.move(to: q(80, 195))
            p.addCurve(to: q(82, 98),   control1: q(76, 168), control2: q(77, 130))
            p.addCurve(to: q(118, 32),  control1: q(88, 72),  control2: q(98, 50))
            p.addCurve(to: q(198, 10),  control1: q(138, 18), control2: q(168, 10))
            p.addCurve(to: q(260, 18),  control1: q(222, 10), control2: q(245, 12))
            p.addCurve(to: q(332, 38),  control1: q(278, 12), control2: q(308, 14))
            p.addCurve(to: q(402, 118), control1: q(352, 52), control2: q(378, 80))
            p.addCurve(to: q(415, 205), control1: q(420, 148), control2: q(422, 180))
            p.addCurve(to: q(370, 278), control1: q(408, 230), control2: q(392, 260))
            p.addCurve(to: q(300, 308), control1: q(350, 295), control2: q(325, 305))
            p.addCurve(to: q(235, 308), control1: q(275, 311), control2: q(255, 312))
            p.addCurve(to: q(178, 278), control1: q(212, 302), control2: q(192, 292))
            p.addCurve(to: q(110, 242), control1: q(158, 260), control2: q(132, 250))
            p.addCurve(to: q(80, 218),  control1: q(92, 235), control2: q(82, 226))
            p.addCurve(to: q(80, 195),  control1: q(73, 205), control2: q(73, 200))
            p.closeSubpath()
        }
    }

    static func frontalLobe(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            p.move(to: q(260, 18))
            p.addCurve(to: q(198, 10),  control1: q(242, 12), control2: q(222, 10))
            p.addCurve(to: q(118, 32),  control1: q(168, 10), control2: q(138, 18))
            p.addCurve(to: q(82, 98),   control1: q(98, 50),  control2: q(88, 72))
            p.addCurve(to: q(80, 195),  control1: q(77, 130), control2: q(76, 168))
            p.addCurve(to: q(88, 225),  control1: q(74, 210), control2: q(79, 218))
            p.addCurve(to: q(175, 197), control1: q(110, 215), control2: q(140, 205))
            p.addCurve(to: q(252, 192), control1: q(210, 192), control2: q(235, 190))
            p.addCurve(to: q(260, 18),  control1: q(254, 108), control2: q(256, 58))
            p.closeSubpath()
        }
    }

    static func parietalLobe(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            p.move(to: q(260, 18))
            p.addCurve(to: q(332, 38),  control1: q(278, 12), control2: q(308, 14))
            p.addCurve(to: q(352, 158), control1: q(340, 72), control2: q(348, 115))
            p.addCurve(to: q(354, 182), control1: q(354, 170), control2: q(355, 175))
            p.addCurve(to: q(315, 190), control1: q(342, 188), control2: q(330, 190))
            p.addCurve(to: q(252, 192), control1: q(298, 192), control2: q(272, 194))
            p.addCurve(to: q(260, 18),  control1: q(254, 108), control2: q(256, 58))
            p.closeSubpath()
        }
    }

    static func temporalLobe(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            p.move(to: q(88, 225))
            p.addCurve(to: q(78, 270),  control1: q(82, 238), control2: q(76, 255))
            p.addCurve(to: q(110, 305), control1: q(80, 285), control2: q(92, 298))
            p.addCurve(to: q(195, 312), control1: q(132, 312), control2: q(162, 315))
            p.addCurve(to: q(260, 308), control1: q(222, 312), control2: q(242, 310))
            p.addCurve(to: q(318, 275), control1: q(290, 302), control2: q(312, 290))
            p.addCurve(to: q(315, 190), control1: q(325, 252), control2: q(322, 218))
            p.addCurve(to: q(252, 192), control1: q(298, 192), control2: q(272, 194))
            p.addCurve(to: q(175, 197), control1: q(235, 190), control2: q(210, 192))
            p.addCurve(to: q(88, 225),  control1: q(140, 205), control2: q(110, 215))
            p.closeSubpath()
        }
    }

    static func occipitalLobe(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            p.move(to: q(332, 38))
            p.addCurve(to: q(402, 118), control1: q(352, 52), control2: q(378, 80))
            p.addCurve(to: q(415, 205), control1: q(420, 148), control2: q(422, 180))
            p.addCurve(to: q(370, 278), control1: q(408, 230), control2: q(392, 260))
            p.addCurve(to: q(318, 300), control1: q(350, 295), control2: q(332, 302))
            p.addCurve(to: q(315, 190), control1: q(322, 258), control2: q(320, 228))
            p.addCurve(to: q(354, 182), control1: q(328, 192), control2: q(342, 188))
            p.addCurve(to: q(352, 70),  control1: q(355, 155), control2: q(354, 118))
            p.addCurve(to: q(332, 38),  control1: q(350, 52), control2: q(342, 44))
            p.closeSubpath()
        }
    }

    static func cerebellum(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            p.move(to: q(268, 308))
            p.addCurve(to: q(260, 335), control1: q(260, 315), control2: q(258, 325))
            p.addCurve(to: q(295, 360), control1: q(262, 348), control2: q(276, 358))
            p.addCurve(to: q(362, 364), control1: q(318, 366), control2: q(340, 368))
            p.addCurve(to: q(412, 335), control1: q(385, 360), control2: q(402, 348))
            p.addCurve(to: q(410, 298), control1: q(418, 322), control2: q(416, 308))
            p.addCurve(to: q(362, 288), control1: q(400, 290), control2: q(382, 286))
            p.addCurve(to: q(310, 295), control1: q(340, 290), control2: q(322, 292))
            p.addCurve(to: q(268, 308), control1: q(295, 300), control2: q(280, 305))
            p.closeSubpath()
        }
    }

    static func brainstem(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            p.move(to: q(172, 268))
            p.addCurve(to: q(192, 255), control1: q(172, 260), control2: q(180, 255))
            p.addCurve(to: q(213, 268), control1: q(204, 255), control2: q(212, 260))
            p.addCurve(to: q(215, 308), control1: q(215, 282), control2: q(215, 295))
            p.addCurve(to: q(202, 338), control1: q(214, 325), control2: q(209, 333))
            p.addCurve(to: q(182, 338), control1: q(196, 343), control2: q(188, 343))
            p.addCurve(to: q(172, 308), control1: q(174, 332), control2: q(172, 322))
            p.addCurve(to: q(172, 268), control1: q(172, 295), control2: q(172, 280))
            p.closeSubpath()
        }
    }

    // MARK: Sulci (strokes only)

    static func centralSulcus(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            p.move(to: q(260, 18))
            p.addCurve(to: q(250, 155), control1: q(256, 58),  control2: q(252, 108))
            p.addCurve(to: q(252, 192), control1: q(250, 172), control2: q(250, 183))
        }
    }

    static func sylvianFissure(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            p.move(to: q(88, 225))
            p.addCurve(to: q(175, 197), control1: q(110, 215), control2: q(140, 205))
            p.addCurve(to: q(252, 192), control1: q(210, 192), control2: q(235, 190))
            p.addCurve(to: q(315, 190), control1: q(272, 194), control2: q(298, 192))
        }
    }

    static func parietoOccipitalSulcus(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            p.move(to: q(332, 38))
            p.addCurve(to: q(352, 158), control1: q(340, 72),  control2: q(348, 115))
            p.addCurve(to: q(354, 183), control1: q(354, 168), control2: q(355, 176))
        }
    }

    static func secondarySulci(sx: CGFloat, sy: CGFloat) -> Path {
        Path { p in
            func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            // Superior frontal sulcus
            p.move(to: q(215, 15))
            p.addCurve(to: q(220, 148), control1: q(215, 60),  control2: q(218, 108))
            p.addCurve(to: q(232, 190), control1: q(220, 170), control2: q(225, 182))
            // Precentral sulcus
            p.move(to: q(244, 18))
            p.addCurve(to: q(244, 155), control1: q(244, 60),  control2: q(244, 110))
            p.addCurve(to: q(248, 192), control1: q(244, 170), control2: q(245, 182))
            // Postcentral sulcus (parietal)
            p.move(to: q(272, 20))
            p.addCurve(to: q(272, 152), control1: q(270, 65),  control2: q(272, 108))
            p.addCurve(to: q(274, 185), control1: q(272, 168), control2: q(273, 178))
            // Intraparietal sulcus
            p.move(to: q(290, 22))
            p.addCurve(to: q(308, 125), control1: q(298, 55),  control2: q(305, 90))
            p.addCurve(to: q(312, 182), control1: q(310, 150), control2: q(312, 168))
            // Superior temporal sulcus
            p.move(to: q(95, 233))
            p.addCurve(to: q(185, 218), control1: q(125, 228), control2: q(155, 222))
            p.addCurve(to: q(265, 213), control1: q(215, 216), control2: q(242, 214))
            p.addCurve(to: q(312, 212), control1: q(285, 212), control2: q(300, 212))
            // Inferior temporal sulcus
            p.move(to: q(108, 252))
            p.addCurve(to: q(198, 240), control1: q(140, 248), control2: q(170, 244))
            p.addCurve(to: q(272, 238), control1: q(225, 238), control2: q(250, 238))
        }
    }

    // MARK: Cerebellar foliation

    static func cerebellumFoliation(sx: CGFloat, sy: CGFloat) -> [Path] {
        let foliationY: [CGFloat] = [310, 318, 328, 338, 348, 356]
        return foliationY.compactMap { y in
            let t = (y - 308) / 50.0   // 0..1 from top to bottom of cerebellum
            let inset = 10.0 + t * 15.0
            let leftX  = 268.0 + inset
            let rightX = 412.0 - inset
            guard leftX < rightX else { return nil }
            return Path { p in
                func q(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
                let midX = (leftX + rightX) / 2
                p.move(to: q(leftX, y))
                p.addQuadCurve(to: q(rightX, y), control: q(midX, y + 7))
            }
        }
    }

    // MARK: Region helpers

    /// Maps a tapped BrainRegion to its 2D-visible lobe
    static func lateralLobe(for region: BrainRegion) -> BrainRegion { region.lateralLobe }

    /// Returns the first structureID for a given visible lobe region
    static func representativeStructure(for region: BrainRegion) -> String {
        let lobe = lateralLobe(for: region)
        return BrainStructureStore.all.first { $0.region == lobe }?.id
            ?? BrainStructureStore.all.first?.id
            ?? ""
    }

    /// Returns the path for a given BrainRegion's visible lobe
    static func path(for region: BrainRegion, sx: CGFloat, sy: CGFloat) -> Path {
        switch region.lateralLobe {
        case .frontalLobe:   return frontalLobe(sx: sx, sy: sy)
        case .parietalLobe:  return parietalLobe(sx: sx, sy: sy)
        case .temporalLobe:  return temporalLobe(sx: sx, sy: sy)
        case .occipitalLobe: return occipitalLobe(sx: sx, sy: sy)
        case .cerebellum:    return cerebellum(sx: sx, sy: sy)
        case .brainstem:     return brainstem(sx: sx, sy: sy)
        default:             return frontalLobe(sx: sx, sy: sy)
        }
    }
}

// MARK: - Brain Illustration View

/// High-quality 2D anatomical brain atlas — left lateral view.
/// Uses SwiftUI Canvas for crisp, resolution-independent rendering.
/// Compatible with Brain3DViewModel for seamless drop-in replacement.
struct BrainIllustrationView: View {
    @Bindable var viewModel: Brain3DViewModel
    var onStructureTapped: ((String) -> Void)?

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        GeometryReader { geo in
            let sz = geo.size
            ZStack {
                BrainIllustrationCanvas(viewModel: viewModel, colorScheme: colorScheme)

                if !viewModel.isQuizMode {
                    lobeLabels(in: sz)
                }

                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        handleTap(at: location, in: sz)
                    }
            }
        }
        .aspectRatio(440.0 / 380.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.12 : 0.40),
                            .white.opacity(0.04)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        }
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.45 : 0.18), radius: 24, y: 10)
    }

    // MARK: - Tap Handling

    private func handleTap(at location: CGPoint, in size: CGSize) {
        let sx = size.width  / 440.0
        let sy = size.height / 380.0

        // Check small structures first so they don't get masked by larger lobes
        let tappedRegion: BrainRegion?
        if BrainPaths.brainstem(sx: sx, sy: sy).contains(location) {
            tappedRegion = .brainstem
        } else if BrainPaths.cerebellum(sx: sx, sy: sy).contains(location) {
            tappedRegion = .cerebellum
        } else if BrainPaths.occipitalLobe(sx: sx, sy: sy).contains(location) {
            tappedRegion = .occipitalLobe
        } else if BrainPaths.temporalLobe(sx: sx, sy: sy).contains(location) {
            tappedRegion = .temporalLobe
        } else if BrainPaths.parietalLobe(sx: sx, sy: sy).contains(location) {
            tappedRegion = .parietalLobe
        } else if BrainPaths.frontalLobe(sx: sx, sy: sy).contains(location) {
            tappedRegion = .frontalLobe
        } else {
            tappedRegion = nil
        }

        guard let region = tappedRegion else { return }
        fireCallback(for: region)
    }

    private func fireCallback(for region: BrainRegion) {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif

        if let handler = onStructureTapped {
            if viewModel.isQuizMode,
               let targetID = viewModel.quizTargetID,
               let targetStructure = BrainStructureStore.structure(byID: targetID) {
                // Quiz mode: check if the tapped lobe contains the target structure
                let targetLobe = BrainPaths.lateralLobe(for: targetStructure.region)
                if targetLobe == region {
                    handler(targetID)       // correct lobe → correct answer
                } else {
                    handler("wrong-lobe")   // wrong lobe
                }
            } else {
                let structureID = BrainPaths.representativeStructure(for: region)
                handler(structureID)
            }
        } else {
            let structureID = BrainPaths.representativeStructure(for: region)
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                viewModel.select(structureID)
            }
        }
    }

    // MARK: - Lobe Labels

    private func lobeLabels(in size: CGSize) -> some View {
        let sx = size.width  / 440.0
        let sy = size.height / 380.0
        return ZStack {
            lobeLabel("Frontal",   pos: CGPoint(x: 148 * sx, y: 112 * sy), color: LobeColors.frontal)
            lobeLabel("Parietal",  pos: CGPoint(x: 295 * sx, y: 82  * sy), color: LobeColors.parietal)
            lobeLabel("Temporal",  pos: CGPoint(x: 182 * sx, y: 252 * sy), color: LobeColors.temporal)
            lobeLabel("Occipital", pos: CGPoint(x: 372 * sx, y: 155 * sy), color: LobeColors.occipital)
            lobeLabel("Cereb.",    pos: CGPoint(x: 338 * sx, y: 328 * sy), color: LobeColors.cerebellum)
            lobeLabel("Stem",      pos: CGPoint(x: 192 * sx, y: 298 * sy), color: LobeColors.brainstem)
        }
    }

    private func lobeLabel(_ text: String, pos: CGPoint, color: Color) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .foregroundStyle(color.opacity(0.88))
            .shadow(color: .black.opacity(0.18), radius: 2, x: 0, y: 1)
            .position(pos)
    }
}

// MARK: - Canvas Drawing

private struct BrainIllustrationCanvas: View {
    @Bindable var viewModel: Brain3DViewModel
    let colorScheme: ColorScheme

    var body: some View {
        Canvas { ctx, size in
            let sx = size.width  / 440.0
            let sy = size.height / 380.0

            let brain          = BrainPaths.outerBrain(sx: sx, sy: sy)
            let frontal        = BrainPaths.frontalLobe(sx: sx, sy: sy)
            let parietal       = BrainPaths.parietalLobe(sx: sx, sy: sy)
            let temporal       = BrainPaths.temporalLobe(sx: sx, sy: sy)
            let occipital      = BrainPaths.occipitalLobe(sx: sx, sy: sy)
            let cerebell       = BrainPaths.cerebellum(sx: sx, sy: sy)
            let bstem          = BrainPaths.brainstem(sx: sx, sy: sy)
            let central        = BrainPaths.centralSulcus(sx: sx, sy: sy)
            let sylvian        = BrainPaths.sylvianFissure(sx: sx, sy: sy)
            let parOcc         = BrainPaths.parietoOccipitalSulcus(sx: sx, sy: sy)
            let secondary      = BrainPaths.secondarySulci(sx: sx, sy: sy)
            let foliations     = BrainPaths.cerebellumFoliation(sx: sx, sy: sy)
            let sulcalStyle    = StrokeStyle(lineWidth: 2.0 * sx, lineCap: .round, lineJoin: .round)
            let secondaryStyle = StrokeStyle(lineWidth: 1.0 * sx, lineCap: .round, lineJoin: .round)
            let outlineStyle   = StrokeStyle(lineWidth: 1.5 * sx, lineCap: .round, lineJoin: .round)

            // Determine selected lobe for highlighting
            let selectedLobe: BrainRegion? = {
                guard let id = viewModel.selectedID,
                      let s = BrainStructureStore.structure(byID: id) else { return nil }
                return s.region.lateralLobe
            }()

            // ── 1. Cerebellum & Brainstem (drawn behind cortex) ──────────────────
            ctx.fill(cerebell, with: .color(LobeColors.cerebellum.opacity(0.92)))
            ctx.fill(bstem,    with: .color(LobeColors.brainstem.opacity(0.92)))

            // Slight gap shadow between cerebellum and cortex
            ctx.stroke(cerebell, with: .color(LobeColors.sulcal.opacity(0.18)),
                       style: StrokeStyle(lineWidth: 3.0 * sx))

            // ── 2. Cortical lobes (clipped to outer brain shape) ─────────────────
            ctx.drawLayer { layerCtx in
                layerCtx.clip(to: brain)
                layerCtx.fill(frontal,   with: .color(LobeColors.frontal.opacity(0.92)))
                layerCtx.fill(parietal,  with: .color(LobeColors.parietal.opacity(0.92)))
                layerCtx.fill(temporal,  with: .color(LobeColors.temporal.opacity(0.92)))
                layerCtx.fill(occipital, with: .color(LobeColors.occipital.opacity(0.92)))
            }

            // ── 3. Selection highlight ────────────────────────────────────────────
            if let lobe = selectedLobe {
                let highlightPath = BrainPaths.path(for: lobe, sx: sx, sy: sy)
                ctx.drawLayer { layerCtx in
                    // Clip cortical lobes highlight to brain outline
                    if lobe != .cerebellum && lobe != .brainstem {
                        layerCtx.clip(to: brain)
                    }
                    layerCtx.fill(highlightPath, with: .color(Color.white.opacity(0.30)))
                }
                // Colored border on selected lobe
                let lobeColor: Color = {
                    switch lobe {
                    case .frontalLobe:   return LobeColors.frontal
                    case .parietalLobe:  return LobeColors.parietal
                    case .temporalLobe:  return LobeColors.temporal
                    case .occipitalLobe: return LobeColors.occipital
                    case .cerebellum:    return LobeColors.cerebellum
                    default:             return LobeColors.brainstem
                    }
                }()
                ctx.stroke(highlightPath, with: .color(lobeColor),
                           style: StrokeStyle(lineWidth: 2.5 * sx, lineCap: .round, lineJoin: .round))
            }

            // ── 4. Secondary (fine) sulci ─────────────────────────────────────────
            ctx.drawLayer { layerCtx in
                layerCtx.clip(to: brain)
                layerCtx.stroke(secondary, with: .color(LobeColors.sulcal.opacity(0.30)),
                                style: secondaryStyle)
            }

            // ── 5. Primary sulci ──────────────────────────────────────────────────
            ctx.drawLayer { layerCtx in
                layerCtx.clip(to: brain)
                layerCtx.stroke(central, with: .color(LobeColors.sulcal.opacity(0.72)), style: sulcalStyle)
                layerCtx.stroke(sylvian, with: .color(LobeColors.sulcal.opacity(0.72)), style: sulcalStyle)
                layerCtx.stroke(parOcc,  with: .color(LobeColors.sulcal.opacity(0.72)), style: sulcalStyle)
            }

            // ── 6. Cerebellar foliation ────────────────────────────────────────────
            ctx.drawLayer { layerCtx in
                layerCtx.clip(to: cerebell)
                for fol in foliations {
                    layerCtx.stroke(fol, with: .color(LobeColors.sulcal.opacity(0.38)),
                                    style: StrokeStyle(lineWidth: 0.8 * sx, lineCap: .round))
                }
            }

            // ── 7. Outlines ────────────────────────────────────────────────────────
            ctx.stroke(brain,    with: .color(LobeColors.outline.opacity(0.75)), style: outlineStyle)
            ctx.stroke(cerebell, with: .color(LobeColors.outline.opacity(0.65)), style: outlineStyle)
            ctx.stroke(bstem,    with: .color(LobeColors.outline.opacity(0.65)), style: outlineStyle)

            // ── 8. Lighting overlay (depth illusion) ───────────────────────────────
            ctx.drawLayer { layerCtx in
                layerCtx.clip(to: brain)
                let lightGrad = Gradient(stops: [
                    .init(color: .white.opacity(colorScheme == .dark ? 0.14 : 0.24), location: 0.0),
                    .init(color: .white.opacity(0.06),  location: 0.35),
                    .init(color: .clear,                location: 0.60),
                    .init(color: .black.opacity(0.10),  location: 1.00)
                ])
                let center = CGPoint(x: size.width * 0.28, y: size.height * 0.12)
                let shading = GraphicsContext.Shading.radialGradient(
                    lightGrad,
                    center: center,
                    startRadius: 0,
                    endRadius: max(size.width, size.height) * 0.72
                )
                layerCtx.fill(brain, with: shading)
            }
            // Also apply to cerebellum + brainstem
            ctx.drawLayer { layerCtx in
                let combined = cerebell.union(bstem)
                layerCtx.clip(to: combined)
                let lightGrad2 = Gradient(stops: [
                    .init(color: .white.opacity(colorScheme == .dark ? 0.10 : 0.18), location: 0.0),
                    .init(color: .clear,               location: 0.55),
                    .init(color: .black.opacity(0.08), location: 1.00)
                ])
                let shading2 = GraphicsContext.Shading.radialGradient(
                    lightGrad2,
                    center: CGPoint(x: size.width * 0.72, y: size.height * 0.72),
                    startRadius: 0,
                    endRadius: size.width * 0.42
                )
                layerCtx.fill(combined, with: shading2)
            }
        }
    }
}
