import SwiftUI

/// Drives the pre-app flow: splash/login → nickname setup → done.
/// Login pushes the nickname screen; its back button returns to login; "다음"
/// completes auth and hands off to the main app.
struct AuthCoordinator: View {
    var onComplete: () -> Void = {}

    @State private var showNickname = false

    var body: some View {
        NavigationStack {
            AuthFlowView(onLogin: { showNickname = true })
                .navigationDestination(isPresented: $showNickname) {
                    NicknameView(onNext: onComplete)
                        .toolbar(.hidden, for: .navigationBar)
                }
        }
    }
}

#Preview {
    AuthCoordinator()
}
