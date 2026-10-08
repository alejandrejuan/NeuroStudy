import SwiftUI

// MARK: - Navigation Selection
private enum MainSection: String, CaseIterable, Identifiable, Hashable {
    case explore, quiz, progress, settings, about
    var id: String { rawValue }
    var title: String {
        switch self {
        case .explore: return "Atlas"
        case .quiz: return "Quiz"
        case .progress: return "Progress"
        case .settings: return "Settings"
        case .about: return "About"
        }
    }
    var systemImage: String {
        switch self {
        case .explore: return "brain.head.profile"
        case .quiz: return "questionmark.circle.fill"
        case .progress: return "chart.bar.fill"
        case .settings: return "gearshape"
        case .about: return "info.circle"
        }
    }
}

// MARK: - Universal App Structure with iPad Optimization

/// Adaptive main view that provides optimal layouts for iPhone and iPad
struct UniversalMainView: View {
    let progressStore: ProgressStore
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selection: MainSection? = .explore
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    var body: some View {
        content
    }

    @ViewBuilder
    private var content: some View {
        #if os(iOS)
        if horizontalSizeClass == .regular {
            // iPad or iPhone Plus in landscape - Use sidebar navigation
            iPadLayout
        } else {
            // iPhone portrait - Use tab bar
            iPhoneLayout
        }
        #elseif os(macOS)
        // macOS - Use sidebar
        macOSLayout
        #endif
    }

    // MARK: - iPad Layout (Sidebar Navigation)

