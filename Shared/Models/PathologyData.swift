import Foundation

// MARK: - Content Reference Source

/// Identifies which authoritative reference a piece of content is sourced from.
enum ContentReference: String, Codable, CaseIterable {
    case dsm5        = "DSM-5-TR"
    case lezak       = "Neuropsychology"
    case brainImaging = "Neuroimaging"
    case neuroanatomy = "Neuroanatomy Reference"

    var sfSymbol: String {
        switch self {
        case .dsm5:         return "book.closed.fill"
        case .lezak:        return "brain.head.profile"
        case .brainImaging: return "waveform.path.ecg.rectangle"
        case .neuroanatomy: return "network"
        }
    }

    var shortLabel: String {
        switch self {
        case .dsm5:         return "DSM-5"
        case .lezak:        return "Neuropsych"
        case .brainImaging: return "Imaging"
        case .neuroanatomy: return "Neuroanat."
        }
    }
}

// MARK: - DSM-5 Diagnostic Criteria

/// Encodes DSM-5-TR diagnostic criteria for a mental disorder.
struct DSM5CriteriaData: Codable {
    /// Criterion A — specific signs/symptoms list
    let criterionA: [String]
    /// Minimum number of Criterion A symptoms required (nil if all required)
    let minimumSymptomCount: Int?
    /// Duration requirement, e.g. "≥2 weeks"
    let durationRequirement: String
    /// Criteria B–E (functional impairment, exclusions, specifiers combined)
    let criterionBCDE: String
    /// DSM-5 diagnostic specifiers
    let specifiers: [String]
    /// Epidemiological prevalence
    let prevalence: String
}

// MARK: - Pathology Model

struct Pathology: Identifiable, Codable {
    let id: String
    let name: String
    let category: PathologyCategory
    let clinicalPresentation: ClinicalPresentation
    let neuropsychProfile: NeuropsychProfile
    let neuroimaging: NeuroimagingFindings
    let relatedStructures: [String] // BrainStructure IDs
    let epidemiology: String
    let etiology: String
    /// DSM-5 diagnostic criteria — present for psychiatric/neurodevelopmental disorders
    let dsm5Criteria: DSM5CriteriaData?

    init(id: String, name: String, category: PathologyCategory,
         clinicalPresentation: ClinicalPresentation, neuropsychProfile: NeuropsychProfile,
         neuroimaging: NeuroimagingFindings, relatedStructures: [String],
         epidemiology: String, etiology: String, dsm5Criteria: DSM5CriteriaData? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.clinicalPresentation = clinicalPresentation
        self.neuropsychProfile = neuropsychProfile
        self.neuroimaging = neuroimaging
        self.relatedStructures = relatedStructures
        self.epidemiology = epidemiology
        self.etiology = etiology
        self.dsm5Criteria = dsm5Criteria
    }
}

enum PathologyCategory: String, Codable, CaseIterable, Identifiable {
    case neurodegenerative = "Neurodegenerative"
    case vascular = "Vascular"
    case developmental = "Developmental"
    case psychiatric = "Psychiatric"
    case traumatic = "Traumatic"
    case neoplastic = "Neoplastic"
    case infectious = "Infectious"
    case autoimmune = "Autoimmune"
    case metabolic = "Metabolic"
    case epileptic = "Epileptic"
    case movement = "Movement Disorder"
    case syndromic = "Neurological Syndrome"

    var id: String { rawValue }

    var sfSymbol: String {
        switch self {
        case .neurodegenerative: return "brain"
        case .vascular: return "heart.fill"
        case .developmental: return "figure.child"
        case .psychiatric: return "person.fill.questionmark"
        case .traumatic: return "bolt.fill"
        case .neoplastic: return "staroflife.fill"
        case .infectious: return "microbe.fill"
        case .autoimmune: return "shield.lefthalf.filled"
        case .metabolic: return "atom"
        case .epileptic: return "waveform.path.ecg"
        case .movement: return "figure.walk"
        case .syndromic: return "list.clipboard.fill"
        }
    }
}

// MARK: - Clinical Presentation

struct ClinicalPresentation: Codable {
    let signsAndSymptoms: [String]
    let observableBehaviors: [String]
    let onset: String
    let progression: String
}

// MARK: - Neuropsych Profile

struct NeuropsychProfile: Codable {
    let cognitiveDomainsAffected: [CognitiveDomain]
    let expectedTestPatterns: [String]
    let preservedFunctions: [String]
    let differentialConsiderations: [String]
}

struct CognitiveDomain: Codable {
    let domain: String
    let severity: CognitiveSeverity
    let description: String
}

enum CognitiveSeverity: String, Codable {
    case minimal = "Minimal"
    case mild = "Mild"
    case moderate = "Moderate"
    case severe = "Severe"
    case variable = "Variable"
}

// MARK: - Neuroimaging

struct NeuroimagingFindings: Codable {
    let mri: [String]
    let ct: [String]
    let pet: [String]
    let otherModalities: [ImagingFinding]
}

struct ImagingFinding: Codable {
    let modality: String
    let findings: [String]
}
