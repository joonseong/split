import SwiftUI

/// Top-level navigation container for the app.
struct RootView: View {
    var body: some View {
        NavigationStack {
            LibraryView()
        }
    }
}

#Preview {
    RootView()
        .environment(LibraryStore())
}
