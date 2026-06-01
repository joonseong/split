import Foundation

/// Bundled sample books used until real content is loaded from a backend.
/// The raw text is split on demand by `Paginator`, so changing `ReadingConfig`
/// automatically reshapes these books too.
enum SampleLibrary {

    static let books: [Book] = {
        var result: [Book] = []
        if let memorandum = bundledBook(
            resource: "memorandum",
            title: "존재하지 않는 것들의 비망록",
            author: "minimalBookCreator AI"
        ) {
            result.append(memorandum)
        }
        result.append(placeholderBook)
        return result
    }()

    // MARK: - Loading

    /// Loads a plain-text resource from the app bundle and splits it into a book.
    private static func bundledBook(resource: String, title: String, author: String) -> Book? {
        guard
            let url = Bundle.main.url(forResource: resource, withExtension: "txt"),
            let text = try? String(contentsOf: url, encoding: .utf8)
        else {
            return nil
        }
        return Paginator.makeBook(title: title, author: author, rawText: text)
    }

    /// A small built-in book so previews and empty-bundle situations still work.
    private static let placeholderBook = Paginator.makeBook(
        title: "느리게 읽는 즐거움",
        author: "민리딩 편집부",
        rawText: Array(repeating: placeholderParagraphs, count: 4)
            .flatMap { $0 }
            .joined(separator: "\n\n")
    )

    private static let placeholderParagraphs = [
        "책을 빨리 읽어야 한다는 조바심은 종종 독서의 가장 큰 적이 된다. 한 문장을 천천히 곱씹을 때, 우리는 비로소 글자 너머에 숨은 생각의 결을 만난다. 속도를 늦추는 일은 게으름이 아니라, 더 깊이 들어가기 위한 준비다.",
        "하루에 단 몇 페이지라도 꾸준히 읽는 사람은, 어느 날 문득 자신이 한 권의 책을 끝까지 통과했음을 깨닫는다. 작은 분량이 모여 거대한 흐름을 이루듯, 독서의 습관은 양이 아니라 반복에서 자란다.",
        "긴 글 앞에서 압도당하지 않는 방법은 의외로 간단하다. 그것을 잘게 나누는 것이다. 한 번에 다 삼키려 하지 말고, 한 입 크기로 잘라 천천히 음미하면 어느새 마지막 장에 닿아 있다."
    ]
}
