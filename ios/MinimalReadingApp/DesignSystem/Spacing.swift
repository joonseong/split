import CoreGraphics

// Spacing scale (pt). Generated from `design-system/tokens/spacing.json`.
//
// Steps: -1, 1, 2, 4, 6, 8, 10, 12, 16, 20, then 4pt increments through 80.
// Negative values allow intentional overlap. Usage: `.padding(Spacing.s16)`.
enum Spacing {
    public static let sNeg1: CGFloat = -1
    public static let s1: CGFloat = 1
    public static let s2: CGFloat = 2
    public static let s4: CGFloat = 4
    public static let s6: CGFloat = 6
    public static let s8: CGFloat = 8
    public static let s10: CGFloat = 10
    public static let s12: CGFloat = 12
    public static let s16: CGFloat = 16
    public static let s20: CGFloat = 20
    public static let s24: CGFloat = 24
    public static let s28: CGFloat = 28
    public static let s32: CGFloat = 32
    public static let s36: CGFloat = 36
    public static let s40: CGFloat = 40
    public static let s44: CGFloat = 44
    public static let s48: CGFloat = 48
    public static let s52: CGFloat = 52
    public static let s56: CGFloat = 56
    public static let s60: CGFloat = 60
    public static let s64: CGFloat = 64
    public static let s68: CGFloat = 68
    public static let s72: CGFloat = 72
    public static let s76: CGFloat = 76
    public static let s80: CGFloat = 80
}
