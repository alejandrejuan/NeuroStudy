import SwiftUI

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
                .strokeBorder(.primary.opacity(0.12), lineWidth: 0.5)
        }
        .foregroundStyle(.secondary)
    }
}
