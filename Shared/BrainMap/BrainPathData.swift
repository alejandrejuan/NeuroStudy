import SwiftUI

// All paths are authored in normalized 0...1 coordinate space
// and scaled to the given rect at render time.
// Lateral view: brain facing left, anterior (front) on left side
// Medial view: sagittal cut, anterior on left side
//
// Redesigned for anatomically realistic proportions with visible
// gyri/sulci detail matching standard neuroanatomy references.

struct BrainPathData {
    static func path(for structureID: String, view: DiagramView, in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        switch (structureID, view) {

        // ============================================================
        // MARK: - LATERAL VIEW PATHS
        // ============================================================

        // MARK: Prefrontal Cortex (anterior frontal lobe)
        case ("prefrontal-cortex", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.07 * w, y: 0.50 * h))
            p.addCurve(to: CGPoint(x: 0.06 * w, y: 0.38 * h),
                       control1: CGPoint(x: 0.05 * w, y: 0.47 * h),
                       control2: CGPoint(x: 0.04 * w, y: 0.42 * h))
            p.addCurve(to: CGPoint(x: 0.10 * w, y: 0.26 * h),
                       control1: CGPoint(x: 0.07 * w, y: 0.33 * h),
                       control2: CGPoint(x: 0.08 * w, y: 0.29 * h))
            p.addCurve(to: CGPoint(x: 0.17 * w, y: 0.16 * h),
                       control1: CGPoint(x: 0.12 * w, y: 0.22 * h),
                       control2: CGPoint(x: 0.14 * w, y: 0.18 * h))
            p.addCurve(to: CGPoint(x: 0.24 * w, y: 0.12 * h),
                       control1: CGPoint(x: 0.19 * w, y: 0.14 * h),
                       control2: CGPoint(x: 0.21 * w, y: 0.12 * h))
            p.addLine(to: CGPoint(x: 0.28 * w, y: 0.11 * h))
            p.addCurve(to: CGPoint(x: 0.27 * w, y: 0.24 * h),
                       control1: CGPoint(x: 0.29 * w, y: 0.16 * h),
                       control2: CGPoint(x: 0.28 * w, y: 0.20 * h))
            p.addCurve(to: CGPoint(x: 0.28 * w, y: 0.35 * h),
                       control1: CGPoint(x: 0.26 * w, y: 0.28 * h),
                       control2: CGPoint(x: 0.27 * w, y: 0.32 * h))
            p.addCurve(to: CGPoint(x: 0.26 * w, y: 0.44 * h),
                       control1: CGPoint(x: 0.29 * w, y: 0.39 * h),
                       control2: CGPoint(x: 0.28 * w, y: 0.42 * h))
            p.addCurve(to: CGPoint(x: 0.18 * w, y: 0.52 * h),
                       control1: CGPoint(x: 0.23 * w, y: 0.47 * h),
                       control2: CGPoint(x: 0.20 * w, y: 0.50 * h))
            p.addCurve(to: CGPoint(x: 0.07 * w, y: 0.50 * h),
                       control1: CGPoint(x: 0.14 * w, y: 0.55 * h),
                       control2: CGPoint(x: 0.09 * w, y: 0.53 * h))
            p.closeSubpath()
            return p

        // MARK: Primary Motor Cortex (precentral gyrus strip)
        case ("primary-motor-cortex", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.36 * w, y: 0.08 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.07 * h),
                       control1: CGPoint(x: 0.38 * w, y: 0.07 * h),
                       control2: CGPoint(x: 0.40 * w, y: 0.07 * h))
            p.addCurve(to: CGPoint(x: 0.41 * w, y: 0.20 * h),
                       control1: CGPoint(x: 0.43 * w, y: 0.12 * h),
                       control2: CGPoint(x: 0.42 * w, y: 0.16 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.32 * h),
                       control1: CGPoint(x: 0.40 * w, y: 0.24 * h),
                       control2: CGPoint(x: 0.41 * w, y: 0.28 * h))
            p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.42 * h),
                       control1: CGPoint(x: 0.43 * w, y: 0.36 * h),
                       control2: CGPoint(x: 0.42 * w, y: 0.40 * h))
            p.addCurve(to: CGPoint(x: 0.36 * w, y: 0.44 * h),
                       control1: CGPoint(x: 0.39 * w, y: 0.43 * h),
                       control2: CGPoint(x: 0.37 * w, y: 0.44 * h))
            p.addCurve(to: CGPoint(x: 0.35 * w, y: 0.32 * h),
                       control1: CGPoint(x: 0.37 * w, y: 0.40 * h),
                       control2: CGPoint(x: 0.36 * w, y: 0.36 * h))
            p.addCurve(to: CGPoint(x: 0.36 * w, y: 0.20 * h),
                       control1: CGPoint(x: 0.34 * w, y: 0.28 * h),
                       control2: CGPoint(x: 0.35 * w, y: 0.24 * h))
            p.addCurve(to: CGPoint(x: 0.36 * w, y: 0.08 * h),
                       control1: CGPoint(x: 0.37 * w, y: 0.16 * h),
                       control2: CGPoint(x: 0.37 * w, y: 0.12 * h))
            p.closeSubpath()
            return p

        // MARK: Premotor Cortex
        case ("premotor-cortex", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.28 * w, y: 0.11 * h))
            p.addCurve(to: CGPoint(x: 0.36 * w, y: 0.08 * h),
                       control1: CGPoint(x: 0.31 * w, y: 0.09 * h),
                       control2: CGPoint(x: 0.34 * w, y: 0.08 * h))
            p.addCurve(to: CGPoint(x: 0.35 * w, y: 0.20 * h),
                       control1: CGPoint(x: 0.37 * w, y: 0.12 * h),
                       control2: CGPoint(x: 0.37 * w, y: 0.16 * h))
            p.addCurve(to: CGPoint(x: 0.36 * w, y: 0.32 * h),
                       control1: CGPoint(x: 0.34 * w, y: 0.24 * h),
                       control2: CGPoint(x: 0.35 * w, y: 0.28 * h))
            p.addCurve(to: CGPoint(x: 0.36 * w, y: 0.44 * h),
                       control1: CGPoint(x: 0.37 * w, y: 0.36 * h),
                       control2: CGPoint(x: 0.37 * w, y: 0.40 * h))
            p.addCurve(to: CGPoint(x: 0.28 * w, y: 0.35 * h),
                       control1: CGPoint(x: 0.33 * w, y: 0.42 * h),
                       control2: CGPoint(x: 0.29 * w, y: 0.39 * h))
            p.addCurve(to: CGPoint(x: 0.27 * w, y: 0.24 * h),
                       control1: CGPoint(x: 0.27 * w, y: 0.32 * h),
                       control2: CGPoint(x: 0.26 * w, y: 0.28 * h))
            p.addCurve(to: CGPoint(x: 0.28 * w, y: 0.11 * h),
                       control1: CGPoint(x: 0.28 * w, y: 0.20 * h),
                       control2: CGPoint(x: 0.29 * w, y: 0.16 * h))
            p.closeSubpath()
            return p

        // MARK: Broca's Area
        case ("brocas-area", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.18 * w, y: 0.52 * h))
            p.addCurve(to: CGPoint(x: 0.26 * w, y: 0.44 * h),
                       control1: CGPoint(x: 0.20 * w, y: 0.50 * h),
                       control2: CGPoint(x: 0.23 * w, y: 0.47 * h))
            p.addLine(to: CGPoint(x: 0.34 * w, y: 0.44 * h))
            p.addCurve(to: CGPoint(x: 0.33 * w, y: 0.52 * h),
                       control1: CGPoint(x: 0.34 * w, y: 0.47 * h),
                       control2: CGPoint(x: 0.34 * w, y: 0.50 * h))
            p.addCurve(to: CGPoint(x: 0.26 * w, y: 0.58 * h),
                       control1: CGPoint(x: 0.31 * w, y: 0.55 * h),
                       control2: CGPoint(x: 0.28 * w, y: 0.57 * h))
            p.addCurve(to: CGPoint(x: 0.18 * w, y: 0.52 * h),
                       control1: CGPoint(x: 0.22 * w, y: 0.59 * h),
                       control2: CGPoint(x: 0.18 * w, y: 0.56 * h))
            p.closeSubpath()
            return p

        // MARK: Frontal Eye Fields
        case ("frontal-eye-fields", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.26 * w, y: 0.16 * h))
            p.addCurve(to: CGPoint(x: 0.33 * w, y: 0.14 * h),
                       control1: CGPoint(x: 0.28 * w, y: 0.14 * h),
                       control2: CGPoint(x: 0.31 * w, y: 0.13 * h))
            p.addLine(to: CGPoint(x: 0.33 * w, y: 0.26 * h))
            p.addCurve(to: CGPoint(x: 0.26 * w, y: 0.28 * h),
                       control1: CGPoint(x: 0.31 * w, y: 0.27 * h),
                       control2: CGPoint(x: 0.28 * w, y: 0.28 * h))
            p.closeSubpath()
            return p

        // MARK: Primary Somatosensory Cortex
        case ("primary-somatosensory-cortex", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.42 * w, y: 0.07 * h))
            p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.07 * h),
                       control1: CGPoint(x: 0.44 * w, y: 0.06 * h),
                       control2: CGPoint(x: 0.46 * w, y: 0.06 * h))
            p.addCurve(to: CGPoint(x: 0.47 * w, y: 0.20 * h),
                       control1: CGPoint(x: 0.49 * w, y: 0.12 * h),
                       control2: CGPoint(x: 0.48 * w, y: 0.16 * h))
            p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.32 * h),
                       control1: CGPoint(x: 0.46 * w, y: 0.24 * h),
                       control2: CGPoint(x: 0.47 * w, y: 0.28 * h))
            p.addCurve(to: CGPoint(x: 0.46 * w, y: 0.40 * h),
                       control1: CGPoint(x: 0.49 * w, y: 0.36 * h),
                       control2: CGPoint(x: 0.48 * w, y: 0.38 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.32 * h),
                       control1: CGPoint(x: 0.44 * w, y: 0.38 * h),
                       control2: CGPoint(x: 0.43 * w, y: 0.36 * h))
            p.addCurve(to: CGPoint(x: 0.41 * w, y: 0.20 * h),
                       control1: CGPoint(x: 0.41 * w, y: 0.28 * h),
                       control2: CGPoint(x: 0.40 * w, y: 0.24 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.07 * h),
                       control1: CGPoint(x: 0.42 * w, y: 0.16 * h),
                       control2: CGPoint(x: 0.43 * w, y: 0.12 * h))
            p.closeSubpath()
            return p

        // MARK: Superior Parietal Lobule
        case ("parietal-superior", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.48 * w, y: 0.07 * h))
            p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.07 * h),
                       control1: CGPoint(x: 0.52 * w, y: 0.05 * h),
                       control2: CGPoint(x: 0.55 * w, y: 0.05 * h))
            p.addCurve(to: CGPoint(x: 0.66 * w, y: 0.12 * h),
                       control1: CGPoint(x: 0.61 * w, y: 0.08 * h),
                       control2: CGPoint(x: 0.64 * w, y: 0.10 * h))
            p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.26 * h),
                       control1: CGPoint(x: 0.65 * w, y: 0.17 * h),
                       control2: CGPoint(x: 0.63 * w, y: 0.22 * h))
            p.addLine(to: CGPoint(x: 0.48 * w, y: 0.26 * h))
            p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.07 * h),
                       control1: CGPoint(x: 0.47 * w, y: 0.20 * h),
                       control2: CGPoint(x: 0.47 * w, y: 0.13 * h))
            p.closeSubpath()
            return p

        // MARK: Inferior Parietal Lobule
        case ("parietal-inferior", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.48 * w, y: 0.26 * h))
            p.addLine(to: CGPoint(x: 0.60 * w, y: 0.26 * h))
            p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.40 * h),
                       control1: CGPoint(x: 0.61 * w, y: 0.31 * h),
                       control2: CGPoint(x: 0.60 * w, y: 0.36 * h))
            p.addCurve(to: CGPoint(x: 0.46 * w, y: 0.40 * h),
                       control1: CGPoint(x: 0.54 * w, y: 0.41 * h),
                       control2: CGPoint(x: 0.50 * w, y: 0.41 * h))
            p.closeSubpath()
            return p

        // MARK: Angular Gyrus
        case ("angular-gyrus", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.60 * w, y: 0.26 * h))
            p.addCurve(to: CGPoint(x: 0.66 * w, y: 0.12 * h),
                       control1: CGPoint(x: 0.63 * w, y: 0.22 * h),
                       control2: CGPoint(x: 0.65 * w, y: 0.17 * h))
            p.addCurve(to: CGPoint(x: 0.74 * w, y: 0.18 * h),
                       control1: CGPoint(x: 0.69 * w, y: 0.13 * h),
                       control2: CGPoint(x: 0.72 * w, y: 0.15 * h))
            p.addCurve(to: CGPoint(x: 0.72 * w, y: 0.34 * h),
                       control1: CGPoint(x: 0.76 * w, y: 0.23 * h),
                       control2: CGPoint(x: 0.75 * w, y: 0.29 * h))
            p.addCurve(to: CGPoint(x: 0.66 * w, y: 0.40 * h),
                       control1: CGPoint(x: 0.70 * w, y: 0.37 * h),
                       control2: CGPoint(x: 0.68 * w, y: 0.39 * h))
            p.addLine(to: CGPoint(x: 0.58 * w, y: 0.40 * h))
            p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.26 * h),
                       control1: CGPoint(x: 0.60 * w, y: 0.36 * h),
                       control2: CGPoint(x: 0.61 * w, y: 0.31 * h))
            p.closeSubpath()
            return p

        // MARK: Primary Auditory Cortex
        case ("primary-auditory-cortex", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.34 * w, y: 0.46 * h))
            p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.44 * h),
                       control1: CGPoint(x: 0.38 * w, y: 0.44 * h),
                       control2: CGPoint(x: 0.44 * w, y: 0.43 * h))
            p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.52 * h),
                       control1: CGPoint(x: 0.49 * w, y: 0.47 * h),
                       control2: CGPoint(x: 0.49 * w, y: 0.50 * h))
            p.addCurve(to: CGPoint(x: 0.34 * w, y: 0.54 * h),
                       control1: CGPoint(x: 0.44 * w, y: 0.53 * h),
                       control2: CGPoint(x: 0.38 * w, y: 0.54 * h))
            p.closeSubpath()
            return p

        // MARK: Wernicke's Area
        case ("wernickes-area", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.48 * w, y: 0.40 * h))
            p.addLine(to: CGPoint(x: 0.58 * w, y: 0.40 * h))
            p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.52 * h),
                       control1: CGPoint(x: 0.60 * w, y: 0.44 * h),
                       control2: CGPoint(x: 0.61 * w, y: 0.48 * h))
            p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.52 * h),
                       control1: CGPoint(x: 0.56 * w, y: 0.53 * h),
                       control2: CGPoint(x: 0.52 * w, y: 0.53 * h))
            p.closeSubpath()
            return p

        // MARK: Superior Temporal Sulcus region
        case ("superior-temporal-sulcus", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.26 * w, y: 0.56 * h))
            p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.52 * h),
                       control1: CGPoint(x: 0.38 * w, y: 0.54 * h),
                       control2: CGPoint(x: 0.50 * w, y: 0.52 * h))
            p.addCurve(to: CGPoint(x: 0.57 * w, y: 0.62 * h),
                       control1: CGPoint(x: 0.60 * w, y: 0.56 * h),
                       control2: CGPoint(x: 0.59 * w, y: 0.60 * h))
            p.addCurve(to: CGPoint(x: 0.24 * w, y: 0.64 * h),
                       control1: CGPoint(x: 0.48 * w, y: 0.63 * h),
                       control2: CGPoint(x: 0.35 * w, y: 0.64 * h))
            p.closeSubpath()
            return p

        // MARK: Inferior Temporal Cortex
        case ("inferior-temporal-cortex", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.24 * w, y: 0.64 * h))
            p.addCurve(to: CGPoint(x: 0.57 * w, y: 0.62 * h),
                       control1: CGPoint(x: 0.35 * w, y: 0.64 * h),
                       control2: CGPoint(x: 0.48 * w, y: 0.63 * h))
            p.addCurve(to: CGPoint(x: 0.52 * w, y: 0.74 * h),
                       control1: CGPoint(x: 0.57 * w, y: 0.67 * h),
                       control2: CGPoint(x: 0.56 * w, y: 0.72 * h))
            p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.78 * h),
                       control1: CGPoint(x: 0.48 * w, y: 0.76 * h),
                       control2: CGPoint(x: 0.44 * w, y: 0.78 * h))
            p.addCurve(to: CGPoint(x: 0.25 * w, y: 0.74 * h),
                       control1: CGPoint(x: 0.35 * w, y: 0.79 * h),
                       control2: CGPoint(x: 0.29 * w, y: 0.77 * h))
            p.addCurve(to: CGPoint(x: 0.20 * w, y: 0.68 * h),
                       control1: CGPoint(x: 0.22 * w, y: 0.72 * h),
                       control2: CGPoint(x: 0.20 * w, y: 0.70 * h))
            p.addCurve(to: CGPoint(x: 0.24 * w, y: 0.64 * h),
                       control1: CGPoint(x: 0.20 * w, y: 0.66 * h),
                       control2: CGPoint(x: 0.22 * w, y: 0.65 * h))
            p.closeSubpath()
            return p

        // MARK: Visual Association Areas (lateral occipital)
        case ("visual-association", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.74 * w, y: 0.18 * h))
            p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.26 * h),
                       control1: CGPoint(x: 0.78 * w, y: 0.20 * h),
                       control2: CGPoint(x: 0.81 * w, y: 0.23 * h))
            p.addCurve(to: CGPoint(x: 0.86 * w, y: 0.40 * h),
                       control1: CGPoint(x: 0.84 * w, y: 0.30 * h),
                       control2: CGPoint(x: 0.87 * w, y: 0.35 * h))
            p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.52 * h),
                       control1: CGPoint(x: 0.86 * w, y: 0.45 * h),
                       control2: CGPoint(x: 0.84 * w, y: 0.49 * h))
            p.addCurve(to: CGPoint(x: 0.72 * w, y: 0.56 * h),
                       control1: CGPoint(x: 0.80 * w, y: 0.54 * h),
                       control2: CGPoint(x: 0.76 * w, y: 0.56 * h))
            p.addCurve(to: CGPoint(x: 0.66 * w, y: 0.48 * h),
                       control1: CGPoint(x: 0.70 * w, y: 0.54 * h),
                       control2: CGPoint(x: 0.68 * w, y: 0.51 * h))
            p.addLine(to: CGPoint(x: 0.66 * w, y: 0.40 * h))
            p.addCurve(to: CGPoint(x: 0.72 * w, y: 0.34 * h),
                       control1: CGPoint(x: 0.68 * w, y: 0.39 * h),
                       control2: CGPoint(x: 0.70 * w, y: 0.37 * h))
            p.addCurve(to: CGPoint(x: 0.74 * w, y: 0.18 * h),
                       control1: CGPoint(x: 0.75 * w, y: 0.29 * h),
                       control2: CGPoint(x: 0.76 * w, y: 0.23 * h))
            p.closeSubpath()
            return p

        // MARK: Insula (deep to Sylvian fissure)
        case ("insula", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.30 * w, y: 0.46 * h))
            p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.44 * h),
                       control1: CGPoint(x: 0.33 * w, y: 0.44 * h),
                       control2: CGPoint(x: 0.36 * w, y: 0.43 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.47 * h),
                       control1: CGPoint(x: 0.40 * w, y: 0.44 * h),
                       control2: CGPoint(x: 0.42 * w, y: 0.45 * h))
            p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.54 * h),
                       control1: CGPoint(x: 0.43 * w, y: 0.50 * h),
                       control2: CGPoint(x: 0.42 * w, y: 0.53 * h))
            p.addCurve(to: CGPoint(x: 0.32 * w, y: 0.54 * h),
                       control1: CGPoint(x: 0.37 * w, y: 0.55 * h),
                       control2: CGPoint(x: 0.34 * w, y: 0.55 * h))
            p.addCurve(to: CGPoint(x: 0.30 * w, y: 0.46 * h),
                       control1: CGPoint(x: 0.30 * w, y: 0.52 * h),
                       control2: CGPoint(x: 0.29 * w, y: 0.49 * h))
            p.closeSubpath()
            return p

        // MARK: Supramarginal Gyrus
        case ("supramarginal-gyrus", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.58 * w, y: 0.36 * h))
            p.addCurve(to: CGPoint(x: 0.66 * w, y: 0.36 * h),
                       control1: CGPoint(x: 0.61 * w, y: 0.34 * h),
                       control2: CGPoint(x: 0.64 * w, y: 0.34 * h))
            p.addCurve(to: CGPoint(x: 0.68 * w, y: 0.44 * h),
                       control1: CGPoint(x: 0.68 * w, y: 0.39 * h),
                       control2: CGPoint(x: 0.69 * w, y: 0.42 * h))
            p.addCurve(to: CGPoint(x: 0.62 * w, y: 0.48 * h),
                       control1: CGPoint(x: 0.66 * w, y: 0.46 * h),
                       control2: CGPoint(x: 0.64 * w, y: 0.48 * h))
            p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.44 * h),
                       control1: CGPoint(x: 0.60 * w, y: 0.48 * h),
                       control2: CGPoint(x: 0.58 * w, y: 0.46 * h))
            p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.36 * h),
                       control1: CGPoint(x: 0.57 * w, y: 0.41 * h),
                       control2: CGPoint(x: 0.57 * w, y: 0.38 * h))
            p.closeSubpath()
            return p

        // MARK: Middle Frontal Gyrus
        case ("middle-frontal-gyrus", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.12 * w, y: 0.26 * h))
            p.addCurve(to: CGPoint(x: 0.18 * w, y: 0.24 * h),
                       control1: CGPoint(x: 0.14 * w, y: 0.24 * h),
                       control2: CGPoint(x: 0.16 * w, y: 0.23 * h))
            p.addCurve(to: CGPoint(x: 0.28 * w, y: 0.26 * h),
                       control1: CGPoint(x: 0.22 * w, y: 0.24 * h),
                       control2: CGPoint(x: 0.26 * w, y: 0.25 * h))
            p.addCurve(to: CGPoint(x: 0.27 * w, y: 0.38 * h),
                       control1: CGPoint(x: 0.29 * w, y: 0.30 * h),
                       control2: CGPoint(x: 0.28 * w, y: 0.34 * h))
            p.addCurve(to: CGPoint(x: 0.18 * w, y: 0.38 * h),
                       control1: CGPoint(x: 0.24 * w, y: 0.39 * h),
                       control2: CGPoint(x: 0.20 * w, y: 0.39 * h))
            p.addCurve(to: CGPoint(x: 0.12 * w, y: 0.34 * h),
                       control1: CGPoint(x: 0.15 * w, y: 0.37 * h),
                       control2: CGPoint(x: 0.13 * w, y: 0.36 * h))
            p.addCurve(to: CGPoint(x: 0.12 * w, y: 0.26 * h),
                       control1: CGPoint(x: 0.11 * w, y: 0.31 * h),
                       control2: CGPoint(x: 0.11 * w, y: 0.28 * h))
            p.closeSubpath()
            return p

        // MARK: Superior Frontal Gyrus
        case ("superior-frontal-gyrus", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.14 * w, y: 0.14 * h))
            p.addCurve(to: CGPoint(x: 0.22 * w, y: 0.12 * h),
                       control1: CGPoint(x: 0.17 * w, y: 0.12 * h),
                       control2: CGPoint(x: 0.20 * w, y: 0.11 * h))
            p.addCurve(to: CGPoint(x: 0.28 * w, y: 0.14 * h),
                       control1: CGPoint(x: 0.24 * w, y: 0.12 * h),
                       control2: CGPoint(x: 0.26 * w, y: 0.13 * h))
            p.addLine(to: CGPoint(x: 0.27 * w, y: 0.24 * h))
            p.addCurve(to: CGPoint(x: 0.18 * w, y: 0.24 * h),
                       control1: CGPoint(x: 0.24 * w, y: 0.25 * h),
                       control2: CGPoint(x: 0.20 * w, y: 0.25 * h))
            p.addCurve(to: CGPoint(x: 0.14 * w, y: 0.22 * h),
                       control1: CGPoint(x: 0.16 * w, y: 0.23 * h),
                       control2: CGPoint(x: 0.14 * w, y: 0.23 * h))
            p.addCurve(to: CGPoint(x: 0.14 * w, y: 0.14 * h),
                       control1: CGPoint(x: 0.13 * w, y: 0.19 * h),
                       control2: CGPoint(x: 0.13 * w, y: 0.16 * h))
            p.closeSubpath()
            return p

        // MARK: Middle Temporal Gyrus
        case ("middle-temporal-gyrus", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.24 * w, y: 0.56 * h))
            p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.55 * h),
                       control1: CGPoint(x: 0.30 * w, y: 0.54 * h),
                       control2: CGPoint(x: 0.36 * w, y: 0.54 * h))
            p.addCurve(to: CGPoint(x: 0.57 * w, y: 0.56 * h),
                       control1: CGPoint(x: 0.46 * w, y: 0.55 * h),
                       control2: CGPoint(x: 0.52 * w, y: 0.55 * h))
            p.addCurve(to: CGPoint(x: 0.55 * w, y: 0.64 * h),
                       control1: CGPoint(x: 0.58 * w, y: 0.59 * h),
                       control2: CGPoint(x: 0.57 * w, y: 0.62 * h))
            p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.64 * h),
                       control1: CGPoint(x: 0.50 * w, y: 0.65 * h),
                       control2: CGPoint(x: 0.44 * w, y: 0.65 * h))
            p.addCurve(to: CGPoint(x: 0.24 * w, y: 0.62 * h),
                       control1: CGPoint(x: 0.32 * w, y: 0.64 * h),
                       control2: CGPoint(x: 0.27 * w, y: 0.63 * h))
            p.addCurve(to: CGPoint(x: 0.24 * w, y: 0.56 * h),
                       control1: CGPoint(x: 0.22 * w, y: 0.60 * h),
                       control2: CGPoint(x: 0.22 * w, y: 0.58 * h))
            p.closeSubpath()
            return p

        // MARK: Cerebellum (lateral)
        case ("cerebellum", .lateral):
            var p = Path()
            p.move(to: CGPoint(x: 0.58 * w, y: 0.64 * h))
            p.addCurve(to: CGPoint(x: 0.72 * w, y: 0.58 * h),
                       control1: CGPoint(x: 0.64 * w, y: 0.61 * h),
                       control2: CGPoint(x: 0.68 * w, y: 0.58 * h))
            p.addCurve(to: CGPoint(x: 0.84 * w, y: 0.64 * h),
                       control1: CGPoint(x: 0.77 * w, y: 0.57 * h),
                       control2: CGPoint(x: 0.82 * w, y: 0.60 * h))
            p.addCurve(to: CGPoint(x: 0.86 * w, y: 0.72 * h),
                       control1: CGPoint(x: 0.86 * w, y: 0.67 * h),
                       control2: CGPoint(x: 0.87 * w, y: 0.70 * h))
            p.addCurve(to: CGPoint(x: 0.83 * w, y: 0.80 * h),
                       control1: CGPoint(x: 0.86 * w, y: 0.76 * h),
                       control2: CGPoint(x: 0.85 * w, y: 0.78 * h))
            p.addCurve(to: CGPoint(x: 0.72 * w, y: 0.86 * h),
                       control1: CGPoint(x: 0.80 * w, y: 0.83 * h),
                       control2: CGPoint(x: 0.76 * w, y: 0.85 * h))
            p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.84 * h),
                       control1: CGPoint(x: 0.67 * w, y: 0.87 * h),
                       control2: CGPoint(x: 0.63 * w, y: 0.86 * h))
            p.addCurve(to: CGPoint(x: 0.54 * w, y: 0.76 * h),
                       control1: CGPoint(x: 0.57 * w, y: 0.82 * h),
                       control2: CGPoint(x: 0.55 * w, y: 0.80 * h))
            p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.64 * h),
                       control1: CGPoint(x: 0.53 * w, y: 0.72 * h),
                       control2: CGPoint(x: 0.55 * w, y: 0.68 * h))
            p.closeSubpath()
            return p

        // ============================================================
        // MARK: - MEDIAL VIEW PATHS (unchanged from proven layout)
        // ============================================================

        case ("corpus-callosum", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.22 * w, y: 0.32 * h))
            p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.25 * h), control1: CGPoint(x: 0.28 * w, y: 0.28 * h), control2: CGPoint(x: 0.34 * w, y: 0.25 * h))
            p.addCurve(to: CGPoint(x: 0.62 * w, y: 0.28 * h), control1: CGPoint(x: 0.48 * w, y: 0.24 * h), control2: CGPoint(x: 0.56 * w, y: 0.25 * h))
            p.addCurve(to: CGPoint(x: 0.65 * w, y: 0.33 * h), control1: CGPoint(x: 0.64 * w, y: 0.29 * h), control2: CGPoint(x: 0.65 * w, y: 0.31 * h))
            p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.30 * h), control1: CGPoint(x: 0.58 * w, y: 0.31 * h), control2: CGPoint(x: 0.48 * w, y: 0.29 * h))
            p.addCurve(to: CGPoint(x: 0.22 * w, y: 0.36 * h), control1: CGPoint(x: 0.32 * w, y: 0.30 * h), control2: CGPoint(x: 0.26 * w, y: 0.32 * h))
            p.closeSubpath()
            return p

        case ("cingulate-cortex", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.18 * w, y: 0.28 * h))
            p.addCurve(to: CGPoint(x: 0.35 * w, y: 0.18 * h), control1: CGPoint(x: 0.23 * w, y: 0.22 * h), control2: CGPoint(x: 0.29 * w, y: 0.18 * h))
            p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.18 * h), control1: CGPoint(x: 0.42 * w, y: 0.16 * h), control2: CGPoint(x: 0.50 * w, y: 0.16 * h))
            p.addCurve(to: CGPoint(x: 0.66 * w, y: 0.24 * h), control1: CGPoint(x: 0.62 * w, y: 0.19 * h), control2: CGPoint(x: 0.65 * w, y: 0.21 * h))
            p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.22 * h), control1: CGPoint(x: 0.58 * w, y: 0.23 * h), control2: CGPoint(x: 0.48 * w, y: 0.21 * h))
            p.addCurve(to: CGPoint(x: 0.18 * w, y: 0.28 * h), control1: CGPoint(x: 0.32 * w, y: 0.23 * h), control2: CGPoint(x: 0.24 * w, y: 0.25 * h))
            p.closeSubpath()
            return p

        case ("thalamus", .medial):
            var p = Path()
            let cx = 0.48 * w, cy = 0.40 * h, rx = 0.07 * w, ry = 0.06 * h
            p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
            return p

        case ("hypothalamus", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.36 * w, y: 0.50 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.47 * h), control1: CGPoint(x: 0.38 * w, y: 0.48 * h), control2: CGPoint(x: 0.40 * w, y: 0.47 * h))
            p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.50 * h), control1: CGPoint(x: 0.44 * w, y: 0.47 * h), control2: CGPoint(x: 0.46 * w, y: 0.48 * h))
            p.addCurve(to: CGPoint(x: 0.44 * w, y: 0.58 * h), control1: CGPoint(x: 0.48 * w, y: 0.54 * h), control2: CGPoint(x: 0.46 * w, y: 0.57 * h))
            p.addCurve(to: CGPoint(x: 0.36 * w, y: 0.50 * h), control1: CGPoint(x: 0.40 * w, y: 0.58 * h), control2: CGPoint(x: 0.36 * w, y: 0.55 * h))
            p.closeSubpath()
            return p

        case ("hippocampus", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.42 * w, y: 0.58 * h))
            p.addCurve(to: CGPoint(x: 0.52 * w, y: 0.55 * h), control1: CGPoint(x: 0.45 * w, y: 0.56 * h), control2: CGPoint(x: 0.48 * w, y: 0.54 * h))
            p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.60 * h), control1: CGPoint(x: 0.55 * w, y: 0.56 * h), control2: CGPoint(x: 0.57 * w, y: 0.58 * h))
            p.addCurve(to: CGPoint(x: 0.55 * w, y: 0.66 * h), control1: CGPoint(x: 0.59 * w, y: 0.63 * h), control2: CGPoint(x: 0.58 * w, y: 0.65 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.64 * h), control1: CGPoint(x: 0.50 * w, y: 0.67 * h), control2: CGPoint(x: 0.46 * w, y: 0.66 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.58 * h), control1: CGPoint(x: 0.40 * w, y: 0.62 * h), control2: CGPoint(x: 0.40 * w, y: 0.60 * h))
            p.closeSubpath()
            return p

        case ("amygdala", .medial):
            var p = Path()
            let cx = 0.36 * w, cy = 0.60 * h, rx = 0.035 * w, ry = 0.04 * h
            p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
            return p

        case ("fornix", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.28 * w, y: 0.42 * h))
            p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.35 * h), control1: CGPoint(x: 0.30 * w, y: 0.38 * h), control2: CGPoint(x: 0.34 * w, y: 0.35 * h))
            p.addCurve(to: CGPoint(x: 0.50 * w, y: 0.36 * h), control1: CGPoint(x: 0.42 * w, y: 0.34 * h), control2: CGPoint(x: 0.46 * w, y: 0.34 * h))
            p.addCurve(to: CGPoint(x: 0.52 * w, y: 0.42 * h), control1: CGPoint(x: 0.52 * w, y: 0.38 * h), control2: CGPoint(x: 0.53 * w, y: 0.40 * h))
            p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.38 * h), control1: CGPoint(x: 0.48 * w, y: 0.39 * h), control2: CGPoint(x: 0.42 * w, y: 0.37 * h))
            p.addCurve(to: CGPoint(x: 0.28 * w, y: 0.42 * h), control1: CGPoint(x: 0.34 * w, y: 0.38 * h), control2: CGPoint(x: 0.30 * w, y: 0.40 * h))
            p.closeSubpath()
            return p

        case ("mammillary-bodies", .medial):
            var p = Path()
            let cx = 0.40 * w, cy = 0.62 * h, r = 0.018 * w
            p.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
            return p

        case ("supplementary-motor-area", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.25 * w, y: 0.08 * h))
            p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.06 * h), control1: CGPoint(x: 0.30 * w, y: 0.06 * h), control2: CGPoint(x: 0.34 * w, y: 0.05 * h))
            p.addLine(to: CGPoint(x: 0.38 * w, y: 0.18 * h))
            p.addLine(to: CGPoint(x: 0.25 * w, y: 0.20 * h))
            p.closeSubpath()
            return p

        case ("orbitofrontal-cortex", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.08 * w, y: 0.48 * h))
            p.addCurve(to: CGPoint(x: 0.15 * w, y: 0.40 * h), control1: CGPoint(x: 0.09 * w, y: 0.44 * h), control2: CGPoint(x: 0.12 * w, y: 0.40 * h))
            p.addLine(to: CGPoint(x: 0.25 * w, y: 0.40 * h))
            p.addLine(to: CGPoint(x: 0.28 * w, y: 0.52 * h))
            p.addCurve(to: CGPoint(x: 0.18 * w, y: 0.58 * h), control1: CGPoint(x: 0.25 * w, y: 0.55 * h), control2: CGPoint(x: 0.22 * w, y: 0.58 * h))
            p.addCurve(to: CGPoint(x: 0.08 * w, y: 0.48 * h), control1: CGPoint(x: 0.13 * w, y: 0.58 * h), control2: CGPoint(x: 0.08 * w, y: 0.54 * h))
            p.closeSubpath()
            return p

        case ("primary-visual-cortex", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.75 * w, y: 0.30 * h))
            p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.35 * h), control1: CGPoint(x: 0.78 * w, y: 0.31 * h), control2: CGPoint(x: 0.81 * w, y: 0.33 * h))
            p.addCurve(to: CGPoint(x: 0.83 * w, y: 0.48 * h), control1: CGPoint(x: 0.84 * w, y: 0.40 * h), control2: CGPoint(x: 0.84 * w, y: 0.44 * h))
            p.addCurve(to: CGPoint(x: 0.76 * w, y: 0.52 * h), control1: CGPoint(x: 0.82 * w, y: 0.50 * h), control2: CGPoint(x: 0.79 * w, y: 0.52 * h))
            p.addLine(to: CGPoint(x: 0.72 * w, y: 0.42 * h))
            p.addLine(to: CGPoint(x: 0.75 * w, y: 0.30 * h))
            p.closeSubpath()
            return p

        case ("cuneus-lingual", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.65 * w, y: 0.20 * h))
            p.addCurve(to: CGPoint(x: 0.75 * w, y: 0.18 * h), control1: CGPoint(x: 0.68 * w, y: 0.18 * h), control2: CGPoint(x: 0.72 * w, y: 0.17 * h))
            p.addLine(to: CGPoint(x: 0.75 * w, y: 0.30 * h))
            p.addLine(to: CGPoint(x: 0.72 * w, y: 0.42 * h))
            p.addLine(to: CGPoint(x: 0.68 * w, y: 0.42 * h))
            p.addLine(to: CGPoint(x: 0.65 * w, y: 0.30 * h))
            p.closeSubpath()
            return p

        case ("fusiform-gyrus", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.42 * w, y: 0.70 * h))
            p.addCurve(to: CGPoint(x: 0.55 * w, y: 0.68 * h), control1: CGPoint(x: 0.46 * w, y: 0.68 * h), control2: CGPoint(x: 0.50 * w, y: 0.67 * h))
            p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.75 * h), control1: CGPoint(x: 0.58 * w, y: 0.70 * h), control2: CGPoint(x: 0.60 * w, y: 0.72 * h))
            p.addCurve(to: CGPoint(x: 0.50 * w, y: 0.80 * h), control1: CGPoint(x: 0.60 * w, y: 0.78 * h), control2: CGPoint(x: 0.56 * w, y: 0.80 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.70 * h), control1: CGPoint(x: 0.46 * w, y: 0.80 * h), control2: CGPoint(x: 0.42 * w, y: 0.76 * h))
            p.closeSubpath()
            return p

        case ("basal-ganglia-caudate", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.32 * w, y: 0.32 * h))
            p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.30 * h), control1: CGPoint(x: 0.34 * w, y: 0.30 * h), control2: CGPoint(x: 0.36 * w, y: 0.29 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.35 * h), control1: CGPoint(x: 0.40 * w, y: 0.31 * h), control2: CGPoint(x: 0.42 * w, y: 0.33 * h))
            p.addLine(to: CGPoint(x: 0.38 * w, y: 0.38 * h))
            p.addLine(to: CGPoint(x: 0.32 * w, y: 0.36 * h))
            p.closeSubpath()
            return p

        case ("basal-ganglia-putamen", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.36 * w, y: 0.40 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.38 * h), control1: CGPoint(x: 0.38 * w, y: 0.39 * h), control2: CGPoint(x: 0.40 * w, y: 0.38 * h))
            p.addCurve(to: CGPoint(x: 0.45 * w, y: 0.44 * h), control1: CGPoint(x: 0.44 * w, y: 0.39 * h), control2: CGPoint(x: 0.45 * w, y: 0.41 * h))
            p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.48 * h), control1: CGPoint(x: 0.45 * w, y: 0.46 * h), control2: CGPoint(x: 0.43 * w, y: 0.48 * h))
            p.addCurve(to: CGPoint(x: 0.36 * w, y: 0.40 * h), control1: CGPoint(x: 0.37 * w, y: 0.48 * h), control2: CGPoint(x: 0.35 * w, y: 0.44 * h))
            p.closeSubpath()
            return p

        case ("globus-pallidus", .medial):
            var p = Path()
            let cx = 0.42 * w, cy = 0.46 * h, rx = 0.025 * w, ry = 0.03 * h
            p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
            return p

        case ("pineal-gland", .medial):
            var p = Path()
            let cx = 0.58 * w, cy = 0.38 * h, r = 0.012 * w
            p.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
            return p

        case ("midbrain", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.46 * w, y: 0.52 * h))
            p.addLine(to: CGPoint(x: 0.54 * w, y: 0.52 * h))
            p.addCurve(to: CGPoint(x: 0.56 * w, y: 0.60 * h), control1: CGPoint(x: 0.56 * w, y: 0.55 * h), control2: CGPoint(x: 0.57 * w, y: 0.58 * h))
            p.addLine(to: CGPoint(x: 0.50 * w, y: 0.62 * h))
            p.addCurve(to: CGPoint(x: 0.46 * w, y: 0.52 * h), control1: CGPoint(x: 0.47 * w, y: 0.60 * h), control2: CGPoint(x: 0.45 * w, y: 0.56 * h))
            p.closeSubpath()
            return p

        case ("brainstem-pons", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.48 * w, y: 0.62 * h))
            p.addCurve(to: CGPoint(x: 0.56 * w, y: 0.62 * h), control1: CGPoint(x: 0.50 * w, y: 0.61 * h), control2: CGPoint(x: 0.54 * w, y: 0.61 * h))
            p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.70 * h), control1: CGPoint(x: 0.58 * w, y: 0.65 * h), control2: CGPoint(x: 0.59 * w, y: 0.68 * h))
            p.addCurve(to: CGPoint(x: 0.52 * w, y: 0.73 * h), control1: CGPoint(x: 0.57 * w, y: 0.72 * h), control2: CGPoint(x: 0.55 * w, y: 0.73 * h))
            p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.62 * h), control1: CGPoint(x: 0.48 * w, y: 0.72 * h), control2: CGPoint(x: 0.46 * w, y: 0.67 * h))
            p.closeSubpath()
            return p

        case ("medulla", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.50 * w, y: 0.73 * h))
            p.addLine(to: CGPoint(x: 0.54 * w, y: 0.73 * h))
            p.addCurve(to: CGPoint(x: 0.52 * w, y: 0.85 * h), control1: CGPoint(x: 0.54 * w, y: 0.78 * h), control2: CGPoint(x: 0.53 * w, y: 0.82 * h))
            p.addCurve(to: CGPoint(x: 0.50 * w, y: 0.85 * h), control1: CGPoint(x: 0.51 * w, y: 0.85 * h), control2: CGPoint(x: 0.50 * w, y: 0.85 * h))
            p.addCurve(to: CGPoint(x: 0.50 * w, y: 0.73 * h), control1: CGPoint(x: 0.49 * w, y: 0.82 * h), control2: CGPoint(x: 0.49 * w, y: 0.78 * h))
            p.closeSubpath()
            return p

        case ("reticular-formation", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.49 * w, y: 0.54 * h))
            p.addLine(to: CGPoint(x: 0.53 * w, y: 0.54 * h))
            p.addCurve(to: CGPoint(x: 0.54 * w, y: 0.72 * h), control1: CGPoint(x: 0.55 * w, y: 0.60 * h), control2: CGPoint(x: 0.55 * w, y: 0.66 * h))
            p.addLine(to: CGPoint(x: 0.50 * w, y: 0.72 * h))
            p.addCurve(to: CGPoint(x: 0.49 * w, y: 0.54 * h), control1: CGPoint(x: 0.48 * w, y: 0.66 * h), control2: CGPoint(x: 0.47 * w, y: 0.60 * h))
            p.closeSubpath()
            return p

        case ("cerebellum", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.60 * w, y: 0.55 * h))
            p.addCurve(to: CGPoint(x: 0.76 * w, y: 0.52 * h), control1: CGPoint(x: 0.66 * w, y: 0.52 * h), control2: CGPoint(x: 0.72 * w, y: 0.50 * h))
            p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.65 * h), control1: CGPoint(x: 0.80 * w, y: 0.55 * h), control2: CGPoint(x: 0.83 * w, y: 0.60 * h))
            p.addCurve(to: CGPoint(x: 0.75 * w, y: 0.80 * h), control1: CGPoint(x: 0.82 * w, y: 0.72 * h), control2: CGPoint(x: 0.80 * w, y: 0.78 * h))
            p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.78 * h), control1: CGPoint(x: 0.70 * w, y: 0.82 * h), control2: CGPoint(x: 0.63 * w, y: 0.81 * h))
            p.addCurve(to: CGPoint(x: 0.56 * w, y: 0.68 * h), control1: CGPoint(x: 0.55 * w, y: 0.75 * h), control2: CGPoint(x: 0.54 * w, y: 0.72 * h))
            p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.55 * h), control1: CGPoint(x: 0.57 * w, y: 0.63 * h), control2: CGPoint(x: 0.58 * w, y: 0.58 * h))
            p.closeSubpath()
            return p

        // ============================================================
        // MARK: - NEW MEDIAL STRUCTURES
        // ============================================================

        // MARK: Precuneus
        case ("precuneus", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.52 * w, y: 0.08 * h))
            p.addCurve(to: CGPoint(x: 0.62 * w, y: 0.08 * h),
                       control1: CGPoint(x: 0.56 * w, y: 0.06 * h),
                       control2: CGPoint(x: 0.60 * w, y: 0.06 * h))
            p.addCurve(to: CGPoint(x: 0.66 * w, y: 0.14 * h),
                       control1: CGPoint(x: 0.64 * w, y: 0.10 * h),
                       control2: CGPoint(x: 0.66 * w, y: 0.12 * h))
            p.addCurve(to: CGPoint(x: 0.64 * w, y: 0.20 * h),
                       control1: CGPoint(x: 0.66 * w, y: 0.16 * h),
                       control2: CGPoint(x: 0.65 * w, y: 0.18 * h))
            p.addLine(to: CGPoint(x: 0.55 * w, y: 0.20 * h))
            p.addCurve(to: CGPoint(x: 0.52 * w, y: 0.14 * h),
                       control1: CGPoint(x: 0.53 * w, y: 0.18 * h),
                       control2: CGPoint(x: 0.52 * w, y: 0.16 * h))
            p.addCurve(to: CGPoint(x: 0.52 * w, y: 0.08 * h),
                       control1: CGPoint(x: 0.51 * w, y: 0.12 * h),
                       control2: CGPoint(x: 0.51 * w, y: 0.10 * h))
            p.closeSubpath()
            return p

        // MARK: Paracentral Lobule
        case ("paracentral-lobule", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.38 * w, y: 0.06 * h))
            p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.06 * h),
                       control1: CGPoint(x: 0.42 * w, y: 0.05 * h),
                       control2: CGPoint(x: 0.46 * w, y: 0.05 * h))
            p.addCurve(to: CGPoint(x: 0.52 * w, y: 0.10 * h),
                       control1: CGPoint(x: 0.50 * w, y: 0.06 * h),
                       control2: CGPoint(x: 0.52 * w, y: 0.08 * h))
            p.addLine(to: CGPoint(x: 0.50 * w, y: 0.18 * h))
            p.addLine(to: CGPoint(x: 0.40 * w, y: 0.18 * h))
            p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.06 * h),
                       control1: CGPoint(x: 0.39 * w, y: 0.14 * h),
                       control2: CGPoint(x: 0.38 * w, y: 0.10 * h))
            p.closeSubpath()
            return p

        // MARK: Entorhinal Cortex
        case ("entorhinal-cortex", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.32 * w, y: 0.56 * h))
            p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.55 * h),
                       control1: CGPoint(x: 0.34 * w, y: 0.55 * h),
                       control2: CGPoint(x: 0.36 * w, y: 0.54 * h))
            p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.58 * h),
                       control1: CGPoint(x: 0.40 * w, y: 0.55 * h),
                       control2: CGPoint(x: 0.42 * w, y: 0.56 * h))
            p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.64 * h),
                       control1: CGPoint(x: 0.42 * w, y: 0.60 * h),
                       control2: CGPoint(x: 0.41 * w, y: 0.62 * h))
            p.addCurve(to: CGPoint(x: 0.34 * w, y: 0.64 * h),
                       control1: CGPoint(x: 0.38 * w, y: 0.65 * h),
                       control2: CGPoint(x: 0.36 * w, y: 0.65 * h))
            p.addCurve(to: CGPoint(x: 0.32 * w, y: 0.56 * h),
                       control1: CGPoint(x: 0.32 * w, y: 0.62 * h),
                       control2: CGPoint(x: 0.31 * w, y: 0.59 * h))
            p.closeSubpath()
            return p

        // MARK: Parahippocampal Gyrus
        case ("parahippocampal-gyrus", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.38 * w, y: 0.64 * h))
            p.addCurve(to: CGPoint(x: 0.50 * w, y: 0.63 * h),
                       control1: CGPoint(x: 0.42 * w, y: 0.63 * h),
                       control2: CGPoint(x: 0.46 * w, y: 0.62 * h))
            p.addCurve(to: CGPoint(x: 0.56 * w, y: 0.66 * h),
                       control1: CGPoint(x: 0.53 * w, y: 0.63 * h),
                       control2: CGPoint(x: 0.55 * w, y: 0.64 * h))
            p.addCurve(to: CGPoint(x: 0.54 * w, y: 0.72 * h),
                       control1: CGPoint(x: 0.57 * w, y: 0.68 * h),
                       control2: CGPoint(x: 0.56 * w, y: 0.70 * h))
            p.addCurve(to: CGPoint(x: 0.44 * w, y: 0.72 * h),
                       control1: CGPoint(x: 0.50 * w, y: 0.73 * h),
                       control2: CGPoint(x: 0.46 * w, y: 0.73 * h))
            p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.68 * h),
                       control1: CGPoint(x: 0.42 * w, y: 0.72 * h),
                       control2: CGPoint(x: 0.39 * w, y: 0.70 * h))
            p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.64 * h),
                       control1: CGPoint(x: 0.37 * w, y: 0.66 * h),
                       control2: CGPoint(x: 0.37 * w, y: 0.65 * h))
            p.closeSubpath()
            return p

        // MARK: Nucleus Accumbens
        case ("nucleus-accumbens", .medial):
            var p = Path()
            let cx = 0.34 * w, cy = 0.44 * h, rx = 0.025 * w, ry = 0.022 * h
            p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
            return p

        // MARK: Substantia Nigra
        case ("substantia-nigra", .medial):
            var p = Path()
            let cx = 0.50 * w, cy = 0.56 * h, rx = 0.030 * w, ry = 0.020 * h
            p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
            return p

        // MARK: Superior Colliculus
        case ("superior-colliculus", .medial):
            var p = Path()
            let cx = 0.56 * w, cy = 0.50 * h, rx = 0.018 * w, ry = 0.016 * h
            p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
            return p

        // MARK: Inferior Colliculus
        case ("inferior-colliculus", .medial):
            var p = Path()
            let cx = 0.58 * w, cy = 0.53 * h, rx = 0.016 * w, ry = 0.014 * h
            p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
            return p

        // MARK: Septal Nuclei
        case ("septal-nuclei", .medial):
            var p = Path()
            let cx = 0.26 * w, cy = 0.38 * h, rx = 0.022 * w, ry = 0.025 * h
            p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
            return p

        // MARK: Optic Chiasm (diamond shape)
        case ("optic-chiasm", .medial):
            var p = Path()
            let cx = 0.34 * w, cy = 0.60 * h
            let dx = 0.022 * w, dy = 0.018 * h
            p.move(to: CGPoint(x: cx, y: cy - dy))
            p.addLine(to: CGPoint(x: cx + dx, y: cy))
            p.addLine(to: CGPoint(x: cx, y: cy + dy))
            p.addLine(to: CGPoint(x: cx - dx, y: cy))
            p.closeSubpath()
            return p

        // MARK: Anterior Commissure
        case ("anterior-commissure", .medial):
            var p = Path()
            let cx = 0.30 * w, cy = 0.44 * h, rx = 0.020 * w, ry = 0.015 * h
            p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
            return p

        // MARK: Lateral Ventricle (C-shaped)
        case ("lateral-ventricle", .medial):
            var p = Path()
            p.move(to: CGPoint(x: 0.28 * w, y: 0.32 * h))
            p.addCurve(to: CGPoint(x: 0.36 * w, y: 0.28 * h),
                       control1: CGPoint(x: 0.30 * w, y: 0.29 * h),
                       control2: CGPoint(x: 0.33 * w, y: 0.27 * h))
            p.addCurve(to: CGPoint(x: 0.52 * w, y: 0.30 * h),
                       control1: CGPoint(x: 0.42 * w, y: 0.27 * h),
                       control2: CGPoint(x: 0.48 * w, y: 0.28 * h))
            p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.36 * h),
                       control1: CGPoint(x: 0.56 * w, y: 0.31 * h),
                       control2: CGPoint(x: 0.59 * w, y: 0.33 * h))
            p.addCurve(to: CGPoint(x: 0.64 * w, y: 0.44 * h),
                       control1: CGPoint(x: 0.62 * w, y: 0.39 * h),
                       control2: CGPoint(x: 0.64 * w, y: 0.42 * h))
            p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.52 * h),
                       control1: CGPoint(x: 0.64 * w, y: 0.48 * h),
                       control2: CGPoint(x: 0.62 * w, y: 0.51 * h))
            // Inner C return
            p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.44 * h),
                       control1: CGPoint(x: 0.60 * w, y: 0.50 * h),
                       control2: CGPoint(x: 0.61 * w, y: 0.47 * h))
            p.addCurve(to: CGPoint(x: 0.56 * w, y: 0.38 * h),
                       control1: CGPoint(x: 0.60 * w, y: 0.42 * h),
                       control2: CGPoint(x: 0.58 * w, y: 0.39 * h))
            p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.34 * h),
                       control1: CGPoint(x: 0.54 * w, y: 0.36 * h),
                       control2: CGPoint(x: 0.52 * w, y: 0.34 * h))
            p.addCurve(to: CGPoint(x: 0.34 * w, y: 0.33 * h),
                       control1: CGPoint(x: 0.44 * w, y: 0.33 * h),
                       control2: CGPoint(x: 0.38 * w, y: 0.32 * h))
            p.addCurve(to: CGPoint(x: 0.28 * w, y: 0.32 * h),
                       control1: CGPoint(x: 0.32 * w, y: 0.34 * h),
                       control2: CGPoint(x: 0.29 * w, y: 0.34 * h))
            p.closeSubpath()
            return p

        default:
            var p = Path()
            p.addEllipse(in: CGRect(x: 0.45 * w, y: 0.45 * h, width: 0.1 * w, height: 0.1 * h))
            return p
        }
    }

    // MARK: - Brain Outline

    static func lateralOutline(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()

        // Anatomically realistic lateral hemisphere silhouette with
        // visible gyri bumps along the superior and inferior contours.
        p.move(to: CGPoint(x: 0.07 * w, y: 0.54 * h))
        // Frontal pole
        p.addCurve(to: CGPoint(x: 0.06 * w, y: 0.40 * h),
                   control1: CGPoint(x: 0.04 * w, y: 0.50 * h),
                   control2: CGPoint(x: 0.04 * w, y: 0.45 * h))
        p.addCurve(to: CGPoint(x: 0.10 * w, y: 0.28 * h),
                   control1: CGPoint(x: 0.07 * w, y: 0.35 * h),
                   control2: CGPoint(x: 0.08 * w, y: 0.31 * h))
        // Superior frontal gyri bumps
        p.addCurve(to: CGPoint(x: 0.17 * w, y: 0.16 * h),
                   control1: CGPoint(x: 0.12 * w, y: 0.24 * h),
                   control2: CGPoint(x: 0.14 * w, y: 0.19 * h))
        p.addCurve(to: CGPoint(x: 0.22 * w, y: 0.12 * h),
                   control1: CGPoint(x: 0.19 * w, y: 0.14 * h),
                   control2: CGPoint(x: 0.20 * w, y: 0.12 * h))
        // Gyrus bumps along superior margin (enhanced undulation)
        p.addCurve(to: CGPoint(x: 0.25 * w, y: 0.10 * h),
                   control1: CGPoint(x: 0.23 * w, y: 0.11 * h),
                   control2: CGPoint(x: 0.24 * w, y: 0.09 * h))
        p.addCurve(to: CGPoint(x: 0.28 * w, y: 0.10 * h),
                   control1: CGPoint(x: 0.26 * w, y: 0.10 * h),
                   control2: CGPoint(x: 0.27 * w, y: 0.09 * h))
        p.addCurve(to: CGPoint(x: 0.31 * w, y: 0.09 * h),
                   control1: CGPoint(x: 0.29 * w, y: 0.10 * h),
                   control2: CGPoint(x: 0.30 * w, y: 0.09 * h))
        p.addCurve(to: CGPoint(x: 0.34 * w, y: 0.08 * h),
                   control1: CGPoint(x: 0.32 * w, y: 0.09 * h),
                   control2: CGPoint(x: 0.33 * w, y: 0.08 * h))
        p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.07 * h),
                   control1: CGPoint(x: 0.35 * w, y: 0.08 * h),
                   control2: CGPoint(x: 0.37 * w, y: 0.07 * h))
        p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.06 * h),
                   control1: CGPoint(x: 0.39 * w, y: 0.07 * h),
                   control2: CGPoint(x: 0.41 * w, y: 0.06 * h))
        p.addCurve(to: CGPoint(x: 0.46 * w, y: 0.055 * h),
                   control1: CGPoint(x: 0.43 * w, y: 0.06 * h),
                   control2: CGPoint(x: 0.45 * w, y: 0.055 * h))
        p.addCurve(to: CGPoint(x: 0.50 * w, y: 0.05 * h),
                   control1: CGPoint(x: 0.47 * w, y: 0.055 * h),
                   control2: CGPoint(x: 0.49 * w, y: 0.05 * h))
        p.addCurve(to: CGPoint(x: 0.54 * w, y: 0.055 * h),
                   control1: CGPoint(x: 0.51 * w, y: 0.05 * h),
                   control2: CGPoint(x: 0.53 * w, y: 0.05 * h))
        p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.06 * h),
                   control1: CGPoint(x: 0.55 * w, y: 0.055 * h),
                   control2: CGPoint(x: 0.57 * w, y: 0.055 * h))
        p.addCurve(to: CGPoint(x: 0.62 * w, y: 0.08 * h),
                   control1: CGPoint(x: 0.59 * w, y: 0.06 * h),
                   control2: CGPoint(x: 0.61 * w, y: 0.07 * h))
        p.addCurve(to: CGPoint(x: 0.66 * w, y: 0.10 * h),
                   control1: CGPoint(x: 0.63 * w, y: 0.09 * h),
                   control2: CGPoint(x: 0.65 * w, y: 0.09 * h))
        // Parietal to occipital
        p.addCurve(to: CGPoint(x: 0.74 * w, y: 0.16 * h),
                   control1: CGPoint(x: 0.69 * w, y: 0.12 * h),
                   control2: CGPoint(x: 0.72 * w, y: 0.13 * h))
        p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.26 * h),
                   control1: CGPoint(x: 0.78 * w, y: 0.19 * h),
                   control2: CGPoint(x: 0.81 * w, y: 0.22 * h))
        p.addCurve(to: CGPoint(x: 0.86 * w, y: 0.38 * h),
                   control1: CGPoint(x: 0.84 * w, y: 0.30 * h),
                   control2: CGPoint(x: 0.86 * w, y: 0.34 * h))
        p.addCurve(to: CGPoint(x: 0.86 * w, y: 0.50 * h),
                   control1: CGPoint(x: 0.87 * w, y: 0.43 * h),
                   control2: CGPoint(x: 0.87 * w, y: 0.47 * h))
        // Occipital-cerebellar junction
        p.addCurve(to: CGPoint(x: 0.80 * w, y: 0.56 * h),
                   control1: CGPoint(x: 0.85 * w, y: 0.53 * h),
                   control2: CGPoint(x: 0.83 * w, y: 0.55 * h))
        // Cerebellar bulge
        p.addCurve(to: CGPoint(x: 0.86 * w, y: 0.66 * h),
                   control1: CGPoint(x: 0.84 * w, y: 0.58 * h),
                   control2: CGPoint(x: 0.87 * w, y: 0.62 * h))
        p.addCurve(to: CGPoint(x: 0.84 * w, y: 0.76 * h),
                   control1: CGPoint(x: 0.87 * w, y: 0.70 * h),
                   control2: CGPoint(x: 0.86 * w, y: 0.74 * h))
        p.addCurve(to: CGPoint(x: 0.78 * w, y: 0.84 * h),
                   control1: CGPoint(x: 0.82 * w, y: 0.79 * h),
                   control2: CGPoint(x: 0.80 * w, y: 0.82 * h))
        p.addCurve(to: CGPoint(x: 0.68 * w, y: 0.87 * h),
                   control1: CGPoint(x: 0.75 * w, y: 0.86 * h),
                   control2: CGPoint(x: 0.72 * w, y: 0.87 * h))
        p.addCurve(to: CGPoint(x: 0.56 * w, y: 0.82 * h),
                   control1: CGPoint(x: 0.64 * w, y: 0.88 * h),
                   control2: CGPoint(x: 0.60 * w, y: 0.86 * h))
        // Temporal pole inferior contour
        p.addCurve(to: CGPoint(x: 0.46 * w, y: 0.78 * h),
                   control1: CGPoint(x: 0.52 * w, y: 0.80 * h),
                   control2: CGPoint(x: 0.49 * w, y: 0.79 * h))
        p.addCurve(to: CGPoint(x: 0.36 * w, y: 0.76 * h),
                   control1: CGPoint(x: 0.43 * w, y: 0.78 * h),
                   control2: CGPoint(x: 0.39 * w, y: 0.77 * h))
        p.addCurve(to: CGPoint(x: 0.24 * w, y: 0.72 * h),
                   control1: CGPoint(x: 0.32 * w, y: 0.76 * h),
                   control2: CGPoint(x: 0.28 * w, y: 0.74 * h))
        p.addCurve(to: CGPoint(x: 0.18 * w, y: 0.66 * h),
                   control1: CGPoint(x: 0.21 * w, y: 0.70 * h),
                   control2: CGPoint(x: 0.19 * w, y: 0.68 * h))
        p.addCurve(to: CGPoint(x: 0.07 * w, y: 0.54 * h),
                   control1: CGPoint(x: 0.14 * w, y: 0.63 * h),
                   control2: CGPoint(x: 0.08 * w, y: 0.59 * h))
        p.closeSubpath()
        return p
    }

    static func medialOutline(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()

        p.move(to: CGPoint(x: 0.09 * w, y: 0.52 * h))
        p.addCurve(to: CGPoint(x: 0.11 * w, y: 0.26 * h), control1: CGPoint(x: 0.06 * w, y: 0.45 * h), control2: CGPoint(x: 0.08 * w, y: 0.32 * h))
        p.addCurve(to: CGPoint(x: 0.30 * w, y: 0.07 * h), control1: CGPoint(x: 0.14 * w, y: 0.17 * h), control2: CGPoint(x: 0.22 * w, y: 0.09 * h))
        p.addCurve(to: CGPoint(x: 0.55 * w, y: 0.05 * h), control1: CGPoint(x: 0.38 * w, y: 0.05 * h), control2: CGPoint(x: 0.46 * w, y: 0.04 * h))
        p.addCurve(to: CGPoint(x: 0.76 * w, y: 0.12 * h), control1: CGPoint(x: 0.63 * w, y: 0.06 * h), control2: CGPoint(x: 0.71 * w, y: 0.09 * h))
        p.addCurve(to: CGPoint(x: 0.86 * w, y: 0.32 * h), control1: CGPoint(x: 0.82 * w, y: 0.17 * h), control2: CGPoint(x: 0.86 * w, y: 0.24 * h))
        p.addCurve(to: CGPoint(x: 0.84 * w, y: 0.48 * h), control1: CGPoint(x: 0.87 * w, y: 0.38 * h), control2: CGPoint(x: 0.86 * w, y: 0.44 * h))
        p.addCurve(to: CGPoint(x: 0.77 * w, y: 0.56 * h), control1: CGPoint(x: 0.83 * w, y: 0.52 * h), control2: CGPoint(x: 0.80 * w, y: 0.55 * h))
        p.addCurve(to: CGPoint(x: 0.84 * w, y: 0.68 * h), control1: CGPoint(x: 0.81 * w, y: 0.59 * h), control2: CGPoint(x: 0.84 * w, y: 0.63 * h))
        p.addCurve(to: CGPoint(x: 0.73 * w, y: 0.84 * h), control1: CGPoint(x: 0.84 * w, y: 0.76 * h), control2: CGPoint(x: 0.80 * w, y: 0.82 * h))
        p.addCurve(to: CGPoint(x: 0.56 * w, y: 0.89 * h), control1: CGPoint(x: 0.67 * w, y: 0.86 * h), control2: CGPoint(x: 0.61 * w, y: 0.89 * h))
        p.addCurve(to: CGPoint(x: 0.47 * w, y: 0.85 * h), control1: CGPoint(x: 0.53 * w, y: 0.89 * h), control2: CGPoint(x: 0.50 * w, y: 0.87 * h))
        p.addCurve(to: CGPoint(x: 0.44 * w, y: 0.73 * h), control1: CGPoint(x: 0.45 * w, y: 0.82 * h), control2: CGPoint(x: 0.44 * w, y: 0.78 * h))
        p.addCurve(to: CGPoint(x: 0.24 * w, y: 0.64 * h), control1: CGPoint(x: 0.40 * w, y: 0.67 * h), control2: CGPoint(x: 0.31 * w, y: 0.64 * h))
        p.addCurve(to: CGPoint(x: 0.12 * w, y: 0.58 * h), control1: CGPoint(x: 0.19 * w, y: 0.64 * h), control2: CGPoint(x: 0.14 * w, y: 0.62 * h))
        p.addCurve(to: CGPoint(x: 0.09 * w, y: 0.52 * h), control1: CGPoint(x: 0.10 * w, y: 0.56 * h), control2: CGPoint(x: 0.09 * w, y: 0.54 * h))
        p.closeSubpath()
        return p
    }

    // MARK: - Lateral Sulci (major landmarks)

    static func lateralSulci(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()

        // Central sulcus
        p.move(to: CGPoint(x: 0.42 * w, y: 0.06 * h))
        p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.20 * h), control1: CGPoint(x: 0.43 * w, y: 0.10 * h), control2: CGPoint(x: 0.42 * w, y: 0.16 * h))
        p.addCurve(to: CGPoint(x: 0.38 * w, y: 0.44 * h), control1: CGPoint(x: 0.39 * w, y: 0.28 * h), control2: CGPoint(x: 0.38 * w, y: 0.36 * h))

        // Sylvian (lateral) fissure
        p.move(to: CGPoint(x: 0.22 * w, y: 0.52 * h))
        p.addCurve(to: CGPoint(x: 0.40 * w, y: 0.44 * h), control1: CGPoint(x: 0.28 * w, y: 0.50 * h), control2: CGPoint(x: 0.34 * w, y: 0.46 * h))
        p.addCurve(to: CGPoint(x: 0.66 * w, y: 0.42 * h), control1: CGPoint(x: 0.48 * w, y: 0.42 * h), control2: CGPoint(x: 0.58 * w, y: 0.40 * h))

        // Precentral sulcus
        p.move(to: CGPoint(x: 0.36 * w, y: 0.08 * h))
        p.addCurve(to: CGPoint(x: 0.34 * w, y: 0.44 * h), control1: CGPoint(x: 0.37 * w, y: 0.20 * h), control2: CGPoint(x: 0.35 * w, y: 0.34 * h))

        // Postcentral sulcus
        p.move(to: CGPoint(x: 0.48 * w, y: 0.07 * h))
        p.addCurve(to: CGPoint(x: 0.46 * w, y: 0.38 * h), control1: CGPoint(x: 0.49 * w, y: 0.18 * h), control2: CGPoint(x: 0.47 * w, y: 0.30 * h))

        // Intraparietal sulcus
        p.move(to: CGPoint(x: 0.50 * w, y: 0.24 * h))
        p.addCurve(to: CGPoint(x: 0.70 * w, y: 0.28 * h), control1: CGPoint(x: 0.58 * w, y: 0.22 * h), control2: CGPoint(x: 0.65 * w, y: 0.24 * h))

        // Parieto-occipital sulcus
        p.move(to: CGPoint(x: 0.72 * w, y: 0.14 * h))
        p.addCurve(to: CGPoint(x: 0.68 * w, y: 0.44 * h), control1: CGPoint(x: 0.71 * w, y: 0.24 * h), control2: CGPoint(x: 0.69 * w, y: 0.36 * h))

        // Superior temporal sulcus
        p.move(to: CGPoint(x: 0.26 * w, y: 0.58 * h))
        p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.58 * h), control1: CGPoint(x: 0.36 * w, y: 0.55 * h), control2: CGPoint(x: 0.48 * w, y: 0.55 * h))

        return p
    }

    // MARK: - Medial Sulci

    static func medialSulci(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()

        // Cingulate sulcus
        p.move(to: CGPoint(x: 0.16 * w, y: 0.23 * h))
        p.addCurve(to: CGPoint(x: 0.67 * w, y: 0.23 * h), control1: CGPoint(x: 0.30 * w, y: 0.14 * h), control2: CGPoint(x: 0.57 * w, y: 0.15 * h))

        // Callosal sulcus
        p.move(to: CGPoint(x: 0.22 * w, y: 0.30 * h))
        p.addCurve(to: CGPoint(x: 0.61 * w, y: 0.32 * h), control1: CGPoint(x: 0.35 * w, y: 0.25 * h), control2: CGPoint(x: 0.52 * w, y: 0.27 * h))

        // Calcarine sulcus
        p.move(to: CGPoint(x: 0.63 * w, y: 0.35 * h))
        p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.44 * h), control1: CGPoint(x: 0.70 * w, y: 0.37 * h), control2: CGPoint(x: 0.77 * w, y: 0.41 * h))

        // Parieto-occipital sulcus
        p.move(to: CGPoint(x: 0.67 * w, y: 0.14 * h))
        p.addCurve(to: CGPoint(x: 0.66 * w, y: 0.36 * h), control1: CGPoint(x: 0.66 * w, y: 0.22 * h), control2: CGPoint(x: 0.66 * w, y: 0.30 * h))

        // Collateral sulcus
        p.move(to: CGPoint(x: 0.34 * w, y: 0.60 * h))
        p.addCurve(to: CGPoint(x: 0.61 * w, y: 0.67 * h), control1: CGPoint(x: 0.43 * w, y: 0.58 * h), control2: CGPoint(x: 0.53 * w, y: 0.61 * h))

        // Marginal ramus
        p.move(to: CGPoint(x: 0.48 * w, y: 0.20 * h))
        p.addCurve(to: CGPoint(x: 0.52 * w, y: 0.33 * h), control1: CGPoint(x: 0.50 * w, y: 0.24 * h), control2: CGPoint(x: 0.52 * w, y: 0.28 * h))

        return p
    }

    // MARK: - Lateral Minor Sulci (gyri fold detail)

    static func lateralSulciMinor(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()

        // Frontal gyri folds (superior, middle, inferior frontal gyri)
        p.move(to: CGPoint(x: 0.14 * w, y: 0.22 * h))
        p.addCurve(to: CGPoint(x: 0.30 * w, y: 0.18 * h), control1: CGPoint(x: 0.20 * w, y: 0.19 * h), control2: CGPoint(x: 0.26 * w, y: 0.17 * h))

        p.move(to: CGPoint(x: 0.12 * w, y: 0.28 * h))
        p.addCurve(to: CGPoint(x: 0.26 * w, y: 0.25 * h), control1: CGPoint(x: 0.17 * w, y: 0.26 * h), control2: CGPoint(x: 0.22 * w, y: 0.24 * h))

        p.move(to: CGPoint(x: 0.12 * w, y: 0.34 * h))
        p.addCurve(to: CGPoint(x: 0.28 * w, y: 0.30 * h), control1: CGPoint(x: 0.17 * w, y: 0.31 * h), control2: CGPoint(x: 0.23 * w, y: 0.29 * h))

        p.move(to: CGPoint(x: 0.10 * w, y: 0.42 * h))
        p.addCurve(to: CGPoint(x: 0.24 * w, y: 0.40 * h), control1: CGPoint(x: 0.15 * w, y: 0.40 * h), control2: CGPoint(x: 0.20 * w, y: 0.39 * h))

        p.move(to: CGPoint(x: 0.09 * w, y: 0.48 * h))
        p.addCurve(to: CGPoint(x: 0.20 * w, y: 0.46 * h), control1: CGPoint(x: 0.13 * w, y: 0.47 * h), control2: CGPoint(x: 0.17 * w, y: 0.46 * h))

        // Parietal gyri folds (postcentral, supramarginal detail)
        p.move(to: CGPoint(x: 0.52 * w, y: 0.12 * h))
        p.addCurve(to: CGPoint(x: 0.62 * w, y: 0.16 * h), control1: CGPoint(x: 0.56 * w, y: 0.12 * h), control2: CGPoint(x: 0.60 * w, y: 0.14 * h))

        p.move(to: CGPoint(x: 0.50 * w, y: 0.18 * h))
        p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.22 * h), control1: CGPoint(x: 0.54 * w, y: 0.18 * h), control2: CGPoint(x: 0.58 * w, y: 0.20 * h))

        p.move(to: CGPoint(x: 0.52 * w, y: 0.30 * h))
        p.addCurve(to: CGPoint(x: 0.64 * w, y: 0.34 * h), control1: CGPoint(x: 0.56 * w, y: 0.30 * h), control2: CGPoint(x: 0.61 * w, y: 0.32 * h))

        // Occipital gyri folds
        p.move(to: CGPoint(x: 0.76 * w, y: 0.28 * h))
        p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.36 * h), control1: CGPoint(x: 0.79 * w, y: 0.30 * h), control2: CGPoint(x: 0.81 * w, y: 0.33 * h))

        p.move(to: CGPoint(x: 0.74 * w, y: 0.38 * h))
        p.addCurve(to: CGPoint(x: 0.80 * w, y: 0.46 * h), control1: CGPoint(x: 0.77 * w, y: 0.40 * h), control2: CGPoint(x: 0.79 * w, y: 0.43 * h))

        p.move(to: CGPoint(x: 0.72 * w, y: 0.48 * h))
        p.addCurve(to: CGPoint(x: 0.78 * w, y: 0.52 * h), control1: CGPoint(x: 0.74 * w, y: 0.48 * h), control2: CGPoint(x: 0.77 * w, y: 0.50 * h))

        // Temporal gyri folds (superior, middle, inferior temporal gyri)
        p.move(to: CGPoint(x: 0.26 * w, y: 0.60 * h))
        p.addCurve(to: CGPoint(x: 0.50 * w, y: 0.58 * h), control1: CGPoint(x: 0.34 * w, y: 0.58 * h), control2: CGPoint(x: 0.44 * w, y: 0.57 * h))

        p.move(to: CGPoint(x: 0.26 * w, y: 0.66 * h))
        p.addCurve(to: CGPoint(x: 0.48 * w, y: 0.68 * h), control1: CGPoint(x: 0.34 * w, y: 0.65 * h), control2: CGPoint(x: 0.42 * w, y: 0.66 * h))

        p.move(to: CGPoint(x: 0.28 * w, y: 0.72 * h))
        p.addCurve(to: CGPoint(x: 0.44 * w, y: 0.74 * h), control1: CGPoint(x: 0.34 * w, y: 0.71 * h), control2: CGPoint(x: 0.40 * w, y: 0.72 * h))

        // Additional frontal detail sulci
        p.move(to: CGPoint(x: 0.16 * w, y: 0.18 * h))
        p.addCurve(to: CGPoint(x: 0.24 * w, y: 0.16 * h), control1: CGPoint(x: 0.19 * w, y: 0.16 * h), control2: CGPoint(x: 0.22 * w, y: 0.15 * h))

        p.move(to: CGPoint(x: 0.14 * w, y: 0.38 * h))
        p.addCurve(to: CGPoint(x: 0.22 * w, y: 0.36 * h), control1: CGPoint(x: 0.17 * w, y: 0.37 * h), control2: CGPoint(x: 0.20 * w, y: 0.36 * h))

        // Additional parietal detail sulci
        p.move(to: CGPoint(x: 0.54 * w, y: 0.16 * h))
        p.addCurve(to: CGPoint(x: 0.64 * w, y: 0.20 * h), control1: CGPoint(x: 0.58 * w, y: 0.16 * h), control2: CGPoint(x: 0.62 * w, y: 0.18 * h))

        p.move(to: CGPoint(x: 0.50 * w, y: 0.34 * h))
        p.addCurve(to: CGPoint(x: 0.58 * w, y: 0.38 * h), control1: CGPoint(x: 0.53 * w, y: 0.34 * h), control2: CGPoint(x: 0.56 * w, y: 0.36 * h))

        // Additional temporal detail sulci
        p.move(to: CGPoint(x: 0.24 * w, y: 0.54 * h))
        p.addCurve(to: CGPoint(x: 0.34 * w, y: 0.52 * h), control1: CGPoint(x: 0.28 * w, y: 0.53 * h), control2: CGPoint(x: 0.31 * w, y: 0.52 * h))

        p.move(to: CGPoint(x: 0.30 * w, y: 0.70 * h))
        p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.72 * h), control1: CGPoint(x: 0.34 * w, y: 0.69 * h), control2: CGPoint(x: 0.38 * w, y: 0.70 * h))

        // Additional occipital detail
        p.move(to: CGPoint(x: 0.76 * w, y: 0.24 * h))
        p.addCurve(to: CGPoint(x: 0.80 * w, y: 0.30 * h), control1: CGPoint(x: 0.78 * w, y: 0.26 * h), control2: CGPoint(x: 0.79 * w, y: 0.28 * h))

        p.move(to: CGPoint(x: 0.78 * w, y: 0.42 * h))
        p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.48 * h), control1: CGPoint(x: 0.80 * w, y: 0.44 * h), control2: CGPoint(x: 0.81 * w, y: 0.46 * h))

        // Cerebellar folia (densely packed horizontal folds — increased from 5 to 10)
        p.move(to: CGPoint(x: 0.60 * w, y: 0.64 * h))
        p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.65 * h), control1: CGPoint(x: 0.68 * w, y: 0.62 * h), control2: CGPoint(x: 0.76 * w, y: 0.63 * h))

        p.move(to: CGPoint(x: 0.60 * w, y: 0.66 * h))
        p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.67 * h), control1: CGPoint(x: 0.68 * w, y: 0.64 * h), control2: CGPoint(x: 0.76 * w, y: 0.65 * h))

        p.move(to: CGPoint(x: 0.59 * w, y: 0.68 * h))
        p.addCurve(to: CGPoint(x: 0.84 * w, y: 0.70 * h), control1: CGPoint(x: 0.67 * w, y: 0.66 * h), control2: CGPoint(x: 0.78 * w, y: 0.67 * h))

        p.move(to: CGPoint(x: 0.60 * w, y: 0.70 * h))
        p.addCurve(to: CGPoint(x: 0.84 * w, y: 0.72 * h), control1: CGPoint(x: 0.68 * w, y: 0.68 * h), control2: CGPoint(x: 0.78 * w, y: 0.69 * h))

        p.move(to: CGPoint(x: 0.58 * w, y: 0.72 * h))
        p.addCurve(to: CGPoint(x: 0.84 * w, y: 0.74 * h), control1: CGPoint(x: 0.66 * w, y: 0.70 * h), control2: CGPoint(x: 0.78 * w, y: 0.71 * h))

        p.move(to: CGPoint(x: 0.58 * w, y: 0.74 * h))
        p.addCurve(to: CGPoint(x: 0.84 * w, y: 0.76 * h), control1: CGPoint(x: 0.66 * w, y: 0.72 * h), control2: CGPoint(x: 0.78 * w, y: 0.73 * h))

        p.move(to: CGPoint(x: 0.57 * w, y: 0.76 * h))
        p.addCurve(to: CGPoint(x: 0.82 * w, y: 0.78 * h), control1: CGPoint(x: 0.65 * w, y: 0.74 * h), control2: CGPoint(x: 0.76 * w, y: 0.75 * h))

        p.move(to: CGPoint(x: 0.58 * w, y: 0.78 * h))
        p.addCurve(to: CGPoint(x: 0.80 * w, y: 0.80 * h), control1: CGPoint(x: 0.65 * w, y: 0.77 * h), control2: CGPoint(x: 0.74 * w, y: 0.78 * h))

        p.move(to: CGPoint(x: 0.59 * w, y: 0.80 * h))
        p.addCurve(to: CGPoint(x: 0.78 * w, y: 0.82 * h), control1: CGPoint(x: 0.65 * w, y: 0.79 * h), control2: CGPoint(x: 0.73 * w, y: 0.80 * h))

        p.move(to: CGPoint(x: 0.60 * w, y: 0.82 * h))
        p.addCurve(to: CGPoint(x: 0.76 * w, y: 0.84 * h), control1: CGPoint(x: 0.65 * w, y: 0.81 * h), control2: CGPoint(x: 0.72 * w, y: 0.82 * h))

        return p
    }

    // MARK: - Medial Minor Sulci

    static func medialSulciMinor(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()

        // Central sulcus medial continuation
        p.move(to: CGPoint(x: 0.40 * w, y: 0.07 * h))
        p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.20 * h), control1: CGPoint(x: 0.41 * w, y: 0.11 * h), control2: CGPoint(x: 0.42 * w, y: 0.16 * h))

        // Subparietal sulcus
        p.move(to: CGPoint(x: 0.52 * w, y: 0.18 * h))
        p.addCurve(to: CGPoint(x: 0.64 * w, y: 0.22 * h), control1: CGPoint(x: 0.56 * w, y: 0.17 * h), control2: CGPoint(x: 0.61 * w, y: 0.19 * h))

        // Paracentral sulcus
        p.move(to: CGPoint(x: 0.44 * w, y: 0.08 * h))
        p.addCurve(to: CGPoint(x: 0.46 * w, y: 0.16 * h), control1: CGPoint(x: 0.45 * w, y: 0.11 * h), control2: CGPoint(x: 0.46 * w, y: 0.14 * h))

        // Precuneal sulcus
        p.move(to: CGPoint(x: 0.56 * w, y: 0.10 * h))
        p.addCurve(to: CGPoint(x: 0.60 * w, y: 0.18 * h), control1: CGPoint(x: 0.57 * w, y: 0.13 * h), control2: CGPoint(x: 0.59 * w, y: 0.16 * h))

        // Cingulate detail fold
        p.move(to: CGPoint(x: 0.30 * w, y: 0.20 * h))
        p.addCurve(to: CGPoint(x: 0.42 * w, y: 0.18 * h), control1: CGPoint(x: 0.34 * w, y: 0.19 * h), control2: CGPoint(x: 0.38 * w, y: 0.17 * h))

        // Rhinal sulcus
        p.move(to: CGPoint(x: 0.30 * w, y: 0.58 * h))
        p.addCurve(to: CGPoint(x: 0.44 * w, y: 0.60 * h), control1: CGPoint(x: 0.35 * w, y: 0.57 * h), control2: CGPoint(x: 0.40 * w, y: 0.58 * h))

        // Hippocampal sulcus
        p.move(to: CGPoint(x: 0.42 * w, y: 0.62 * h))
        p.addCurve(to: CGPoint(x: 0.56 * w, y: 0.64 * h), control1: CGPoint(x: 0.46 * w, y: 0.61 * h), control2: CGPoint(x: 0.52 * w, y: 0.62 * h))

        // Cerebellar folia medial (increased from 3 to 7)
        p.move(to: CGPoint(x: 0.59 * w, y: 0.58 * h))
        p.addCurve(to: CGPoint(x: 0.80 * w, y: 0.62 * h), control1: CGPoint(x: 0.66 * w, y: 0.56 * h), control2: CGPoint(x: 0.74 * w, y: 0.58 * h))

        p.move(to: CGPoint(x: 0.59 * w, y: 0.62 * h))
        p.addCurve(to: CGPoint(x: 0.79 * w, y: 0.66 * h), control1: CGPoint(x: 0.66 * w, y: 0.60 * h), control2: CGPoint(x: 0.74 * w, y: 0.62 * h))

        p.move(to: CGPoint(x: 0.58 * w, y: 0.66 * h))
        p.addCurve(to: CGPoint(x: 0.80 * w, y: 0.70 * h), control1: CGPoint(x: 0.66 * w, y: 0.64 * h), control2: CGPoint(x: 0.74 * w, y: 0.66 * h))

        p.move(to: CGPoint(x: 0.58 * w, y: 0.70 * h))
        p.addCurve(to: CGPoint(x: 0.78 * w, y: 0.74 * h), control1: CGPoint(x: 0.65 * w, y: 0.68 * h), control2: CGPoint(x: 0.73 * w, y: 0.70 * h))

        p.move(to: CGPoint(x: 0.58 * w, y: 0.73 * h))
        p.addCurve(to: CGPoint(x: 0.76 * w, y: 0.76 * h), control1: CGPoint(x: 0.64 * w, y: 0.72 * h), control2: CGPoint(x: 0.72 * w, y: 0.73 * h))

        p.move(to: CGPoint(x: 0.59 * w, y: 0.76 * h))
        p.addCurve(to: CGPoint(x: 0.75 * w, y: 0.79 * h), control1: CGPoint(x: 0.64 * w, y: 0.74 * h), control2: CGPoint(x: 0.70 * w, y: 0.76 * h))

        p.move(to: CGPoint(x: 0.60 * w, y: 0.78 * h))
        p.addCurve(to: CGPoint(x: 0.73 * w, y: 0.80 * h), control1: CGPoint(x: 0.64 * w, y: 0.77 * h), control2: CGPoint(x: 0.70 * w, y: 0.78 * h))

        return p
    }
}
