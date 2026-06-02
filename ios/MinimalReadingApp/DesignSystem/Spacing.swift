import CoreGraphics

// Spacing scale (pt). Generated from `design-system/tokens/spacing.json`.
//
// Steps: -1, 1, 2, 4, 6, 8, 10, 12, 16, 20 — beyond 20 the scale continues in
// 4pt increments. Negative values allow intentional overlap. Usage:
// `.padding(Spacing.s16)`.
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
}
