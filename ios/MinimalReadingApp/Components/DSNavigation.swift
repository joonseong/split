import SwiftUI

/// One item in the bottom navigation bar. The selected tab shows `fillIcon`,
/// others show `lineIcon` (both rendered in their dark source color).
struct DSTabItem: Identifiable {
    let id = UUID()
    let lineIcon: String
    let fillIcon: String
    let label: String
}

/// Bottom navigation bar (GNB). Selection is shown by the filled icon + bold
/// label; all items use the dark secondary color.
struct DSBottomBar: View {
    let items: [DSTabItem]
    @Binding var selection: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                let isSelected = index == selection
                Button { selection = index } label: {
                    VStack(spacing: Spacing.s2) {
                        if isSelected {
                            Image(item.fillIcon)
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: Spacing.s32, height: Spacing.s32)
                        } else {
                            DSIcon(item.lineIcon, size: Spacing.s32, color: Color.Semantic.Txt.B.secondary)
                        }
                        Text(item.label)
                            .textStyle(isSelected ? .labelBold : .labelRegular)
                            .foregroundStyle(Color.Semantic.Txt.B.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.s48)
        .frame(height: Spacing.s64)
        .background(Color.Semantic.Shape.white)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.Semantic.Border.div)
                .frame(height: 1)
        }
    }
}

/// Reader navigation bar: previous episode / list / next episode.
struct DSReaderNavBar: View {
    var onPrev: () -> Void = {}
    var onList: () -> Void = {}
    var onNext: () -> Void = {}

    var body: some View {
        HStack(spacing: Spacing.s16) {
            Button(action: onPrev) {
                HStack(spacing: Spacing.s4) {
                    DSIcon("ic_left", size: Spacing.s20, color: Color.Semantic.Txt.B.secondary)
                    Text("이전 화").textStyle(.body2)
                }
            }
            Spacer()
            Button(action: onList) {
                Text("목록").textStyle(.body2)
            }
            Spacer()
            Button(action: onNext) {
                HStack(spacing: Spacing.s4) {
                    Text("다음 화").textStyle(.body2)
                    DSIcon("ic_right", size: Spacing.s20, color: Color.Semantic.Txt.B.secondary)
                }
            }
        }
        .foregroundStyle(Color.Semantic.Txt.B.secondary)
        .padding(.horizontal, Spacing.s16)
        .frame(height: Spacing.s48)
        .background(Color.Semantic.Shape.white)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.Semantic.Border.div)
                .frame(height: 1)
        }
    }
}

#Preview {
    VStack(spacing: Spacing.s24) {
        DSReaderNavBar()
        DSBottomBar(
            items: [
                .init(lineIcon: "ic_home_line", fillIcon: "ic_home_fill", label: "홈"),
                .init(lineIcon: "ic_library_line", fillIcon: "ic_library_fill", label: "내 책장"),
                .init(lineIcon: "ic_my_line", fillIcon: "ic_my_fill", label: "마이")
            ],
            selection: .constant(0)
        )
    }
}
