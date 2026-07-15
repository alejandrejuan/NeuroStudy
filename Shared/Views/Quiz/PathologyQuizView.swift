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
                AdaptiveGradientBackground()

                if viewModel.isComplete {
                    PathologyResultsView(viewModel: viewModel)
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

                    // Explanation panel (shown after answering)
                    if viewModel.showingFeedback, let answered = viewModel.answeredQuestions.last {
                        explanationPanel(answered.question, wasCorrect: answered.wasCorrect)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.showingFeedback)
            .navigationTitle("Clinical Quiz")
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
                .tint(.orange)

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

    private func questionCard(_ question: PathologyQuizQuestion) -> some View {
        LiquidGlassCard(cornerRadius: 20, padding: 16, prominent: true) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // Pathology name badge
                    Text(question.pathology.name)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background {
                            Capsule(style: .continuous)
                                .fill(.orange.opacity(0.15))
                        }
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(.orange.opacity(0.35), lineWidth: 0.5)
                        }
                        .foregroundStyle(.orange)

                    Spacer()

                    SourceReferenceBadge(reference: question.sourceReference)
                }

                Text(question.prompt)
                    .font(.quizPrompt)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Answer Choices

    private func answerChoices(_ question: PathologyQuizQuestion) -> some View {
        VStack(spacing: 10) {
            ForEach(question.choices, id: \.self) { choice in
                answerButton(choice: choice, question: question)
            }
        }
    }

    private func answerButton(choice: String, question: PathologyQuizQuestion) -> some View {
        let isSelected = selectedAnswer == choice
        let isCorrect = choice == question.correctAnswer
        let showResult = viewModel.showingFeedback

        return Button {
            guard !viewModel.showingFeedback else { return }
            selectedAnswer = choice
            viewModel.submitAnswer(choice)

            Haptics.result(correct: viewModel.lastAnswerCorrect)
        } label: {
            HStack {
                Text(choice)
                    .font(.bodyText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 8)

                if showResult {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .transition(.scale.combined(with: .opacity))
                    } else if isSelected && !isCorrect {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(answerBackground(isSelected: isSelected, isCorrect: isCorrect, showResult: showResult))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(
                        answerBorder(isSelected: isSelected, isCorrect: isCorrect, showResult: showResult),
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
        if isSelected { return AnyShapeStyle(.orange.opacity(0.1)) }
        return AnyShapeStyle(.ultraThinMaterial)
    }

    private func answerBorder(isSelected: Bool, isCorrect: Bool, showResult: Bool) -> Color {
        if showResult && isCorrect { return .green }
        if showResult && isSelected && !isCorrect { return .red }
        if isSelected { return .orange }
        return .white.opacity(0.2)
    }

    // MARK: - Explanation Panel

    private func explanationPanel(_ question: PathologyQuizQuestion, wasCorrect: Bool) -> some View {
        VStack {
            Spacer()

            LiquidGlassCard(cornerRadius: 24, padding: 20) {
                VStack(alignment: .leading, spacing: 14) {
                    // Result header
                    HStack(spacing: 10) {
                        Image(systemName: wasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(wasCorrect ? .green : .red)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(wasCorrect ? "Correct!" : "Incorrect")
                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                                .foregroundStyle(wasCorrect ? .green : .red)
                            if !wasCorrect {
                                Text("Correct: \(question.correctAnswer)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }

                        Spacer()

                        SourceReferenceBadge(reference: question.sourceReference)
                    }

                    Divider()

                    // Explanation
                    Text(question.explanation)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(5)
                        .fixedSize(horizontal: false, vertical: true)

                    // Next button
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            viewModel.advance()
                            selectedAnswer = nil
                        }
                    } label: {
                        Text(viewModel.currentIndex + 1 >= viewModel.totalQuestions
                             ? "See Results" : "Next Question")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .frame(maxWidth: .infinity)
                    }
                    .glassButton(prominent: true)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }
}

// MARK: - Pathology Results View

struct PathologyResultsView: View {
    let viewModel: PathologyQuizViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false
    @State private var scoreAnimated = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                scoreSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 14)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: appeared)

                if !missedItems.isEmpty {
                    missedSection
                        .opacity(appeared ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: appeared)
                }

                Button {
                    dismiss()
                } label: {
                    Label("Done", systemImage: "checkmark")
                        .frame(maxWidth: .infinity)
                }
                .glassButton(prominent: true)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.3), value: appeared)
            }
            .padding()
        }
        .background { AdaptiveGradientBackground() }
        .task {
            appeared = true
            try? await Task.sleep(nanoseconds: 400_000_000)
            scoreAnimated = true
        }
    }

    private var percentage: Double {
        guard viewModel.totalQuestions > 0 else { return 0 }
        return Double(viewModel.correctCount) / Double(viewModel.totalQuestions)
    }

    private var missedItems: [(question: PathologyQuizQuestion, wasCorrect: Bool)] {
        viewModel.answeredQuestions.filter { !$0.wasCorrect }
    }

    private var scoreColor: Color {
        switch percentage {
        case 0.9...: return .yellow
        case 0.7..<0.9: return .green
        case 0.5..<0.7: return .orange
        default: return .red
        }
    }

    // MARK: - Score Section

    private var scoreSection: some View {
        LiquidGlassCard(cornerRadius: 24, padding: 24, prominent: true) {
            VStack(spacing: 20) {
                Image(systemName: percentage >= 0.7 ? "brain.head.profile" : "book.fill")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(scoreColor)
                    .symbolEffect(.bounce, value: appeared)

                Text("Quiz Complete!")
                    .font(.system(.title2, design: .rounded, weight: .bold))

                ZStack {
                    Circle()
                        .stroke(.quaternary, lineWidth: 10)
                        .frame(width: 130, height: 130)

                    Circle()
                        .trim(from: 0, to: scoreAnimated ? percentage : 0)
                        .stroke(
                            AngularGradient(colors: [scoreColor, scoreColor.opacity(0.45)], center: .center),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 130, height: 130)
                        .animation(.easeOut(duration: 1.1).delay(0.1), value: scoreAnimated)

                    VStack(spacing: 2) {
                        Text("\(viewModel.correctCount)/\(viewModel.totalQuestions)")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                        Text("\(Int(percentage * 100))%")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Missed Section

    private var missedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Review These", systemImage: "xmark.circle.fill")
                .font(.sectionHeader)
                .foregroundStyle(.red)

            ForEach(Array(missedItems.enumerated()), id: \.offset) { idx, item in
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.question.pathology.name)
                            .font(.structureSubtitle)
                        Text(item.question.prompt)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.25 + Double(idx) * 0.04), value: appeared)
            }
        }
    }
}
