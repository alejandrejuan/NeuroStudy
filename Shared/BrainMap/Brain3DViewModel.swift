import SwiftUI
import SceneKit

// MARK: - Brain 3D View Model

@Observable
class Brain3DViewModel {
    var selectedID: String?
    var highlightedIDs: Set<String> = []
    var isQuizMode: Bool = false
    var quizTargetID: String?
    var showLabels: Bool = true

    var selectedStructure: BrainStructure? {
        guard let id = selectedID else { return nil }
        return BrainStructureStore.structure(byID: id)
    }

    func select(_ structureID: String) {
        if selectedID == structureID {
            selectedID = nil
            highlightedIDs = []
        } else {
            selectedID = structureID
            if let structure = BrainStructureStore.structure(byID: structureID) {
                highlightedIDs = Set(structure.connections)
            }
        }
    }

    func clearSelection() {
        selectedID = nil
        highlightedIDs = []
    }

    func enterQuizMode(targetID: String) {
        isQuizMode = true
        quizTargetID = targetID
        selectedID = nil
        highlightedIDs = []
        showLabels = false
    }

    func exitQuizMode() {
        isQuizMode = false
        quizTargetID = nil
        showLabels = true
    }

    func checkQuizTap(_ structureID: String) -> Bool {
        structureID == quizTargetID
    }
}

// MARK: - 3D Anatomical Positions

struct Brain3DPositions {
    /// Approximate anatomical positions in SceneKit coordinate space.
    /// X: left(−)/right(+), Y: inferior(−)/superior(+), Z: posterior(−)/anterior(+)
    static let positions: [String: SCNVector3] = [
        // Frontal Lobe
        "prefrontal-cortex":         SCNVector3(-0.45, 0.15, 0.85),
        "primary-motor-cortex":      SCNVector3(-0.48, 0.72, 0.28),
        "premotor-cortex":           SCNVector3(-0.47, 0.56, 0.42),
        "supplementary-motor-area":  SCNVector3( 0.00, 0.72, 0.35),
        "brocas-area":               SCNVector3(-0.62, 0.08, 0.52),
        "frontal-eye-fields":        SCNVector3(-0.48, 0.40, 0.50),
        "orbitofrontal-cortex":      SCNVector3(-0.38, -0.18, 0.80),
        "superior-frontal-gyrus":    SCNVector3(-0.30, 0.78, 0.55),
        "middle-frontal-gyrus":      SCNVector3(-0.50, 0.45, 0.62),

        // Parietal Lobe
        "primary-somatosensory-cortex": SCNVector3(-0.48, 0.82, 0.10),
        "parietal-superior":            SCNVector3(-0.40, 0.88, -0.22),
        "parietal-inferior":            SCNVector3(-0.58, 0.60, -0.12),
        "angular-gyrus":                SCNVector3(-0.62, 0.42, -0.30),
        "supramarginal-gyrus":          SCNVector3(-0.65, 0.52, -0.10),
        "precuneus":                    SCNVector3( 0.00, 0.88, -0.40),
        "paracentral-lobule":           SCNVector3( 0.00, 0.92, 0.02),

        // Temporal Lobe
        "primary-auditory-cortex":      SCNVector3(-0.82, 0.08, 0.10),
        "wernickes-area":               SCNVector3(-0.78, 0.08, -0.18),
        "fusiform-gyrus":               SCNVector3(-0.48, -0.48, -0.18),
        "superior-temporal-sulcus":     SCNVector3(-0.80, -0.02, 0.02),
        "inferior-temporal-cortex":     SCNVector3(-0.58, -0.40, -0.08),
        "middle-temporal-gyrus":        SCNVector3(-0.72, 0.02, -0.10),
        "entorhinal-cortex":            SCNVector3(-0.42, -0.42, 0.18),
        "parahippocampal-gyrus":        SCNVector3(-0.38, -0.52, -0.08),

        // Occipital Lobe
        "primary-visual-cortex":        SCNVector3( 0.00, 0.18, -0.92),
        "visual-association":           SCNVector3(-0.38, 0.28, -0.82),
        "cuneus-lingual":               SCNVector3(-0.18, 0.22, -0.88),

        // Limbic System
        "hippocampus":                  SCNVector3(-0.48, -0.28, -0.18),
        "amygdala":                     SCNVector3(-0.55, -0.22, 0.18),
        "cingulate-cortex":             SCNVector3( 0.00, 0.48, 0.18),
        "fornix":                       SCNVector3( 0.00, 0.12, 0.02),
        "mammillary-bodies":            SCNVector3( 0.00, -0.50, 0.22),
        "nucleus-accumbens":            SCNVector3(-0.22, -0.10, 0.48),
        "septal-nuclei":                SCNVector3( 0.00, 0.02, 0.48),
        "insula":                       SCNVector3(-0.88, 0.28, 0.18),

        // Basal Ganglia
        "basal-ganglia-caudate":        SCNVector3(-0.22, 0.20, 0.28),
        "basal-ganglia-putamen":        SCNVector3(-0.38, 0.02, 0.18),
        "globus-pallidus":              SCNVector3(-0.32, 0.02, 0.10),

        // Diencephalon
        "thalamus":                     SCNVector3( 0.00, 0.02, 0.00),
        "hypothalamus":                 SCNVector3( 0.00, -0.38, 0.28),
        "pineal-gland":                 SCNVector3( 0.00, -0.08, -0.28),
        "optic-chiasm":                 SCNVector3( 0.00, -0.58, 0.28),

        // Brainstem
        "midbrain":                     SCNVector3( 0.00, -0.72, -0.10),
        "brainstem-pons":               SCNVector3( 0.00, -0.92, -0.08),
        "medulla":                      SCNVector3( 0.00, -1.12, -0.08),
        "reticular-formation":          SCNVector3( 0.00, -0.88, -0.10),
        "substantia-nigra":             SCNVector3( 0.00, -0.72, -0.18),
        "superior-colliculus":          SCNVector3( 0.00, -0.65, -0.28),
        "inferior-colliculus":          SCNVector3( 0.00, -0.70, -0.32),

        // Cerebellum
        "cerebellum":                   SCNVector3( 0.00, -0.88, -0.68),

        // White Matter
        "corpus-callosum":              SCNVector3( 0.00, 0.30, 0.08),
        "anterior-commissure":          SCNVector3( 0.00, -0.08, 0.38),
        "lateral-ventricle":            SCNVector3(-0.22, 0.18, 0.02),
    ]

    static func position(for structureID: String) -> SCNVector3 {
        positions[structureID] ?? SCNVector3(0, 0, 0)
    }
}
