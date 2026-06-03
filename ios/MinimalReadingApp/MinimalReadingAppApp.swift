import SwiftUI

@main
struct MinimalReadingAppApp: App {
    @State private var store = LibraryStore()
    @State private var isAuthenticated = false

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                RootView()
                    .environment(store)
            } else {
                AuthCoordinator(onComplete: {
                    withAnimation(.easeInOut) { isAuthenticated = true }
                })
            }
        }
    }
}
