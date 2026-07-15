import SwiftUI

// MARK: - Liquid Glass Compatibility Layer
//
// The app deploys to iOS 17 / macOS 14 but is built against the iOS 26 SDK, where
// SwiftUI gained true Liquid Glass (`.glassEffect`, `.buttonStyle(.glass)`). These
// helpers adopt the real system material on iOS 26+ and fall back to the app's prior
// material-and-stroke look on earlier systems, so there is a single place that knows
// how a "glass" surface is drawn and nothing hand-rolls it at the call site.

extension View {
    /// A glass surface behind the content.
    ///
    /// iOS 26+: the genuine system Liquid Glass, which reacts to what is behind it.
    /// Earlier: an `.ultraThinMaterial` fill with an adaptive hairline border. (The old
    /// look used `white.opacity(...)` borders, which are invisible against the near-white
    /// light-mode background — this fallback uses `.primary.opacity`, visible in both
    /// color schemes.)
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
    /// the app's `ModernGlassButtonStyle` fallback otherwise. Apply to a `Button`.
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
            glass = glass.tint(tint)
        }
        if interactive {
            glass = glass.interactive()
        }
        return glass
    }
}
