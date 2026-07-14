import Foundation

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

enum SpacedRepetitionGrade: Int, CaseIterable {
    case again = 0
    case hard = 3
    case good = 4
    case easy = 5

    var label: String {
        switch self {
        case .again: return "Again"
        case .hard: return "Hard"
        case .good: return "Good"
        case .easy: return "Easy"
        }
    }

    var sfSymbol: String {
        switch self {
        case .again: return "arrow.counterclockwise"
        case .hard: return "tortoise.fill"
        case .good: return "checkmark"
        case .easy: return "bolt.fill"
        }
    }
}

struct SpacedRepetitionEngine {
    /// Longest gap we will ever schedule. Without a ceiling the SM-2 multiplication
    /// runs away: at the default ease factor of 2.5 a card reaches ~8,982 days after
    /// only ten correct answers (effectively retiring it forever), and overflows Int
    /// — trapping at runtime — after roughly forty-five. A year is long enough to be
    /// a real "you know this" interval and short enough that the card comes back.
    static let maximumIntervalDays = 365

    /// SM-2's ease factor has a documented floor of 1.3 but no upper bound. Cap it so
    /// repeated "easy" grades cannot compound the interval growth without limit.
    static let maximumEaseFactor = 2.5

    static func update(_ progress: inout StudyProgress, grade: SpacedRepetitionGrade) {
        let q = Double(grade.rawValue)

        if grade == .again {
            progress.repetitions = 0
            progress.interval = 1
            progress.streakCurrent = 0
        } else {
            if progress.repetitions == 0 {
                progress.interval = 1
            } else if progress.repetitions == 1 {
                progress.interval = 6
            } else {
                let grown = (Double(progress.interval) * progress.easeFactor)
                    .rounded()
                    .clamped(to: 1...Double(maximumIntervalDays))
                progress.interval = Int(grown)
            }
            progress.repetitions += 1
            progress.correctAttempts += 1
            progress.streakCurrent += 1
            progress.streakBest = max(progress.streakBest, progress.streakCurrent)
        }

        // SM-2 ease factor update
        let newEF = progress.easeFactor + (0.1 - (5.0 - q) * (0.08 + (5.0 - q) * 0.02))
        progress.easeFactor = newEF.clamped(to: 1.3...maximumEaseFactor)

        progress.nextReviewDate = Calendar.current.date(
            byAdding: .day, value: progress.interval, to: .now) ?? .now
        progress.totalAttempts += 1
        progress.lastStudied = .now
    }

    static func updateFromQuiz(_ progress: inout StudyProgress, isCorrect: Bool) {
        let grade: SpacedRepetitionGrade = isCorrect ? .good : .again
        update(&progress, grade: grade)
    }

    static func prioritize(_ structures: [BrainStructure], using progressMap: [String: StudyProgress]) -> [BrainStructure] {
        structures.sorted { a, b in
            let pa = progressMap[a.id] ?? StudyProgress(structureID: a.id)
            let pb = progressMap[b.id] ?? StudyProgress(structureID: b.id)

            // Due items first
            if pa.isDueForReview != pb.isDueForReview {
                return pa.isDueForReview
            }
            // Then by lowest ease factor (hardest)
            if pa.easeFactor != pb.easeFactor {
                return pa.easeFactor < pb.easeFactor
            }
            // Then by fewest repetitions (least studied)
            return pa.repetitions < pb.repetitions
        }
    }
}
