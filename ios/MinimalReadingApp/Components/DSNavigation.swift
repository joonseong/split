import SwiftUI

/// One item in the bottom navigation bar.
struct DSTabItem: Identifiable {
    let id = UUID()
    let systemImage: String
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
                Button { selection = index } label: {
                    VStack(spacing: Spacing.s4) {
                        Image(systemName: item.systemImage)
                            .textStyle(.title1)
                        Text(item.label)
                            .textStyle(.labelRegular)
                    }
                    .foregroundStyle(isSelected
                        ? Color.Semantic.Shape.brand
                        : Color.Semantic.Txt.B.tertiary)
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
                    Image(systemName: "chevron.left")
                    Text("이전 화")
                }
                .textStyle(.body2)
            }
            Spacer()
            Button(action: onList) {
                Text("목록").textStyle(.body2)
            }
            Spacer()
            Button(action: onNext) {
                HStack(spacing: Spacing.s4) {
                    Text("다음 화")
                    Image(systemName: "chevron.right")
                }
                .textStyle(.body2)
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
                .init(systemImage: "house", label: "홈"),
                .init(systemImage: "books.vertical", label: "내서재"),
                .init(systemImage: "person", label: "마이")
            ],
            selection: .constant(0)
        )
    }
}
