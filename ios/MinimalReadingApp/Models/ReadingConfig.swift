import Foundation

/// Central tuning knobs for how books are split and how much a user may read
/// per day. Changing these values reshapes pages, series, and the daily quota
/// everywhere in the app.
enum ReadingConfig {
    /// Characters shown on a single mobile page.
    static let charactersPerPage = 220

    /// Number of pages grouped into one series (한 화).
    static let pagesPerSeries = 10

    /// Maximum number of series a user may open in a single day.
    static let dailySeriesLimit = 3
}
