import SwiftUI
import UIKit

/// Weather icon for the home greeting. Uses the user-provided asset
/// (`condition.assetName`) when present; otherwise falls back to an SF Symbol
/// so the greeting renders before the custom weather icons are delivered.
struct WeatherIcon: View {
    let condition: WeatherCondition
    var size: CGFloat = Spacing.s28

    var body: some View {
        if UIImage(named: condition.assetName) != nil {
            Image(condition.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        } else {
            Image(systemName: condition.sfSymbol)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(Color.Semantic.Shape.icon)
        }
    }
}

#Preview {
    HStack(spacing: Spacing.s12) {
        ForEach(WeatherCondition.allCases, id: \.self) { WeatherIcon(condition: $0) }
    }
    .padding(Spacing.s20)
}
