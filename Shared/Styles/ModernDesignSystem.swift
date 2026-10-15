import SwiftUI

// MARK: - Enhanced Glass Button Style

/// Redesigned button style with Liquid Glass aesthetic and haptic feedback
struct ModernGlassButtonStyle: ButtonStyle {
    var isProminent: Bool = false
    var size: ButtonSize = .medium
    
    enum ButtonSize {
        case small, medium, large
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 20
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 10
            case .large: return 12
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background {
                if isProminent {
                    Capsule(style: .continuous)
                        .fill(.regularMaterial)
                        .overlay {
                            Capsule(style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.accentColor.opacity(0.25),
                                            Color.accentColor.opacity(0.15)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(
                                    Color.accentColor.opacity(0.4),
                                    lineWidth: 1
                                )
                        }
                } else {
                    Capsule(style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(.primary.opacity(0.12), lineWidth: 0.5)
                        }
                }
            }
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .sensoryFeedback(trigger: configuration.isPressed) { _, _ in
                Haptics.isEnabled ? .impact(flexibility: .soft) : nil
            }
    }
}

// MARK: - Mastery Badge

/// Study status. In lists it is an 8pt dot; in detail views, a labelled capsule.
struct ModernMasteryBadge: View {
    let level: MasteryLevel
    var showLabel: Bool = true

    var body: some View {
        if showLabel {
            HStack(spacing: 3) {
                Image(systemName: level.sfSymbol)
                    .font(.system(size: 10, weight: .semibold))
                Text(level.rawValue)
                    .font(.system(size: 11.5, weight: .semibold))
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(masteryColor.opacity(0.15), in: Capsule(style: .continuous))
            .foregroundStyle(masteryColor)
        } else {
            Circle()
                .fill(masteryColor)
                .frame(width: 8, height: 8)
                .accessibilityLabel(level.rawValue)
        }
    }

    private var masteryColor: Color {
        switch level {
        case .new: return .secondary
        case .learning: return Theme.violet
        case .struggling: return .red
        case .reviewing: return .orange
        case .mastered: return Theme.emerald
        }
    }
}
