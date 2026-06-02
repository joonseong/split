import SwiftUI

/// Lists the series (episodes) of a book. Opening a new series consumes one of
/// the day's quota; series already opened today stay accessible.
struct SeriesListView: View {
    let book: Book

    @Environment(LibraryStore.self) private var store
    @State private var selectedSeries: Series?
    @State private var showLimitAlert = false

    var body: some View {
        List {
            Section {
                DailyLimitBanner()
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }

            Section("시리즈") {
                ForEach(book.series) { series in
                    Button {
                        handleTap(on: series)
                    } label: {
                        SeriesRow(series: series, locked: !store.canOpen(series))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedSeries) { series in
            ReaderView(book: book, series: series)
        }
        .alert("오늘의 분량을 다 읽었어요", isPresented: $showLimitAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("하루에 \(ReadingConfig.dailySeriesLimit)개의 시리즈까지 읽을 수 있어요. 내일 다시 이어서 읽어보세요.")
        }
    }

    private func handleTap(on series: Series) {
        guard store.open(series) else {
            showLimitAlert = true
            return
        }
        selectedSeries = series
    }
}

private struct SeriesRow: View {
    @Environment(LibraryStore.self) private var store
    let series: Series
    let locked: Bool

    var body: some View {
        HStack(spacing: Spacing.s12) {
            ZStack {
                Circle()
                    .fill(locked ? Color.secondary.opacity(0.15) : Color.accentColor.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundStyle(locked ? Color.secondary : Color.accentColor)
            }

            VStack(alignment: .leading, spacing: Spacing.s2) {
                Text(series.title)
                    .font(.body.weight(.medium))
                Text("\(series.pageCount)페이지 · 약 \(series.characterCount)자")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if store.isCompleted(series) {
                Text("완독")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            } else if store.hasStarted(series) {
                Text("읽는 중")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.accent)
            }
        }
        .foregroundStyle(locked ? .secondary : .primary)
        .padding(.vertical, Spacing.s4)
    }

    private var icon: String {
        if locked { return "lock.fill" }
        if store.isCompleted(series) { return "checkmark" }
        return "book.closed"
    }
}

#Preview {
    NavigationStack {
        SeriesListView(book: SampleLibrary.books[0])
    }
    .environment(LibraryStore())
}
