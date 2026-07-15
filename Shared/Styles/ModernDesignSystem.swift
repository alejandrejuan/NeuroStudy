import SwiftUI

// MARK: - Modern Liquid Glass Design System

/// Additional typography for enhanced hierarchy (base fonts in AppTypography.swift)
extension Font {
    static let heroTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let cardTitle = Font.system(.title3, design: .rounded, weight: .semibold)
    static let microText = Font.system(.caption2, design: .rounded, weight: .medium)
}

// MARK: - Liquid Glass Card Component

/// Modern glass card. Renders true Liquid Glass on iOS 26+ and a material fallback on
/// earlier systems via `glassSurface` (see LiquidGlass.swift). The public API is
/// unchanged so existing call sites are untouched.
struct LiquidGlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 20
    var padding: CGFloat = 16
    var interactive: Bool = false
    var prominent: Bool = false
    @ViewBuilder let content: () -> Content

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    var body: some View {
        content()
            .padding(padding)
            .glassSurface(
                in: shape,
                tint: prominent ? Color.accentColor : nil,
                interactive: interactive,
                shadowRadius: prominent ? 14 : 10,
                shadowY: prominent ? 5 : 3
            )
    }
}

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
                                .strokeBorder(.white.opacity(0.25), lineWidth: 0.5)
                        }
                }
            }
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .sensoryFeedback(.impact(flexibility: .soft), trigger: configuration.isPressed)
    }
}

// MARK: - Adaptive Gradient Background

/// Performance-optimized gradient background with platform detection
struct AdaptiveGradientBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    
    #if os(macOS)
    private let useSimpleGradient = true
    #else
    private let useSimpleGradient = false
    #endif
    
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Color.black
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.05, blue: 0.15),
                        Color(red: 0.03, green: 0.08, blue: 0.12),
                        Color(red: 0.05, green: 0.03, blue: 0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.95)
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.93, green: 0.94, blue: 0.98),
                        Color(red: 0.96, green: 0.95, blue: 0.98),
                        Color(red: 0.94, green: 0.96, blue: 0.99)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .ignoresSafeArea()
        // Reduce animation complexity on macOS
        .drawingGroup(opaque: useSimpleGradient)
    }
}

// MARK: - Enhanced Region Badge

/// Modernized region badge with improved visual hierarchy
struct ModernRegionBadge: View {
    let region: BrainRegion
    var style: BadgeStyle = .standard
    
    enum BadgeStyle {
        case standard, compact, prominent
    }
    
    var body: some View {
        HStack(spacing: style == .compact ? 3 : 4) {
            Image(systemName: region.sfSymbol)
                .font(.system(size: symbolSize, weight: .semibold))
            
            if style != .compact {
                Text(region.displayName)
                    .font(style == .prominent ? .regionBadge : .microText)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background {
            Capsule(style: .continuous)
                .fill(region.color.opacity(backgroundOpacity))
        }
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(
                    region.color.opacity(borderOpacity),
                    lineWidth: style == .prominent ? 1 : 0.5
                )
        }
        .foregroundStyle(region.color)
        .shadow(
            color: style == .prominent ? region.color.opacity(0.3) : .clear,
            radius: 4,
            y: 2
        )
    }
    
    private var symbolSize: CGFloat {
        switch style {
        case .compact: return 8
        case .standard: return 9
        case .prominent: return 11
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch style {
        case .compact: return 6
        case .standard: return 8
        case .prominent: return 10
        }
    }
    
    private var verticalPadding: CGFloat {
        switch style {
        case .compact: return 3
        case .standard: return 4
        case .prominent: return 5
        }
    }
    
    private var backgroundOpacity: Double {
        switch style {
        case .compact: return 0.12
        case .standard: return 0.15
        case .prominent: return 0.2
        }
    }
    
    private var borderOpacity: Double {
        switch style {
        case .compact: return 0.25
        case .standard: return 0.3
        case .prominent: return 0.5
        }
    }
}

// MARK: - Enhanced Mastery Badge

/// Redesigned mastery badge with improved visual feedback
struct ModernMasteryBadge: View {
    let level: MasteryLevel
    var showLabel: Bool = true
    var animated: Bool = false
    
    @State private var pulseAnimation = false
    
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: level.sfSymbol)
                .font(.system(size: 9, weight: .semibold))
                .scaleEffect(pulseAnimation && level == .mastered ? 1.1 : 1.0)
            
            if showLabel {
                Text(level.rawValue)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
            }
        }
        .padding(.horizontal, showLabel ? 7 : 5)
        .padding(.vertical, 3)
        .background {
            Capsule(style: .continuous)
                .fill(masteryColor.opacity(0.15))
                .overlay {
                    if level == .mastered && animated {
                        Capsule(style: .continuous)
                            .stroke(masteryColor.opacity(pulseAnimation ? 0.4 : 0.2), lineWidth: 1)
                            .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    }
                }
        }
        .foregroundStyle(masteryColor)
        .onAppear {
            if animated && level == .mastered {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulseAnimation = true
                }
            }
        }
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

// MARK: - Performance-Optimized Circular Progress

/// Enhanced circular progress with better animation performance
struct OptimizedCircularProgress: View {
    let progress: Double
    let label: String
    var lineWidth: CGFloat = 8
    var size: CGFloat = 100
    var accentColors: [Color] = [.blue, .purple, .pink]
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(.quaternary, lineWidth: lineWidth)
            
            // Progress circle with gradient
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: accentColors + [accentColors.first ?? .blue],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                // Performance optimization: use drawingGroup for complex paths
                .drawingGroup()
            
            // Center label
            VStack(spacing: 1) {
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .contentTransition(.numericText())
                Text(label)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
        .task {
            await animateProgress()
        }
        .onChange(of: progress) { _, newValue in
            Task {
                await animateProgress(to: newValue)
            }
        }
    }
    
    private func animateProgress(to target: Double? = nil) async {
        let targetValue = target ?? progress
        withAnimation(.easeOut(duration: 0.8)) {
            animatedProgress = targetValue
        }
    }
}

// MARK: - Platform-Specific Optimizations

#if os(macOS)
/// macOS-specific view modifiers for optimal performance
extension View {
    func optimizedForMac() -> some View {
        self
            .frame(minWidth: 800, minHeight: 600)
            .background(.ultraThinMaterial)
    }
}
#endif

#if os(iOS)
/// iOS-specific view modifiers for optimal touch interactions
extension View {
    func optimizedForTouch() -> some View {
        self
            .contentShape(Rectangle())
            .hoverEffect(.lift)
    }
}
#endif

