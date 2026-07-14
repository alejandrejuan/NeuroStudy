import SwiftUI

@Observable
class ProgressStore {
    private let defaults: UserDefaults
    private let storageKey = "neurostudy.progress"
    private let activityKey = "neurostudy.activity"
    private let schemaVersionKey = "neurostudy.schemaVersion"
    private let salvageKeyPrefix = "neurostudy.salvage."

    /// Bump when the shape of `StudyProgress` or the activity log changes.
    /// A mismatch routes through `migrate(from:)` instead of silently discarding data.
    private static let currentSchemaVersion = 1

    private var cache: [String: StudyProgress] = [:]

    /// Answers recorded per calendar day, keyed by `yyyy-MM-dd`. Backs the Study
    /// Activity chart on the Progress dashboard.
    private var activity: [String: Int] = [:]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        loadAll()
    }

    // MARK: - Loading

    private func loadAll() {
        let storedVersion = defaults.integer(forKey: schemaVersionKey)

        // A brand-new install has no data and reports version 0. Stamp it and move on.
        guard defaults.data(forKey: storageKey) != nil else {
            defaults.set(Self.currentSchemaVersion, forKey: schemaVersionKey)
            return
        }

        if storedVersion != Self.currentSchemaVersion {
            migrate(from: storedVersion)
            return
        }

        decodeIntoCache()
        decodeActivity()
    }

    private func decodeIntoCache() {
        guard let data = defaults.data(forKey: storageKey) else { return }
        do {
            cache = try JSONDecoder().decode([String: StudyProgress].self, from: data)
        } catch {
            // Never destroy what we could not read. Park the unreadable blob under a
            // salvage key so a future version can recover it, and refuse to overwrite
            // the original until the user has actually created new progress.
            salvage(data, reason: "decode-failed")
            cache = [:]
        }
    }

    private func decodeActivity() {
        guard let data = defaults.data(forKey: activityKey) else { return }
        activity = (try? JSONDecoder().decode([String: Int].self, from: data)) ?? [:]
    }

    /// Older builds wrote no schema version. There is only one schema so far, so the
    /// only real job here is to stamp existing v0 data as v1 without touching it.
    private func migrate(from oldVersion: Int) {
        switch oldVersion {
        case 0:
            decodeIntoCache()
            decodeActivity()
            defaults.set(Self.currentSchemaVersion, forKey: schemaVersionKey)
        default:
            // Data written by a NEWER build than this one. Do not touch it — the user
            // likely downgraded. Start empty rather than corrupting the newer blob.
            if let data = defaults.data(forKey: storageKey) {
                salvage(data, reason: "future-version-\(oldVersion)")
            }
            cache = [:]
        }
    }

    private func salvage(_ data: Data, reason: String) {
        let key = salvageKeyPrefix + reason
        guard defaults.data(forKey: key) == nil else { return }  // keep the first copy
        defaults.set(data, forKey: key)
    }

    // MARK: - Persistence

    private func persistAll() {
        if let data = try? JSONEncoder().encode(cache) {
            defaults.set(data, forKey: storageKey)
            defaults.set(Self.currentSchemaVersion, forKey: schemaVersionKey)
        }
        if let data = try? JSONEncoder().encode(activity) {
            defaults.set(data, forKey: activityKey)
        }
    }

    // MARK: - Reads

    func progress(for structureID: String) -> StudyProgress {
        cache[structureID] ?? StudyProgress(structureID: structureID)
    }

    func allProgress() -> [StudyProgress] {
        Array(cache.values)
    }

    func progressMap() -> [String: StudyProgress] {
        cache
    }

    func dueForReview() -> [String] {
        allProgress()
            .filter { $0.isDueForReview }
            .sorted { $0.easeFactor < $1.easeFactor }
            .map(\.structureID)
    }

    func overallAccuracy() -> Double {
        let all = allProgress()
        let total = all.reduce(0) { $0 + $1.totalAttempts }
        let correct = all.reduce(0) { $0 + $1.correctAttempts }
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }

    func masteredCount() -> Int {
        allProgress().filter { $0.masteryLevel == .mastered }.count
    }

    func studiedCount() -> Int {
        allProgress().filter { $0.totalAttempts > 0 }.count
    }

    // MARK: - Writes

    func save(_ progress: StudyProgress) {
        cache[progress.structureID] = progress
        recordActivity()
        persistAll()
    }

    private func recordActivity() {
        let key = Self.dayKey(for: .now)
        activity[key, default: 0] += 1
    }

    // MARK: - Study Activity

    /// Answers recorded on each of the last `days` calendar days, oldest first.
    /// Always returns exactly `days` entries so the chart has a stable shape.
    func recentActivity(days: Int) -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        return (0..<days).reversed().compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            return (date: date, count: activity[Self.dayKey(for: date), default: 0])
        }
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static func dayKey(for date: Date) -> String {
        dayFormatter.string(from: date)
    }
}
