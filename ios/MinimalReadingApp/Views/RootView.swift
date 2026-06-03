import SwiftUI

/// Top-level container for the authenticated app (home + bottom navigation).
struct RootView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    RootView()
        .environment(UserProfileStore())
        .environment(LibraryStore())
}
