import SwiftUI

/// 02-3. 장르선택 — favorite-genre selection after nickname setup (Figma 378:3401).
/// Multi-select; "다음" enabled once at least one is chosen. "잘 모르겠음" skips
/// with no selection (home shows its default tabs). Back returns to nickname.
struct GenreSelectionView: View {
    let nickname: String
    var onComplete: ([Genre]) -> Void = { _ in }

    @Environment(\.dismiss) private var dismiss
    @State private var selected: Set<Genre> = []

    var body: some View {
        VStack(spacing: 0) {
            DSHeader(onBack: { dismiss() })

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.s32) {
                    Text("\(nickname)님이\n좋아하는 장르를 알려주세요.")
                        .textStyle(.display1)
                        .foregroundStyle(Color.Semantic.Txt.B.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: Spacing.s8) {
                        Text("어떤 장르를 좋아하세요?(복수선택)")
                            .textStyle(.title1)
                            .foregroundStyle(Color.Semantic.Txt.B.primary)

                        FlowLayout(spacing: Spacing.s8) {
                            ForEach(Genre.allCases) { genre in
                                GenreChip(title: genre.title, isSelected: selected.contains(genre)) {
                                    toggle(genre)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.s16)
                .padding(.top, Spacing.s8)
            }

            Spacer(minLength: 0)

            bottomBar
        }
        .background(Color.Semantic.Shape.white)
    }

    private var bottomBar: some View {
        VStack(spacing: Spacing.s24) {
            Button { onComplete([]) } label: {
                Text("잘 모르겠음")
                    .textStyle(.body2)
                    .foregroundStyle(Color.Semantic.Txt.B.tertiary)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)

            DSButton(title: "다음", size: .h56, style: .primary) {
                onComplete(orderedSelection)
            }
            .disabled(selected.isEmpty)
        }
        .padding(.horizontal, Spacing.s16)
        .padding(.top, Spacing.s8)
        .padding(.bottom, Spacing.s16)
        .background(Color.Semantic.Shape.white)
    }

    private func toggle(_ genre: Genre) {
        if selected.contains(genre) { selected.remove(genre) } else { selected.insert(genre) }
    }

    /// Selected genres in canonical order (drives leftmost home-tab placement).
    private var orderedSelection: [Genre] {
        Genre.allCases.filter { selected.contains($0) }
    }
}

/// A toggleable genre pill (selected = brand fill / white text).
private struct GenreChip: View {
    let title: String
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(isSelected ? .title2 : .body2)
                .foregroundStyle(isSelected ? Color.Semantic.Txt.W.primary : Color.Semantic.Txt.B.primary)
                .padding(.horizontal, Spacing.s16)
                .padding(.vertical, Spacing.s10)
                .background(isSelected ? Color.Semantic.Shape.brand : Color.Semantic.Shape.depth1)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    GenreSelectionView(nickname: "철학적인 니체")
}
