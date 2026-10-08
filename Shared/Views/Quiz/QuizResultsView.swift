import SwiftUI

struct QuizResultsView: View {
    let viewModel: QuizViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                ScoreHero(correct: viewModel.correctCount, total: viewModel.totalQuestions)

                if !missed.isEmpty {
                    resultSection("Review These", questions: missed, correct: false)
                }
                if !correct.isEmpty {
                    resultSection("Got Right", questions: correct, correct: true)
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

    private var missed: [QuizQuestion] {
        viewModel.answeredQuestions.filter { !$0.wasCorrect }.map(\.question)
    }

    private var correct: [QuizQuestion] {
        viewModel.answeredQuestions.filter { $0.wasCorrect }.map(\.question)
    }

    private func resultSection(_ title: String, questions: [QuizQuestion], correct: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title) {
                Text("\(questions.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            GroupedList(data: questions) { question in
                HStack(spacing: 14) {
                    GlyphTile(systemName: question.targetStructure.region.sfSymbol, color: question.targetStructure.region.color)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(question.targetStructure.name)
                            .font(.body)
                        if let function = question.targetStructure.functions.first {
                            Text(function)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    Spacer(minLength: 8)
                    ResultMark(correct: correct)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
        }
    }
}
