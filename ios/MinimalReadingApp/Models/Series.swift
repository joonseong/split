import Foundation

/// A "시리즈" — one episode of a book, made up of up to
/// `ReadingConfig.pagesPerSeries` pages and delivered to the reader one at a time.
struct Series: Identifiable, Hashable, Codable {
    let id: UUID

    /// 1-based episode number within the book (제 N 화).
    let episode: Int

    let pages: [ReadingPage]

    init(id: UUID = UUID(), episode: Int, pages: [ReadingPage]) {
        self.id = id
        self.episode = episode
        self.pages = pages
    }

    var title: String { "제 \(episode)화" }

    var pageCount: Int { pages.count }

    var characterCount: Int { pages.reduce(0) { $0 + $1.content.count } }
}
