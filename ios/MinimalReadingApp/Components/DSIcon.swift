import SwiftUI

/// Renders a design-system icon asset as a tintable (template) image.
/// Default color is the `Shape.icon` semantic token; pass `color` to override.
/// Use this for monochrome UI icons — for full-color illustrations (e.g.
/// `ic_fox`, payment logos) use `Image(_:)` directly so their colors are kept.
struct DSIcon: View {
    let name: String
    var size: CGFloat = Spacing.s24
    var color: Color = Color.Semantic.Shape.icon

    init(_ name: String, size: CGFloat = Spacing.s24, color: Color = Color.Semantic.Shape.icon) {
        self.name = name
        self.size = size
        self.color = color
    }

    var body: some View {
        Image(name)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(color)
    }
}

#Preview {
    HStack(spacing: Spacing.s12) {
        DSIcon("ic_search")
        DSIcon("ic_notice")
        DSIcon("ic_bookmark_fill", color: Color.Semantic.Shape.brand)
        DSIcon("ic_close", color: Color.Semantic.Txt.error)
    }
    .padding(Spacing.s20)
}
