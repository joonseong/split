import SwiftUI

/// 04. Home (Figma node 316:675): header, weather greeting, genre tabs, ad slot,
/// and the book grid.
struct HomeView: View {
    @Environment(UserProfileStore.self) private var profile
    @State private var weather = WeatherViewModel()
    @State private var selectedTab = 0
    @State private var books = HomeBook.samples

    private let columns = [
        GridItem(.flexible(), spacing: Spacing.s12),
        GridItem(.flexible(), spacing: Spacing.s12),
    ]

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.s24) {
                    greeting
                    HomeTabBar(tabs: profile.homeTabs, selection: $selectedTab)
                    AdBanner()
                    bookGrid
                }
                .padding(.vertical, Spacing.s16)
            }
        }
        .background(Color.Semantic.Shape.white)
        .task { await weather.refresh() }
    }

    private var header: some View {
        HStack {
            Image("LogoMinimalReading")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 102, height: 18)
                .foregroundStyle(Color.Semantic.Shape.brand)
            Spacer()
            HStack(spacing: Spacing.s16) {
                Button {} label: { DSIcon("ic_search") }.buttonStyle(.plain)
                Button {} label: { DSIcon("ic_notice") }.buttonStyle(.plain)
            }
        }
        .padding(Spacing.s16)
        .background(Color.Semantic.Shape.white)
    }

    private var greeting: some View {
        VStack(alignment: .leading, spacing: Spacing.s2) {
            Text("\(displayName)님,")
                .textStyle(.display1)
                .foregroundStyle(Color.Semantic.Txt.B.primary)
            HStack(spacing: Spacing.s4) {
                WeatherIcon(condition: weather.condition)
                Text(weather.condition.lead)
                    .textStyle(.display1)
                    .foregroundStyle(Color.Semantic.Txt.B.primary)
            }
            Text(weather.condition.closing)
                .textStyle(.display1)
                .foregroundStyle(Color.Semantic.Txt.B.primary)
        }
        .padding(.horizontal, Spacing.s16)
    }

    private var bookGrid: some View {
        LazyVGrid(columns: columns, spacing: Spacing.s24) {
            ForEach($books) { $book in
                BookCard(book: book) { book.isSaved.toggle() }
            }
        }
        .padding(.horizontal, Spacing.s16)
    }

    private var displayName: String {
        profile.nickname.isEmpty ? "독서가" : profile.nickname
    }
}

#Preview {
    HomeView()
        .environment(UserProfileStore())
}
