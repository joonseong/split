import SwiftUI

/// A pill-shaped segmented control. The selected segment fills with the brand
/// color; unselected labels use tertiary text.
struct DSRoundTab: View {
    let items: [String]
    @Binding var selection: Int

    var body: some View {
        HStack(spacing: Spacing.s2) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, label in
                let isSelected = index == selection
                Button { selection = index } label: {
                    Text(label)
                        .textStyle(.title2)
                        .foregroundStyle(isSelected
                            ? Color.Semantic.Txt.W.primary
                            : Color.Semantic.Txt.B.tertiary)
                        .padding(.horizontal, Spacing.s16)
                        .frame(height: Spacing.s32)
                        .background(isSelected ? Color.Semantic.Shape.brand : Color.clear)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Spacing.s4)
        .background(Color.Semantic.Shape.depth2)
        .clipShape(Capsule())
    }
}

/// Full-width underline tabs. The selected tab shows bold text and a brand dot.
struct DSBoxTab: View {
    let items: [String]
    @Binding var selection: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, label in
                let isSelected = index == selection
                Button { selection = index } label: {
                    VStack(spacing: Spacing.s4) {
                        Text(label)
                            .textStyle(isSelected ? .title2 : .body2)
                            .foregroundStyle(isSelected
                                ? Color.Semantic.Txt.B.primary
                                : Color.Semantic.Txt.B.tertiary)
                        Circle()
                            .fill(isSelected ? Color.Semantic.Shape.brand : Color.clear)
                            .frame(width: Spacing.s4, height: Spacing.s4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s12)
                }
                .buttonStyle(.plain)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.Semantic.Border.div)
                .frame(height: 1)
        }
    }
}

#Preview {
    VStack(spacing: Spacing.s24) {
        DSRoundTab(items: ["Label", "Label", "Label"], selection: .constant(0))
        DSBoxTab(items: ["Tab name", "Tab name"], selection: .constant(0))
    }
    .padding(Spacing.s20)
}
