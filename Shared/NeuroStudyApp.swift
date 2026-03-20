import SwiftUI

@main
struct NeuroStudyApp: App {
    @State private var progressStore = ProgressStore()

    var body: some Scene {
        WindowGroup {
            UniversalMainView(progressStore: progressStore)
        }
    }
}
