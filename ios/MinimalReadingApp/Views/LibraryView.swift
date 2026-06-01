import SwiftUI

/// The home screen: a daily-limit banner above the list of available books.
struct LibraryView: View {
    @Environment(LibraryStore.self) private var store

    var body: some View {
        List {
            Section {
                DailyLimitBanner()
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }

            Section("서재") {
                ForEach(store.books) { book in
                    NavigationLink(value: book) {
                        BookRow(book: book)
                    }
                }
            }
        }
        .navigationTitle("MinimalReading")
        .navigationDestination(for: Book.self) { book in
            SeriesListView(book: book)
        }
    }
}

private struct BookRow: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title)
                .font(.headline)
            Text(book.author)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("\(book.seriesCount)개 시리즈 · 약 \(book.totalCharacterCount.formatted())자")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
    .environment(LibraryStore())
}
