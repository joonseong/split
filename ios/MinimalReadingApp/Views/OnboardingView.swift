import SwiftUI

/// 03-1. 온보딩 — concept intro with a looping Lottie animation and caption.
/// (Figma node 5389:9357). The red placeholder in the design is the animation
/// area. Tap anywhere to continue.
struct OnboardingView: View {
    var onFinished: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: Spacing.s24) {
                LottieView(name: "onboarding")
                    .aspectRatio(393.0 / 310.0, contentMode: .fit)
                    .frame(maxWidth: .infinity)

                Text("미니멀리딩은 책 한 권을\n시리즈로 나누어 읽습니다.")
                    .textStyle(.display2)
                    .foregroundStyle(Color.Semantic.Txt.B.primary)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Semantic.Shape.white)
        .contentShape(Rectangle())
        .onTapGesture { onFinished() }
    }
}

#Preview {
    OnboardingView()
}
