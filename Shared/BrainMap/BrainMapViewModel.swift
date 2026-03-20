import SwiftUI

enum StructureRenderStyle {
    case standard
    case ventricle
    case whiteMatter
    case nerve
}

@Observable
class BrainMapViewModel {
    var currentView: DiagramView = .lateral
    var selectedID: String?
    var highlightedIDs: Set<String> = []
    var hoveredID: String?
    var isQuizMode: Bool = false
    var quizTargetID: String?
    var showLabels: Bool = true

    var selectedStructure: BrainStructure? {
        guard let id = selectedID else { return nil }
        return BrainStructureStore.structure(byID: id)
    }

    var currentHotspots: [BrainHotspot] {
        BrainHotspotRegistry.hotspots(for: currentView)
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

    func hover(_ structureID: String, isHovering: Bool) {
        hoveredID = isHovering ? structureID : nil
    }

    func toggleView() {
        currentView = currentView == .lateral ? .medial : .lateral
        clearSelection()
    }

    // Quiz mode
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
        return structureID == quizTargetID
    }

    func fillColor(for hotspot: BrainHotspot, isSelected: Bool, isHighlighted: Bool) -> Color {
        if isQuizMode {
            return regionColor(for: hotspot.structureID).opacity(0.15)
        }
        if isSelected {
            return regionColor(for: hotspot.structureID).opacity(0.5)
        }
        if isHighlighted {
            return regionColor(for: hotspot.structureID).opacity(0.35)
        }
        if hotspot.id == hoveredID ?? "" {
            return regionColor(for: hotspot.structureID).opacity(0.3)
        }
        return regionColor(for: hotspot.structureID).opacity(0.2)
    }

    func strokeColor(for hotspot: BrainHotspot, isSelected: Bool) -> Color {
        if isSelected {
            return regionColor(for: hotspot.structureID)
        }
        return regionColor(for: hotspot.structureID).opacity(0.5)
    }

    func strokeWidth(for hotspot: BrainHotspot, isSelected: Bool) -> CGFloat {
        isSelected ? 2.5 : 0.5
    }

    // MARK: - Gradient Helpers

    func regionBaseColor(for structureID: String) -> Color {
        regionColor(for: structureID)
    }

    func regionOpacity(for structureID: String, isSelected: Bool, isHighlighted: Bool) -> (top: Double, bottom: Double) {
        if isQuizMode {
            return (0.30, 0.18)
        }
        if isSelected {
            return (0.85, 0.65)
        }
        if isHighlighted {
            return (0.60, 0.42)
        }
        if structureID == hoveredID ?? "" {
            return (0.55, 0.38)
        }
        return (0.50, 0.35)
    }

    func renderingStyle(for structureID: String) -> StructureRenderStyle {
        switch structureID {
        case "lateral-ventricle":
            return .ventricle
        case "corpus-callosum", "anterior-commissure":
            return .whiteMatter
        case "optic-chiasm":
            return .nerve
        default:
            return .standard
        }
    }

    private func regionColor(for structureID: String) -> Color {
        BrainStructureStore.structure(byID: structureID)?.region.color ?? .gray
    }
}
