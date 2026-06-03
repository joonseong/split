import SwiftUI

/// One item in the bottom navigation bar. `icon` is a design-system asset name.
struct DSTabItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
}

/// Bottom navigation bar (GNB). Selected item uses the brand color.
struct DSBottomBar: View {
    let items: [DSTabItem]
    @Binding var selection: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                let isSelected = index == selection
                let tint = isSelected ? Color.Semantic.Shape.brand : Color.Semantic.Txt.B.tertiary
                Button { selection = index } label: {
                    VStack(spacing: Spacing.s4) {
                        DSIcon(item.icon, size: Spacing.s24, color: tint)
                        Text(item.label)
                            .textStyle(.labelRegular)
                            .foregroundStyle(tint)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.s8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.s8)
        .frame(height: Spacing.s56)
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
                .init(icon: "ic_home_line", label: "홈"),
                .init(icon: "ic_library_line", label: "내서재"),
                .init(icon: "ic_my_line", label: "마이")
            ],
            selection: .constant(0)
        )
    }
}
