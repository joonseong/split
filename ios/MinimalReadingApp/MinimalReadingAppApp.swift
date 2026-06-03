import SwiftUI

@main
struct MinimalReadingAppApp: App {
    @State private var store = LibraryStore()
    @State private var profile = UserProfileStore()
    @State private var isAuthenticated = false

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                RootView()
                    .environment(store)
                    .environment(profile)
            } else {
                AuthCoordinator(onComplete: { nickname, genres in
                    profile.complete(nickname: nickname, genres: genres)
                    withAnimation(.easeInOut) { isAuthenticated = true }
                })
            }
        }
    }
}
