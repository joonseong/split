import SwiftUI

/// A removable chip: label + trailing close button.
struct DSChip: View {
    let label: String
    var onRemove: () -> Void = {}

    var body: some View {
        HStack(spacing: Spacing.s4) {
            Text(label)
                .textStyle(.caption1)
                .foregroundStyle(Color.Semantic.Txt.B.secondary)
            Button(action: onRemove) {
                DSIcon("ic_close", size: Spacing.s16, color: Color.Semantic.Shape.iconLight)
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, Spacing.s12)
        .padding(.trailing, Spacing.s8)
        .frame(height: Spacing.s32)
        .background(Color.Semantic.Shape.depth2)
        .clipShape(Capsule())
    }
}

/// A tiny "AD" marker.
struct DSAdBadge: View {
    var body: some View {
        Text("AD")
            .textStyle(.labelRegular)
            .foregroundStyle(Color.Semantic.Txt.B.tertiary)
            .padding(.horizontal, Spacing.s4)
            .padding(.vertical, Spacing.s2)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.r2, style: .continuous)
                    .strokeBorder(Color.Semantic.Border.button, lineWidth: 1)
            )
    }
}

/// A compact 20pt-tall status badge (highlight color).
struct DSBadge20: View {
    let label: String

    var body: some View {
        Text(label)
            .textStyle(.labelBold)
            .foregroundStyle(Color.Semantic.Txt.W.primary)
            .padding(.horizontal, Spacing.s8)
            .frame(height: Spacing.s20)
            .background(Color.Semantic.Shape.highlight)
            .clipShape(Capsule())
    }
}

/// A 32pt-tall neutral badge.
struct DSBadge32: View {
    let label: String

    var body: some View {
        Text(label)
            .textStyle(.title2)
            .foregroundStyle(Color.Semantic.Txt.B.secondary)
            .padding(.horizontal, Spacing.s12)
            .frame(height: Spacing.s32)
            .background(Color.Semantic.Shape.depth2)
            .clipShape(Capsule())
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.s16) {
        DSChip(label: "Label")
        DSAdBadge()
        DSBadge20(label: "Label")
        DSBadge32(label: "Label")
    }
    .padding(Spacing.s20)
}
