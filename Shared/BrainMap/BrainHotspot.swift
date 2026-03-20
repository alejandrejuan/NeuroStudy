import SwiftUI

struct BrainHotspot: Identifiable {
    let id: String
    let structureID: String
    let view: DiagramView
    let zIndex: Int
    let labelAnchor: CGPoint  // normalized 0...1

    func path(in rect: CGRect) -> Path {
        BrainPathData.path(for: structureID, view: view, in: rect)
    }

    func contains(point: CGPoint, in rect: CGRect) -> Bool {
        path(in: rect).contains(point)
    }
}

// MARK: - Hotspot Registry

struct BrainHotspotRegistry {
    static let lateral: [BrainHotspot] = [
        // Frontal Lobe structures (lateral view)
        BrainHotspot(id: "lat-prefrontal", structureID: "prefrontal-cortex", view: .lateral, zIndex: 1, labelAnchor: CGPoint(x: 0.15, y: 0.30)),
        BrainHotspot(id: "lat-motor", structureID: "primary-motor-cortex", view: .lateral, zIndex: 2, labelAnchor: CGPoint(x: 0.38, y: 0.15)),
        BrainHotspot(id: "lat-premotor", structureID: "premotor-cortex", view: .lateral, zIndex: 2, labelAnchor: CGPoint(x: 0.30, y: 0.18)),
        BrainHotspot(id: "lat-broca", structureID: "brocas-area", view: .lateral, zIndex: 3, labelAnchor: CGPoint(x: 0.18, y: 0.55)),
        BrainHotspot(id: "lat-fef", structureID: "frontal-eye-fields", view: .lateral, zIndex: 3, labelAnchor: CGPoint(x: 0.25, y: 0.22)),

        // Parietal Lobe structures (lateral view)
        BrainHotspot(id: "lat-somatosensory", structureID: "primary-somatosensory-cortex", view: .lateral, zIndex: 2, labelAnchor: CGPoint(x: 0.45, y: 0.15)),
        BrainHotspot(id: "lat-spl", structureID: "parietal-superior", view: .lateral, zIndex: 1, labelAnchor: CGPoint(x: 0.55, y: 0.18)),
        BrainHotspot(id: "lat-ipl", structureID: "parietal-inferior", view: .lateral, zIndex: 2, labelAnchor: CGPoint(x: 0.55, y: 0.35)),
        BrainHotspot(id: "lat-angular", structureID: "angular-gyrus", view: .lateral, zIndex: 3, labelAnchor: CGPoint(x: 0.62, y: 0.38)),

        // Temporal Lobe structures (lateral view)
        BrainHotspot(id: "lat-auditory", structureID: "primary-auditory-cortex", view: .lateral, zIndex: 3, labelAnchor: CGPoint(x: 0.40, y: 0.55)),
        BrainHotspot(id: "lat-wernicke", structureID: "wernickes-area", view: .lateral, zIndex: 3, labelAnchor: CGPoint(x: 0.52, y: 0.52)),
        BrainHotspot(id: "lat-sts", structureID: "superior-temporal-sulcus", view: .lateral, zIndex: 2, labelAnchor: CGPoint(x: 0.45, y: 0.60)),
        BrainHotspot(id: "lat-it", structureID: "inferior-temporal-cortex", view: .lateral, zIndex: 1, labelAnchor: CGPoint(x: 0.38, y: 0.72)),

        // Occipital Lobe structures (lateral view)
        BrainHotspot(id: "lat-visual-assoc", structureID: "visual-association", view: .lateral, zIndex: 1, labelAnchor: CGPoint(x: 0.78, y: 0.35)),

        // Cerebellum (lateral view)
        BrainHotspot(id: "lat-cerebellum", structureID: "cerebellum", view: .lateral, zIndex: 0, labelAnchor: CGPoint(x: 0.75, y: 0.72)),

        // New lateral structures
        BrainHotspot(id: "lat-insula", structureID: "insula", view: .lateral, zIndex: 4, labelAnchor: CGPoint(x: 0.36, y: 0.44)),
        BrainHotspot(id: "lat-supramarginal", structureID: "supramarginal-gyrus", view: .lateral, zIndex: 2, labelAnchor: CGPoint(x: 0.63, y: 0.38)),
        BrainHotspot(id: "lat-mfg", structureID: "middle-frontal-gyrus", view: .lateral, zIndex: 1, labelAnchor: CGPoint(x: 0.20, y: 0.30)),
        BrainHotspot(id: "lat-sfg", structureID: "superior-frontal-gyrus", view: .lateral, zIndex: 1, labelAnchor: CGPoint(x: 0.21, y: 0.16)),
        BrainHotspot(id: "lat-mtg", structureID: "middle-temporal-gyrus", view: .lateral, zIndex: 2, labelAnchor: CGPoint(x: 0.40, y: 0.58)),
    ]

