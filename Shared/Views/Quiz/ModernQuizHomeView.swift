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
                        heroCard

                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader("Practice")
                            GroupedList(data: QuizMode.allCases, separatorInset: 64) { mode in
                                modeRow(mode)
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader("Clinical")
                            clinicalRow
                                .contentSurface()
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

    // MARK: - Hero

    /// The Invites-style feature card: full colour, big type, one glass button.
    /// Leads with spaced-repetition reviews when any are due, otherwise a daily set.
    private var heroCard: some View {
        let dueCount = progressStore.dueForReview().count
        let isReview = dueCount > 0
        let shape = RoundedRectangle(cornerRadius: 30, style: .continuous)

        return VStack(alignment: .leading, spacing: 0) {
            Text(isReview ? "REVIEW" : "DAILY PRACTICE")
                .font(.statLabel)
                .kerning(0.6)
                .foregroundStyle(.white.opacity(0.75))

            Group {
                if isReview {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("\(dueCount)")
                            .font(.numeral(56, weight: .heavy))
                            .contentTransition(.numericText())
                        Text(dueCount == 1 ? "structure due" : "structures due")
                            .font(.title3.weight(.semibold))
                    }
                } else {
                    Text("Sharpen your recall.")
                        .font(.title.weight(.bold))
                        .padding(.vertical, 6)
                }
            }
            .foregroundStyle(.white)
            .padding(.top, 4)

            Text(isReview
                 ? "Spaced repetition brings these back right before you would forget them."
                 : selectedRegion.map { "\(questionCount) questions on the \($0.displayName)." }
                    ?? "\(questionCount) questions from across the atlas.")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 2)

            Button {
                startQuiz(mode: isReview ? .flashcard : .multipleChoice)
            } label: {
                Label(isReview ? "Start Review" : "Start", systemImage: "play.fill")
                    .font(.headline)
                    .foregroundStyle(Color(red: 0.30, green: 0.22, blue: 0.74))
                    .padding(.horizontal, 8)
            }
            // White prominent glass on the colour field, like the RSVP button in Invites.
            .glassButton(prominent: true, controlSize: .large)
            .tint(.white)
            .padding(.top, 18)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            ZStack(alignment: .topTrailing) {
                LinearGradient(
                    colors: [Color(red: 0.36, green: 0.27, blue: 0.86), Color(red: 0.22, green: 0.20, blue: 0.62), Color(red: 0.05, green: 0.50, blue: 0.40)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Image(systemName: "brain")
                    .font(.system(size: 150, weight: .light))
                    .foregroundStyle(.white.opacity(0.09))
                    .offset(x: 30, y: -14)
                    .accessibilityHidden(true)
            }
            .clipShape(shape)
        }
        .overlay {
            shape.strokeBorder(.white.opacity(0.18), lineWidth: 0.75)
        }
        .shadow(color: Color(red: 0.25, green: 0.18, blue: 0.70).opacity(0.28), radius: 24, y: 12)
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
                GlyphTile(systemName: "stethoscope", color: .orange, size: 36)
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
