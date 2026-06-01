import Foundation

/// Splits raw book text into fixed-size pages and groups those pages into
/// series. This is the Swift counterpart of the original server-side splitter.
enum Paginator {

    /// Cleans raw text: collapses single line breaks into spaces while keeping
    /// blank-line paragraph breaks, and trims redundant whitespace.
    static func clean(_ raw: String) -> String {
        var text = raw.replacingOccurrences(of: "\r\n", with: "\n")

        // Protect paragraph breaks (two or more newlines) with a placeholder.
        let paragraphBreak = "\u{0001}"
        text = text.replacingOccurrences(
            of: "\n{2,}",
            with: paragraphBreak,
            options: .regularExpression
        )

        // Remaining single newlines become spaces so sentences flow together.
        text = text.replacingOccurrences(of: "\n", with: " ")

        // Restore paragraph breaks as a single newline.
        text = text.replacingOccurrences(of: paragraphBreak, with: "\n")

        // Collapse runs of spaces/tabs.
        text = text.replacingOccurrences(
            of: "[ \t]{2,}",
            with: " ",
            options: .regularExpression
        )

        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Splits cleaned text into pages of at most `charactersPerPage` characters.
    static func paginate(
        _ text: String,
        charactersPerPage: Int = ReadingConfig.charactersPerPage
    ) -> [ReadingPage] {
        precondition(charactersPerPage > 0, "charactersPerPage must be positive")
        let cleaned = clean(text)
        guard !cleaned.isEmpty else { return [] }

        var pages: [ReadingPage] = []
        var index = 0
        var start = cleaned.startIndex
        while start < cleaned.endIndex {
            let end = cleaned.index(
                start,
                offsetBy: charactersPerPage,
                limitedBy: cleaned.endIndex
            ) ?? cleaned.endIndex
            let slice = String(cleaned[start..<end])
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if !slice.isEmpty {
                pages.append(ReadingPage(index: index, content: slice))
                index += 1
            }
            start = end
        }
        return pages
    }

    /// Groups pages into series of `pagesPerSeries` pages each, re-indexing the
    /// pages within every series so each starts at zero.
    static func makeSeries(
        from pages: [ReadingPage],
        pagesPerSeries: Int = ReadingConfig.pagesPerSeries
    ) -> [Series] {
        precondition(pagesPerSeries > 0, "pagesPerSeries must be positive")
        var series: [Series] = []
        var episode = 1
        var cursor = 0
        while cursor < pages.count {
            let end = min(cursor + pagesPerSeries, pages.count)
            let chunk = pages[cursor..<end].enumerated().map { offset, page in
                ReadingPage(index: offset, content: page.content)
            }
            series.append(Series(episode: episode, pages: chunk))
            episode += 1
            cursor = end
        }
        return series
    }

    /// Convenience: build a complete `Book` from raw text.
    static func makeBook(title: String, author: String, rawText: String) -> Book {
        let pages = paginate(rawText)
        let series = makeSeries(from: pages)
        return Book(title: title, author: author, series: series)
    }
}
