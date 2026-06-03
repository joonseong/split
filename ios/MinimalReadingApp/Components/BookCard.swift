import SwiftUI

/// A home book cell: cover (with optional free badge + save button) and the
/// episode count / title / author below.
struct BookCard: View {
    let book: HomeBook
    var onToggleSave: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            cover
            VStack(alignment: .leading, spacing: 0) {
                Text("총 \(book.episodes)화")
                    .textStyle(.title2)
                    .foregroundStyle(Color.Semantic.Txt.B.secondary)
                Text(book.title)
                    .textStyle(.body2)
                    .foregroundStyle(Color.Semantic.Txt.B.secondary)
                Text(book.author)
                    .textStyle(.body2)
                    .foregroundStyle(Color.Semantic.Txt.B.tertiary)
            }
            .lineLimit(1)
            .padding(.horizontal, Spacing.s4)
        }
    }

    private var cover: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radius.r8, style: .continuous)
                .fill(Color.Semantic.Shape.depth2)
            DSIcon("ic_nobook", size: Spacing.s40, color: Color.Semantic.Shape.iconLight)
        }
        .aspectRatio(174.5 / 264.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r8, style: .continuous))
        .overlay(alignment: .topLeading) {
            if book.isFree { freeBadge }
        }
        .overlay(alignment: .topTrailing) {
            saveButton
        }
    }

    private var freeBadge: some View {
        Text("무료 도서")
            .textStyle(.labelBold)
            .foregroundStyle(Color.Semantic.Txt.W.primary)
            .padding(.horizontal, Spacing.s6)
            .padding(.vertical, Spacing.s2)
            .background(Color.Semantic.Shape.icon)
            .clipShape(RoundedRectangle(cornerRadius: Radius.r4, style: .continuous))
            .padding(Spacing.s8)
    }

    private var saveButton: some View {
        Button(action: onToggleSave) {
            ZStack {
                Circle()
                    .fill(book.isSaved
                        ? Color.Semantic.Shape.brand
                        : Color.Semantic.Shape.black.opacity(0.32))
                DSIcon(book.isSaved ? "ic_bookmark_fill" : "ic_bookmark_line",
                       size: Spacing.s20,
                       color: Color.Semantic.Txt.W.primary)
            }
            .frame(width: Spacing.s32, height: Spacing.s32)
            .padding(Spacing.s8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(alignment: .top, spacing: Spacing.s12) {
        BookCard(book: HomeBook.samples[0])
        BookCard(book: HomeBook.samples[1])
    }
    .padding(Spacing.s16)
}
