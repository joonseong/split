import SwiftUI

private enum AuthRoute: Hashable {
    case nickname
    case genre(nickname: String)
}

/// Drives the pre-app flow: splash/login → nickname → genre selection → done.
/// Each screen's back button pops to the previous one (genre → nickname →
/// login). Completion hands the nickname + chosen genres to the app.
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
                            onComplete(nickname, genres)
                        })
                        .toolbar(.hidden, for: .navigationBar)
                    }
                }
        }
    }
}

#Preview {
    AuthCoordinator()
}
