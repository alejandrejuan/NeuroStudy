import SwiftUI

struct TapIdentifyQuizView: View {
    @Bindable var viewModel: QuizViewModel
    @State private var brainMap = BrainMapViewModel()
    @State private var feedbackIsCorrect = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AdaptiveGradientBackground()

                if viewModel.isComplete {
                    QuizResultsView(viewModel: viewModel)
                } else {
                    VStack(spacing: 16) {
                        progressBar

                        if let question = viewModel.currentQuestion {
                            promptCard(question)
                        }

                        BrainMapView(viewModel: brainMap) { structureID in
                            handleTap(structureID)
                        }
                        .padding(.horizontal)

                        Text("Tap the structure on the brain map")
                            .font(.detailLabel)
                            .foregroundStyle(.secondary)

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
            .navigationTitle("Tap to Identify")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("End Quiz") { dismiss() }
                }
            }
            .onAppear {
                if let question = viewModel.currentQuestion {
                    brainMap.enterQuizMode(targetID: question.correctAnswer)
                }
            }
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        VStack(spacing: 4) {
            ProgressView(value: viewModel.progress)
                .tint(.blue)
                .padding(.horizontal)

            HStack {
                Text("Question \(viewModel.currentIndex + 1) of \(viewModel.totalQuestions)")
                    .font(.detailLabel)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(viewModel.correctCount) correct")
                    .font(.detailLabel)
                    .foregroundStyle(.green)
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Prompt Card

    private func promptCard(_ question: QuizQuestion) -> some View {
        LiquidGlassCard(cornerRadius: 16, padding: 14) {
            HStack(spacing: 12) {
                Image(systemName: "hand.tap.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)

                Text(question.prompt)
                    .font(.quizPrompt)

                Spacer()
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Handle Tap

    private func handleTap(_ structureID: String) {
        guard !viewModel.showingFeedback else { return }

        viewModel.submitTapAnswer(structureID)
        feedbackIsCorrect = viewModel.lastAnswerCorrect

        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(feedbackIsCorrect ? .success : .error)
        #endif

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

    // MARK: - Feedback Overlay

    private var feedbackOverlay: some View {
        VStack {
            Spacer()

            LiquidGlassCard(cornerRadius: 24, padding: 20) {
                VStack(spacing: 12) {
                    if feedbackIsCorrect {
                        AnimatedCheckmark()
                        Text("Correct!")
                            .font(.structureTitle)
                            .foregroundStyle(.green)
                    } else {
                        AnimatedXMark()
                        Text("Not quite")
                            .font(.structureTitle)
                            .foregroundStyle(.red)

                        if let question = viewModel.answeredQuestions.last?.question {
                            Text("The answer was: \(question.targetStructure.name)")
                                .font(.structureSubtitle)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}
