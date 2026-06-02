import SwiftUI

/// A book cover card: cover area with a bookmark toggle and optional corner
/// badge, then episode / title / author lines beneath.
struct DSThumbnail: View {
    var title: String
    var bookTitle: String
    var author: String
    var isSaved: Bool = false
    var badge: String?
    /// Optional cover artwork; a placeholder is shown when nil.
    var cover: Image?
    var onToggleSave: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            coverArea
            VStack(alignment: .leading, spacing: Spacing.s2) {
                Text(title)
                    .textStyle(.title2)
                    .foregroundStyle(Color.Semantic.Txt.B.primary)
                Text(bookTitle)
                    .textStyle(.caption1)
                    .foregroundStyle(Color.Semantic.Txt.B.tertiary)
                Text(author)
                    .textStyle(.caption1)
                    .foregroundStyle(Color.Semantic.Txt.B.tertiary)
            }
            .lineLimit(1)
        }
    }

    private var coverArea: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radius.r12, style: .continuous)
                .fill(Color.Semantic.Shape.depth2)
            if let cover {
                cover
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "book.closed")
                    .textStyle(.display1)
                    .foregroundStyle(Color.Semantic.Shape.iconLight)
            }
        }
        .aspectRatio(3.0 / 4.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r12, style: .continuous))
        .overlay(alignment: .topTrailing) {
            Button(action: onToggleSave) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .textStyle(.body2)
                    .foregroundStyle(isSaved ? Color.Semantic.Shape.brand : Color.Semantic.Shape.white)
                    .padding(Spacing.s8)
            }
            .buttonStyle(.plain)
        }
        .overlay(alignment: .topLeading) {
            if let badge {
                Text(badge)
                    .textStyle(.labelBold)
                    .foregroundStyle(Color.Semantic.Txt.W.primary)
                    .padding(.horizontal, Spacing.s8)
                    .frame(height: Spacing.s20)
                    .background(Color.Semantic.Shape.brand)
                    .clipShape(Capsule())
                    .padding(Spacing.s8)
            }
        }
    }
}

#Preview {
    HStack(alignment: .top, spacing: Spacing.s12) {
        DSThumbnail(title: "총 12화", bookTitle: "(책 이름)", author: "(작가명)",
                    isSaved: false, badge: "무료", cover: nil)
        DSThumbnail(title: "총 12화", bookTitle: "(책 이름)", author: "(작가명)",
                    isSaved: true, badge: nil, cover: nil)
    }
    .frame(width: Spacing.s80 + Spacing.s40)
    .padding(Spacing.s20)
}
