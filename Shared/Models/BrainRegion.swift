import SwiftUI

enum BrainRegion: String, Codable, CaseIterable, Identifiable {
    case frontalLobe
    case parietalLobe
    case temporalLobe
    case occipitalLobe
    case cerebellum
    case brainstem
    case limbicSystem
    case basalGanglia
    case diencephalon
    case whiteTracts

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .frontalLobe: return "Frontal Lobe"
        case .parietalLobe: return "Parietal Lobe"
        case .temporalLobe: return "Temporal Lobe"
        case .occipitalLobe: return "Occipital Lobe"
        case .cerebellum: return "Cerebellum"
        case .brainstem: return "Brainstem"
        case .limbicSystem: return "Limbic System"
        case .basalGanglia: return "Basal Ganglia"
        case .diencephalon: return "Diencephalon"
        case .whiteTracts: return "White Matter Tracts"
        }
    }

    var color: Color {
        switch self {
        case .frontalLobe: return Color(red: 0.55, green: 0.72, blue: 0.92)     // Soft blue
        case .parietalLobe: return Color(red: 0.76, green: 0.60, blue: 0.85)     // Soft purple
        case .temporalLobe: return Color(red: 0.95, green: 0.82, blue: 0.40)     // Warm yellow
        case .occipitalLobe: return Color(red: 0.55, green: 0.82, blue: 0.58)    // Soft green
        case .cerebellum: return Color(red: 0.90, green: 0.62, blue: 0.68)       // Soft pink
        case .brainstem: return Color(red: 0.95, green: 0.72, blue: 0.45)        // Soft orange
        case .limbicSystem: return Color(red: 0.95, green: 0.80, blue: 0.45)     // Golden yellow
        case .basalGanglia: return Color(red: 0.82, green: 0.52, blue: 0.52)     // Muted rose
        case .diencephalon: return Color(red: 0.58, green: 0.78, blue: 0.82)     // Teal
        case .whiteTracts: return Color(red: 0.88, green: 0.88, blue: 0.92)      // Light gray
        }
    }

    var sfSymbol: String {
        switch self {
        case .frontalLobe: return "brain.head.profile"
        case .parietalLobe: return "hand.raised.fill"
        case .temporalLobe: return "ear.fill"
        case .occipitalLobe: return "eye.fill"
        case .cerebellum: return "figure.walk"
        case .brainstem: return "heart.fill"
        case .limbicSystem: return "face.smiling.inverse"
        case .basalGanglia: return "arrow.triangle.2.circlepath"
        case .diencephalon: return "thermometer.medium"
        case .whiteTracts: return "cable.connector.horizontal"
        }
    }

    var shortDescription: String {
        switch self {
        case .frontalLobe: return "Executive function, motor control, and personality"
        case .parietalLobe: return "Sensory processing and spatial awareness"
        case .temporalLobe: return "Auditory processing, language, and memory"
        case .occipitalLobe: return "Visual processing and perception"
        case .cerebellum: return "Motor coordination and balance"
        case .brainstem: return "Vital functions and consciousness"
        case .limbicSystem: return "Emotion, memory, and motivation"
        case .basalGanglia: return "Movement regulation and habit learning"
        case .diencephalon: return "Sensory relay and homeostasis"
        case .whiteTracts: return "Interhemispheric communication"
        }
    }
}
