import Foundation

/// A book that has been split into an ordered sequence of series (episodes).
struct Book: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let author: String
    let series: [Series]

    init(id: UUID = UUID(), title: String, author: String, series: [Series]) {
        self.id = id
        self.title = title
        self.author = author
        self.series = series
    }

    var seriesCount: Int { series.count }

    var totalCharacterCount: Int { series.reduce(0) { $0 + $1.characterCount } }
}
