import SwiftUI

// MARK: - Theme
//
// The whole visual language in one place. Two layers, straight from Apple's Liquid Glass
// guidance for iOS 26 and later:
//
//   • Controls float on Liquid Glass: tab bar, chips, buttons, the floating selection
//     card. That lives in LiquidGlass.swift.
//   • Content sits on quiet translucent surfaces (`SurfaceCard`, `contentSurface`), never
//     glass. Glass on content makes everything compete with the controls above it.
//
// Behind both is `AppBackground`: a mesh of the icon's violet with a touch of emerald,
// strongest at the top of the screen and settling into a neutral base below, the way
// Apple Sports and Apple Invites let colour bleed in behind the content.

enum Theme {
    /// The icon's violet. Same as the asset-catalog accent, so `.tint` and `Theme.violet` agree.
    static let violet = Color.accentColor
    /// The secondary brand colour. Used for success, progress, and the background glow.
    static let emerald = Color("Emerald")

    /// Progress and score gradient: violet into emerald.
    static let progressGradient: [Color] = [violet, emerald]
}

// MARK: - Typography

extension Font {
    /// Big numerals in standard-width SF Pro.
    static func numeral(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight)
    }

    /// Small uppercase label that sits above or below a numeral.
    static let statLabel = Font.system(.footnote, weight: .semibold)
}

// MARK: - App Background

/// The single background for every screen.
///
/// A static mesh, heavily blurred so the colours melt into one another with no
/// visible seams, under a fixed film grain like Apple Invites' backgrounds. Nothing
/// animates and nothing is rasterized with `.drawingGroup()`, so Liquid Glass above
/// it has real colour to refract. Reduce Transparency drops both the glow and the
/// grain for the plain grouped background, since they are purely decorative.
struct AppBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        ZStack {
            base
            if !reduceTransparency {
                glow
                    .blur(radius: 60, opaque: true)
                grain
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

    private var isDark: Bool { colorScheme == .dark }

    private var base: Color {
        #if os(iOS)
        if reduceTransparency { return Color(uiColor: .systemGroupedBackground) }
        #endif
        return isDark
            ? Color(red: 0.040, green: 0.040, blue: 0.065)
            : Color(red: 0.965, green: 0.963, blue: 0.980)
    }

    @ViewBuilder
    private var glow: some View {
        if #available(iOS 18.0, macOS 15.0, *) {
            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.45], [0.55, 0.40], [1, 0.42],
                    [0, 1], [0.5, 1], [1, 1],
                ],
                colors: meshColors
            )
        } else {
            // iOS 17: two soft radial blooms approximate the same mesh.
            ZStack {
                RadialGradient(colors: [meshColors[0], .clear], center: .topLeading, startRadius: 0, endRadius: 520)
                RadialGradient(colors: [meshColors[2], .clear], center: .topTrailing, startRadius: 0, endRadius: 420)
            }
        }
    }

    /// Violet top-left, emerald top-right, both settling into the base by mid-screen.
    /// Each tint is mixed toward the base by `intensity`, so the whole glow can be made
    /// quieter or stronger in one place.
    private var meshColors: [Color] {
        let intensity = 0.5
        let b: (Double, Double, Double) = isDark ? (0.040, 0.040, 0.065) : (0.965, 0.963, 0.980)
        func tint(_ r: Double, _ g: Double, _ bl: Double) -> Color {
            Color(red: b.0 + (r - b.0) * intensity, green: b.1 + (g - b.1) * intensity, blue: b.2 + (bl - b.2) * intensity)
        }
        let base = Color(red: b.0, green: b.1, blue: b.2)
        if isDark {
            return [
                tint(0.22, 0.16, 0.52), tint(0.15, 0.11, 0.36), tint(0.05, 0.25, 0.20),
                tint(0.09, 0.075, 0.18), tint(0.06, 0.055, 0.11), tint(0.05, 0.10, 0.09),
                base, base, base,
            ]
        } else {
            return [
                tint(0.85, 0.83, 0.98), tint(0.90, 0.89, 0.98), tint(0.82, 0.94, 0.89),
                tint(0.935, 0.93, 0.985), tint(0.955, 0.953, 0.982), tint(0.925, 0.96, 0.945),
                base, base, base,
            ]
        }
    }

    /// Film grain: a fixed monochrome noise tile, repeated. Faint enough to feel like
    /// texture rather than noise, slightly stronger in dark mode where it would vanish.
    @ViewBuilder
    private var grain: some View {
        if let tile = FilmGrain.tile {
            Image(decorative: tile, scale: 2)
                .interpolation(.none)
                .resizable(resizingMode: .tile)
                .opacity(isDark ? 0.07 : 0.07)
                .blendMode(isDark ? .screen : .multiply)
                .allowsHitTesting(false)
        }
    }
}

