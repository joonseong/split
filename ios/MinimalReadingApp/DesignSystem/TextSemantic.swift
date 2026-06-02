import SwiftUI

// Semantic typography styles — composite text styles built on `TextCore`.
// Renamed from the design source's `sys` namespace to `semantic`.
//
// Generated from `design-system/tokens/text.semantic.json`. Exposed as static
// members on `TextStyle` for ergonomic use: `Text("Title").textStyle(.title1)`.
extension TextStyle {

    // MARK: Display
    static let display1 = TextStyle(
        size: TextCore.FontSize.s24, weight: TextCore.FontWeight.bold,
        lineHeight: TextCore.LineHeight.s32, letterSpacing: TextCore.LetterSpacing.l
    )
    static let display2 = TextStyle(
        size: TextCore.FontSize.s20, weight: TextCore.FontWeight.bold,
        lineHeight: TextCore.LineHeight.s28, letterSpacing: TextCore.LetterSpacing.m
    )

    // MARK: Title
    static let title1 = TextStyle(
        size: TextCore.FontSize.s16, weight: TextCore.FontWeight.bold,
        lineHeight: TextCore.LineHeight.s24, letterSpacing: TextCore.LetterSpacing.m
    )
    static let title2 = TextStyle(
        size: TextCore.FontSize.s14, weight: TextCore.FontWeight.bold,
        lineHeight: TextCore.LineHeight.s20, letterSpacing: TextCore.LetterSpacing.m
    )

    // MARK: Body
    static let body1 = TextStyle(
        size: TextCore.FontSize.s16, weight: TextCore.FontWeight.regular,
        lineHeight: TextCore.LineHeight.s24, letterSpacing: TextCore.LetterSpacing.m
    )
    static let body2 = TextStyle(
        size: TextCore.FontSize.s14, weight: TextCore.FontWeight.regular,
        lineHeight: TextCore.LineHeight.s20, letterSpacing: TextCore.LetterSpacing.m
    )

    // MARK: Caption
    static let caption1 = TextStyle(
        size: TextCore.FontSize.s13, weight: TextCore.FontWeight.regular,
        lineHeight: TextCore.LineHeight.s20, letterSpacing: TextCore.LetterSpacing.m
    )

    // MARK: Label
    static let labelBold = TextStyle(
        size: TextCore.FontSize.s10, weight: TextCore.FontWeight.bold,
        lineHeight: TextCore.LineHeight.s14, letterSpacing: TextCore.LetterSpacing.m
    )
    static let labelRegular = TextStyle(
        size: TextCore.FontSize.s10, weight: TextCore.FontWeight.regular,
        lineHeight: TextCore.LineHeight.s14, letterSpacing: TextCore.LetterSpacing.m
    )

    // MARK: Viewer
    static let viewerL = TextStyle(
        size: TextCore.FontSize.s28, weight: TextCore.FontWeight.regular,
        lineHeight: TextCore.LineHeight.s52, letterSpacing: TextCore.LetterSpacing.m
    )
    static let viewerM = TextStyle(
        size: TextCore.FontSize.s22, weight: TextCore.FontWeight.regular,
        lineHeight: TextCore.LineHeight.s44, letterSpacing: TextCore.LetterSpacing.m
    )
    static let viewerS = TextStyle(
        size: TextCore.FontSize.s16, weight: TextCore.FontWeight.regular,
        lineHeight: TextCore.LineHeight.s32, letterSpacing: TextCore.LetterSpacing.m
    )
    static let viewerXS = TextStyle(
        size: TextCore.FontSize.s14, weight: TextCore.FontWeight.regular,
        lineHeight: TextCore.LineHeight.s28, letterSpacing: TextCore.LetterSpacing.m
    )
}
