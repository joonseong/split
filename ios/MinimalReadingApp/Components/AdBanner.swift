import SwiftUI

/// Placeholder for the Google AdMob banner slot on the home screen.
///
/// NOTE: real ads require the Google Mobile Ads SDK plus a `GADApplicationIdentifier`
/// in Info.plist and an ad unit ID — adding the SDK without the app ID crashes at
/// launch, so this renders a styled placeholder until those are configured.
struct AdBanner: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radius.r8, style: .continuous)
                .fill(Color.Semantic.Shape.depth2)
            VStack(spacing: Spacing.s4) {
                Text("광고 영역")
                    .textStyle(.title2)
                    .foregroundStyle(Color.Semantic.Txt.B.tertiary)
                Text("Google AdMob 배너")
                    .textStyle(.caption1)
                    .foregroundStyle(Color.Semantic.Txt.B.tertiary)
            }
        }
        .frame(height: 113)
        .overlay(alignment: .topTrailing) {
            DSAdBadge().padding(Spacing.s8)
        }
        .padding(.horizontal, Spacing.s16)
    }
}

#Preview {
    AdBanner()
}
