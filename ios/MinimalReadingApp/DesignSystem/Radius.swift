import CoreGraphics

// Corner radius scale (pt). Generated from `design-system/tokens/radius.json`.
//
// `full` (999) produces a pill/circle for any element. Usage:
// `.clipShape(RoundedRectangle(cornerRadius: Radius.r12))`.
enum Radius {
    public static let r2: CGFloat = 2
    public static let r4: CGFloat = 4
    public static let r8: CGFloat = 8
    public static let r12: CGFloat = 12
    public static let r16: CGFloat = 16
    public static let full: CGFloat = 999
}
