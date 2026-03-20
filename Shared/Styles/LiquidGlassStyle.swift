import SwiftUI

// MARK: - Glass Card

struct GlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 20
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.06), radius: 10, y: 3)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.45), .white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
    }
}

// MARK: - Glass Button Style

struct GlassButtonStyle: ButtonStyle {
    var isProminent: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                if isProminent {
                    Capsule(style: .continuous)
                        .fill(.thinMaterial)
                        .overlay {
                            Capsule(style: .continuous)
                                .fill(Color.accentColor.opacity(0.12))
                        }
                } else {
                    Capsule(style: .continuous)
                        .fill(.ultraThinMaterial)
                }
            }
            .overlay {
                Capsule(style: .continuous)
                    .strokeBorder(.white.opacity(0.25), lineWidth: 0.5)
            }
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Glass Card Button Style

struct GlassCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.35), .white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .scaleEffect(configuration.isPressed ? 0.975 : 1.0)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Region Badge

struct RegionBadge: View {
    let region: BrainRegion

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: region.sfSymbol)
                .font(.system(size: 9, weight: .semibold))
            Text(region.displayName)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            Capsule(style: .continuous)
                .fill(region.color.opacity(0.15))
        }
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(region.color.opacity(0.3), lineWidth: 0.5)
        }
        .foregroundStyle(region.color)
    }
}

// MARK: - Source Reference Badge

/// Small pill badge indicating which authoritative source a piece of content is from.
struct SourceReferenceBadge: View {
    let reference: ContentReference

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: reference.sfSymbol)
                .font(.system(size: 9, weight: .semibold))
            Text(reference.shortLabel)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
        }
        .foregroundStyle(.secondary)
    }
}

// MARK: - Mastery Badge

struct MasteryBadge: View {
    let level: MasteryLevel

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: level.sfSymbol)
                .font(.system(size: 9, weight: .semibold))
            Text(level.rawValue)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 3)
        .background {
            Capsule(style: .continuous)
                .fill(masteryColor.opacity(0.15))
        }
        .foregroundStyle(masteryColor)
    }

    private var masteryColor: Color {
        switch level {
        case .new: return .secondary
        case .learning: return .blue
        case .struggling: return .red
        case .reviewing: return .orange
        case .mastered: return .green
        }
    }
}
