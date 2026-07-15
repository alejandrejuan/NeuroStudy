import SwiftUI

struct FlashcardQuizView: View {
    @Bindable var viewModel: QuizViewModel
    @State private var isFlipped = false
    @State private var dragOffset: CGSize = .zero
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AdaptiveGradientBackground()

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
                            Text("Tap card to reveal answer")
                                .font(.detailLabel)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Flashcards")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("End Quiz") { dismiss() }
                }
            }
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        VStack(spacing: 4) {
            ProgressView(value: viewModel.progress)
                .tint(.purple)

            HStack {
                Text("Card \(viewModel.currentIndex + 1) of \(viewModel.totalQuestions)")
                    .font(.detailLabel)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(viewModel.correctCount) recalled")
                    .font(.detailLabel)
                    .foregroundStyle(.green)
            }
        }
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
        .frame(maxWidth: 400)
    }

    private func cardFace(isFront: Bool, question: QuizQuestion) -> some View {
        LiquidGlassCard(cornerRadius: 24, prominent: isFront) {
            VStack(spacing: 16) {
                if isFront {
                    // Front: structure name and region
                    Spacer()

                    ModernRegionBadge(region: question.targetStructure.region, style: .prominent)

                    Text(question.targetStructure.name)
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .multilineTextAlignment(.center)

                    if !question.targetStructure.aliases.isEmpty {
                        Text(question.targetStructure.aliases.first ?? "")
                            .font(.structureSubtitle)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    SourceReferenceBadge(reference: question.sourceReference)

                    HStack {
                        Image(systemName: "hand.tap.fill")
                            .foregroundStyle(.secondary)
                        Text("Tap to flip")
                            .font(.detailLabel)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    // Back: functions and clinical info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Functions")
                            .font(.sectionHeader)
                            .foregroundStyle(.purple)

                        ForEach(question.targetStructure.functions, id: \.self) { function in
                            HStack(alignment: .top, spacing: 8) {
                                Circle()
                                    .fill(.purple.opacity(0.5))
                                    .frame(width: 6, height: 6)
                                    .padding(.top, 6)
                                Text(function)
                                    .font(.bodyText)
                            }
                        }

                        Divider()

                        Text("Clinical Significance")
                            .font(.sectionHeader)
                            .foregroundStyle(.orange)

                        Text(question.targetStructure.clinicalSignificance)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(4)

                        if !question.targetStructure.associatedDisorders.isEmpty {
                            Divider()
                            Text("Disorders")
                                .font(.sectionHeader)
                                .foregroundStyle(.red)
                            Text(question.targetStructure.associatedDisorders.joined(separator: ", "))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 300)
        }
    }

    // MARK: - Grade Buttons

    private var gradeButtons: some View {
        VStack(spacing: 8) {
            Text("How well did you recall?")
                .font(.structureSubtitle)
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
                                .font(.system(.caption, design: .rounded, weight: .medium))
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
