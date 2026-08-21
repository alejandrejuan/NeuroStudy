import SwiftUI

// MARK: - Liquid Glass Layer
//
// The app deploys to iOS 17 / macOS 14 but builds against the iOS 26 SDK, where SwiftUI
// gained true Liquid Glass. Everything glass-related lives here so no screen hand-rolls
// its own material, and so the iOS 26 adoption is gated in exactly one place.
//
// Design rules this layer enforces (all straight from Apple's Liquid Glass guidance):
//   1. Glass refracts CONTENT. The app background is therefore a plain system color —
//      never a decorative gradient, and never rasterized with .drawingGroup(), both of
//      which leave the material with nothing meaningful to sample.
//   2. Never stack glass on glass. Elements sitting inside a glass card use `softChip`
//      (a flat, opaque-ish fill), not another material.
//   3. Group adjacent glass so the shapes merge and flow instead of reading as separate
//      blurred rectangles — that is what `glassGroup` is for.

// MARK: - App Background

/// The single background for every screen.
///
/// Deliberately flat. The previous design painted a hardcoded purple/blue gradient here
/// and rasterized it, which is precisely what prevents Liquid Glass from working: the
/// material could only ever sample a frozen gradient. A plain system background lets
/// real content scroll beneath the glass and gives the refraction something to do, and
/// it adapts to light/dark and accessibility settings for free.
struct AppBackground: View {
    var body: some View {
        backgroundColor.ignoresSafeArea()
    }

    private var backgroundColor: Color {
        #if os(iOS)
        Color(uiColor: .systemGroupedBackground)
        #else
        Color(nsColor: .windowBackgroundColor)
        #endif
    }
}

// MARK: - Glass Surfaces

extension View {
    /// A glass surface behind the content.
    ///
    /// iOS 26+: genuine system Liquid Glass, which refracts and reacts to what is behind
    /// it. Earlier: an `.ultraThinMaterial` fill with an adaptive hairline border. (The
    /// original design used `white.opacity(...)` borders, invisible against a light
    /// background — the fallback uses `.primary.opacity`, which reads in both schemes.)
    func glassSurface(
        in shape: some Shape = RoundedRectangle(cornerRadius: 20, style: .continuous),
        tint: Color? = nil,
        interactive: Bool = false,
        shadowRadius: CGFloat = 10,
        shadowY: CGFloat = 3
    ) -> some View {
        modifier(GlassSurfaceModifier(
            shape: AnyShape(shape),
            tint: tint,
            interactive: interactive,
            shadowRadius: shadowRadius,
            shadowY: shadowY
        ))
    }

    /// Applies a glass button style: real `.glass` / `.glassProminent` on iOS 26+,
    /// the app's fallback otherwise. Apply to a `Button`.
    @ViewBuilder
    func glassButton(prominent: Bool = false, controlSize: ControlSize = .regular) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            if prominent {
                self.buttonStyle(.glassProminent).controlSize(controlSize)
            } else {
                self.buttonStyle(.glass).controlSize(controlSize)
            }
        } else {
            self.buttonStyle(ModernGlassButtonStyle(
                isProminent: prominent,
                size: controlSize == .small ? .small : .medium
            ))
        }
    }

    /// A flat chip for elements that sit INSIDE a glass surface — badges, pills, tags.
    ///
    /// Stacking a second material inside a glass card muddies both and is called out
    /// explicitly in Apple's guidance. This gives the same visual separation using an
    /// opaque fill, so the parent glass stays legible.
    func softChip(tint: Color? = nil, in shape: some Shape = Capsule(style: .continuous)) -> some View {
        background {
            if let tint {
                shape.fill(tint.opacity(0.16))
            } else {
                shape.fill(.quaternary)
            }
        }
    }
}

private struct GlassSurfaceModifier: ViewModifier {
    let shape: AnyShape
    let tint: Color?
    let interactive: Bool
    let shadowRadius: CGFloat
    let shadowY: CGFloat

    func body(content: Content) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            content.glassEffect(glass, in: shape)
        } else {
            content
                .background {
                    shape
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.08), radius: shadowRadius, y: shadowY)
                        .overlay {
                            if let tint {
                                shape.fill(tint.opacity(0.12))
                            }
                        }
                }
                .overlay {
                    // Adaptive hairline: dark in light mode, light in dark mode.
                    shape.stroke(.primary.opacity(0.12), lineWidth: 0.5)
                }
        }
    }

    @available(iOS 26.0, macOS 26.0, *)
    private var glass: Glass {
        var glass = Glass.regular
        if let tint {
            // `Glass.tint` takes the color at face value, so a full-strength accent
            // renders as a solid opaque blob rather than tinted glass — it stops looking
            // like a material at all and craters the contrast of any label on top.
            // A low alpha keeps it reading as glass with a hint of colour.
            glass = glass.tint(tint.opacity(0.18))
        }
        if interactive {
            glass = glass.interactive()
        }
        return glass
    }
}

// MARK: - Glass Grouping

/// Groups adjacent glass elements so they blend and flow into one another rather than
/// reading as a row of separate frosted rectangles. This is what produces the fluid,
/// liquid quality of the material; without it, neighbouring glass just looks blurry.
///
/// No-ops into a plain `HStack`-friendly container below iOS 26.
struct GlassGroup<Content: View>: View {
    var spacing: CGFloat = 12
    @ViewBuilder let content: () -> Content

    var body: some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            GlassEffectContainer(spacing: spacing) {
                content()
            }
        } else {
            content()
        }
    }
}

// MARK: - Navigation Chrome

extension View {
    /// The iOS 26 scroll-edge treatment: content softly dissolves as it passes beneath
    /// the navigation bar instead of colliding with a hard edge.
    @ViewBuilder
    func softScrollEdges() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.scrollEdgeEffectStyle(.soft, for: .top)
        } else {
            self
        }
    }
}

#if os(iOS)
extension TabView {
    /// Shrinks the tab bar as the user scrolls down, handing the screen back to content.
    /// One of the signature iOS 26 interactions.
    @ViewBuilder
    func minimizingTabBar() -> some View {
        if #available(iOS 26.0, *) {
            self.tabBarMinimizeBehavior(.onScrollDown)
        } else {
            self
        }
    }
}
#endif
