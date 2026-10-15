import SwiftUI

// MARK: - Quiz

struct ModernQuizHomeView: View {
    let progressStore: ProgressStore
    @State private var selectedRegion: BrainRegion?
    @AppStorage("defaultQuizLength") private var defaultQuizLength = 10
    @State private var questionCount: Int = 10
    @State private var activeSession: QuizSession?
    @State private var showingPathologyQuiz = false
    @State private var pathologyQuizVM = PathologyQuizViewModel(progressStore: nil)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        reviewSection

                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader("Practice")
                            GroupedList(data: PracticeItem.all, separatorInset: 64) { item in
                                switch item {
                                case .mode(let mode): modeRow(mode)
                                case .clinical: clinicalRow
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader("Session")
                            sessionSettings
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 28)
                    .frame(maxWidth: horizontalSizeClass == .regular ? 720 : .infinity)
                    .frame(maxWidth: .infinity)
                }
                .softScrollEdges()
            }
            .navigationTitle("Quiz")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .fullScreenCover(item: $activeSession) { session in
                QuizSessionView(session: session, progressStore: progressStore)
            }
            .fullScreenCover(isPresented: $showingPathologyQuiz) {
                PathologyQuizView(viewModel: pathologyQuizVM)
            }
            #else
            .sheet(item: $activeSession) { session in
                QuizSessionView(session: session, progressStore: progressStore)
                    .frame(minWidth: 700, minHeight: 600)
            }
            .sheet(isPresented: $showingPathologyQuiz) {
                PathologyQuizView(viewModel: pathologyQuizVM)
                    .frame(minWidth: 700, minHeight: 600)
            }
            #endif
            .task {
                questionCount = defaultQuizLength
            }
        }
    }

    // MARK: - Review

    /// Shown only when spaced repetition has something due. One row, no banner:
    /// the count is the whole message.
    @ViewBuilder
    private var reviewSection: some View {
        let dueCount = progressStore.dueForReview().count
        if dueCount > 0 {
            VStack(alignment: .leading, spacing: 10) {
                SectionHeader("Review")
                Button {
                    startQuiz(mode: .flashcard)
                } label: {
                    HStack(spacing: 14) {
                        GlyphTile(systemName: "clock.arrow.circlepath", color: .orange, size: 36)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(dueCount) \(dueCount == 1 ? "structure" : "structures") due")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.primary)
                            Text("Review them before they fade")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 8)
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .contentSurface()
            }
        }
    }

    // MARK: - Rows

    private func modeRow(_ mode: QuizMode) -> some View {
        Button {
            startQuiz(mode: mode)
        } label: {
            HStack(spacing: 14) {
                GlyphTile(systemName: mode.sfSymbol, color: modeColor(mode), size: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text(mode.rawValue)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(mode.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func modeColor(_ mode: QuizMode) -> Color {
        switch mode {
        case .tapIdentify: return .blue
        case .flashcard: return Theme.violet
        case .multipleChoice: return Theme.emerald
        }
    }

    private var clinicalRow: some View {
        Button {
            pathologyQuizVM = PathologyQuizViewModel(count: questionCount, progressStore: progressStore)
            showingPathologyQuiz = true
        } label: {
            HStack(spacing: 14) {
                GlyphTile(systemName: "stethoscope", color: .pink, size: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text("DSM-5 & Neuropsychology")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text("Criteria, test profiles, and imaging")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Session Settings

    /// Native controls, the way Apple's own apps expose settings: a segmented control
    /// for length and a pop-up menu for the region, not a strip of custom chips.
    private var sessionSettings: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text("Questions")
                Spacer()
                Picker("Questions", selection: $questionCount) {
                    ForEach([5, 10, 15, 20], id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .frame(maxWidth: 210)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            Divider().padding(.leading, 14)

            HStack {
                Text("Focus")
                Spacer()
                Picker("Focus", selection: $selectedRegion) {
                    Text("All Regions").tag(BrainRegion?.none)
                    Divider()
                    ForEach(BrainRegion.allCases) { region in
                        Text(region.displayName).tag(BrainRegion?.some(region))
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .tint(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
        }
        .contentSurface()
    }

    // MARK: - Helper Methods

    private func startQuiz(mode: QuizMode) {
        activeSession = QuizSession(
            mode: mode,
            questionCount: questionCount,
            region: selectedRegion
        )
    }
}

// MARK: - Supporting Types

/// The rows of the Practice list: the three anatomy modes, then the clinical quiz.
private enum PracticeItem: Identifiable {
    case mode(QuizMode)
    case clinical

    static let all: [PracticeItem] = QuizMode.allCases.map { .mode($0) } + [.clinical]

    var id: String {
        switch self {
        case .mode(let mode): return mode.id
        case .clinical: return "clinical"
        }
    }
}

private struct QuizSession: Identifiable {
    let id = UUID()
    let mode: QuizMode
    let questionCount: Int
    let region: BrainRegion?
}

private struct QuizSessionView: View {
    let session: QuizSession
    @State private var viewModel: QuizViewModel
    
    init(session: QuizSession, progressStore: ProgressStore) {
        self.session = session
        _viewModel = State(initialValue: QuizViewModel(
            mode: session.mode,
            progressStore: progressStore,
            questionCount: session.questionCount,
            region: session.region
        ))
    }
    
    var body: some View {
        switch session.mode {
        case .tapIdentify:
            TapIdentifyQuizView(viewModel: viewModel)
        case .flashcard:
            FlashcardQuizView(viewModel: viewModel)
        case .multipleChoice:
            MultipleChoiceQuizView(viewModel: viewModel)
        }
    }
}
