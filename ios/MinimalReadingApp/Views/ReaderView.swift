import SwiftUI

/// The reader: shows one page at a time with horizontal paging. The reader's
/// position is persisted so they resume where they left off.
struct ReaderView: View {
    let book: Book
    let series: Series

    @Environment(LibraryStore.self) private var store
    @State private var currentPage = 0

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(series.pages) { page in
                    PageView(page: page)
                        .tag(page.index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(.page(backgroundDisplayMode: .never))

            footer
        }
        .navigationTitle(series.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            currentPage = min(store.lastPageIndex(for: series), series.pages.count - 1)
        }
        .onChange(of: currentPage) { _, newValue in
            store.updateProgress(newValue, for: series)
        }
    }

    private var footer: some View {
        VStack(spacing: 8) {
            ProgressView(value: progress)
                .tint(.accent)
            HStack {
                Text(book.title)
                    .lineLimit(1)
                Spacer()
                Text("\(currentPage + 1) / \(series.pages.count)")
                    .monospacedDigit()
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.bar)
    }

    private var progress: Double {
        guard series.pages.count > 1 else { return 1 }
        return Double(currentPage) / Double(series.pages.count - 1)
    }
}

/// A single page of reading text, vertically centered with comfortable spacing.
private struct PageView: View {
    let page: ReadingPage

    var body: some View {
        ScrollView {
            Text(page.content)
                .font(.system(.title3, design: .serif))
                .lineSpacing(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .padding(.vertical, 32)
        }
    }
}

#Preview {
    NavigationStack {
        ReaderView(
            book: SampleLibrary.books[0],
            series: SampleLibrary.books[0].series[0]
        )
    }
    .environment(LibraryStore())
}
