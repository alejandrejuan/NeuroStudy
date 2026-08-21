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
            .navigationTitle("Multiple Choice")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("End Quiz") { dismiss() }
                }
            }
            .task { appeared = true }
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        VStack(spacing: 4) {
            ProgressView(value: viewModel.progress)
                .tint(.green)

            HStack {
                Text("Question \(viewModel.currentIndex + 1) of \(viewModel.totalQuestions)")
                    .font(.detailLabel)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(viewModel.correctCount) correct")
                    .font(.detailLabel)
                    .foregroundStyle(.green)
            }
        }
    }

    // MARK: - Question Card

    private func questionCard(_ question: QuizQuestion) -> some View {
        LiquidGlassCard(cornerRadius: 20, padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ModernRegionBadge(region: question.targetStructure.region)
                    Spacer()
                    SourceReferenceBadge(reference: question.sourceReference)
                }

                Text(question.prompt)
                    .font(.quizPrompt)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Answer Choices

    @ViewBuilder
    private func answerChoices(_ question: QuizQuestion) -> some View {
        if let choices = question.choices {
            VStack(spacing: 10) {
                ForEach(choices, id: \.self) { choice in
                    answerButton(choice: choice, question: question)
                }
            }
        }
    }

    private func answerButton(choice: String, question: QuizQuestion) -> some View {
        let isSelected = selectedAnswer == choice
        let isCorrectAnswer = choice == question.correctAnswer
        let showResult = viewModel.showingFeedback

        return Button {
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
            HStack {
                Text(choice)
                    .font(.bodyText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)

                Spacer()

                if showResult {
                    if isCorrectAnswer {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .transition(.scale.combined(with: .opacity))
                    } else if isSelected && !isCorrectAnswer {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(answerBackground(isSelected: isSelected, isCorrect: isCorrectAnswer, showResult: showResult))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(
                        answerBorder(isSelected: isSelected, isCorrect: isCorrectAnswer, showResult: showResult),
                        lineWidth: isSelected ? 2 : 0.5
                    )
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.showingFeedback)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: showResult)
    }

    private func answerBackground(isSelected: Bool, isCorrect: Bool, showResult: Bool) -> some ShapeStyle {
        if showResult && isCorrect { return AnyShapeStyle(.green.opacity(0.15)) }
        if showResult && isSelected && !isCorrect { return AnyShapeStyle(.red.opacity(0.15)) }
        if isSelected { return AnyShapeStyle(.blue.opacity(0.1)) }
        return AnyShapeStyle(.ultraThinMaterial)
    }

    private func answerBorder(isSelected: Bool, isCorrect: Bool, showResult: Bool) -> Color {
        if showResult && isCorrect { return .green }
        if showResult && isSelected && !isCorrect { return .red }
        if isSelected { return .blue }
        return .white.opacity(0.2)
    }

    // MARK: - Feedback Banner

    private var feedbackBanner: some View {
        VStack {
            Spacer()

            LiquidGlassCard(cornerRadius: 20, padding: 16) {
                HStack(spacing: 14) {
                    Image(systemName: viewModel.lastAnswerCorrect
                          ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(viewModel.lastAnswerCorrect ? .green : .red)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(viewModel.lastAnswerCorrect ? "Correct!" : "Incorrect")
                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                            .foregroundStyle(viewModel.lastAnswerCorrect ? .green : .red)

                        if !viewModel.lastAnswerCorrect,
                           let question = viewModel.answeredQuestions.last?.question {
                            Text("Answer: \(question.correctAnswer)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }

                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
    }
}
