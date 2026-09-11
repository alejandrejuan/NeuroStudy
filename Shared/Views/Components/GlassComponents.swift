import SwiftUI

// MARK: - Animated Checkmark

struct AnimatedCheckmark: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .fill(.green.opacity(0.15))
                .frame(width: 80, height: 80)
                .scaleEffect(isAnimating ? 1.0 : 0.3)

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 44))
                .foregroundStyle(.green)
                .scaleEffect(isAnimating ? 1.0 : 0.1)
                .rotationEffect(.degrees(isAnimating ? 0 : -60))
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.55)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Animated X Mark

struct AnimatedXMark: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .fill(.red.opacity(0.15))
                .frame(width: 80, height: 80)
                .scaleEffect(isAnimating ? 1.0 : 0.3)

            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 44))
                .foregroundStyle(.red)
                .scaleEffect(isAnimating ? 1.0 : 0.1)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.55)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Pulse Highlight

struct PulseHighlight: ViewModifier {
    let isActive: Bool
    @State private var isPulsing = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .overlay {
                if isActive {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.accentColor, lineWidth: 2)
                        .scaleEffect(isPulsing ? 1.04 : 1.0)
                        .opacity(isPulsing ? 0.3 : 0.8)
                        .animation(
                            // Static ring under Reduce Motion instead of an endless pulse.
                            reduceMotion ? nil : .easeInOut(duration: 0.9).repeatForever(autoreverses: true),
                            value: isPulsing
                        )
                        .onAppear { if !reduceMotion { isPulsing = true } }
                }
            }
    }
}

extension View {
    func pulseHighlight(_ isActive: Bool) -> some View {
        modifier(PulseHighlight(isActive: isActive))
    }
}

// MARK: - Circular Progress

struct CircularProgressView: View {
    let progress: Double
    let label: String
    var lineWidth: CGFloat = 8
    var size: CGFloat = 100
    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(.quaternary, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: [.blue, .purple, .pink, .blue],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

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
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Score Display

struct ScoreDisplayView: View {
    let correct: Int
    let total: Int

    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }

    var body: some View {
        VStack(spacing: 6) {
            CircularProgressView(
                progress: percentage,
                label: "Score",
                lineWidth: 10,
                size: 120
            )

            Text("\(correct) / \(total)")
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }
}

