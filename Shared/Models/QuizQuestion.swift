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
        case .tapIdentify:    return "Tap the correct structure on the brain map"
        case .flashcard:      return "Review structures and self-assess your recall"
        case .multipleChoice: return "Identify functions, structures, and lesion effects"
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

    // MARK: - Distractor safety
    //
    // Every multiple-choice question here builds its wrong answers from OTHER disorders'
    // data. That is only safe if the borrowed answer is actually false for the disorder
    // being asked about, and many disorders share findings (impaired CVLT recall in
    // Alzheimer's, PTSD, TLE and Korsakoff; hippocampal volume loss in three of them;
    // "standard testing impossible" for both locked-in and akinetic mutism). Without a
    // guard a student gets marked wrong for a correct answer. Two guards apply:
    //   1. Distractors only come from a disorder in a different clinical family.
    //   2. A distractor is rejected if it shares a key concept with anything listed for
    //      the target disorder.

    /// Disorders whose test patterns, imaging, or criteria overlap enough that one can
    /// never serve as a wrong answer for another.
    private static let family: [String: Int] = [
        // Memory / mesial temporal
        "alzheimers-disease": 1, "ptsd": 1, "temporal-lobe-epilepsy": 1, "korsakoff-syndrome": 1, "kluver-bucy": 1,
        // Frontostriatal / executive / neurodevelopmental
        "frontotemporal-dementia": 2, "ocd": 2, "parkinsons-disease": 2, "huntingtons-disease": 2,
        "adhd": 2, "schizophrenia": 2, "autism-spectrum": 2,
        // Brainstem and states where testing is impossible or normal
        "wallenberg-syndrome": 3, "locked-in-syndrome": 3, "akinetic-mutism": 3,
        // Language and MCA territory
        "stroke-mca": 4, "brocas-aphasia": 4, "wernickes-aphasia": 4, "hemispatial-neglect": 4,
        // Higher visual / disconnection
        "prosopagnosia": 5, "split-brain-syndrome": 5,
    ]

    /// Concepts that are clinically the same even when worded differently.
    private static let synonyms: [(stem: String, concept: String)] = [
        ("concentrat", "attention"), ("attent", "attention"), ("focus", "attention"), ("distract", "attention"),
        ("sleep", "sleep"), ("irritab", "irritability"), ("anger", "irritability"), ("angry", "irritability"),
        ("outburst", "irritability"), ("impuls", "impulsivity"), ("reckless", "impulsivity"),
        ("forget", "memory"), ("recall", "memory"), ("remember", "memory"), ("amnesi", "memory"),
        ("ritual", "repetition"), ("routine", "repetition"), ("repetit", "repetition"), ("stereotyp", "repetition"),
        ("ventric", "ventricles"), ("hippocamp", "hippocampus"), ("caudate", "caudate"),
        ("restless", "restlessness"), ("fidget", "restlessness"), ("delusion", "delusion"), ("hallucinat", "hallucination"),
        ("normal", "normal"), ("impossible", "untestable"),
    ]
    private static let stopWords: Set<String> = [
        "impaired", "reduced", "increased", "finding", "findings", "replicated", "lesion", "lesions", "volume",
        "often", "relatively", "preserved", "pattern", "patterns", "severely", "marked", "showing", "during",
        "activities", "others", "things",
    ]

    private static func concepts(_ text: String) -> Set<String> {
        let words = text.lowercased().split { !$0.isLetter }.map(String.init)
        var out = Set<String>()
        for w in words where w.count >= 5 && !stopWords.contains(w) {
            if let hit = synonyms.first(where: { w.hasPrefix($0.stem) }) { out.insert("#" + hit.concept) }
            else { out.insert(w) }
        }
        return out
    }

    /// True when `candidate` would plausibly also be a correct answer for the target.
    private static func overlaps(_ candidate: String, with targetTexts: [String]) -> Bool {
        let c = concepts(candidate)
        let t = targetTexts.reduce(into: Set<String>()) { $0.formUnion(concepts($1)) }
        let shared = c.intersection(t)
        // One shared clinical concept (e.g. both about attention) is enough; plain words need two.
        return shared.contains { $0.hasPrefix("#") } || shared.count >= 2
    }

    private static func safeDistractors(
        for pathology: Pathology,
        from all: [Pathology],
        targetTexts: [String],
        candidates: (Pathology) -> [String],
        count: Int = 3
    ) -> [String]? {
        let fam = family[pathology.id]
        var seen = Set<String>(targetTexts)
        var out: [String] = []
        for other in all.shuffled() where other.id != pathology.id && (fam == nil || family[other.id] != fam) {
            for text in candidates(other).shuffled() {
                guard !seen.contains(text), !overlaps(text, with: targetTexts) else { continue }
                seen.insert(text); out.append(text); break
            }
            if out.count == count { break }
        }
        // Better no question than a two-choice question.
        return out.count == count ? out : nil
    }

    /// Criteria are stored with a leading label ("INATTENTION domain: ...") for the
    /// detail screen. In a quiz the label would give away which disorder a line is from.
    private static func symptomText(_ item: String) -> String {
        guard let range = item.range(of: ": ") else { return item }
        let text = item[range.upperBound...]
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    /// Criterion items that are not symptoms (PTSD's exposure requirement) or that only
    /// introduce a rule must not be offered as "a symptom".
    private static func symptoms(of criteria: DSM5CriteriaData) -> [String] {
        criteria.criterionA
            .filter { !$0.hasPrefix("Criterion A (exposure)") && !$0.hasPrefix("The disorder requires") }
            .map(symptomText)
    }

    private static func firstSentence(_ text: String) -> String {
        guard let end = text.range(of: ". ") else { return text }
        return String(text[..<end.lowerBound]) + "."
    }

    // MARK: - Templates

    /// DSM-5: How many Criterion A symptoms are required?
    static func dsm5SymptomCount(for pathology: Pathology, allPathologies: [Pathology]) -> PathologyQuizQuestion? {
        guard let criteria = pathology.dsm5Criteria,
              let minimum = criteria.minimumSymptomCount else { return nil }

        let correct = "\(minimum) or more"
        let pool = [minimum - 1, minimum + 1, minimum + 2, minimum - 2]
            .filter { $0 > 0 && $0 != minimum }
            .map { "\($0) or more" }
        let choices = (Array(Set(pool)).shuffled().prefix(3) + [correct]).shuffled()

        // ADHD's threshold applies within ONE domain (and drops to 5 at age 17), so the
        // question has to say so or "6 of 18 symptoms" reads as correct.
        let perDomain = criteria.criterionBCDE.contains("SINGLE domain")
        let prompt = perDomain
            ? "Under DSM-5, how many symptoms within a single domain (inattention or hyperactivity–impulsivity) are required for a diagnosis of \(pathology.name) before age 17?"
            : "According to DSM-5, a diagnosis of \(pathology.name) requires at least how many Criterion A symptoms?"

        return PathologyQuizQuestion(
            pathology: pathology,
            prompt: prompt,
            choices: Array(choices),
            correctAnswer: correct,
            sourceReference: .dsm5,
            explanation: firstSentence(criteria.criterionBCDE)
        )
    }

    /// DSM-5: How long must symptoms be present?
    static func dsm5Duration(for pathology: Pathology, allPathologies: [Pathology]) -> PathologyQuizQuestion? {
        guard let criteria = pathology.dsm5Criteria else { return nil }

        // Only disorders with an actual DSM duration criterion. OCD and autism have none,
        // and the old version asked anyway with a non-duration "correct" answer.
        let canonical = criteria.durationRequirement
            .components(separatedBy: " (").first?
            .trimmingCharacters(in: .whitespaces) ?? ""
        guard canonical.hasPrefix("≥") || canonical.hasPrefix(">") else { return nil }

        // Compare on the span alone so "≥1 month" can never be offered as a wrong answer
        // when the real criterion is ">1 month".
        func span(_ s: String) -> String { s.trimmingCharacters(in: CharacterSet(charactersIn: "≥> ")) }
        let pool = ["≥1 week", "≥2 weeks", "≥1 month", "≥3 months", "≥6 months", "≥1 year", "≥2 years"]
            .filter { span($0) != span(canonical) }
        let choices = (Array(pool.shuffled().prefix(3)) + [canonical]).shuffled()

        return PathologyQuizQuestion(
            pathology: pathology,
            prompt: "According to DSM-5, how long must the symptoms of \(pathology.name) be present?",
            choices: choices,
            correctAnswer: canonical,
            sourceReference: .dsm5,
            explanation: "DSM-5 requires \(criteria.durationRequirement) for \(pathology.name)."
        )
    }

    /// DSM-5: Which of these is NOT a Criterion A symptom?
    static func dsm5NotACriterion(for pathology: Pathology, allPathologies: [Pathology]) -> PathologyQuizQuestion? {
        guard let criteria = pathology.dsm5Criteria else { return nil }
        let real = symptoms(of: criteria)
        guard real.count >= 3 else { return nil }
        let targetTexts = criteria.criterionA + [criteria.criterionBCDE]

        guard let distractor = safeDistractors(
            for: pathology, from: allPathologies, targetTexts: targetTexts,
            candidates: { $0.dsm5Criteria.map(symptoms(of:)) ?? [] }, count: 1
        )?.first else { return nil }

        let shown = Array(real.shuffled().prefix(3))
        return PathologyQuizQuestion(
            pathology: pathology,
            prompt: "Which of the following is NOT a DSM-5 Criterion A feature of \(pathology.name)?",
            choices: (shown + [distractor]).shuffled(),
            correctAnswer: distractor,
            sourceReference: .dsm5,
            explanation: "\"\(distractor)\" is not part of \(pathology.name)'s Criterion A. The other three are."
        )
    }

    /// Neuropsychology: Which test pattern fits this disorder?
    static func neuropsychProfile(for pathology: Pathology, allPathologies: [Pathology]) -> PathologyQuizQuestion? {
        let patterns = pathology.neuropsychProfile.expectedTestPatterns
        guard let correct = patterns.first else { return nil }
        let targetTexts = patterns + pathology.neuropsychProfile.cognitiveDomainsAffected.map(\.description)

        guard let wrong = safeDistractors(
            for: pathology, from: allPathologies, targetTexts: targetTexts,
            candidates: { $0.neuropsychProfile.expectedTestPatterns.prefix(1).map { $0 } }
        ) else { return nil }

        return PathologyQuizQuestion(
            pathology: pathology,
            prompt: "On neuropsychological testing, which pattern is most consistent with \(pathology.name)?",
            choices: (wrong + [correct]).shuffled(),
            correctAnswer: correct,
            sourceReference: .lezak,
            explanation: "\(pathology.name) typically shows: \(correct)."
        )
    }

    /// Imaging: Which MRI finding is characteristic?
    static func imagingFindings(for pathology: Pathology, allPathologies: [Pathology]) -> PathologyQuizQuestion? {
        let mri = pathology.neuroimaging.mri
        guard let correct = mri.first else { return nil }
        let targetTexts = mri + pathology.neuroimaging.ct + pathology.neuroimaging.pet

        guard let wrong = safeDistractors(
            for: pathology, from: allPathologies, targetTexts: targetTexts,
            candidates: { $0.neuroimaging.mri.prefix(1).map { $0 } }
        ) else { return nil }

        return PathologyQuizQuestion(
            pathology: pathology,
            prompt: "On MRI, \(pathology.name) characteristically shows:",
            choices: (wrong + [correct]).shuffled(),
            correctAnswer: correct,
            sourceReference: .brainImaging,
            explanation: "Brain imaging in \(pathology.name): \(correct)."
        )
    }
}
