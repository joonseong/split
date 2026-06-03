import SwiftUI

/// Horizontally scrollable round tabs for the home screen. The selected tab is
/// brand-filled; others use the 1depth surface.
struct HomeTabBar: View {
    let tabs: [String]
    @Binding var selection: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.s8) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    let isSelected = index == selection
                    Button { selection = index } label: {
                        Text(tab)
                            .textStyle(isSelected ? .title2 : .body2)
                            .foregroundStyle(isSelected
                                ? Color.Semantic.Txt.W.primary
                                : Color.Semantic.Txt.B.primary)
                            .padding(.horizontal, Spacing.s16)
                            .padding(.vertical, Spacing.s10)
                            .background(isSelected ? Color.Semantic.Shape.brand : Color.Semantic.Shape.depth1)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Spacing.s16)
        }
    }
}

#Preview {
    HomeTabBar(tabs: ["베스트셀러", "자기계발", "건강/운동", "경제/경영"], selection: .constant(0))
}
