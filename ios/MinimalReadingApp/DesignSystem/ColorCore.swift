import SwiftUI

// Core color palette — the raw, primitive color tokens of the design system.
//
// Generated from `design-system/tokens/color.core.json`. Do not consume these
// directly in feature code; build semantic tokens on top of them. Use as
// `Color.Core.gs900`, `Color.Core.red500`, etc.
extension Color {
    enum Core {

        // MARK: Grayscale
        public static let gs900 = Color(hex: 0x151517)
        public static let gs800 = Color(hex: 0x3F4047)
        public static let gs700 = Color(hex: 0x61626C)
        public static let gs600 = Color(hex: 0x858691)
        public static let gs500 = Color(hex: 0x9FA0AA)
        public static let gs400 = Color(hex: 0xB4B5C1)
        public static let gs300 = Color(hex: 0xCACBDA)
        public static let gs200 = Color(hex: 0xDEDFEB)
        public static let gs100 = Color(hex: 0xEEEEF9)
        public static let gs10  = Color(hex: 0xF5F5FD)
        public static let gs0   = Color(hex: 0xFFFFFF)

        // MARK: Trans
        public static let trans4 = Color(hex: 0x000000, alpha: 0.04)

        // MARK: Red
        public static let red900 = Color(hex: 0x180507)
        public static let red800 = Color(hex: 0x330D12)
        public static let red700 = Color(hex: 0x7A1525)
        public static let red600 = Color(hex: 0x862637)
        public static let red500 = Color(hex: 0xB53249)
        public static let red400 = Color(hex: 0xE76527)
        public static let red300 = Color(hex: 0xF40944)
        public static let red200 = Color(hex: 0xFCCCD2)
        public static let red100 = Color(hex: 0xFEEBED)

        // MARK: Yellow
        public static let yellow900 = Color(hex: 0x1A1507)
        public static let yellow800 = Color(hex: 0x403511)
        public static let yellow700 = Color(hex: 0x806B21)
        public static let yellow600 = Color(hex: 0xBFA032)
        public static let yellow500 = Color(hex: 0xFFD542)
        public static let yellow400 = Color(hex: 0xFFDF71)
        public static let yellow300 = Color(hex: 0xFFEAA0)
        public static let yellow200 = Color(hex: 0xFFF5D0)
        public static let yellow100 = Color(hex: 0xFFFBEC)

        // MARK: Green
        public static let green900 = Color(hex: 0x0B3F0C)
        public static let green800 = Color(hex: 0x0B6A1E)
        public static let green700 = Color(hex: 0x194E3D)
        public static let green600 = Color(hex: 0x15875B)
        public static let green500 = Color(hex: 0x20967A)
        public static let green400 = Color(hex: 0x558698)
        public static let green300 = Color(hex: 0x99CB8C)
        public static let green200 = Color(hex: 0xC7E5D6)
        public static let green100 = Color(hex: 0xE3F5F2)

        // MARK: Blue
        public static let blue900 = Color(hex: 0x040917)
        public static let blue800 = Color(hex: 0x0B153A)
        public static let blue700 = Color(hex: 0x162B74)
        public static let blue600 = Color(hex: 0x2140AE)
        public static let blue500 = Color(hex: 0x2C55E8)
        public static let blue400 = Color(hex: 0x6180EE)
        public static let blue300 = Color(hex: 0x95AAF3)
        public static let blue200 = Color(hex: 0xCAD4F9)
        public static let blue100 = Color(hex: 0xEAEEFD)

        // MARK: Purple
        public static let purple900 = Color(hex: 0x0E0717)
        public static let purple800 = Color(hex: 0x231139)
        public static let purple700 = Color(hex: 0x452272)
        public static let purple600 = Color(hex: 0x6833A6)
        public static let purple500 = Color(hex: 0x8A44E3)
        public static let purple400 = Color(hex: 0xA773E6)
        public static let purple300 = Color(hex: 0xC5A1F1)
        public static let purple200 = Color(hex: 0xE2C0F6)
        public static let purple100 = Color(hex: 0xF3DCFC)
    }
}
