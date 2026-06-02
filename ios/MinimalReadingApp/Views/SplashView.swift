import SwiftUI
import UIKit

/// 00. Splash — brand-colored launch screen with the wordmark and tagline.
/// Built from Figma node 315:453 (미니멀리딩 UI).
///
/// Tokens: background = Shape.brand, text = Txt.W.primary + .title1, gap = s16.
struct SplashView: View {
    var body: some View {
        ZStack {
            Color.Semantic.Shape.brand
                .ignoresSafeArea()

            VStack(spacing: Spacing.s16) {
                BrandWordmark()
                Text("최소한의 읽기로 기르는 독서습관")
                    .textStyle(.title1)
                    .foregroundStyle(Color.Semantic.Txt.W.primary)
            }
        }
    }
}

/// The "미니멀리딩" wordmark. Shows the bundled brand asset
/// (`LogoMinimalReading`, 258×46) when present; otherwise falls back to a text
/// wordmark so the screen still renders before the asset is added.
private struct BrandWordmark: View {
    var body: some View {
        if UIImage(named: "LogoMinimalReading") != nil {
            Image("LogoMinimalReading")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 258, height: 46)
                .foregroundStyle(Color.Semantic.Txt.W.primary)
        } else {
            Text("미니멀리딩")
                .textStyle(.display1)
                .foregroundStyle(Color.Semantic.Txt.W.primary)
        }
    }
}

#Preview {
    SplashView()
}
