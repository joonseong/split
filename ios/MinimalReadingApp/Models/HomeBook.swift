import Foundation

/// A book shown in the home list. (Mock model until a content backend exists.)
struct HomeBook: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let episodes: Int
    var isFree: Bool = false
    var isSaved: Bool = false
}

extension HomeBook {
    /// Sample home list (covers are placeholders until artwork is available).
    static let samples: [HomeBook] = [
        HomeBook(title: "결국 무엇이든 해내는 사람", author: "김상현", episodes: 12, isFree: true, isSaved: true),
        HomeBook(title: "10년간의 디자인 이야기", author: "이지은", episodes: 8),
        HomeBook(title: "무엇이 인간을 힘들게 하는가", author: "박정훈", episodes: 15),
        HomeBook(title: "송세월", author: "정약용", episodes: 10),
        HomeBook(title: "THE MONEY BOOK", author: "토스", episodes: 20),
        HomeBook(title: "오늘 가장 빛나는 너에게", author: "최유진", episodes: 9),
        HomeBook(title: "느리게 읽는 즐거움", author: "민리딩 편집부", episodes: 6),
        HomeBook(title: "존재하지 않는 것들의 비망록", author: "minimalBookCreator", episodes: 42),
    ]
}
