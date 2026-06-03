import SwiftUI

/// A trailing icon action for a header. `icon` is a design-system asset name.
struct DSHeaderAction: Identifiable {
    let id = UUID()
    let icon: String
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
                    DSIcon("ic_back")
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
                    DSIcon(action.icon)
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
            .init(icon: "ic_search"),
            .init(icon: "ic_notice")
        ])
        DSHeader(title: "Title", onBack: {}, actions: [.init(icon: "ic_close")])
        DSHeader(title: "Title", onBack: {})
        DSHeader(title: "001", onBack: {}, actions: [
            .init(icon: "ic_setting"),
            .init(icon: "ic_home_line")
        ])
    }
}
