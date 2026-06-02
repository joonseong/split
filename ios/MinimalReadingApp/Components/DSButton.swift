import SwiftUI

/// Button size variants (height in pt): 56, 48, 32.
enum DSButtonSize {
    case h56, h48, h32

    var height: CGFloat {
        switch self {
        case .h56: return Spacing.s56
        case .h48: return Spacing.s48
        case .h32: return Spacing.s32
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .h56, .h48: return Radius.full
        case .h32: return Radius.r8
        }
    }

    var textStyle: TextStyle {
        switch self {
        case .h56, .h48: return .title1
        case .h32: return .title2
        }
    }

    /// h56/h48 stretch to fill; h32 hugs its label.
    var fillsWidth: Bool { self != .h32 }
}

/// Button color/role variants.
enum DSButtonStyle { case primary, secondary, tertiary }

/// The primary action button. Combines a size and a style; disabled states are
/// driven by the environment `isEnabled` (use `.disabled(_:)`).
struct DSButton: View {
    let title: String
    var size: DSButtonSize = .h56
    var style: DSButtonStyle = .primary
    var action: () -> Void = {}

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(size.textStyle)
                .lineLimit(1)
                .padding(.horizontal, size.fillsWidth ? Spacing.s16 : Spacing.s12)
                .frame(maxWidth: size.fillsWidth ? .infinity : nil)
                .frame(height: size.height)
                .foregroundStyle(foreground)
                .background(background)
                .overlay(
                    RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                        .strokeBorder(borderColor, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var background: Color {
        guard isEnabled else { return Color.Semantic.Shape.depth2 }
        switch style {
        case .primary:   return Color.Semantic.Shape.brand
        case .secondary: return Color.Semantic.Shape.white
        case .tertiary:  return Color.Semantic.Shape.black
        }
    }

    private var foreground: Color {
        guard isEnabled else { return Color.Semantic.Txt.B.placeholder }
        switch style {
        case .primary, .tertiary: return Color.Semantic.Txt.W.primary
        case .secondary:          return Color.Semantic.Txt.B.primary
        }
    }

    private var borderColor: Color {
        guard isEnabled, style == .secondary else { return .clear }
        return Color.Semantic.Border.button
    }
}

#Preview {
    VStack(spacing: Spacing.s12) {
        DSButton(title: "label", size: .h56, style: .primary)
        DSButton(title: "label", size: .h56, style: .secondary)
        DSButton(title: "label", size: .h48, style: .tertiary)
        DSButton(title: "label", size: .h48, style: .primary).disabled(true)
        HStack(spacing: Spacing.s8) {
            DSButton(title: "Button", size: .h32, style: .primary)
            DSButton(title: "Button", size: .h32, style: .secondary)
            DSButton(title: "Button", size: .h32, style: .tertiary)
        }
    }
    .padding(Spacing.s20)
}
