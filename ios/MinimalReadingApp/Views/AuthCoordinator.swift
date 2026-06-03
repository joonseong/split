import SwiftUI

private enum AuthRoute: Hashable {
    case nickname
    case genre(nickname: String)
    case onboarding(nickname: String, genres: [Genre])
}

/// Drives the pre-app flow: splash/login → nickname → genre selection →
/// onboarding → done. Each screen's back button pops to the previous one.
/// Completion hands the nickname + chosen genres to the app.
struct AuthCoordinator: View {
    var onComplete: (String, [Genre]) -> Void = { _, _ in }

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            AuthFlowView(onLogin: { path.append(AuthRoute.nickname) })
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .nickname:
                        NicknameView(onNext: { nickname in
                            path.append(AuthRoute.genre(nickname: nickname))
                        })
                        .toolbar(.hidden, for: .navigationBar)
                    case .genre(let nickname):
                        GenreSelectionView(nickname: nickname, onComplete: { genres in
                            path.append(AuthRoute.onboarding(nickname: nickname, genres: genres))
                        })
                        .toolbar(.hidden, for: .navigationBar)
                    case .onboarding(let nickname, let genres):
                        OnboardingView(onFinished: { onComplete(nickname, genres) })
                            .toolbar(.hidden, for: .navigationBar)
                    }
                }
        }
    }
}

#Preview {
    AuthCoordinator()
}
