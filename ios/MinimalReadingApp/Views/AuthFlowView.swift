import SwiftUI

private enum AuthPhase { case splash, login }

/// Splash → Login flow. The brand wordmark and tagline are shared elements that
/// animate from the centered splash (brand background, white text) to their
/// login positions (white background, green logo / gray tagline) — moving up
/// while their colors morph. Social buttons and the footer fade in on arrival.
struct AuthFlowView: View {
    /// Called when the user taps a social login button.
    var onLogin: () -> Void = {}

    @State private var phase: AuthPhase = .splash

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let isLogin = phase == .login

            ZStack {
                // Background morph: green -> white.
                Color.Semantic.Shape.brand.ignoresSafeArea()
                Color.Semantic.Shape.white.ignoresSafeArea()
                    .opacity(isLogin ? 1 : 0)

                // Login-only content, fades in on arrival.
                socialRow
                    .position(x: w / 2, y: h * 0.783)
                    .opacity(isLogin ? 1 : 0)

                footer
                    .position(x: w / 2, y: h * 0.914)
                    .opacity(isLogin ? 1 : 0)

                // Shared element: wordmark + tagline.
                VStack(spacing: Spacing.s16) {
                    wordmark(isLogin: isLogin)
                    Text("최소한의 읽기로 기르는 독서습관")
                        .textStyle(.title1)
                        .foregroundStyle(isLogin
                            ? Color.Semantic.Txt.B.secondary
                            : Color.Semantic.Txt.W.primary)
                }
                .position(x: w / 2, y: isLogin ? h * 0.263 : h / 2)
            }
            .task {
                try? await Task.sleep(for: .seconds(1.2))
                withAnimation(.easeInOut(duration: 0.7)) { phase = .login }
            }
        }
    }

    // Crossfade two tinted copies so the logo color morphs smoothly.
    private func wordmark(isLogin: Bool) -> some View {
        ZStack {
            logoImage(Color.Semantic.Txt.W.primary).opacity(isLogin ? 0 : 1)
            logoImage(Color.Semantic.Shape.brand).opacity(isLogin ? 1 : 0)
        }
    }

    private func logoImage(_ color: Color) -> some View {
        Image("LogoMinimalReading")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 258, height: 46)
            .foregroundStyle(color)
    }

    private var socialRow: some View {
        HStack(spacing: Spacing.s16) {
            ForEach(SocialProvider.allCases, id: \.self) { provider in
                SocialLoginButton(provider: provider) { onLogin() }
            }
        }
    }

    private var footer: some View {
        Text("ⓒ MinimalReading Corp.")
            .textStyle(.body2)
            .foregroundStyle(Color.Semantic.Txt.B.tertiary)
    }
}

#Preview {
    AuthFlowView()
}
