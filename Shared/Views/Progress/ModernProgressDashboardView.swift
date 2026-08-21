import SwiftUI
import Charts

// MARK: - Redesigned Progress Dashboard

/// Enhanced progress tracking with data visualization and Liquid Glass design
struct ModernProgressDashboardView: View {
    let progressStore: ProgressStore
    @State private var appeared = false
    @State private var selectedTimeframe: Timeframe = .week
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    enum Timeframe: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All Time"

        /// How many days of history the chart shows.
        var dayCount: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .all: return 365
            }
        }

        /// Keeps the x-axis from turning into an unreadable smear of labels.
        var axisStride: Int {
            switch self {
            case .week: return 1
            case .month: return 7
            case .all: return 90
            }
        }

        var axisFormat: Date.FormatStyle {
            switch self {
            case .week: return .dateTime.weekday(.narrow)
            case .month, .all: return .dateTime.month(.abbreviated).day()
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Hero progress card
                        heroProgressCard
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 12)
                        
                        // Achievement highlights
                        achievementsSection
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 10)
                        
                        // Activity chart
                        activityChartSection
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 8)
                        
                        // Region breakdown
                        regionBreakdownSection
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 6)
                        
                        // Due for review
                        dueForReviewSection
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 4)
                        
                        // All structures mastery
                        masteryListSection
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 2)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                    .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
                    .frame(maxWidth: .infinity)
                }
                .softScrollEdges()
            }
            .navigationTitle("Your Progress")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .task {
                await animateAppearance()
            }
        }
    }
    
    // MARK: - Hero Progress Card
    
    private var heroProgressCard: some View {
        LiquidGlassCard(cornerRadius: 28, padding: 24, prominent: true) {
            VStack(spacing: 20) {
                // Main progress ring
                OptimizedCircularProgress(
                    progress: overallMasteryProgress,
                    label: "Mastery",
                    lineWidth: 14,
                    size: 160,
                    accentColors: [.blue, .cyan, .purple, .pink]
                )
                
                // Title
                VStack(spacing: 4) {
                    Text("Brain Anatomy Mastery")
                        .font(.structureSubtitle)
                        .foregroundStyle(.secondary)
                    
                    Text("\(progressStore.masteredCount()) of \(BrainStructureStore.all.count) structures")
                        .font(.microText)
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }
    
    private var overallMasteryProgress: Double {
        let total = BrainStructureStore.all.count
        guard total > 0 else { return 0 }
        return Double(progressStore.masteredCount()) / Double(total)
    }
    
    // MARK: - Achievements Section
    
    private var achievementsSection: some View {
        HStack(spacing: 12) {
            achievementCard(
                icon: "book.fill",
                title: "Studied",
                value: progressStore.studiedCount(),
                total: BrainStructureStore.all.count,
                color: .blue
            )
            
            achievementCard(
                icon: "star.fill",
                title: "Mastered",
                value: progressStore.masteredCount(),
                total: BrainStructureStore.all.count,
                color: .yellow
            )
            
            achievementCard(
                icon: "target",
                title: "Accuracy",
                percentage: progressStore.overallAccuracy(),
                color: .green
            )
        }
    }
    
    private func achievementCard(
        icon: String,
        title: String,
        value: Int? = nil,
        total: Int? = nil,
        percentage: Double? = nil,
        color: Color
    ) -> some View {
        LiquidGlassCard(cornerRadius: 18, padding: 14) {
            VStack(spacing: 8) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    color.opacity(0.3),
                                    color.opacity(0.12)
                                ],
                                center: .center,
                                startRadius: 5,
                                endRadius: 20
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(color)
                }
                
                // Value
                if let percentage = percentage {
                    Text("\(Int(percentage * 100))%")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                } else if let value = value, let total = total {
                    HStack(spacing: 3) {
                        Text("\(value)")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                        Text("/\(total)")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Title
                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Activity Chart Section
    
    private var activityChartSection: some View {
        LiquidGlassCard(cornerRadius: 20, padding: 18) {
            VStack(alignment: .leading, spacing: 14) {
                // Header
                HStack {
                    Text("Study Activity")
                        .font(.sectionHeader)
                    
                    Spacer()
                    
                    // Timeframe picker
                    Picker("Timeframe", selection: $selectedTimeframe) {
                        ForEach(Timeframe.allCases, id: \.self) { timeframe in
                            Text(timeframe.rawValue).tag(timeframe)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                }
                
                activityChart
                    .frame(height: 180)
            }
        }
    }

    private var activityData: [(date: Date, count: Int)] {
        progressStore.recentActivity(days: selectedTimeframe.dayCount)
    }

    @ViewBuilder
    private var activityChart: some View {
        let data = activityData

        if data.allSatisfy({ $0.count == 0 }) {
            // An empty chart drawn as bars reads as "the feature is broken". Say what
            // is actually true instead: nothing has been studied yet.
            VStack(spacing: 8) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 28))
                    .foregroundStyle(.tertiary)
                Text("No study activity yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Answer a few quiz questions and your activity will show up here.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Chart(data, id: \.date) { entry in
                BarMark(
                    x: .value("Day", entry.date, unit: .day),
                    y: .value("Answers", entry.count)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(6)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: selectedTimeframe.axisStride)) { value in
                    AxisValueLabel(format: selectedTimeframe.axisFormat)
                }
            }
        }
    }
    
    // MARK: - Region Breakdown Section
    
    private var regionBreakdownSection: some View {
        LiquidGlassCard(cornerRadius: 20, padding: 18) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "brain")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.blue)
                    
                    Text("Progress by Region")
                        .font(.sectionHeader)
                    
                    Spacer()
                }
                
                ForEach(BrainRegion.allCases) { region in
                    regionProgressRow(region)
                }
            }
        }
    }
    
    private func regionProgressRow(_ region: BrainRegion) -> some View {
        let structures = BrainStructureStore.structures(inRegion: region)
        let mastered = structures.filter { s in
            progressStore.progress(for: s.id).masteryLevel == .mastered
        }.count
        let progress = structures.isEmpty ? 0 : Double(mastered) / Double(structures.count)
        
        return VStack(spacing: 8) {
            HStack(spacing: 12) {
                // Region icon
                ZStack {
                    Circle()
                        .fill(region.color.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: region.sfSymbol)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(region.color)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(region.displayName)
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                    
                    Text("\(mastered) of \(structures.count) mastered")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Percentage
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(region.color)
                    .frame(minWidth: 50, alignment: .trailing)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(.quaternary)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    region.color,
                                    region.color.opacity(0.7)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(8, geometry.size.width * progress))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Due for Review Section
    
    @ViewBuilder
    private var dueForReviewSection: some View {
        let dueIDs = progressStore.dueForReview()
        
        if !dueIDs.isEmpty {
            LiquidGlassCard(cornerRadius: 20, padding: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    // Header
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(.orange.opacity(0.15))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.orange)
                        }
                        
                        Text("Due for Review")
                            .font(.sectionHeader)
                        
                        Spacer()
                        
                        Text("\(dueIDs.count)")
                            .font(.system(.caption, design: .rounded, weight: .bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background {
                                Capsule()
                                    .fill(.orange.opacity(0.2))
                            }
                            .foregroundStyle(.orange)
                    }
                    
                    // Due structures
                    ForEach(dueIDs.prefix(5), id: \.self) { id in
                        if let structure = BrainStructureStore.structure(byID: id) {
                            CompactStructureRow(
                                structure: structure,
                                progress: progressStore.progress(for: id)
                            )
                        }
                    }
                    
                    if dueIDs.count > 5 {
                        Text("+ \(dueIDs.count - 5) more structures")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            .padding(.leading, 44)
                    }
                }
            }
        }
    }
    
    // MARK: - Mastery List Section
    
    private var masteryListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Structures")
                .font(.sectionHeader)
                .padding(.horizontal, 4)
            
            LazyVStack(spacing: 8) {
                ForEach(BrainStructureStore.all) { structure in
                    CompactStructureRow(
                        structure: structure,
                        progress: progressStore.progress(for: structure.id)
                    )
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func animateAppearance() async {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            appeared = true
        }
    }
}

// MARK: - Compact Structure Row Component

struct CompactStructureRow: View {
    let structure: BrainStructure
    let progress: StudyProgress
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                structure.region.color.opacity(0.3),
                                structure.region.color.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                
                Image(systemName: structure.region.sfSymbol)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(structure.region.color)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(structure.name)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.primary)
                
                if progress.totalAttempts > 0 {
                    HStack(spacing: 10) {
                        Label(
                            "\(Int(progress.accuracy * 100))%",
                            systemImage: "target"
                        )
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                        
                        Label(
                            "\(progress.totalAttempts)",
                            systemImage: "checkmark.circle"
                        )
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                    }
                } else {
                    Text("Not yet studied")
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                }
            }
            
            Spacer()
            
            // Mastery badge
            ModernMasteryBadge(level: progress.masteryLevel)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.7))
        }
    }
}
