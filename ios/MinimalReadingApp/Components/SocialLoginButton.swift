import SwiftUI
import UIKit

/// Social sign-in providers shown on the login screen.
enum SocialProvider: String, CaseIterable {
    case google, kakao, naver, apple

    /// Asset name to drop in for a pixel-perfect button (full-color circle).
    var assetName: String { "social_\(rawValue)" }
}

/// A 64pt circular social login button. Uses the bundled `social_<provider>`
/// asset when present; otherwise renders a brand-colored fallback.
struct SocialLoginButton: View {
    let provider: SocialProvider
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Group {
                if UIImage(named: provider.assetName) != nil {
                    Image(provider.assetName)
                        .resizable()
                        .scaledToFit()
                } else {
                    fallback
                }
            }
            .frame(width: Spacing.s64, height: Spacing.s64)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(provider.rawValue) 로그인")
    }

    @ViewBuilder private var fallback: some View {
        switch provider {
        case .google:
            ZStack {
                Circle().fill(Color.Semantic.Shape.white)
                    .overlay(Circle().strokeBorder(Color.Semantic.Border.button, lineWidth: 1))
                Text("G")
                    .textStyle(.display1)
                    .foregroundStyle(Color(hex: 0x4285F4)) // ds-allow: Google 브랜드 색 (토큰 대상 아님)
            }
        case .kakao:
            ZStack {
                Circle().fill(Color(hex: 0xFEE500)) // ds-allow: KakaoTalk 브랜드 색 (토큰 대상 아님)
                DSIcon("ic_bubble", size: Spacing.s28, color: Color.Semantic.Shape.black)
            }
        case .naver:
            ZStack {
                Circle().fill(Color(hex: 0x03C75A)) // ds-allow: Naver 브랜드 색 (토큰 대상 아님)
                Text("N")
                    .textStyle(.display1)
                    .foregroundStyle(Color.Semantic.Txt.W.primary)
            }
        case .apple:
            ZStack {
                Circle().fill(Color.Semantic.Shape.black)
                Image(systemName: "applelogo")
                    .textStyle(.display1)
                    .foregroundStyle(Color.Semantic.Txt.W.primary)
            }
        }
    }
}

#Preview {
    HStack(spacing: Spacing.s16) {
        ForEach(SocialProvider.allCases, id: \.self) { provider in
            SocialLoginButton(provider: provider)
        }
    }
    .padding(Spacing.s20)
}
