import SwiftUI

// Semantic color tokens — role-based colors built on top of `color.core`.
// Renamed from the design source's `sys` namespace to `semantic`.
//
// Generated from `design-system/tokens/color.semantic.json`. Prefer these in
// feature code over raw `Color.Core.*` values. Usage: `Color.Semantic.Shape.brand`,
// `Color.Semantic.Txt.B.primary`, etc.
extension Color {
    enum Semantic {

        /// Surface / fill colors.
        enum Shape {
            public static let white     = Color.Core.gs0
            public static let depth1     = Color.Core.gs10   // color.semantic.shape.1depth
            public static let depth2     = Color.Core.gs100  // color.semantic.shape.2depth
            public static let div       = Color.Core.gs200
            public static let brand     = Color.Core.green500
            public static let black     = Color.Core.green900
            public static let icon      = Color.Core.green800
            public static let iconLight = Color.Core.gs500
            public static let highlight = Color.Core.red500
        }

        /// Stroke / line colors.
        enum Border {
            public static let div    = Color.Core.gs100
            public static let button = Color.Core.gs200
            public static let thumb  = Color.Core.gs100
            public static let brand  = Color.Core.green500
            public static let error  = Color.Core.red500
        }

        /// Text colors.
        enum Txt {
            /// On light backgrounds (black-family text).
            enum B {
                public static let primary     = Color.Core.gs900
                public static let secondary   = Color.Core.gs800
                public static let tertiary    = Color.Core.gs600
                public static let placeholder = Color.Core.gs400
            }

            /// On dark backgrounds (white-family text).
            enum W {
                public static let primary   = Color.Core.gs0
                public static let secondary = Color.Core.gs100
                public static let tertiary  = Color.Core.gs300
            }

            public static let point     = Color.Core.green600
            public static let error     = Color.Core.red600
            public static let link      = Color.Core.blue600
            public static let highlight = Color.Core.red500
        }
    }
}
