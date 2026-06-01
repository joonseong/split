import SwiftUI

/// Shows how many series the reader has left for today.
struct DailyLimitBanner: View {
    @Environment(LibraryStore.self) private var store

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: store.remainingToday > 0 ? "book.pages" : "moon.zzz")
                .font(.title3)
                .foregroundStyle(.accent)

            VStack(alignment: .leading, spacing: 2) {
                Text("오늘의 읽기")
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(store.remainingToday) / \(ReadingConfig.dailySeriesLimit)")
                .font(.title3.weight(.bold).monospacedDigit())
                .foregroundStyle(store.remainingToday > 0 ? .primary : .secondary)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var subtitle: String {
        store.remainingToday > 0
            ? "오늘 \(store.remainingToday)개의 시리즈를 더 읽을 수 있어요"
            : "오늘 분량을 다 읽었어요. 내일 다시 만나요"
    }
}

#Preview {
    DailyLimitBanner()
        .environment(LibraryStore())
        .padding()
}
