import SwiftUI

#if canImport(Lottie)
import Lottie

/// Plays a bundled Lottie JSON animation. When `loop` is false it plays once and
/// stays on the last frame, calling `onComplete` when finished.
struct LottieView: UIViewRepresentable {
    let name: String
    var loop: Bool = true
    var onComplete: (() -> Void)?

    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: name)
        view.loopMode = loop ? .loop : .playOnce
        view.contentMode = .scaleAspectFit
        view.backgroundBehavior = .pauseAndRestore
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.play { finished in
            if finished { onComplete?() }
        }
        return view
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
#else

/// Fallback shown until the `lottie-ios` Swift Package is added to the project
/// (File → Add Package Dependencies → https://github.com/airbnb/lottie-ios).
struct LottieView: View {
    let name: String
    var loop: Bool = true
    var onComplete: (() -> Void)?

    var body: some View {
        ZStack {
            Color.Semantic.Shape.depth2
            Text("Lottie: \(name)\nlottie-ios 패키지를 추가하면 재생됩니다")
                .textStyle(.caption1)
                .foregroundStyle(Color.Semantic.Txt.B.tertiary)
                .multilineTextAlignment(.center)
                .padding(Spacing.s16)
        }
        .task {
            guard !loop else { return }
            try? await Task.sleep(for: .seconds(1.5))
            onComplete?()
        }
    }
}
#endif
