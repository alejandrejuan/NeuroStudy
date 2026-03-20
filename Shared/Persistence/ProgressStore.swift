import SwiftUI

@Observable
class ProgressStore {
    private let defaults: UserDefaults
    private let storageKey = "neurostudy.progress"
    private var cache: [String: StudyProgress] = [:]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        loadAll()
    }

    private func loadAll() {
        guard let data = defaults.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([String: StudyProgress].self, from: data) else {
            cache = [:]
            return
        }
        cache = decoded
    }

    private func persistAll() {
        if let data = try? JSONEncoder().encode(cache) {
            defaults.set(data, forKey: storageKey)
        }
    }

    func progress(for structureID: String) -> StudyProgress {
        cache[structureID] ?? StudyProgress(structureID: structureID)
    }

    func save(_ progress: StudyProgress) {
        cache[progress.structureID] = progress
        persistAll()
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
}
