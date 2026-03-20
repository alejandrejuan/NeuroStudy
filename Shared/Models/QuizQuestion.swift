import Foundation

// MARK: - Quiz Mode

enum QuizMode: String, CaseIterable, Identifiable {
    case tapIdentify    = "Tap to Identify"
    case flashcard      = "Flashcards"
    case multipleChoice = "Multiple Choice"

    var id: String { rawValue }

    var sfSymbol: String {
        switch self {
        case .tapIdentify:    return "hand.tap.fill"
        case .flashcard:      return "rectangle.on.rectangle.angled"
        case .multipleChoice: return "list.bullet.rectangle.fill"
        }
    }

    var description: String {
        switch self {
        case .tapIdentify:    return "Tap the correct brain region on the 3D model"
        case .flashcard:      return "Review structures and self-assess your recall"
        case .multipleChoice: return "Answer questions sourced from DSM-5 and clinical references"
        }
    }
}

// MARK: - Quiz Question

struct QuizQuestion: Identifiable {
    let id = UUID()
    let targetStructure: BrainStructure
    let mode: QuizMode
    let prompt: String
    let choices: [String]?
    let correctAnswer: String
    /// The authoritative reference this question is sourced from
    let sourceReference: ContentReference
    var userAnswer: String?

    var isCorrect: Bool? {
        guard let answer = userAnswer else { return nil }
        return answer == correctAnswer
    }
}

// MARK: - Pathology Quiz Question

/// A quiz question sourced directly from pathology data (DSM-5, Lezak, imaging)
struct PathologyQuizQuestion: Identifiable {
    let id = UUID()
    let pathology: Pathology
    let prompt: String
    let choices: [String]
    let correctAnswer: String
    let sourceReference: ContentReference
    let explanation: String
    var userAnswer: String?

    var isCorrect: Bool? {
        guard let answer = userAnswer else { return nil }
        return answer == correctAnswer
    }
}

// MARK: - Brain Structure Question Templates

enum QuizQuestionTemplate: CaseIterable {
    case identifyFunction
    case identifyStructure
    case lesionEffect
    case disorderAssociation

    func generate(for structure: BrainStructure, allStructures: [BrainStructure]) -> QuizQuestion {
        let distractorPool = allStructures.filter { $0.id != structure.id }
        let regionFirst = distractorPool.filter { $0.region == structure.region }
        let otherRegions = distractorPool.filter { $0.region != structure.region }
        let orderedPool = regionFirst + otherRegions

        switch self {
        case .identifyFunction:
            let correct = structure.functions.first ?? "Unknown"
            var distractors = orderedPool.prefix(10).compactMap { $0.functions.first }.filter { $0 != correct }
            distractors = Array(Set(distractors)).shuffled()
            let choices = (distractors.prefix(3) + [correct]).shuffled()
            return QuizQuestion(
                targetStructure: structure,
                mode: .multipleChoice,
                prompt: "What is the primary function of the \(structure.name)?",
                choices: Array(choices),
                correctAnswer: correct,
                sourceReference: .neuroanatomy
            )

        case .identifyStructure:
            let function = structure.functions.randomElement() ?? structure.functions.first ?? "Unknown"
            let correct = structure.name
            var distractors = orderedPool.prefix(10).map(\.name).filter { $0 != correct }
            distractors = Array(Set(distractors)).shuffled()
            let choices = (distractors.prefix(3) + [correct]).shuffled()
            return QuizQuestion(
                targetStructure: structure,
                mode: .multipleChoice,
                prompt: "Which structure is primarily responsible for: \(function)?",
                choices: Array(choices),
                correctAnswer: correct,
                sourceReference: .neuroanatomy
            )

        case .lesionEffect:
            let correct = structure.clinicalSignificance
            let truncated = String(correct.prefix(100)) + (correct.count > 100 ? "..." : "")
            var distractors = orderedPool.prefix(10).map {
                let sig = $0.clinicalSignificance
                return String(sig.prefix(100)) + (sig.count > 100 ? "..." : "")
            }.filter { $0 != truncated }
            distractors = Array(Set(distractors)).shuffled()
            let choices = (distractors.prefix(3) + [truncated]).shuffled()
            return QuizQuestion(
                targetStructure: structure,
                mode: .multipleChoice,
                prompt: "Damage to the \(structure.name) most commonly results in:",
                choices: Array(choices),
                correctAnswer: truncated,
                sourceReference: .neuroanatomy
            )

        case .disorderAssociation:
            guard let disorder = structure.associatedDisorders.first else {
                return QuizQuestionTemplate.identifyFunction.generate(for: structure, allStructures: allStructures)
            }
            let correct = structure.name
            var distractors = orderedPool.prefix(10).map(\.name).filter { $0 != correct }
            distractors = Array(Set(distractors)).shuffled()
            let choices = (distractors.prefix(3) + [correct]).shuffled()
            return QuizQuestion(
                targetStructure: structure,
                mode: .multipleChoice,
                prompt: "Which structure is most associated with \(disorder)?",
                choices: Array(choices),
                correctAnswer: correct,
                sourceReference: .neuroanatomy
            )
        }
    }
}

// MARK: - Pathology Question Templates (DSM-5, Lezak, Imaging)

