import SwiftUI

/// 03-1. 온보딩 — concept intro (Figma node 5389:9357). The Lottie animation
/// already contains the caption text, so the screen is just the animation.
/// Tap anywhere to continue.
struct OnboardingView: View {
    var onFinished: () -> Void = {}

    var body: some View {
        VStack {
            Spacer()
            LottieView(name: "onboarding")
                .aspectRatio(393.0 / 310.0, contentMode: .fit)
                .frame(maxWidth: .infinity)
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
