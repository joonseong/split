import SwiftUI

// MARK: - Checkbox

/// A square checkbox. Brand fill + white check when on; bordered box when off.
struct DSCheckbox: View {
    @Binding var isOn: Bool

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            RoundedRectangle(cornerRadius: Radius.r8, style: .continuous)
                .fill(fill)
                .frame(width: Spacing.s24, height: Spacing.s24)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.r8, style: .continuous)
                        .strokeBorder(borderColor, lineWidth: 1)
                )
                .overlay {
                    if isOn {
                        Image(systemName: "checkmark")
                            .textStyle(.labelBold)
                            .foregroundStyle(Color.Semantic.Txt.W.primary)
                    }
                }
        }
        .buttonStyle(.plain)
    }

    private var fill: Color {
        if !isEnabled { return Color.Semantic.Shape.depth2 }
        return isOn ? Color.Semantic.Shape.brand : Color.Semantic.Shape.white
    }

    private var borderColor: Color {
        if isOn && isEnabled { return .clear }
        return Color.Semantic.Border.button
    }
}

// MARK: - Radio

/// A circular single-choice control. Brand ring + brand dot when selected.
struct DSRadio: View {
    @Binding var isSelected: Bool

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button {
            isSelected = true
        } label: {
            Circle()
                .fill(Color.Semantic.Shape.white)
                .frame(width: Spacing.s24, height: Spacing.s24)
                .overlay(Circle().strokeBorder(ringColor, lineWidth: isSelected ? 2 : 1))
                .overlay {
                    if isSelected {
                        Circle()
                            .fill(dotColor)
                            .frame(width: Spacing.s12, height: Spacing.s12)
                    }
                }
        }
        .buttonStyle(.plain)
    }

    private var ringColor: Color {
        if !isEnabled { return Color.Semantic.Border.button }
        return isSelected ? Color.Semantic.Border.brand : Color.Semantic.Border.button
    }

    private var dotColor: Color {
        isEnabled ? Color.Semantic.Shape.brand : Color.Semantic.Shape.iconLight
    }
}

// MARK: - Toggle

/// An on/off switch. Brand track when on; bordered track when off.
struct DSToggle: View {
    @Binding var isOn: Bool

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Capsule()
                .fill(track)
                .frame(width: Spacing.s44, height: Spacing.s24)
                .overlay(alignment: isOn ? .trailing : .leading) {
                    Circle()
                        .fill(Color.Semantic.Shape.white)
                        .frame(width: Spacing.s20, height: Spacing.s20)
                        .padding(Spacing.s2)
                }
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isOn)
    }

    private var track: Color {
        if !isEnabled { return Color.Semantic.Shape.depth2 }
        return isOn ? Color.Semantic.Shape.brand : Color.Semantic.Border.button
    }
}

// MARK: - Text Button

/// A low-emphasis, text-only button.
struct DSTextButton: View {
    let title: String
    var action: () -> Void = {}

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(.body2)
                .foregroundStyle(isEnabled ? Color.Semantic.Txt.B.secondary : Color.Semantic.Txt.B.placeholder)
                .padding(.horizontal, Spacing.s8)
                .padding(.vertical, Spacing.s4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.s20) {
        HStack(spacing: Spacing.s12) {
            DSCheckbox(isOn: .constant(false))
            DSCheckbox(isOn: .constant(true))
            DSCheckbox(isOn: .constant(false)).disabled(true)
        }
        HStack(spacing: Spacing.s12) {
            DSRadio(isSelected: .constant(false))
            DSRadio(isSelected: .constant(true))
            DSRadio(isSelected: .constant(false)).disabled(true)
        }
        HStack(spacing: Spacing.s12) {
            DSToggle(isOn: .constant(false))
            DSToggle(isOn: .constant(true))
            DSToggle(isOn: .constant(false)).disabled(true)
        }
        HStack(spacing: Spacing.s12) {
            DSTextButton(title: "Default")
            DSTextButton(title: "Disabled").disabled(true)
        }
    }
    .padding(Spacing.s20)
}
