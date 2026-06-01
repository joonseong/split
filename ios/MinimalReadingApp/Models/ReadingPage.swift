import Foundation

/// A single mobile reading page — a small, fixed-size slice of a book's text
/// (about `ReadingConfig.charactersPerPage` characters).
struct ReadingPage: Identifiable, Hashable, Codable {
    /// Zero-based position of this page within its series.
    let index: Int

    /// The text shown on this page.
    let content: String

    var id: Int { index }
}
