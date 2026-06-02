import SwiftUI
import UIKit

/// A composite typography style: font size, weight, line height, and letter
/// spacing. Apply to any view with `.textStyle(_:)`.
struct TextStyle: Equatable {
    let size: CGFloat
    let weight: Font.Weight
    /// Total target line height in points.
    let lineHeight: CGFloat
    /// Letter spacing (tracking) in points; negative tightens.
    let letterSpacing: CGFloat
}

extension View {
    /// Applies a design-system text style (font, tracking, and line height).
    func textStyle(_ style: TextStyle) -> some View {
        modifier(TextStyleModifier(style: style))
    }
}

private struct TextStyleModifier: ViewModifier {
    let style: TextStyle

    func body(content: Content) -> some View {
        // Distribute the gap between the target line height and the font's
        // natural line height as leading, padding half above/below so the text
        // sits vertically centered within its line box.
        let naturalLineHeight = UIFont.systemFont(
            ofSize: style.size,
            weight: style.weight.uiKit
        ).lineHeight
        let leading = max(0, style.lineHeight - naturalLineHeight)

        content
            .font(.system(size: style.size, weight: style.weight))
            .tracking(style.letterSpacing)
            .lineSpacing(leading)
            .padding(.vertical, leading / 2)
    }
}

private extension Font.Weight {
    /// Maps a SwiftUI font weight to its UIKit counterpart for metric lookups.
    var uiKit: UIFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin:       return .thin
        case .light:      return .light
        case .regular:    return .regular
        case .medium:     return .medium
        case .semibold:   return .semibold
        case .bold:       return .bold
        case .heavy:      return .heavy
        case .black:      return .black
        default:          return .regular
        }
    }
}
