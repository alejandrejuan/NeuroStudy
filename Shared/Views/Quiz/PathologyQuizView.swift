import SwiftUI

// MARK: - Pathology Quiz View

struct PathologyQuizView: View {
    @Bindable var viewModel: PathologyQuizViewModel
    @State private var selectedAnswer: String?
    @State private var appeared = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                if viewModel.isComplete {
                    PathologyResultsView(viewModel: viewModel)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            progressBar
                                .opacity(appeared ? 1 : 0)
                                .animation(.easeOut(duration: 0.3), value: appeared)

                            if let question = viewModel.currentQuestion {
                                questionCard(question)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                                answerChoices(question)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                            }
                        }
                        .padding()
                        // Room for the explanation panel so the last answer is never trapped under it.
                        .padding(.bottom, viewModel.showingFeedback ? 280 : 0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.currentIndex)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .softScrollEdges()

                    // Explanation panel (shown after answering)
                    if viewModel.showingFeedback, let answered = viewModel.answeredQuestions.last {
                        explanationPanel(answered.question, wasCorrect: answered.wasCorrect)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.showingFeedback)
            .quizChrome(title: "Clinical") { dismiss() }
            .task { appeared = true }
        }
    }

    // MARK: - Progress

    private var progressBar: some View {
        QuizProgressHeader(
            progress: viewModel.progress,
            current: viewModel.currentIndex + 1,
            total: viewModel.totalQuestions,
            score: viewModel.correctCount
        )
    }

    // MARK: - Question

    private func questionCard(_ question: PathologyQuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            QuestionEyebrow(title: question.pathology.name, color: .orange, reference: question.sourceReference)
            Text(question.prompt)
                .font(.title3.weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    // MARK: - Answer Choices

    private func answerChoices(_ question: PathologyQuizQuestion) -> some View {
        VStack(spacing: 10) {
            ForEach(Array(question.choices.enumerated()), id: \.element) { index, choice in
                Button {
                    guard !viewModel.showingFeedback else { return }
                    selectedAnswer = choice
                    viewModel.submitAnswer(choice)
                    Haptics.result(correct: viewModel.lastAnswerCorrect)
                } label: {
                    AnswerRow(
                        index: index,
                        text: choice,
                        state: .of(choice: choice, selected: selectedAnswer, correct: question.correctAnswer, revealed: viewModel.showingFeedback)
                    )
                }
                .buttonStyle(.plain)
                .allowsHitTesting(!viewModel.showingFeedback)
            }
        }
    }

    // MARK: - Explanation Panel

    private func explanationPanel(_ question: PathologyQuizQuestion, wasCorrect: Bool) -> some View {
        FeedbackToast(
            correct: wasCorrect,
            detail: wasCorrect ? nil : "Answer: \(question.correctAnswer)"
        ) {
            VStack(alignment: .leading, spacing: 14) {
                Text(question.explanation)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(6)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        viewModel.advance()
                        selectedAnswer = nil
                    }
                } label: {
                    Text(viewModel.currentIndex + 1 >= viewModel.totalQuestions ? "See Results" : "Next Question")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .glassButton(prominent: true, controlSize: .large)
            }
        }
    }
}

// MARK: - Pathology Results View

struct PathologyResultsView: View {
    let viewModel: PathologyQuizViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                ScoreHero(correct: viewModel.correctCount, total: viewModel.totalQuestions)

                if !missed.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader("Review These") {
                            Text("\(missed.count)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                        GroupedList(data: missed, separatorInset: 14) { question in
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(question.pathology.name)
                                        .font(.body.weight(.semibold))
                                    Text(question.prompt)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                    Text("Answer: \(question.correctAnswer)")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(Theme.emerald)
                                        .lineLimit(2)
                                }
                                Spacer(minLength: 8)
                                ResultMark(correct: false)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 11)
                        }
                    }
                }

                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .glassButton(prominent: true, controlSize: .large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
        }
        .softScrollEdges()
        .background { AppBackground() }
        .task {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) { appeared = true }
        }
    }

    private var missed: [PathologyQuizQuestion] {
        viewModel.answeredQuestions.filter { !$0.wasCorrect }.map(\.question)
    }
}
