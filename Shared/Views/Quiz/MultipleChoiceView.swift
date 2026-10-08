import SwiftUI

struct MultipleChoiceQuizView: View {
    @Bindable var viewModel: QuizViewModel
    @State private var selectedAnswer: String?
    @State private var appeared = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                if viewModel.isComplete {
                    QuizResultsView(viewModel: viewModel)
                } else {
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

                        Spacer()
                    }
                    .padding()
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.currentIndex)

                    // Feedback banner
                    if viewModel.showingFeedback {
                        feedbackBanner
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.showingFeedback)
            .quizChrome(title: "Multiple Choice") { dismiss() }
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

    private func questionCard(_ question: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            QuestionEyebrow(
                title: question.targetStructure.region.displayName,
                color: question.targetStructure.region.color,
                reference: question.sourceReference
            )
            Text(question.prompt)
                .font(.title2.weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    // MARK: - Answer Choices

    @ViewBuilder
    private func answerChoices(_ question: QuizQuestion) -> some View {
        if let choices = question.choices {
            VStack(spacing: 10) {
                ForEach(Array(choices.enumerated()), id: \.element) { index, choice in
                    answerButton(index: index, choice: choice, question: question)
                }
            }
        }
    }

    private func answerButton(index: Int, choice: String, question: QuizQuestion) -> some View {
        Button {
            guard !viewModel.showingFeedback else { return }
            selectedAnswer = choice
            viewModel.submitMultipleChoiceAnswer(choice)

            Haptics.result(correct: viewModel.lastAnswerCorrect)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    viewModel.advance()
                    selectedAnswer = nil
                }
            }
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

    // MARK: - Feedback

    private var feedbackBanner: some View {
        FeedbackToast(
            correct: viewModel.lastAnswerCorrect,
            detail: viewModel.lastAnswerCorrect ? nil : viewModel.answeredQuestions.last.map { "Answer: \($0.question.correctAnswer)" }
        )
    }
}
