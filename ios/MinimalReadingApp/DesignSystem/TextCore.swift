import SwiftUI

// Typography core scales — primitive values.
// Generated from `design-system/tokens/text.core.json`. Build semantic text
// styles (see `TextStyle` extensions) on top of these rather than using them
// directly in feature code.
enum TextCore {

    enum FontSize {
        public static let s10: CGFloat = 10
        public static let s13: CGFloat = 13
        public static let s14: CGFloat = 14
        public static let s16: CGFloat = 16
        public static let s20: CGFloat = 20
        public static let s22: CGFloat = 22
        public static let s24: CGFloat = 24
        public static let s28: CGFloat = 28
        public static let s32: CGFloat = 32
    }

    enum LineHeight {
        public static let s14: CGFloat = 14
        public static let s20: CGFloat = 20
        public static let s24: CGFloat = 24
        public static let s28: CGFloat = 28
        public static let s32: CGFloat = 32
        public static let s40: CGFloat = 40
        public static let s44: CGFloat = 44
        public static let s48: CGFloat = 48
        public static let s52: CGFloat = 52
    }

    enum LetterSpacing {
        public static let m: CGFloat = -0.5
        public static let l: CGFloat = -1
    }

    enum FontWeight {
        public static let bold: Font.Weight = .bold       // 700
        public static let regular: Font.Weight = .regular // 400
    }
}
