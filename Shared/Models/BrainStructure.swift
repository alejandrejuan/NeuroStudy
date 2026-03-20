import Foundation

enum Lateralization: String, Codable {
    case bilateral
    case leftDominant
    case rightDominant
}

enum DiagramView: String, Codable {
    case lateral
    case medial
    case both
}

struct BrainStructure: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let region: BrainRegion
    let aliases: [String]
    let description: String
    let functions: [String]
    let clinicalSignificance: String
    let associatedDisorders: [String]
    let connections: [String]
    let brodmannAreas: [Int]?
    let lateralization: Lateralization
    let diagramView: DiagramView

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: BrainStructure, rhs: BrainStructure) -> Bool {
        lhs.id == rhs.id
    }
}
