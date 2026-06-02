import SwiftUI

/// Shared box chrome for input / select fields: fill, radius, and a state-driven
/// border (error > focused > default; no border when disabled).
private struct FieldContainer<Content: View>: View {
    var isFocused: Bool
    var isError: Bool
    var isEnabled: Bool
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(.horizontal, Spacing.s16)
            .frame(height: Spacing.s56)
            .background(isEnabled ? Color.Semantic.Shape.white : Color.Semantic.Shape.depth2)
            .clipShape(RoundedRectangle(cornerRadius: Radius.r8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.r8, style: .continuous)
                    .strokeBorder(border, lineWidth: isFocused ? 1.5 : 1)
            )
    }

    private var border: Color {
        if !isEnabled { return .clear }
        if isError { return Color.Semantic.Border.error }
        if isFocused { return Color.Semantic.Border.brand }
        return Color.Semantic.Border.button
    }
}

/// Inline placeholder that styles its text with the placeholder token.
private struct PlaceholderField: View {
    let placeholder: String
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .textStyle(.body1)
                    .foregroundStyle(Color.Semantic.Txt.B.placeholder)
            }
            TextField("", text: $text)
                .textStyle(.body1)
                .foregroundStyle(Color.Semantic.Txt.B.primary)
                .focused(isFocused)
        }
    }
}

// MARK: - Inputbox

/// A single-line text input with a clear button (shown while focused & filled)
/// and an optional error message below.
struct DSInputBox: View {
    @Binding var text: String
    var placeholder: String = ""
    var errorMessage: String?

    @FocusState private var focused: Bool
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            FieldContainer(isFocused: focused, isError: errorMessage != nil, isEnabled: isEnabled) {
                HStack(spacing: Spacing.s8) {
                    PlaceholderField(placeholder: placeholder, text: $text, isFocused: $focused)
                        .disabled(!isEnabled)

                    if focused && !text.isEmpty {
                        Button { text = "" } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.Semantic.Shape.iconLight)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            if let errorMessage {
                Text(errorMessage)
                    .textStyle(.caption1)
                    .foregroundStyle(Color.Semantic.Txt.error)
                    .padding(.horizontal, Spacing.s4)
            }
        }
    }
}

// MARK: - Chat Input

/// A pill-shaped chat composer with a trailing circular send button.
struct DSChatInput: View {
    @Binding var text: String
    var placeholder: String = ""
    var onSend: () -> Void = {}

    @FocusState private var focused: Bool
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        HStack(spacing: Spacing.s8) {
            PlaceholderField(placeholder: placeholder, text: $text, isFocused: $focused)
                .disabled(!isEnabled)

            Button(action: onSend) {
                Image(systemName: "arrow.up")
                    .textStyle(.title2)
                    .foregroundStyle(Color.Semantic.Txt.W.primary)
                    .frame(width: Spacing.s32, height: Spacing.s32)
                    .background(isEnabled ? Color.Semantic.Shape.brand : Color.Semantic.Shape.iconLight)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, Spacing.s16)
        .padding(.trailing, Spacing.s4)
        .frame(height: Spacing.s48)
        .background(isEnabled ? Color.Semantic.Shape.depth1 : Color.Semantic.Shape.depth2)
        .clipShape(Capsule())
    }
}

// MARK: - Select box

/// A tappable field that shows the current selection (or placeholder) and a
/// chevron that flips while expanded. Pair with a menu/sheet for the options.
struct DSSelectBox: View {
    var placeholder: String = ""
    @Binding var selection: String?
    @Binding var isExpanded: Bool
    var errorMessage: String?
    var onTap: () -> Void = {}

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            Button {
                isExpanded.toggle()
                onTap()
            } label: {
                FieldContainer(isFocused: isExpanded, isError: errorMessage != nil, isEnabled: isEnabled) {
                    HStack(spacing: Spacing.s8) {
                        Text(selection ?? placeholder)
                            .textStyle(.body1)
                            .foregroundStyle(selection == nil
                                ? Color.Semantic.Txt.B.placeholder
                                : Color.Semantic.Txt.B.primary)
                        Spacer(minLength: Spacing.s8)
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .textStyle(.body2)
                            .foregroundStyle(Color.Semantic.Shape.icon)
                    }
                }
            }
            .buttonStyle(.plain)

            if let errorMessage {
                Text(errorMessage)
                    .textStyle(.caption1)
                    .foregroundStyle(Color.Semantic.Txt.error)
                    .padding(.horizontal, Spacing.s4)
            }
        }
    }
}

#Preview {
    VStack(spacing: Spacing.s16) {
        DSInputBox(text: .constant(""), placeholder: "Placeholder")
        DSInputBox(text: .constant("Error"), placeholder: "", errorMessage: "Error message")
        DSChatInput(text: .constant(""), placeholder: "Placeholder")
        DSChatInput(text: .constant("Enter"), placeholder: "").disabled(true)
        DSSelectBox(placeholder: "Placeholder", selection: .constant(nil), isExpanded: .constant(false))
        DSSelectBox(placeholder: "", selection: .constant("Enter"), isExpanded: .constant(true))
    }
    .padding(Spacing.s20)
}
