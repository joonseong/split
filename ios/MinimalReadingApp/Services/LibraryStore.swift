import Foundation
import Observation

/// App-wide state: the library of books, per-series reading progress, and the
/// daily limit on how many series a user may open. Progress and the daily
/// counter are persisted to `UserDefaults` so they survive app launches.
@Observable
final class LibraryStore {
    private(set) var books: [Book]

    /// IDs of series the user has opened during the current tracking day.
    private(set) var seriesOpenedToday: Set<UUID> = []

    /// The calendar day the counter belongs to.
    private(set) var trackingDay: Date

    /// Last-read page index keyed by series id.
    private(set) var progress: [UUID: Int] = [:]

    private let defaults: UserDefaults
    private let calendar = Calendar.current

    init(books: [Book] = SampleLibrary.books, defaults: UserDefaults = .standard) {
        self.books = books
        self.defaults = defaults
        self.trackingDay = Date()
        load()
        rolloverIfNeeded()
    }

    // MARK: - Daily limit

    var seriesReadToday: Int { seriesOpenedToday.count }

    var remainingToday: Int {
        max(0, ReadingConfig.dailySeriesLimit - seriesReadToday)
    }

    /// Whether a given series can be opened right now. A series already opened
    /// today can always be re-opened; new ones are gated by the daily quota.
    func canOpen(_ series: Series) -> Bool {
        rolloverIfNeeded()
        if seriesOpenedToday.contains(series.id) { return true }
        return remainingToday > 0
    }

    /// Records that the user opened a series. Returns whether it was allowed.
    @discardableResult
    func open(_ series: Series) -> Bool {
        guard canOpen(series) else { return false }
        seriesOpenedToday.insert(series.id)
        save()
        return true
    }

    /// Resets the daily counter when the tracking day is no longer today.
    func rolloverIfNeeded() {
        guard !calendar.isDateInToday(trackingDay) else { return }
        seriesOpenedToday.removeAll()
        trackingDay = Date()
        save()
    }

    // MARK: - Progress

    func lastPageIndex(for series: Series) -> Int {
        progress[series.id] ?? 0
    }

    func updateProgress(_ pageIndex: Int, for series: Series) {
        progress[series.id] = pageIndex
        save()
    }

    func isCompleted(_ series: Series) -> Bool {
        guard !series.pages.isEmpty else { return false }
        return (progress[series.id] ?? 0) >= series.pages.count - 1
    }

    func hasStarted(_ series: Series) -> Bool {
        progress[series.id] != nil
    }

    // MARK: - Persistence

    private struct Snapshot: Codable {
        var trackingDay: Date
        var seriesOpenedToday: [UUID]
        var progress: [String: Int]
    }

    private static let storageKey = "LibraryStore.snapshot"

    private func save() {
        let snapshot = Snapshot(
            trackingDay: trackingDay,
            seriesOpenedToday: Array(seriesOpenedToday),
            progress: Dictionary(
                uniqueKeysWithValues: progress.map { ($0.key.uuidString, $0.value) }
            )
        )
        if let data = try? JSONEncoder().encode(snapshot) {
            defaults.set(data, forKey: Self.storageKey)
        }
    }

    private func load() {
        guard
            let data = defaults.data(forKey: Self.storageKey),
            let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data)
        else { return }

        trackingDay = snapshot.trackingDay
        seriesOpenedToday = Set(snapshot.seriesOpenedToday)
        progress = Dictionary(
            uniqueKeysWithValues: snapshot.progress.compactMap { key, value in
                UUID(uuidString: key).map { ($0, value) }
            }
        )
    }
}
