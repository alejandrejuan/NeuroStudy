import SwiftUI

struct QuizResultsView: View {
    let viewModel: QuizViewModel
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

                performanceMessage
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.12), value: appeared)

                if !missedItems.isEmpty {
                    missedSection
                        .opacity(appeared ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.22), value: appeared)
                }

                if !correctItems.isEmpty {
                    correctSection
                        .opacity(appeared ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.32), value: appeared)
                }

                actionButtons
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.42), value: appeared)
            }
            .padding()
        }
        .background { AppBackground() }
        .task {
            appeared = true
            try? await Task.sleep(nanoseconds: 400_000_000)
            scoreAnimated = true
        }
    }

    // MARK: - Computed Properties

    private var percentage: Double {
        guard viewModel.totalQuestions > 0 else { return 0 }
        return Double(viewModel.correctCount) / Double(viewModel.totalQuestions)
    }

    private var missedItems: [(question: QuizQuestion, wasCorrect: Bool)] {
        viewModel.answeredQuestions.filter { !$0.wasCorrect }
    }

    private var correctItems: [(question: QuizQuestion, wasCorrect: Bool)] {
        viewModel.answeredQuestions.filter { $0.wasCorrect }
    }

    private var scoreColor: Color {
        switch percentage {
        case 0.9...: return .yellow
        case 0.7..<0.9: return .green
        case 0.5..<0.7: return .orange
        default: return .red
        }
    }

    private var scoreIcon: String {
        switch percentage {
        case 0.9...: return "star.fill"
        case 0.7..<0.9: return "hand.thumbsup.fill"
        case 0.5..<0.7: return "book.fill"
        default: return "arrow.counterclockwise"
        }
    }

    // MARK: - Score Section

    private var scoreSection: some View {
        LiquidGlassCard(cornerRadius: 24, padding: 24, prominent: true) {
            VStack(spacing: 20) {
                // Icon + title
                VStack(spacing: 8) {
                    Image(systemName: scoreIcon)
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(scoreColor)
                        .symbolEffect(.bounce, value: appeared)

                    Text("Quiz Complete!")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                }

                // Animated circular score
                ZStack {
                    Circle()
                        .stroke(.quaternary, lineWidth: 10)
                        .frame(width: 130, height: 130)

                    Circle()
                        .trim(from: 0, to: scoreAnimated ? percentage : 0)
                        .stroke(
                            AngularGradient(
                                colors: [scoreColor, scoreColor.opacity(0.45)],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 130, height: 130)
                        .animation(.easeOut(duration: 1.1).delay(0.1), value: scoreAnimated)

                    VStack(spacing: 2) {
                        Text("\(viewModel.correctCount)/\(viewModel.totalQuestions)")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .contentTransition(.numericText())
                        Text("\(Int(percentage * 100))%")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }

                // Stat pills
                HStack(spacing: 14) {
                    statPill(value: "\(viewModel.correctCount)", label: "Correct",
                             color: .green, icon: "checkmark.circle.fill")
                    statPill(value: "\(missedItems.count)", label: "Missed",
                             color: .red, icon: "xmark.circle.fill")
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func statPill(value: String, label: String, color: Color, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(color)
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(color.opacity(0.1))
        }
    }

    // MARK: - Performance Message

    private var performanceMessage: some View {
        LiquidGlassCard(cornerRadius: 16, padding: 14) {
            HStack(spacing: 12) {
                Image(systemName: scoreIcon)
                    .font(.title2)
                    .foregroundStyle(scoreColor)
                Text(messageText)
                    .font(.bodyText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var messageText: String {
        switch percentage {
        case 0.9...: return "Outstanding! You have excellent command of these structures."
        case 0.7..<0.9: return "Good work! A few structures need more review."
        case 0.5..<0.7: return "Keep studying. Focus on the structures you missed."
        default: return "These structures need more practice. Review the ones you missed."
        }
    }

    // MARK: - Missed / Correct Sections

    private var missedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Review These", systemImage: "xmark.circle.fill")
                .font(.sectionHeader)
                .foregroundStyle(.red)

            ForEach(Array(missedItems.enumerated()), id: \.offset) { idx, item in
                resultRow(question: item.question, isCorrect: false)
                    .opacity(appeared ? 1 : 0)
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.8)
                            .delay(0.28 + Double(idx) * 0.04),
                        value: appeared
                    )
            }
        }
    }

    private var correctSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Got Right", systemImage: "checkmark.circle.fill")
                .font(.sectionHeader)
                .foregroundStyle(.green)

            ForEach(Array(correctItems.enumerated()), id: \.offset) { idx, item in
                resultRow(question: item.question, isCorrect: true)
                    .opacity(appeared ? 1 : 0)
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.8)
                            .delay(0.38 + Double(idx) * 0.04),
                        value: appeared
                    )
            }
        }
    }

    private func resultRow(question: QuizQuestion, isCorrect: Bool) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(question.targetStructure.region.color.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay {
                    Image(systemName: question.targetStructure.region.sfSymbol)
                        .font(.caption)
                        .foregroundStyle(question.targetStructure.region.color)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(question.targetStructure.name)
                    .font(.structureSubtitle)
                Text(question.targetStructure.functions.first ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(isCorrect ? .green : .red)
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.ultraThinMaterial)
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        Button {
            dismiss()
        } label: {
            Label("Done", systemImage: "checkmark")
                .frame(maxWidth: .infinity)
        }
        .glassButton(prominent: true)
    }
}
