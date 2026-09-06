import SwiftUI
import UIKit

/// Type ramp — chess.com-derived but using SF Pro Rounded for the Duolingo-style
/// heavier display. SF Pro is the iOS canonical sans-serif; rounded-heavy is the
/// closest free analog to Duolingo's Feather Bold.
enum AppFont {
    /// 36/heavy — hero numbers (rating, ELO)
    static let display    = Font.system(.largeTitle, design: .rounded).weight(.heavy)
    /// 28/heavy — section heroes
    static let titleXL    = Font.system(size: 28, weight: .heavy, design: .rounded)
    /// 22/heavy — drill prompt
    static let title      = Font.system(size: 22, weight: .heavy, design: .rounded)
    /// 20/bold — card titles
    static let titleSmall = Font.system(size: 20, weight: .bold, design: .rounded)
    /// 17/semibold — list rows, candidate text
    static let body       = Font.system(size: 17, weight: .semibold)
    /// 15/regular — body paragraphs
    static let bodySmall  = Font.system(size: 15, weight: .regular)
    /// 14/medium — metadata
    static let caption    = Font.system(size: 14, weight: .medium)
    /// 12/semibold uppercase — section labels
    static let microLabel = Font.system(size: 12, weight: .semibold)
    /// Tabular for ratings, deltas, timers — monospaced digits
    static let tabular    = Font.system(size: 16, weight: .bold, design: .rounded).monospacedDigit()
    static let tabularLg  = Font.system(size: 28, weight: .heavy, design: .rounded).monospacedDigit()
}

extension View {
    /// Section label: 12pt uppercase semibold, .textMuted, letter-spaced.
    func microLabel(_ color: Color = .textLabel) -> some View {
        // Scaled like every other converted font — a fixed 12pt section label under
        // ~19pt scaled captions inverted the hierarchy for large-text users.
        self.scaledFont(size: 12, weight: .semibold)
            .foregroundStyle(color)
            .textCase(.uppercase)
            .kerning(0.8)
    }
}

/// Dynamic Type support for the app's ~200 hand-tuned `.font(.system(size:))`
/// call sites. Point sizes stay as the design baseline; `ScaledFont` runs them
/// through `UIFontMetrics` so they grow/shrink with the user's text-size
/// setting instead of being permanently fixed. Reads `\.sizeCategory` from the
/// environment so SwiftUI re-evaluates the body whenever the setting changes.
private struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) private var sizeCategory
    let size: CGFloat
    var weight: Font.Weight = .regular
    var design: Font.Design = .default

    func body(content: Content) -> some View {
        let traits = UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory(sizeCategory))
        let scaledSize = UIFontMetrics(forTextStyle: .body).scaledValue(for: size, compatibleWith: traits)
        content.font(.system(size: scaledSize, weight: weight, design: design))
    }
}

extension View {
    /// Drop-in replacement for `.font(.system(size:weight:design:))` that scales
    /// with the user's Dynamic Type setting. Chain `.monospacedDigit()` /
    /// `.kerning()` / `.textCase()` after it exactly as before.
    func scaledFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        modifier(ScaledFont(size: size, weight: weight, design: design))
    }
}

extension Text {
    /// `Text`-returning sibling of `View.scaledFont`, for the handful of call
    /// sites that build a sentence out of `Text(...) + Text(...)` — that
    /// operator requires `Text` on both sides, so the `some View` version
    /// above won't compile there. Callers supply their own `\.sizeCategory`
    /// since a free function can't read the environment on its own.
    func scaledFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default, sizeCategory: ContentSizeCategory) -> Text {
        let traits = UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory(sizeCategory))
        let scaledSize = UIFontMetrics(forTextStyle: .body).scaledValue(for: size, compatibleWith: traits)
        return self.font(.system(size: scaledSize, weight: weight, design: design))
    }
}
