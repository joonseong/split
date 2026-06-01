import SwiftUI

@main
struct MinimalReadingAppApp: App {
    @State private var store = LibraryStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
        }
    }
}
