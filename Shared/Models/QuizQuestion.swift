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

    /// Number of wrong options shown alongside the correct one.
    private static let distractorCount = 3

    /// Builds the wrong answers for a question.
    ///
    /// Two rules matter here, and the previous implementation broke both:
    ///
    /// 1. **A distractor must never also be correct.** `isAlsoCorrect` rejects
    ///    candidates that are genuinely valid answers — e.g. asking which structure is
    ///    associated with Parkinson's must not offer both Substantia Nigra and Globus
    ///    Pallidus and then mark one of them wrong.
    /// 2. **Same-region candidates are more plausible, but must not be the only source.**
    ///    Same-region structures are exactly the ones that share disorders and
    ///    functions, so they are drawn first for plausibility but the rest of the atlas
    ///    backfills whenever rule 1 rejects too many of them.
    ///
    /// Returns fewer than `distractorCount` only when the atlas genuinely cannot supply
    /// more; callers should skip such questions rather than show a two-option quiz.
    private func distractors<T: Hashable>(
        for structure: BrainStructure,
        from allStructures: [BrainStructure],
        value: (BrainStructure) -> T?,
        isAlsoCorrect: (BrainStructure) -> Bool
    ) -> [T] {
        let pool = allStructures.filter { $0.id != structure.id && !isAlsoCorrect($0) }
        let sameRegion = pool.filter { $0.region == structure.region }.shuffled()
        let otherRegions = pool.filter { $0.region != structure.region }.shuffled()

        var seen = Set<T>()
        var result: [T] = []
        for candidate in sameRegion + otherRegions {
            guard result.count < Self.distractorCount else { break }
            guard let v = value(candidate), !seen.contains(v) else { continue }
            seen.insert(v)
            result.append(v)
        }
        return result
    }

    private static func truncate(_ text: String) -> String {
        text.count > 100 ? String(text.prefix(100)) + "..." : text
    }

    func generate(for structure: BrainStructure, allStructures: [BrainStructure]) -> QuizQuestion {
        switch self {
        case .identifyFunction:
            let correct = structure.functions.first ?? "Unknown"
            // Any function the target itself performs is a defensible answer to
            // "what is its primary function", so exclude structures that share one.
            let targetFunctions = Set(structure.functions)
            let wrong = distractors(
                for: structure,
                from: allStructures,
                value: { $0.functions.first },
                isAlsoCorrect: { !targetFunctions.isDisjoint(with: Set($0.functions)) }
            )
            return QuizQuestion(
                targetStructure: structure,
                mode: .multipleChoice,
                prompt: "What is the primary function of the \(structure.name)?",
                choices: (wrong + [correct]).shuffled(),
                correctAnswer: correct,
                sourceReference: .neuroanatomy
            )

        case .identifyStructure:
            let function = structure.functions.randomElement() ?? "Unknown"
            let correct = structure.name
            // A structure that also performs the asked-about function is a correct
            // answer to "which structure is responsible for this", not a distractor.
            let wrong = distractors(
                for: structure,
                from: allStructures,
                value: { $0.name },
                isAlsoCorrect: { $0.functions.contains(function) }
            )
            return QuizQuestion(
                targetStructure: structure,
                mode: .multipleChoice,
                prompt: "Which structure is primarily responsible for: \(function)?",
                choices: (wrong + [correct]).shuffled(),
                correctAnswer: correct,
                sourceReference: .neuroanatomy
            )

        case .lesionEffect:
            let correct = Self.truncate(structure.clinicalSignificance)
            let wrong = distractors(
                for: structure,
                from: allStructures,
                value: { Self.truncate($0.clinicalSignificance) },
                isAlsoCorrect: { Self.truncate($0.clinicalSignificance) == correct }
            )
            return QuizQuestion(
                targetStructure: structure,
                mode: .multipleChoice,
                prompt: "Damage to the \(structure.name) most commonly results in:",
                choices: (wrong + [correct]).shuffled(),
                correctAnswer: correct,
                sourceReference: .neuroanatomy
            )

        case .disorderAssociation:
            guard let disorder = structure.associatedDisorders.first else {
                return QuizQuestionTemplate.identifyFunction.generate(for: structure, allStructures: allStructures)
            }
            let correct = structure.name
            // The bug this guards against: Parkinson's is listed on Substantia Nigra
            // *and* on neighbouring basal-ganglia structures. Offering both and scoring
            // only one as right marks a correct answer wrong.
            let wrong = distractors(
                for: structure,
                from: allStructures,
                value: { $0.name },
                isAlsoCorrect: { $0.associatedDisorders.contains(disorder) }
            )
            return QuizQuestion(
                targetStructure: structure,
                mode: .multipleChoice,
                prompt: "Which structure is most associated with \(disorder)?",
                choices: (wrong + [correct]).shuffled(),
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
