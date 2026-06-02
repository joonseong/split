import SwiftUI

/// A trailing icon action for a header.
struct DSHeaderAction: Identifiable {
    let id = UUID()
    let systemImage: String
    var action: () -> Void = {}
}

/// A top app bar. Supports an optional back button, a title (left-aligned, e.g.
/// a logo/title) and a set of trailing icon actions.
struct DSHeader: View {
    var title: String?
    var onBack: (() -> Void)?
    var actions: [DSHeaderAction] = []

    var body: some View {
        HStack(spacing: Spacing.s16) {
            if let onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .textStyle(.title1)
                        .foregroundStyle(Color.Semantic.Shape.icon)
                }
                .buttonStyle(.plain)
            }

            if let title {
                Text(title)
                    .textStyle(.title1)
                    .foregroundStyle(Color.Semantic.Txt.B.primary)
                    .lineLimit(1)
            }

            Spacer(minLength: Spacing.s16)

            ForEach(actions) { action in
                Button(action: action.action) {
                    Image(systemName: action.systemImage)
                        .textStyle(.title1)
                        .foregroundStyle(Color.Semantic.Shape.icon)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.s16)
        .frame(height: Spacing.s56)
        .background(Color.Semantic.Shape.white)
    }
}

#Preview {
    VStack(spacing: 0) {
        DSHeader(title: "미니멀리딩", actions: [
            .init(systemImage: "magnifyingglass"),
            .init(systemImage: "bell")
        ])
        DSHeader(title: "Title", onBack: {}, actions: [.init(systemImage: "xmark")])
        DSHeader(title: "Title", onBack: {})
        DSHeader(title: "001", onBack: {}, actions: [
            .init(systemImage: "gearshape"),
            .init(systemImage: "house")
        ])
    }
}