    private var iPadLayout: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(MainSection.allCases, selection: $selection) { section in
                Label(section.title, systemImage: section.systemImage)
                    .tag(section)
            }
            .navigationTitle("NeuroStudy")
            .listStyle(.sidebar)
        } detail: {
            detailView(for: selection ?? .explore)
        }
        .navigationSplitViewStyle(.balanced)
    }

    // MARK: - iPhone Layout (Tab Bar)

    #if os(iOS)

    private var iPhoneLayout: some View {
        TabView(selection: Binding(
            get: { selection ?? .explore },
            set: { selection = $0 }
        )) {
            ModernExploreView(progressStore: progressStore)
                .tabItem { Label("Atlas", systemImage: "brain.head.profile") }
                .tag(MainSection.explore)

            ModernQuizHomeView(progressStore: progressStore)
                .tabItem { Label("Quiz", systemImage: "questionmark.circle.fill") }
                .tag(MainSection.quiz)

            ModernProgressDashboardView(progressStore: progressStore)
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
                .tag(MainSection.progress)

            // Without this tab the Settings pane — and with it the Privacy Policy
            // link, the Terms link, and the educational-use disclaimer — is
            // unreachable on every iPhone in portrait.
            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
            .tag(MainSection.settings)
        }
        .minimizingTabBar()
        .tint(.accentColor)
    }

    #endif

    // MARK: - macOS Layout

    private var macOSLayout: some View {
        NavigationSplitView {
            List(MainSection.allCases, selection: $selection) { section in
                Label(section.title, systemImage: section.systemImage)
                    .tag(section)
            }
            .navigationTitle("NeuroStudy")
            .frame(minWidth: 200)
        } detail: {
            detailView(for: selection ?? .explore)
        }
    }
    
    // MARK: - Detail View Builder
    
    @ViewBuilder
    private func detailView(for section: MainSection) -> some View {
        switch section {
        case .explore:
            ModernExploreView(progressStore: progressStore)
        case .quiz:
            ModernQuizHomeView(progressStore: progressStore)
        case .progress:
            ModernProgressDashboardView(progressStore: progressStore)
        case .settings:
            // NavigationStack so the About link inside Settings has somewhere to push.
            NavigationStack { SettingsView() }
        case .about:
            NavigationStack { AboutView() }
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    @AppStorage("defaultQuizLength") private var defaultQuizLength = 10

    var body: some View {
        Form {
            Section("Interactions") {
                Toggle(isOn: $hapticFeedback) {
                    Label { Text("Haptic Feedback") } icon: { GlyphTile(systemName: "iphone.radiowaves.left.and.right", color: .pink, size: 29) }
                }
            }

            Section("Study Preferences") {
                Picker(selection: $defaultQuizLength) {
                    Text("5 Questions").tag(5)
                    Text("10 Questions").tag(10)
                    Text("15 Questions").tag(15)
                    Text("20 Questions").tag(20)
                } label: {
                    Label { Text("Default Quiz Length") } icon: { GlyphTile(systemName: "list.number", color: Theme.violet, size: 29) }
                }
            }

            Section("About") {
                NavigationLink {
                    AboutView()
                } label: {
                    Label { Text("About NeuroStudy") } icon: { GlyphTile(systemName: "info", color: .gray, size: 29) }
                }

                Link(destination: URL(string: "https://alejandrejuan.github.io/NeuroStudy/privacy-policy.html")!) {
                    externalRow("Privacy Policy", symbol: "hand.raised.fill", color: .blue)
                }
                Link(destination: URL(string: "https://alejandrejuan.github.io/NeuroStudy/terms-of-service.html")!) {
                    externalRow("Terms of Service", symbol: "doc.text.fill", color: .gray)
                }
            }

            Section {
                LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                LabeledContent("Build", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
            }
        }
        // The form floats on the app background like every other screen, rather than
        // dropping to the flat system grey.
        .scrollContentBackground(.hidden)
        .background { AppBackground() }
        .navigationTitle("Settings")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }

    /// A row that opens Safari: primary text and an outgoing arrow, as in Settings.
    private func externalRow(_ title: String, symbol: String, color: Color) -> some View {
        HStack {
            Label { Text(title) } icon: { GlyphTile(systemName: symbol, color: color, size: 29) }
            Spacer()
            Image(systemName: "arrow.up.forward")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .foregroundStyle(.primary)
    }
}

// MARK: - About View

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // App Icon and Title
                VStack(spacing: 12) {
                    // The real app icon, rendered from AppIcon.icon by ictool (light and
                    // dark variants). The PNG already carries the squircle mask.
                    Image("AppIconDisplay")
                        .resizable()
                        .interpolation(.high)
                        .frame(width: 112, height: 112)
                        .shadow(color: .black.opacity(0.18), radius: 12, y: 6)
                        .accessibilityLabel("NeuroStudy app icon")

                    Text("NeuroStudy")
                        .font(.largeTitle.weight(.bold))
                    
                    Text("Master Brain Anatomy")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
                
                // Description
                SurfaceCard(cornerRadius: 20, padding: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About NeuroStudy")
                            .font(.headline)
                        
                        Text("NeuroStudy is a study tool for learning neuroanatomy and neuropathology. It is built for students, and its content is written as study material, not as a clinical reference. Use it to learn and revise; use your course materials and a qualified clinician for anything that matters.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Features
                SurfaceCard(cornerRadius: 20, padding: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Features")
                            .font(.headline)
                        
                        FeatureRow(
                            icon: "brain.head.profile",
                            color: .blue,
                            title: "Interactive Atlas",
                            description: "Explore \(BrainStructureStore.all.count) brain structures across lateral and medial views"
                        )
                        
                        FeatureRow(
                            icon: "questionmark.circle.fill",
                            color: Theme.violet,
                            title: "Practice Quizzes",
                            description: "Four quiz modes, with spaced repetition scheduling your reviews"
                        )
                        
                        FeatureRow(
                            icon: "chart.bar.fill",
                            color: Theme.emerald,
                            title: "Progress Tracking",
                            description: "Mastery by region, accuracy, and daily activity"
                        )
                    }
                }
                
                // Credits
                SurfaceCard(cornerRadius: 20, padding: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Suggested Reading")
                            .font(.headline)

                        Text("NeuroStudy is not a substitute for a textbook. To go deeper, or to check anything you read here:\n\n• Principles of Neural Science (Kandel et al.)\n• Neuroanatomy Through Clinical Cases (Blumenfeld)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Educational Disclaimer
                SurfaceCard(cornerRadius: 20, padding: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Educational Use Only", systemImage: "exclamationmark.triangle")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.orange)

                        Text("NeuroStudy is an educational tool designed for students and academic study of neuroanatomy and neuropsychology. All content, including DSM-5 diagnostic criteria, clinical descriptions, and neuroimaging findings, is presented for learning purposes only and does not constitute medical advice, diagnosis, or treatment. Always consult a qualified healthcare professional for clinical decisions.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // Copyright
                Text("© 2026 Juan Alejandre. All rights reserved.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.vertical, 20)
            }
            .padding(.horizontal, 20)
        }
        .background(AppBackground())
        .navigationTitle("About")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

struct FeatureRow: View {
    let icon: String
    var color: Color = .blue
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            GlyphTile(systemName: icon, color: color, size: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.semibold))
                Text(description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("iPhone") {
    UniversalMainView(progressStore: ProgressStore())
        .environment(\.horizontalSizeClass, .compact)
}

#Preview("iPad") {
    UniversalMainView(progressStore: ProgressStore())
        .environment(\.horizontalSizeClass, .regular)
}
#endif

