import SwiftUI

@main
struct MinimalReadingAppApp: App {
    @State private var store = LibraryStore()
    @State private var isActive = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isActive {
                    RootView()
                        .environment(store)
                } else {
                    SplashView()
                        .task {
                            try? await Task.sleep(for: .seconds(1.6))
                            withAnimation(.easeInOut) { isActive = true }
                        }
                }
            }
        }
    }
}
