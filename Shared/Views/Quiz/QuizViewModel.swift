import SwiftUI

// MARK: - Brain Anatomy Quiz ViewModel

@Observable
class QuizViewModel {
    let mode: QuizMode
    let progressStore: ProgressStore
    private(set) var questions: [QuizQuestion] = []
    private(set) var currentIndex: Int = 0
    private(set) var correctCount: Int = 0
    private(set) var answeredQuestions: [(question: QuizQuestion, wasCorrect: Bool)] = []
    var showingFeedback: Bool = false
    var lastAnswerCorrect: Bool = false

    var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var isComplete: Bool { currentIndex >= questions.count }
    var totalQuestions: Int { questions.count }
    var progress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentIndex) / Double(totalQuestions)
    }

    init(mode: QuizMode, progressStore: ProgressStore, questionCount: Int = 10, region: BrainRegion? = nil) {
        self.mode = mode
        self.progressStore = progressStore
        self.questions = generateQuestions(mode: mode, count: questionCount, region: region)
    }

    private func generateQuestions(mode: QuizMode, count: Int, region: BrainRegion?) -> [QuizQuestion] {
        let allStructures = BrainStructureStore.all
        var candidates: [BrainStructure]

        if let region = region {
            candidates = allStructures.filter { $0.region == region }
        } else {
            candidates = allStructures
        }

        let progressMap = progressStore.progressMap()
        candidates = SpacedRepetitionEngine.prioritize(candidates, using: progressMap)
        let selected = Array(candidates.prefix(count))

        switch mode {
        case .tapIdentify:
            return selected.map { structure in
                QuizQuestion(
                    targetStructure: structure,
                    mode: .tapIdentify,
                    prompt: "Tap the \(structure.name) on the brain map",
                    choices: nil,
                    correctAnswer: structure.id,
                    sourceReference: .neuroanatomy
                )
            }

        case .flashcard:
            return selected.map { structure in
                QuizQuestion(
                    targetStructure: structure,
                    mode: .flashcard,
                    prompt: structure.name,
                    choices: nil,
                    correctAnswer: structure.functions.joined(separator: "; "),
                    sourceReference: .neuroanatomy
                )
            }

        case .multipleChoice:
            let templates = QuizQuestionTemplate.allCases
            return selected.map { structure in
                let template = templates.randomElement() ?? .identifyFunction
                return template.generate(for: structure, allStructures: allStructures)
            }
        }
    }

    func submitTapAnswer(_ structureID: String) {
        guard let question = currentQuestion else { return }
        let correct = structureID == question.correctAnswer
        lastAnswerCorrect = correct
        if correct { correctCount += 1 }
        answeredQuestions.append((question: question, wasCorrect: correct))

        var progress = progressStore.progress(for: question.targetStructure.id)
        SpacedRepetitionEngine.updateFromQuiz(&progress, isCorrect: correct)
        progressStore.save(progress)

        showingFeedback = true
    }

    func submitMultipleChoiceAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }
        let correct = answer == question.correctAnswer
        lastAnswerCorrect = correct
        if correct { correctCount += 1 }
        answeredQuestions.append((question: question, wasCorrect: correct))

        var progress = progressStore.progress(for: question.targetStructure.id)
        SpacedRepetitionEngine.updateFromQuiz(&progress, isCorrect: correct)
        progressStore.save(progress)

        showingFeedback = true
    }

    func submitFlashcardGrade(_ grade: SpacedRepetitionGrade) {
        guard let question = currentQuestion else { return }
        let correct = grade != .again
        if correct { correctCount += 1 }
        answeredQuestions.append((question: question, wasCorrect: correct))

        var progress = progressStore.progress(for: question.targetStructure.id)
        SpacedRepetitionEngine.update(&progress, grade: grade)
        progressStore.save(progress)

        advance()
    }

    func advance() {
        showingFeedback = false
        currentIndex += 1
    }
}

// MARK: - Pathology Quiz ViewModel (DSM-5, Lezak, Imaging)

@Observable
class PathologyQuizViewModel {
    /// Optional so previews and tests can construct the model without a store; the
    /// app always supplies one so answers count toward study activity.
    private let progressStore: ProgressStore?
    private(set) var questions: [PathologyQuizQuestion] = []
    private(set) var currentIndex: Int = 0
    private(set) var correctCount: Int = 0
    private(set) var answeredQuestions: [(question: PathologyQuizQuestion, wasCorrect: Bool)] = []
    var showingFeedback: Bool = false
    var showingExplanation: Bool = false
    var lastAnswerCorrect: Bool = false

    var currentQuestion: PathologyQuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var isComplete: Bool { currentIndex >= questions.count }
    var totalQuestions: Int { questions.count }
    var progress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentIndex) / Double(totalQuestions)
    }

    init(count: Int = 10, sources: Set<ContentReference> = Set(ContentReference.allCases), progressStore: ProgressStore? = nil) {
        self.progressStore = progressStore
        self.questions = generateQuestions(count: count, sources: sources)
    }

    private func generateQuestions(count: Int, sources: Set<ContentReference>) -> [PathologyQuizQuestion] {
        let allPathologies = PathologyStore.all
        var generated: [PathologyQuizQuestion] = []

        for pathology in allPathologies.shuffled() {
            if generated.count >= count { break }

            // DSM-5 sourced questions
            if sources.contains(.dsm5) {
                if let q = PathologyQuestionTemplate.dsm5SymptomCount(for: pathology, allPathologies: allPathologies) {
                    generated.append(q)
                    if generated.count >= count { break }
                }
                if let q = PathologyQuestionTemplate.dsm5Duration(for: pathology, allPathologies: allPathologies) {
                    generated.append(q)
                    if generated.count >= count { break }
                }
                if let q = PathologyQuestionTemplate.dsm5NotACriterion(for: pathology, allPathologies: allPathologies) {
                    generated.append(q)
                    if generated.count >= count { break }
                }
            }

            // Lezak neuropsych questions
            if sources.contains(.lezak) {
                if let q = PathologyQuestionTemplate.neuropsychProfile(for: pathology, allPathologies: allPathologies) {
                    generated.append(q)
                    if generated.count >= count { break }
                }
            }

            // Brain imaging questions
            if sources.contains(.brainImaging) {
                if let q = PathologyQuestionTemplate.imagingFindings(for: pathology, allPathologies: allPathologies) {
                    generated.append(q)
                    if generated.count >= count { break }
                }
            }
        }

        return generated.shuffled().prefix(count).map { $0 }
    }

    func submitAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }
        let correct = answer == question.correctAnswer
        lastAnswerCorrect = correct
        if correct { correctCount += 1 }
        questions[currentIndex].userAnswer = answer
        let answered = questions[currentIndex]
        answeredQuestions.append((question: answered, wasCorrect: correct))
        progressStore?.recordAnswer()
        showingFeedback = true
    }

    func advance() {
        showingFeedback = false
        showingExplanation = false
        currentIndex += 1
    }
}
