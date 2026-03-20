import Foundation

enum MasteryLevel: String, Codable, CaseIterable {
    case new = "New"
    case learning = "Learning"
    case struggling = "Struggling"
    case reviewing = "Reviewing"
    case mastered = "Mastered"

    var sfSymbol: String {
        switch self {
        case .new: return "sparkle"
        case .learning: return "book.fill"
        case .struggling: return "exclamationmark.triangle.fill"
        case .reviewing: return "arrow.counterclockwise"
        case .mastered: return "star.fill"
        }
    }

    var color: String {
        switch self {
        case .new: return "gray"
        case .learning: return "blue"
        case .struggling: return "red"
        case .reviewing: return "orange"
        case .mastered: return "green"
        }
    }
}

struct StudyProgress: Codable, Identifiable {
    let structureID: String
    var id: String { structureID }

    var easeFactor: Double = 2.5
    var interval: Int = 1
    var repetitions: Int = 0
    var nextReviewDate: Date = .now

    var totalAttempts: Int = 0
    var correctAttempts: Int = 0
    var streakCurrent: Int = 0
    var streakBest: Int = 0
    var lastStudied: Date?

    var accuracy: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(correctAttempts) / Double(totalAttempts)
    }

    var masteryLevel: MasteryLevel {
        if repetitions == 0 && totalAttempts == 0 { return .new }
        if repetitions == 0 { return .struggling }
        if accuracy < 0.6 { return .struggling }
        if repetitions <= 2 { return .learning }
        if repetitions <= 5 || accuracy < 0.8 { return .reviewing }
        return .mastered
    }

    var isDueForReview: Bool {
        nextReviewDate <= .now
    }
}
