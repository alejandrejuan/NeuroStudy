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

    /// Ten hues spaced around the wheel so no two regions read alike, at a saturation
    /// that stays anatomical on the brain map and clean as an icon tint. (Temporal and
    /// limbic used to share a yellow.) These tint icons and map fills, never body text.
    var color: Color {
        switch self {
        case .limbicSystem: return Color(red: 0.96, green: 0.42, blue: 0.40)    // Coral, 0°
        case .brainstem: return Color(red: 0.98, green: 0.60, blue: 0.28)       // Orange, 28°
        case .temporalLobe: return Color(red: 0.97, green: 0.78, blue: 0.24)    // Yellow, 45°
        case .occipitalLobe: return Color(red: 0.30, green: 0.78, blue: 0.48)   // Green, 140°
        case .diencephalon: return Color(red: 0.22, green: 0.74, blue: 0.78)    // Teal, 183°
        case .frontalLobe: return Color(red: 0.30, green: 0.60, blue: 0.98)     // Blue, 215°
        case .basalGanglia: return Color(red: 0.44, green: 0.44, blue: 0.94)    // Indigo, 240°
        case .parietalLobe: return Color(red: 0.68, green: 0.46, blue: 0.94)    // Purple, 268°
        case .cerebellum: return Color(red: 0.94, green: 0.44, blue: 0.70)      // Pink, 325°
        case .whiteTracts: return Color(red: 0.62, green: 0.64, blue: 0.70)     // Graphite
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
