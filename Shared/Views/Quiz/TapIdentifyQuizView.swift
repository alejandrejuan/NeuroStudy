import SwiftUI

struct TapIdentifyQuizView: View {
    @Bindable var viewModel: QuizViewModel
    @State private var brainMap = BrainMapViewModel()
    @State private var feedbackIsCorrect = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                if viewModel.isComplete {
                    QuizResultsView(viewModel: viewModel)
                } else {
                    VStack(spacing: 18) {
                        progressBar
                            .padding(.horizontal)

                        if let question = viewModel.currentQuestion {
                            promptCard(question)
                                .padding(.horizontal)
                        }

                        BrainMapView(viewModel: brainMap) { structureID in
                            handleTap(structureID)
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                    .padding(.vertical)

                    if viewModel.showingFeedback {
                        feedbackOverlay
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.showingFeedback)
            .quizChrome(title: "Tap to Identify") { dismiss() }
            .onAppear {
                if let question = viewModel.currentQuestion {
                    brainMap.enterQuizMode(targetID: question.correctAnswer)
                }
            }
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

    // MARK: - Prompt

    private func promptCard(_ question: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            QuestionEyebrow(title: "Find on the map", color: .blue)
            // The eyebrow already says what to do, so the title is just the name.
            Text(question.targetStructure.name)
                .font(.largeTitle.weight(.bold))
                .minimumScaleFactor(0.7)
                .lineLimit(2)
                .accessibilityLabel(question.prompt)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    // MARK: - Handle Tap

    private func handleTap(_ structureID: String) {
        guard !viewModel.showingFeedback else { return }

        viewModel.submitTapAnswer(structureID)
        feedbackIsCorrect = viewModel.lastAnswerCorrect

        Haptics.result(correct: feedbackIsCorrect)

        if feedbackIsCorrect {
            brainMap.selectedID = structureID
        } else {
            brainMap.selectedID = viewModel.answeredQuestions.last?.question.correctAnswer
            brainMap.highlightedIDs = [structureID]
        }

        let delay = feedbackIsCorrect ? 1.0 : 2.2
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                viewModel.advance()
                brainMap.clearSelection()
                if let next = viewModel.currentQuestion {
                    brainMap.enterQuizMode(targetID: next.correctAnswer)
                }
            }
        }
    }

    // MARK: - Feedback

    private var feedbackOverlay: some View {
        FeedbackToast(
            correct: feedbackIsCorrect,
            detail: feedbackIsCorrect ? nil : viewModel.answeredQuestions.last.map { "The answer was \($0.question.targetStructure.name)." }
        )
    }
}