/// One noise tile, generated once from a fixed seed so the grain never shimmers or
/// changes between screens.
private enum FilmGrain {
    static let tile: CGImage? = {
        let size = 256
        var state: UInt64 = 0x9E37_79B9_7F4A_7C15
        var pixels = [UInt8](repeating: 0, count: size * size)
        for i in pixels.indices {
            state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            pixels[i] = UInt8(truncatingIfNeeded: state >> 56)
        }
        guard let provider = CGDataProvider(data: Data(pixels) as CFData) else { return nil }
        return CGImage(
            width: size, height: size,
            bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: size,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
            provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent
        )
    }()
}

// MARK: - Content Surface

extension View {
    /// The quiet translucent card that content sits on.
    ///
    /// Light: a milky white that lets the background tint through. Dark: a faint lift
    /// with a top-lit hairline, the look of Apple Sports' score cards. Reduce Transparency
    /// swaps both for an opaque grouped-cell colour.
    func contentSurface(cornerRadius: CGFloat = 22) -> some View {
        modifier(ContentSurfaceModifier(cornerRadius: cornerRadius))
    }
}

private struct ContentSurfaceModifier: ViewModifier {
    let cornerRadius: CGFloat
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let isDark = colorScheme == .dark

        content
            .background {
                shape
                    .fill(fill(isDark: isDark))
                    .shadow(color: .black.opacity(isDark ? 0 : 0.045), radius: 14, y: 6)
            }
            .overlay {
                shape.strokeBorder(
                    LinearGradient(
                        colors: isDark
                            ? [.white.opacity(0.16), .white.opacity(0.04)]
                            : [.white.opacity(0.9), .black.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 0.75
                )
            }
    }

    private func fill(isDark: Bool) -> Color {
        #if os(iOS)
        if reduceTransparency { return Color(uiColor: .secondarySystemGroupedBackground) }
        #endif
        return isDark ? .white.opacity(0.075) : .white.opacity(0.74)
    }
}

/// A padded content card. `floating: true` lifts it onto Liquid Glass instead; use that
/// only for transient UI that hovers over content (the Atlas selection card), not for
/// content itself.
struct SurfaceCard<Content: View>: View {
    var cornerRadius: CGFloat = 22
    var padding: CGFloat = 16
    var floating: Bool = false
    @ViewBuilder let content: () -> Content

    var body: some View {
        if floating {
            content()
                .padding(padding)
                .glassSurface(in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        } else {
            content()
                .padding(padding)
                .contentSurface(cornerRadius: cornerRadius)
        }
    }
}

// MARK: - Glyph Tile

/// The Settings-app icon tile: a white SF Symbol on a solid, top-lit rounded square.
struct GlyphTile: View {
    let systemName: String
    let color: Color
    var size: CGFloat = 30

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.27, style: .continuous)
            .fill(color.gradient)
            // Resolve asset colours in their light variant: like Settings icons, a tile
            // keeps the same saturated fill in both modes so the white glyph stays legible.
            .environment(\.colorScheme, .light)
            .frame(width: size, height: size)
            .overlay {
                Image(systemName: systemName)
                    .font(.system(size: size * 0.44, weight: .semibold))
                    .foregroundStyle(.white)
                    .symbolRenderingMode(.monochrome)
            }
            .accessibilityHidden(true)
    }
}

// MARK: - Stat Tile

/// One number on its own near-square tile: an uppercase label, the value as a
/// scoreboard numeral, and a short caption that says what the number is out of.
/// Three of these side by side replace a single long, short strip.
struct StatTile: View {
    let title: String
    let value: String
    var caption: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.statLabel)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 8)
            Text(value)
                .font(.numeral(30))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .contentTransition(.numericText())
            if let caption {
                Text(caption)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .leading)
        .padding(14)
        .contentSurface(cornerRadius: 20)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Section Header

/// Section title in the iOS 26 style: bold Title 3, flush with the card edge.
struct SectionHeader<Accessory: View>: View {
    let title: String
    @ViewBuilder var accessory: () -> Accessory

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.title3.weight(.bold))
                .accessibilityAddTraits(.isHeader)
            Spacer()
            accessory()
        }
        .padding(.horizontal, 4)
    }
}

extension SectionHeader where Accessory == EmptyView {
    init(_ title: String) {
        self.title = title
        self.accessory = { EmptyView() }
    }
}

extension SectionHeader {
    init(_ title: String, @ViewBuilder accessory: @escaping () -> Accessory) {
        self.title = title
        self.accessory = accessory
    }
}

// MARK: - Grouped List

/// Rows stacked inside one content surface with inset hairline separators, the way
/// Settings and Sports group related items instead of floating each in its own card.
struct GroupedList<Data: RandomAccessCollection, Row: View>: View where Data.Element: Identifiable {
    let data: Data
    var separatorInset: CGFloat = 58
    @ViewBuilder let row: (Data.Element) -> Row

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, element in
                row(element)
                if index < data.count - 1 {
                    Divider().padding(.leading, separatorInset)
                }
            }
        }
        // Clip first so a tinted first or last row follows the card's corners, then add
        // the surface outside the clip so its shadow is not cut off.
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .contentSurface()
    }
}
