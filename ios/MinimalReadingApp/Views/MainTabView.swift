import SwiftUI

/// Main app shell with the bottom navigation bar (홈 / 내 책장 / 마이).
struct MainTabView: View {
    @State private var selection = 0

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selection {
                case 0: HomeView()
                case 1: placeholder("내 책장")
                default: placeholder("마이")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            DSBottomBar(
                items: [
                    .init(lineIcon: "ic_home_line", fillIcon: "ic_home_fill", label: "홈"),
                    .init(lineIcon: "ic_library_line", fillIcon: "ic_library_fill", label: "내 책장"),
                    .init(lineIcon: "ic_my_line", fillIcon: "ic_my_fill", label: "마이"),
                ],
                selection: $selection
            )
        }
        .background(Color.Semantic.Shape.white)
    }

    private func placeholder(_ title: String) -> some View {
        VStack {
            Text(title)
                .textStyle(.display2)
                .foregroundStyle(Color.Semantic.Txt.B.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Semantic.Shape.white)
    }
}

#Preview {
    MainTabView()
        .environment(UserProfileStore())
}
