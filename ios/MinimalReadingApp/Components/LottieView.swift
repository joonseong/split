import SwiftUI

#if canImport(Lottie)
import Lottie

/// Plays a bundled Lottie JSON animation (looping). Backed by lottie-ios.
struct LottieView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: name)
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.backgroundBehavior = .pauseAndRestore
        view.play()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
#else

/// Fallback shown until the `lottie-ios` Swift Package is added to the project
/// (File → Add Package Dependencies → https://github.com/airbnb/lottie-ios).
struct LottieView: View {
    let name: String

    var body: some View {
        ZStack {
            Color.Semantic.Shape.depth2
            Text("Lottie: \(name)\nlottie-ios 패키지를 추가하면 재생됩니다")
                .textStyle(.caption1)
                .foregroundStyle(Color.Semantic.Txt.B.tertiary)
                .multilineTextAlignment(.center)
                .padding(Spacing.s16)
        }
    }
}
#endif
