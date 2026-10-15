import SwiftUI

// MARK: - Gyrus Shading (per-region 3D effects)

struct GyrusShading {
    /// Convex radial gradient with top-left lighting bias
    static func convexGradient(path: Path, baseColor: Color, centerBrightness: Double, edgeBrightness: Double) -> some View {
        path.fill(
            RadialGradient(
                colors: [
                    baseColor.opacity(centerBrightness),
                    baseColor.opacity((centerBrightness + edgeBrightness) / 2),
                    baseColor.opacity(edgeBrightness)
                ],
                center: .init(x: 0.35, y: 0.30),
                startRadius: 1,
                endRadius: 200
            )
        )
    }

    /// Inner shadow using stroke + blur + clip for edge depth
    static func innerShadow(path: Path, isDark: Bool) -> some View {
        path.stroke(
            Color.black.opacity(isDark ? 0.22 : 0.15),
            lineWidth: 3.0
        )
        .blur(radius: 2.5)
        .clipShape(path)
    }

    /// Small specular highlight spot at ~30% from top-left
    static func specularHighlight(path: Path) -> some View {
        path.fill(
            RadialGradient(
                colors: [
                    .white.opacity(0.30),
                    .white.opacity(0.08),
                    .clear
                ],
                center: .init(x: 0.30, y: 0.25),
                startRadius: 0,
                endRadius: 80
            )
        )
        .clipShape(path)
    }

    /// Warm pinkish subsurface scatter glow at edges
    static func subsurfaceScatter(path: Path, isDark: Bool) -> some View {
        path.stroke(
            Color(red: 0.95, green: 0.75, blue: 0.70).opacity(isDark ? 0.12 : 0.18),
            lineWidth: 2.5
        )
        .blur(radius: 3.0)
        .clipShape(path)
    }
}

// MARK: - Sulcus Depth Effect (5-layer groove rendering)

struct SulcusDepthEffect {
    @ViewBuilder
    static func deepSulcus(path: Path, isDark: Bool, isMajor: Bool) -> some View {
        let baseOpacity = isMajor ? 1.0 : 0.6

        // 1 - Deep shadow (widest, most blurred)
        path.stroke(
            Color(red: 0.24, green: 0.20, blue: 0.24).opacity((isDark ? 0.25 : 0.18) * baseOpacity),
            style: StrokeStyle(lineWidth: isMajor ? 3.5 : 2.0, lineCap: .round, lineJoin: .round)
        )
        .blur(radius: isMajor ? 2.5 : 1.5)

        // 2 - Ambient occlusion
        path.stroke(
            Color(red: 0.29, green: 0.25, blue: 0.29).opacity((isDark ? 0.30 : 0.22) * baseOpacity),
            style: StrokeStyle(lineWidth: isMajor ? 2.5 : 1.5, lineCap: .round, lineJoin: .round)
        )
        .blur(radius: isMajor ? 1.5 : 0.8)

        // 3 - Upper rim highlight (offset up-left to catch light)
        path.stroke(
            Color.white.opacity(0.22 * baseOpacity),
            style: StrokeStyle(lineWidth: isMajor ? 0.8 : 0.5, lineCap: .round, lineJoin: .round)
        )
        .offset(x: -1, y: -1)

        // 4 - Lower rim shadow (offset down-right)
        path.stroke(
            Color(red: 0.29, green: 0.25, blue: 0.29).opacity(0.18 * baseOpacity),
            style: StrokeStyle(lineWidth: isMajor ? 0.7 : 0.4, lineCap: .round, lineJoin: .round)
        )
        .offset(x: 0.5, y: 0.5)

        // 5 - Crisp center line
        path.stroke(
            Color(red: 0.36, green: 0.31, blue: 0.35).opacity((isDark ? 0.38 : 0.30) * baseOpacity),
            style: StrokeStyle(lineWidth: isMajor ? 1.2 : 0.7, lineCap: .round, lineJoin: .round)
        )
    }
}

// MARK: - Brain Outline Enhanced (7-layer fill)

struct BrainOutlineEnhanced {
    @ViewBuilder
    static func enhancedFill(outlinePath: Path, rect: CGRect, isDark: Bool) -> some View {
        // 1 - Outer drop shadow (enhanced)
        outlinePath
            .fill(Color.clear)
            .shadow(color: .black.opacity(isDark ? 0.25 : 0.15), radius: 16, x: 2, y: 8)

        // 2 - Base tissue gradient (warmer pink-beige tones)
        outlinePath
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.90, blue: 0.91),
                        Color(red: 0.92, green: 0.86, blue: 0.88),
                        Color(red: 0.87, green: 0.80, blue: 0.83)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

        // 3 - Depth radial gradient (warm brown at edges)
        outlinePath
            .fill(
                RadialGradient(
                    colors: [
                        .clear,
                        Color(red: 0.66, green: 0.60, blue: 0.64).opacity(0.08),
                        Color(red: 0.55, green: 0.48, blue: 0.53).opacity(0.15)
                    ],
                    center: .init(x: 0.40, y: 0.35),
                    startRadius: rect.width * 0.20,
                    endRadius: rect.width * 0.55
                )
            )

        // 4 - Edge ambient occlusion (inset stroke + blur)
        outlinePath
            .stroke(
                Color(red: 0.46, green: 0.40, blue: 0.45).opacity(isDark ? 0.20 : 0.14),
                lineWidth: 4.0
            )
            .blur(radius: 4.0)
            .clipShape(outlinePath)

        // 5 - Dome highlight (shifted top-left)
        outlinePath
            .fill(
                RadialGradient(
                    colors: [
                        .white.opacity(0.28),
                        .white.opacity(0.08),
                        .clear
                    ],
                    center: .init(x: 0.32, y: 0.22),
                    startRadius: 1,
                    endRadius: rect.width * 0.45
                )
            )

        // 6 - Secondary specular spot
        outlinePath
            .fill(
                RadialGradient(
                    colors: [
                        .white.opacity(0.15),
                        .clear
                    ],
                    center: .init(x: 0.25, y: 0.18),
                    startRadius: 0,
                    endRadius: rect.width * 0.18
                )
            )

        // 7 - Outline stroke
        outlinePath
            .stroke(
                Color(red: 0.28, green: 0.25, blue: 0.29).opacity(isDark ? 0.65 : 0.55),
                lineWidth: 1.8
            )
    }
}
