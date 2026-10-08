import SwiftUI
import Charts

// MARK: - Progress

/// A scoreboard, in the Apple Sports sense: the numbers are the design. Big expanded
/// numerals, small uppercase labels, everything else quiet.
struct ModernProgressDashboardView: View {
    let progressStore: ProgressStore
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
                    VStack(alignment: .leading, spacing: 28) {
                        VStack(spacing: 12) {
                            masteryCard
                            statsRow
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader("Activity")
                            activityCard
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader("By Region")
                            GroupedList(data: BrainRegion.allCases) { regionRow($0) }
                        }

                        dueForReviewSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 28)
                    .frame(maxWidth: horizontalSizeClass == .regular ? 720 : .infinity)
                    .frame(maxWidth: .infinity)
                }
                .softScrollEdges()
            }
            .navigationTitle("Progress")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }

    private var totalStructures: Int { BrainStructureStore.all.count }

    // MARK: - Mastery

    private var masteryCard: some View {
        let mastered = progressStore.masteredCount()

        return SurfaceCard(cornerRadius: 28, padding: 22) {
            HStack(spacing: 22) {
                OptimizedCircularProgress(
                    progress: overallMasteryProgress,
                    label: "Mastery",
                    lineWidth: 12,
                    size: 116
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text("MASTERED")
                        .font(.statLabel)
                        .foregroundStyle(.secondary)
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("\(mastered)")
                            .font(.numeral(48, weight: .heavy))
                            .contentTransition(.numericText())
                        Text("/ \(totalStructures)")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    Text("structures")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .monospacedDigit()

                Spacer(minLength: 0)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var overallMasteryProgress: Double {
        guard totalStructures > 0 else { return 0 }
        return Double(progressStore.masteredCount()) / Double(totalStructures)
    }

    // MARK: - Stats

    private var statsRow: some View {
        HStack(spacing: 0) {
            stat("Studied", value: "\(progressStore.studiedCount())", symbol: "book.fill", color: Theme.violet)
            Divider().padding(.vertical, 14)
            stat("Accuracy", value: "\(Int(progressStore.overallAccuracy() * 100))%", symbol: "target", color: Theme.emerald)
            Divider().padding(.vertical, 14)
            stat("Due", value: "\(progressStore.dueForReview().count)", symbol: "clock.arrow.circlepath", color: .orange)
        }
        .contentSurface()
    }

    private func stat(_ title: String, value: String, symbol: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title.uppercased(), systemImage: symbol)
                .font(.statLabel)
                .foregroundStyle(.secondary)
                .labelStyle(StatLabelStyle(color: color))
            Text(value)
                .font(.numeral(26))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Activity

    private var activityCard: some View {
        SurfaceCard(padding: 16) {
            VStack(alignment: .leading, spacing: 16) {
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(Timeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()

                activityChart
                    .frame(height: 170)
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
                .foregroundStyle(Theme.violet.gradient)
                .cornerRadius(4)
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
    
    // MARK: - Regions

    private func regionRow(_ region: BrainRegion) -> some View {
        let structures = BrainStructureStore.structures(inRegion: region)
        let mastered = structures.filter { progressStore.progress(for: $0.id).masteryLevel == .mastered }.count
        let progress = structures.isEmpty ? 0 : Double(mastered) / Double(structures.count)

        return HStack(spacing: 14) {
            GlyphTile(systemName: region.sfSymbol, color: region.color)

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(region.displayName)
                        .font(.body)
                    Spacer()
                    Text("\(mastered)/\(structures.count)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(.quaternary)
                        Capsule()
                            .fill(region.color)
                            .frame(width: progress > 0 ? max(6, geo.size.width * progress) : 0)
                    }
                }
                .frame(height: 4)
                .animation(.spring(response: 0.6, dampingFraction: 0.85), value: progress)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(region.displayName), \(mastered) of \(structures.count) mastered")
    }

    // MARK: - Due for Review

    @ViewBuilder
    private var dueForReviewSection: some View {
        let dueIDs = progressStore.dueForReview()
        let structures = dueIDs.prefix(5).compactMap { BrainStructureStore.structure(byID: $0) }

        if !structures.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                SectionHeader("Due for Review") {
                    Text("\(dueIDs.count)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.orange)
                        .monospacedDigit()
                }
                GroupedList(data: structures) { structure in
                    CompactStructureRow(structure: structure, progress: progressStore.progress(for: structure.id))
                }
                if dueIDs.count > 5 {
                    Text("\(dueIDs.count - 5) more in your next review")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }
            }
        }
    }
}

// MARK: - Stat Label Style

/// A tinted symbol beside an uppercase caption.
private struct StatLabelStyle: LabelStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon.foregroundStyle(color)
            configuration.title
        }
    }
}

// MARK: - Compact Structure Row

struct CompactStructureRow: View {
    let structure: BrainStructure
    let progress: StudyProgress

    var body: some View {
        HStack(spacing: 14) {
            GlyphTile(systemName: structure.region.sfSymbol, color: structure.region.color)

            VStack(alignment: .leading, spacing: 1) {
                Text(structure.name)
                    .font(.body)
                Group {
                    if progress.totalAttempts > 0 {
                        Text("\(Int(progress.accuracy * 100))% accuracy over \(progress.totalAttempts) \(progress.totalAttempts == 1 ? "answer" : "answers")")
                    } else {
                        Text("Not yet studied")
                    }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            ModernMasteryBadge(level: progress.masteryLevel)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}
