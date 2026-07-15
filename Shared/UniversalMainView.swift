import SwiftUI

// MARK: - Navigation Selection
private enum MainSection: String, CaseIterable, Identifiable, Hashable {
    case explore, quiz, progress, settings, about
    var id: String { rawValue }
    var title: String {
        switch self {
        case .explore: return "Explore Atlas"
        case .quiz: return "Practice Quiz"
        case .progress: return "Your Progress"
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
    @AppStorage("darkMode") private var darkMode = false

    var body: some View {
        content
            .preferredColorScheme(darkMode ? .dark : nil)
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

    private var iPhoneLayout: some View {
        TabView(selection: Binding(
            get: { selection ?? .explore },
            set: { selection = $0 }
        )) {
            ModernExploreView(progressStore: progressStore)
                .tabItem { Label("Explore", systemImage: "brain.head.profile") }
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
        .tint(.accentColor)
    }

    // MARK: - macOS Layout

    private var macOSLayout: some View {
        NavigationSplitView {
            List(MainSection.allCases, selection: $selection) { section in
                Label(section.title.replacingOccurrences(of: "Atlas", with: ""), systemImage: section.systemImage)
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
    @AppStorage("darkMode") private var darkMode = false
    @AppStorage("defaultQuizLength") private var defaultQuizLength = 10

    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $darkMode)
            }

            Section("Interactions") {
                Toggle("Haptic Feedback", isOn: $hapticFeedback)
            }

            Section("Study Preferences") {
                Picker("Default Quiz Length", selection: $defaultQuizLength) {
                    Text("5 Questions").tag(5)
                    Text("10 Questions").tag(10)
                    Text("15 Questions").tag(15)
                    Text("20 Questions").tag(20)
                }
            }
            
            Section("About") {
                LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                LabeledContent("Build", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")

                NavigationLink("About NeuroStudy") {
                    AboutView()
                }

                Link("Privacy Policy", destination: URL(string: "https://alejandrejuan.github.io/NeuroStudy/privacy-policy.html")!)
                Link("Terms of Service", destination: URL(string: "https://alejandrejuan.github.io/NeuroStudy/terms-of-service.html")!)
            }
        }
        .navigationTitle("Settings")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - About View

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // App Icon and Title
                VStack(spacing: 12) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("NeuroStudy")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    
                    Text("Master Brain Anatomy")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
                
                // Description
                LiquidGlassCard(cornerRadius: 20, padding: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About NeuroStudy")
                            .font(.headline)
                        
                        Text("NeuroStudy is a study tool for learning neuroanatomy and neuropathology. It is built for students, and its content is written as study material — not as a clinical reference. Use it to learn and revise; use your course materials and a qualified clinician for anything that matters.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Features
                LiquidGlassCard(cornerRadius: 20, padding: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Features")
                            .font(.headline)
                        
                        FeatureRow(
                            icon: "brain.head.profile",
                            title: "Interactive Atlas",
                            description: "Explore \(BrainStructureStore.all.count) brain structures across lateral and medial views"
                        )
                        
                        FeatureRow(
                            icon: "questionmark.circle.fill",
                            title: "Practice Quizzes",
                            description: "Multiple quiz modes with spaced repetition for optimal learning"
                        )
                        
                        FeatureRow(
                            icon: "chart.bar.fill",
                            title: "Progress Tracking",
                            description: "Monitor your mastery with detailed analytics and insights"
                        )
                    }
                }
                
                // Credits
                LiquidGlassCard(cornerRadius: 20, padding: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Suggested Reading")
                            .font(.headline)

                        Text("NeuroStudy is not a substitute for a textbook. To go deeper, or to check anything you read here:\n\n• Principles of Neural Science (Kandel et al.)\n• Neuroanatomy Through Clinical Cases (Blumenfeld)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Educational Disclaimer
                LiquidGlassCard(cornerRadius: 20, padding: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Educational Use Only", systemImage: "exclamationmark.triangle")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.orange)

                        Text("NeuroStudy is an educational tool designed for students and academic study of neuroanatomy and neuropsychology. All content — including DSM-5 diagnostic criteria, clinical descriptions, and neuroimaging findings — is presented for learning purposes only and does not constitute medical advice, diagnosis, or treatment. Always consult a qualified healthcare professional for clinical decisions.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // Copyright
                Text("© 2026 NeuroStudy. All rights reserved.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.vertical, 20)
            }
            .padding(.horizontal, 20)
        }
        .background(AdaptiveGradientBackground())
        .navigationTitle("About")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
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

