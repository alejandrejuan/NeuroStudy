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
        // A flat chip, not a material. This badge always sits inside a glass card, and
        // stacking a second material there muddies both surfaces.
        .softChip()
        .foregroundStyle(.secondary)
    }
}
