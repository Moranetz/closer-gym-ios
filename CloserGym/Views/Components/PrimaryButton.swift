import SwiftUI

/// Duolingo-style depth-plate primary button — a top face that translates +4pt
/// on press while the plate behind stays put. The single biggest "this feels
/// premium" detail in any drill app. Used for CHECK / CONTINUE / Solve / Next.
struct PrimaryButton: View {
    let title: String
    let symbol: String?
    let isEnabled: Bool
    let style: PrimaryButtonStyle
    let action: () -> Void

    @State private var isPressed = false

    enum PrimaryButtonStyle {
        case green, danger, warning

        var face: Color {
            switch self {
            case .green:   return .brandGreen
            case .danger:  return .danger
            case .warning: return .warning
            }
        }
        var plate: Color {
            switch self {
            case .green:   return .brandGreenDeep
            case .danger:  return Color(red: 0.541, green: 0.122, blue: 0.149) // darker red
            case .warning: return Color(red: 0.741, green: 0.490, blue: 0.000) // darker amber
            }
        }
    }

    var body: some View {
        Button(action: {
            guard isEnabled else { return }
            Haptics.shared.medium()
            action()
        }) {
            ZStack(alignment: .top) {
                // Depth plate
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isEnabled ? style.plate : Color.borderStrong)
                    .frame(height: 56)
                    .offset(y: 4)

                // Face
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isEnabled ? style.face : Color.borderStrong)
                    .frame(height: 52)
                    .overlay {
                        HStack(spacing: 8) {
                            if let symbol {
                                Image(systemName: symbol)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            Text(title)
                                .font(.system(size: 15, weight: .heavy, design: .rounded))
                                .kerning(0.4)
                                .textCase(.uppercase)
                        }
                        .foregroundStyle(isEnabled ? .white : Color.textFaint)
                    }
                    .offset(y: isPressed ? 4 : 0)
            }
            .frame(height: 56)
            .animation(.snappy(duration: 0.10, extraBounce: 0), value: isPressed)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .onLongPressGesture(minimumDuration: 0.01, maximumDistance: 50, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

/// Secondary outline button — used for "Skip" and tertiary actions.
struct SecondaryButton: View {
    let title: String
    let symbol: String?
    let action: () -> Void

    var body: some View {
        Button(action: {
            Haptics.shared.light()
            action()
        }) {
            HStack(spacing: 8) {
                if let symbol {
                    Image(systemName: symbol).font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .kerning(0.3)
            }
            .foregroundStyle(Color.textSecondary)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.bgPanel)
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.borderStrong, lineWidth: 1.5))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
