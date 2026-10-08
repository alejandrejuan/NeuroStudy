import SwiftUI

struct FlashcardQuizView: View {
    @Bindable var viewModel: QuizViewModel
    @State private var isFlipped = false
    @State private var dragOffset: CGSize = .zero
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                if viewModel.isComplete {
                    QuizResultsView(viewModel: viewModel)
                } else {
                    VStack(spacing: 24) {
                        // Progress
                        progressBar

                        Spacer()

                        // Card
                        if let question = viewModel.currentQuestion {
                            flashcard(question)
                                .offset(dragOffset)
                                .gesture(swipeGesture)
                        }

                        Spacer()

                        // Grade buttons (shown when flipped)
                        if isFlipped {
                            gradeButtons
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        } else {
                            Label("Tap the card to reveal", systemImage: "hand.tap")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                }
            }
            .quizChrome(title: "Flashcards") { dismiss() }
        }
    }

    // MARK: - Progress

    private var progressBar: some View {
        QuizProgressHeader(
            progress: viewModel.progress,
            current: viewModel.currentIndex + 1,
            total: viewModel.totalQuestions,
            score: viewModel.correctCount,
            scoreNoun: "recalled"
        )
    }

    // MARK: - Flashcard

    private func flashcard(_ question: QuizQuestion) -> some View {
        ZStack {
            // Front
            cardFace(isFront: true, question: question)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // Back
            cardFace(isFront: false, question: question)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isFlipped.toggle()
            }
        }
        // Both faces share one frame so the card keeps its size through the flip:
        // as tall as the screen allows, up to a comfortable 500pt.
        .frame(maxWidth: 420, minHeight: 360, maxHeight: 500)
    }

    private func cardFace(isFront: Bool, question: QuizQuestion) -> some View {
        let structure = question.targetStructure

        return SurfaceCard(cornerRadius: 30, padding: 24) {
            Group {
                if isFront {
                    VStack(spacing: 14) {
                        Spacer(minLength: 0)
                        GlyphTile(systemName: structure.region.sfSymbol, color: structure.region.color, size: 60)
                        Text(structure.region.displayName.uppercased())
                            .font(.statLabel)
                            .foregroundStyle(.secondary)
                        Text(structure.name)
                            .font(.largeTitle.weight(.bold))
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.7)
                        if let alias = structure.aliases.first {
                            Text(alias)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        backSection("Functions") {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(structure.functions, id: \.self) { function in
                                    Label {
                                        Text(function).font(.body)
                                    } icon: {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 5))
                                            .foregroundStyle(structure.region.color)
                                    }
                                }
                            }
                        }

                        Divider()

                        backSection("Clinical Significance") {
                            Text(structure.clinicalSignificance)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .lineLimit(5)
                        }

                        if !structure.associatedDisorders.isEmpty {
                            Divider()
                            backSection("Disorders") {
                                Text(structure.associatedDisorders.joined(separator: ", "))
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }

    private func backSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.statLabel)
                .foregroundStyle(.secondary)
            content()
        }
    }

    // MARK: - Grade Buttons

    private var gradeButtons: some View {
        VStack(spacing: 8) {
            Text("How well did you recall it?")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ForEach(SpacedRepetitionGrade.allCases, id: \.rawValue) { grade in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            viewModel.submitFlashcardGrade(grade)
                            isFlipped = false
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: grade.sfSymbol)
                                .font(.title3)
                            Text(grade.label)
                                .font(.footnote.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .glassButton(prominent: grade == .good)
                }
            }
        }
    }

    // MARK: - Swipe Gesture

    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    dragOffset = .zero
                }
            }
    }
}
