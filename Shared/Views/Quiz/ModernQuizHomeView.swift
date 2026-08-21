import SwiftUI

// MARK: - Redesigned Quiz Home View

/// Enhanced quiz interface with Liquid Glass design and improved UX
struct ModernQuizHomeView: View {
    let progressStore: ProgressStore
    @State private var selectedRegion: BrainRegion?
    @AppStorage("defaultQuizLength") private var defaultQuizLength = 10
    @State private var questionCount: Int = 10
    @State private var appeared = false
    @State private var activeSession: QuizSession?
    @State private var showingPathologyQuiz = false
    @State private var pathologyQuizVM = PathologyQuizViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Hero stats card
                        heroStatsCard
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 10)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: appeared)
                        
                        // Due for review banner
                        dueForReviewBanner
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 10)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1), value: appeared)
                        
                        // Quiz modes with enhanced cards
                        quizModesSection

                        // Clinical Knowledge (DSM-5 / Lezak / Imaging)
                        clinicalKnowledgeSection

                        // Quick settings
                        quickSettingsSection
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 8)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.3), value: appeared)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                    .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Practice Quiz")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            #if os(iOS)
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
                await animateAppearance()
            }
        }
    }
    
    // MARK: - Hero Stats Card
    
    private var heroStatsCard: some View {
        LiquidGlassCard(cornerRadius: 24, padding: 20, prominent: true) {
            VStack(spacing: 16) {
                // Progress ring
                OptimizedCircularProgress(
                    progress: overallProgress,
                    label: "Mastery",
                    lineWidth: 10,
                    size: 130,
                    accentColors: [.blue, .purple, .pink, .orange]
                )
                
                // Stats grid
                HStack(spacing: 0) {
                    statColumn(
                        value: "\(progressStore.studiedCount())",
                        label: "Studied",
                        icon: "book.fill",
                        color: .blue
                    )
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .frame(height: 40)
                        .overlay(.quaternary)
                    
                    statColumn(
                        value: "\(progressStore.masteredCount())",
                        label: "Mastered",
                        icon: "star.fill",
                        color: .green
                    )
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .frame(height: 40)
                        .overlay(.quaternary)
                    
                    statColumn(
                        value: "\(Int(progressStore.overallAccuracy() * 100))%",
                        label: "Accuracy",
                        icon: "target",
                        color: .orange
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 4)
            }
        }
    }
    
    private func statColumn(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(.primary)
            
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
    
    private var overallProgress: Double {
        let total = BrainStructureStore.all.count
        guard total > 0 else { return 0 }
        return Double(progressStore.masteredCount()) / Double(total)
    }
    
    // MARK: - Due for Review Banner
    
    @ViewBuilder
    private var dueForReviewBanner: some View {
        let dueCount = progressStore.dueForReview().count
        
        if dueCount > 0 {
            Button {
                startQuiz(mode: .flashcard)
            } label: {
                LiquidGlassCard(cornerRadius: 18, padding: 16) {
                    HStack(spacing: 14) {
                        // Animated icon
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            .orange.opacity(0.25),
                                            .orange.opacity(0.12)
                                        ],
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 25
                                    )
                                )
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.orange)
                        }
                        
                        // Info
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 6) {
                                Text("\(dueCount)")
                                    .font(.system(.title3, design: .rounded, weight: .bold))
                                    .foregroundStyle(.orange)
                                
                                Text(dueCount == 1 ? "structure due" : "structures due")
                                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            }
                            
                            Text("Spaced repetition • Optimize retention")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        // CTA
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.orange, .ultraThinMaterial)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Quiz Modes Section
    
    private var quizModesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practice Modes")
                .font(.sectionHeader)
                .padding(.horizontal, 4)
            
            ForEach(Array(QuizMode.allCases.enumerated()), id: \.element.id) { index, mode in
                quizModeCard(mode)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : CGFloat(12 + index * 6))
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.8)
                            .delay(Double(index) * 0.08 + 0.15),
                        value: appeared
                    )
            }
        }
    }
    
    private func quizModeCard(_ mode: QuizMode) -> some View {
        Button {
            startQuiz(mode: mode)
        } label: {
            LiquidGlassCard(cornerRadius: 20, padding: 16) {
                HStack(spacing: 16) {
                    // Mode icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        modeColor(mode).opacity(0.2),
                                        modeColor(mode).opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                        
                        Image(systemName: mode.sfSymbol)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(modeColor(mode))
                    }
                    
                    // Mode info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mode.rawValue)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .foregroundStyle(.primary)
                        
                        Text(mode.description)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer(minLength: 8)
                    
                    // Chevron
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .buttonStyle(.plain)
        .pressableScale()
    }
    
    private func modeColor(_ mode: QuizMode) -> Color {
        switch mode {
        case .tapIdentify: return .blue
        case .flashcard: return .purple
        case .multipleChoice: return .green
        }
    }

    // MARK: - Clinical Knowledge Section

    private var clinicalKnowledgeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Clinical Knowledge")
                .font(.sectionHeader)
                .padding(.horizontal, 4)

            Button {
                pathologyQuizVM = PathologyQuizViewModel(count: questionCount)
                showingPathologyQuiz = true
            } label: {
                LiquidGlassCard(cornerRadius: 20, padding: 16) {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [.orange.opacity(0.2), .red.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundStyle(.orange)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("DSM-5 & Neuropsychology")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .foregroundStyle(.primary)
                            Text("Diagnostic criteria, Lezak test profiles, and brain imaging findings")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)

                            HStack(spacing: 6) {
                                ForEach([ContentReference.dsm5, .lezak, .brainImaging], id: \.rawValue) { ref in
                                    SourceReferenceBadge(reference: ref)
                                }
                            }
                            .padding(.top, 2)
                        }

                        Spacer(minLength: 8)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            .buttonStyle(.plain)
            .pressableScale()
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 10)
            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.28), value: appeared)
        }
    }
    
    // MARK: - Quick Settings
    
    private var quickSettingsSection: some View {
        LiquidGlassCard(cornerRadius: 18, padding: 16) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Quick Settings")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                
                // Question count picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Questions per session")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 8) {
                        ForEach([5, 10, 15, 20], id: \.self) { count in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    questionCount = count
                                }
                            } label: {
                                Text("\(count)")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(questionCount == count ? .white : .secondary)
                                    .frame(minWidth: 44, minHeight: 34)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(questionCount == count ? AnyShapeStyle(Color.accentColor) : AnyShapeStyle(.quaternary))
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Region filter
                VStack(alignment: .leading, spacing: 8) {
                    Text("Focus region (optional)")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            regionFilterButton(label: "All", region: nil)
                            
                            ForEach(BrainRegion.allCases) { region in
                                regionFilterButton(label: region.displayName, region: region)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func regionFilterButton(label: String, region: BrainRegion?) -> some View {
        let isSelected = selectedRegion == region
        
        return Button {
            withAnimation(.spring(response: 0.3)) {
                selectedRegion = region
            }
        } label: {
            HStack(spacing: 4) {
                if let r = region {
                    Image(systemName: r.sfSymbol)
                        .font(.system(size: 9, weight: .semibold))
                }
                
                Text(label)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background {
                Capsule(style: .continuous)
                    .fill(isSelected ? AnyShapeStyle(region?.color.opacity(0.2) ?? Color.accentColor.opacity(0.2)) : AnyShapeStyle(.quaternary))
            }
            .overlay {
                if isSelected {
                    Capsule(style: .continuous)
                        .strokeBorder(region?.color ?? .accentColor, lineWidth: 1)
                }
            }
            .foregroundStyle(isSelected ? (region?.color ?? .accentColor) : .secondary)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Helper Methods
    
    private func startQuiz(mode: QuizMode) {
        activeSession = QuizSession(
            mode: mode,
            questionCount: questionCount,
            region: selectedRegion
        )
    }
    
    private func animateAppearance() async {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            appeared = true
        }
    }
}

// MARK: - Pressable Scale Modifier

extension View {
    func pressableScale(scale: CGFloat = 0.97) -> some View {
        self.modifier(PressableScaleModifier(scale: scale))
    }
}

struct PressableScaleModifier: ViewModifier {
    let scale: CGFloat
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
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
