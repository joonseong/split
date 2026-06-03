import SwiftUI

/// 03. 온보딩 — concept intro (Figma nodes 5389:9357 → 424:2459). The Lottie
/// animation (caption text baked in) plays once and stops on the last frame;
/// the "시작하기" button appears when it finishes.
struct OnboardingView: View {
    var onFinished: () -> Void = {}

    @State private var didFinishAnimation = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            LottieView(name: "onboarding", loop: false) {
                didFinishAnimation = true
            }
            .aspectRatio(393.0 / 310.0, contentMode: .fit)
            .frame(maxWidth: .infinity)
            Spacer()

            if didFinishAnimation {
                DSButton(title: "시작하기", size: .h56, style: .primary) { onFinished() }
                    .padding(.horizontal, Spacing.s16)
                    .padding(.top, Spacing.s8)
                    .padding(.bottom, Spacing.s16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Semantic.Shape.white)
        .animation(.easeInOut, value: didFinishAnimation)
    }
}

#Preview {
    OnboardingView()
}