    static let medial: [BrainHotspot] = [
        // Limbic structures
        BrainHotspot(id: "med-hippocampus", structureID: "hippocampus", view: .medial, zIndex: 3, labelAnchor: CGPoint(x: 0.48, y: 0.65)),
        BrainHotspot(id: "med-amygdala", structureID: "amygdala", view: .medial, zIndex: 3, labelAnchor: CGPoint(x: 0.35, y: 0.62)),
        BrainHotspot(id: "med-cingulate", structureID: "cingulate-cortex", view: .medial, zIndex: 2, labelAnchor: CGPoint(x: 0.40, y: 0.25)),
        BrainHotspot(id: "med-fornix", structureID: "fornix", view: .medial, zIndex: 3, labelAnchor: CGPoint(x: 0.42, y: 0.38)),
        BrainHotspot(id: "med-mammillary", structureID: "mammillary-bodies", view: .medial, zIndex: 4, labelAnchor: CGPoint(x: 0.40, y: 0.68)),

        // Frontal (medial)
        BrainHotspot(id: "med-sma", structureID: "supplementary-motor-area", view: .medial, zIndex: 2, labelAnchor: CGPoint(x: 0.32, y: 0.12)),
        BrainHotspot(id: "med-ofc", structureID: "orbitofrontal-cortex", view: .medial, zIndex: 2, labelAnchor: CGPoint(x: 0.15, y: 0.58)),

        // Occipital (medial)
        BrainHotspot(id: "med-v1", structureID: "primary-visual-cortex", view: .medial, zIndex: 2, labelAnchor: CGPoint(x: 0.82, y: 0.38)),
        BrainHotspot(id: "med-cuneus", structureID: "cuneus-lingual", view: .medial, zIndex: 1, labelAnchor: CGPoint(x: 0.80, y: 0.28)),

        // Temporal (medial)
        BrainHotspot(id: "med-fusiform", structureID: "fusiform-gyrus", view: .medial, zIndex: 2, labelAnchor: CGPoint(x: 0.55, y: 0.75)),

        // Basal Ganglia
        BrainHotspot(id: "med-caudate", structureID: "basal-ganglia-caudate", view: .medial, zIndex: 3, labelAnchor: CGPoint(x: 0.38, y: 0.35)),
        BrainHotspot(id: "med-putamen", structureID: "basal-ganglia-putamen", view: .medial, zIndex: 3, labelAnchor: CGPoint(x: 0.42, y: 0.42)),
        BrainHotspot(id: "med-gp", structureID: "globus-pallidus", view: .medial, zIndex: 4, labelAnchor: CGPoint(x: 0.40, y: 0.48)),

        // Diencephalon
        BrainHotspot(id: "med-thalamus", structureID: "thalamus", view: .medial, zIndex: 2, labelAnchor: CGPoint(x: 0.48, y: 0.40)),
        BrainHotspot(id: "med-hypothalamus", structureID: "hypothalamus", view: .medial, zIndex: 3, labelAnchor: CGPoint(x: 0.38, y: 0.55)),
        BrainHotspot(id: "med-pineal", structureID: "pineal-gland", view: .medial, zIndex: 4, labelAnchor: CGPoint(x: 0.58, y: 0.38)),

        // Brainstem
        BrainHotspot(id: "med-midbrain", structureID: "midbrain", view: .medial, zIndex: 1, labelAnchor: CGPoint(x: 0.52, y: 0.58)),
        BrainHotspot(id: "med-pons", structureID: "brainstem-pons", view: .medial, zIndex: 1, labelAnchor: CGPoint(x: 0.52, y: 0.68)),
        BrainHotspot(id: "med-medulla", structureID: "medulla", view: .medial, zIndex: 1, labelAnchor: CGPoint(x: 0.52, y: 0.78)),
        BrainHotspot(id: "med-reticular", structureID: "reticular-formation", view: .medial, zIndex: 2, labelAnchor: CGPoint(x: 0.50, y: 0.65)),

        // White matter
        BrainHotspot(id: "med-cc", structureID: "corpus-callosum", view: .medial, zIndex: 1, labelAnchor: CGPoint(x: 0.45, y: 0.28)),

        // Cerebellum
        BrainHotspot(id: "med-cerebellum", structureID: "cerebellum", view: .medial, zIndex: 0, labelAnchor: CGPoint(x: 0.72, y: 0.65)),

        // New medial structures
        BrainHotspot(id: "med-precuneus", structureID: "precuneus", view: .medial, zIndex: 1, labelAnchor: CGPoint(x: 0.59, y: 0.12)),
        BrainHotspot(id: "med-paracentral", structureID: "paracentral-lobule", view: .medial, zIndex: 2, labelAnchor: CGPoint(x: 0.45, y: 0.10)),
        BrainHotspot(id: "med-entorhinal", structureID: "entorhinal-cortex", view: .medial, zIndex: 3, labelAnchor: CGPoint(x: 0.37, y: 0.58)),
        BrainHotspot(id: "med-parahippocampal", structureID: "parahippocampal-gyrus", view: .medial, zIndex: 2, labelAnchor: CGPoint(x: 0.47, y: 0.68)),
        BrainHotspot(id: "med-nac", structureID: "nucleus-accumbens", view: .medial, zIndex: 5, labelAnchor: CGPoint(x: 0.34, y: 0.42)),
        BrainHotspot(id: "med-sn", structureID: "substantia-nigra", view: .medial, zIndex: 4, labelAnchor: CGPoint(x: 0.50, y: 0.54)),
        BrainHotspot(id: "med-sc", structureID: "superior-colliculus", view: .medial, zIndex: 5, labelAnchor: CGPoint(x: 0.56, y: 0.48)),
        BrainHotspot(id: "med-ic", structureID: "inferior-colliculus", view: .medial, zIndex: 5, labelAnchor: CGPoint(x: 0.58, y: 0.51)),
        BrainHotspot(id: "med-septal", structureID: "septal-nuclei", view: .medial, zIndex: 4, labelAnchor: CGPoint(x: 0.26, y: 0.36)),
        BrainHotspot(id: "med-optic-chiasm", structureID: "optic-chiasm", view: .medial, zIndex: 5, labelAnchor: CGPoint(x: 0.34, y: 0.58)),
        BrainHotspot(id: "med-ac", structureID: "anterior-commissure", view: .medial, zIndex: 4, labelAnchor: CGPoint(x: 0.30, y: 0.42)),
        BrainHotspot(id: "med-ventricle", structureID: "lateral-ventricle", view: .medial, zIndex: 0, labelAnchor: CGPoint(x: 0.45, y: 0.38)),
    ]

    static func hotspots(for view: DiagramView) -> [BrainHotspot] {
        switch view {
        case .lateral: return lateral
        case .medial: return medial
        case .both: return lateral + medial
        }
    }
}
