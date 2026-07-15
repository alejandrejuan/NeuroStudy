import Foundation
#if os(iOS)
import UIKit
#endif

/// Central haptic feedback that honors the user's "Haptic Feedback" setting.
///
/// Before this existed, the Settings toggle wrote to `@AppStorage("hapticFeedback")`
/// but nothing read it, so turning haptics off did nothing. Every tactile moment now
/// routes through here, which checks the flag first.
enum Haptics {
    /// Defaults to `true` — matching the Settings default and the state before the
    /// user has ever opened Settings (no stored value yet).
    private static var isEnabled: Bool {
        UserDefaults.standard.object(forKey: "hapticFeedback") as? Bool ?? true
    }

    static func success() {
        #if os(iOS)
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }

    static func error() {
        #if os(iOS)
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        #endif
    }

    /// Convenience for the common "correct → success, wrong → error" pattern.
    static func result(correct: Bool) {
        correct ? success() : error()
    }

    static func lightImpact() {
        #if os(iOS)
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }

    static func softImpact() {
        #if os(iOS)
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        #endif
    }
}