enum PathologyQuestionTemplate {

    /// DSM-5: How many Criterion A symptoms are required?
    static func dsm5SymptomCount(for pathology: Pathology, allPathologies: [Pathology]) -> PathologyQuizQuestion? {
        guard let criteria = pathology.dsm5Criteria,
              let minimum = criteria.minimumSymptomCount else { return nil }

        let correct = "\(minimum) or more"
        let distractors: [String] = {
            let pool = [minimum - 1, minimum + 1, minimum + 2, minimum - 2]
                .filter { $0 > 0 && $0 != minimum }
                .map { "\($0) or more" }
            return Array(Set(pool)).shuffled()
        }()
        let choices = (distractors.prefix(3) + [correct]).shuffled()

        return PathologyQuizQuestion(
            pathology: pathology,
            prompt: "According to DSM-5, a diagnosis of \(pathology.name) requires at least how many Criterion A symptoms?",
            choices: Array(choices),
            correctAnswer: correct,
            sourceReference: .dsm5,
            explanation: "DSM-5 Criterion A for \(pathology.name) specifies \(minimum) or more of the listed symptoms. Duration: \(criteria.durationRequirement)."
        )
    }

    /// DSM-5: Duration requirement question
    static func dsm5Duration(for pathology: Pathology, allPathologies: [Pathology]) -> PathologyQuizQuestion? {
        guard let criteria = pathology.dsm5Criteria else { return nil }

        let correct = criteria.durationRequirement
        let durationPool = ["≥1 week", "≥2 weeks", "≥1 month", "≥3 months",
                            "≥6 months", "≥1 year", "≥2 years", "Most of the day, nearly every day for ≥2 weeks"]
            .filter { $0 != correct }
        let choices = (Array(durationPool.shuffled().prefix(3)) + [correct]).shuffled()

        return PathologyQuizQuestion(
            pathology: pathology,
            prompt: "According to DSM-5, symptoms of \(pathology.name) must be present for:",
            choices: choices,
            correctAnswer: correct,
            sourceReference: .dsm5,
            explanation: "DSM-5 specifies a duration of \(correct) for \(pathology.name) (\(criteria.criterionBCDE))."
        )
    }

    /// DSM-5: Which is NOT a Criterion A symptom?
    static func dsm5NotACriterion(for pathology: Pathology, allPathologies: [Pathology]) -> PathologyQuizQuestion? {
        guard let criteria = pathology.dsm5Criteria, criteria.criterionA.count >= 3 else { return nil }

        // Pull a distractor symptom from a different disorder
        let otherPathologies = allPathologies.filter { $0.id != pathology.id }
        guard let otherCriteria = otherPathologies.compactMap({ $0.dsm5Criteria }).first,
              let distractor = otherCriteria.criterionA.first(where: { !criteria.criterionA.contains($0) }) else {
            return nil
        }

        let realSymptoms = Array(criteria.criterionA.shuffled().prefix(3))
        let choices = (realSymptoms + [distractor]).shuffled()

        return PathologyQuizQuestion(
            pathology: pathology,
            prompt: "According to DSM-5, which of the following is NOT a Criterion A symptom for \(pathology.name)?",
            choices: choices,
            correctAnswer: distractor,
            sourceReference: .dsm5,
            explanation: "\"\(distractor)\" is not part of \(pathology.name)'s DSM-5 Criterion A. The actual criteria include: \(realSymptoms.joined(separator: "; "))."
        )
    }

    /// Lezak: Which neuropsych test pattern matches this disorder?
    static func neuropsychProfile(for pathology: Pathology, allPathologies: [Pathology]) -> PathologyQuizQuestion? {
        let patterns = pathology.neuropsychProfile.expectedTestPatterns
        guard let correct = patterns.first else { return nil }

        let otherPatterns = allPathologies
            .filter { $0.id != pathology.id }
            .compactMap { $0.neuropsychProfile.expectedTestPatterns.first }
            .filter { $0 != correct }

        let choices = (Array(otherPatterns.shuffled().prefix(3)) + [correct]).shuffled()

        return PathologyQuizQuestion(
            pathology: pathology,
            prompt: "On neuropsychological testing (per Lezak), which pattern is most consistent with \(pathology.name)?",
            choices: choices,
            correctAnswer: correct,
            sourceReference: .lezak,
            explanation: "Lezak's Neuropsychological Assessment describes \(pathology.name) as showing: \(correct)."
        )
    }

    /// Brain Imaging: Classic imaging finding for this condition
    static func imagingFindings(for pathology: Pathology, allPathologies: [Pathology]) -> PathologyQuizQuestion? {
        guard let correct = pathology.neuroimaging.mri.first else { return nil }

        let otherFindings = allPathologies
            .filter { $0.id != pathology.id }
            .compactMap { $0.neuroimaging.mri.first }
            .filter { $0 != correct }

        let choices = (Array(otherFindings.shuffled().prefix(3)) + [correct]).shuffled()

        return PathologyQuizQuestion(
            pathology: pathology,
            prompt: "On MRI, \(pathology.name) characteristically shows:",
            choices: choices,
            correctAnswer: correct,
            sourceReference: .brainImaging,
            explanation: "Brain imaging in \(pathology.name): \(correct)."
        )
    }
}
