import SwiftUI

/// A small downward-pointing triangle used as the tooltip's tail.
private struct DownTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

/// A brand-colored tooltip bubble with a downward tail.
struct DSTooltip: View {
    let text: String

    var body: some View {
        VStack(spacing: 0) {
            Text(text)
                .textStyle(.caption1)
                .foregroundStyle(Color.Semantic.Txt.W.primary)
                .padding(.horizontal, Spacing.s12)
                .padding(.vertical, Spacing.s8)
                .background(Color.Semantic.Shape.brand)
                .clipShape(RoundedRectangle(cornerRadius: Radius.r8, style: .continuous))
            DownTriangle()
                .fill(Color.Semantic.Shape.brand)
                .frame(width: Spacing.s12, height: Spacing.s6)
        }
    }
}

/// A transient dark toast message.
struct DSToast: View {
    let text: String

    var body: some View {
        Text(text)
            .textStyle(.body2)
            .foregroundStyle(Color.Semantic.Txt.W.primary)
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s12)
            .background(Color.Semantic.Shape.black)
            .clipShape(RoundedRectangle(cornerRadius: Radius.r8, style: .continuous))
    }
}

#Preview {
    VStack(spacing: Spacing.s24) {
        DSTooltip(text: "툴팁 텍스트")
        DSToast(text: "토스트 텍스트")
    }
    .padding(Spacing.s20)
}
