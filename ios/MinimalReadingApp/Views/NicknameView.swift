import SwiftUI

/// 02-1. 닉네임 설정 — first screen after sign-up (Figma node 378:3191).
/// A default nickname is auto-generated ("형용사 명사"); the user can edit it
/// (max 16 chars). Back returns to the login screen.
struct NicknameView: View {
    var onNext: () -> Void = {}

    @Environment(\.dismiss) private var dismiss
    @State private var nickname = NicknameGenerator.random()

    private let maxLength = 16

    var body: some View {
        VStack(spacing: 0) {
            DSHeader(onBack: { dismiss() })

            VStack(alignment: .leading, spacing: Spacing.s32) {
                Text("미니멀리딩에서\n활동할 정보를 입력해주세요.")
                    .textStyle(.display1)
                    .foregroundStyle(Color.Semantic.Txt.B.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: Spacing.s24) {
                    avatar
                    nicknameField
                }
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s8)

            Spacer(minLength: 0)

            bottomBar
        }
        .background(Color.Semantic.Shape.white)
        .onChange(of: nickname) { _, value in
            if value.count > maxLength {
                nickname = String(value.prefix(maxLength))
            }
        }
    }

    // MARK: Avatar with edit badge

    private var avatar: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(Color.Semantic.Shape.brand.opacity(0.12))
                .frame(width: Spacing.s80, height: Spacing.s80)
                .overlay {
                    DSIcon("LogoM", size: Spacing.s40, color: Color.Semantic.Shape.brand)
                }

            ZStack {
                Circle()
                    .fill(Color.Semantic.Shape.black)
                    .frame(width: Spacing.s32, height: Spacing.s32)
                DSIcon("ic_edit", size: Spacing.s16, color: Color.Semantic.Txt.W.primary)
            }
        }
    }

    // MARK: Nickname field with counter

    private var nicknameField: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            HStack {
                Text("닉네임")
                    .textStyle(.body2)
                    .foregroundStyle(Color.Semantic.Txt.B.primary)
                Spacer()
                HStack(spacing: Spacing.s2) {
                    Text("\(nickname.count)")
                        .textStyle(.body2)
                        .foregroundStyle(Color.Semantic.Txt.B.primary)
                    Rectangle()
                        .fill(Color.Semantic.Shape.div)
                        .frame(width: 1, height: Spacing.s12)
                    Text("\(maxLength)")
                        .textStyle(.body2)
                        .foregroundStyle(Color.Semantic.Txt.B.tertiary)
                }
            }
            DSInputBox(text: $nickname, placeholder: "닉네임을 입력해주세요")
        }
    }

    // MARK: Bottom action

    private var bottomBar: some View {
        DSButton(title: "다음", size: .h56, style: .primary) { onNext() }
            .disabled(nickname.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s8)
            .padding(.bottom, Spacing.s16)
            .background(Color.Semantic.Shape.white)
    }
}

#Preview {
    NicknameView()
}
