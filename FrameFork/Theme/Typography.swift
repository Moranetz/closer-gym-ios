import SwiftUI
import UIKit

/// Type ramp. Every step routes through `AppType`, so the family is decided in one place rather
/// than ten. The `.display` steps were `SF Pro Rounded`; that is now a fallback rather than a
/// choice, and the choice arrives in the next round.
///
/// These statics are NOT Dynamic Type aware and never were — they carry the design baseline size.
/// The scaled path is `.scaledFont(size:)`, which is what almost every call site uses.
/// THE FACE LAYER (round 173).
///
/// Her ruling of 2026-09-08: one typeface per app, chosen from what iOS already ships, because
/// every app in this fleet was set in SF Pro and the expressive choice in this one was SF Rounded
/// — 95 call sites of `design: .rounded`, which is the default expressive gesture of a SwiftUI app
/// built fast, and the reason these apps read as generated.
///
/// The face is not chosen here. This round only builds the place where it can be chosen: one
/// constant per role, resolved once, so the next round can put three candidates on the real screens
/// and she can pick from pictures. `nil` means the system face, so with both nil this file renders
/// exactly what shipped — proved by pixel diff, not asserted.
///
/// Sizes still run through `UIFontMetrics` before they reach a family, so a custom face keeps
/// Dynamic Type. That is the usual way this change quietly breaks an app.
enum AppType {
    /// Headlines, hero numbers, card titles. Was SF Rounded.
    ///
    /// `FF_DISPLAY_FACE=<PostScript name>` overrides it in DEBUG so candidates can be rendered on
    /// the real screens without a rebuild each time. A face iOS does not have falls back to system
    /// silently, which means the capture is also the proof that the family loaded.
    static let displayFamily: String? = {
        #if DEBUG
        if let f = CaptureHooks.value("FF_DISPLAY_FACE"), !f.isEmpty { return f }
        #endif
        return nil
    }()
    /// Everything a person reads in sentences. Stays system unless there is a reason.
    static let bodyFamily: String? = nil
    /// Ratings, deltas, timers.
    static let monoFamily: String? = nil

    /// What a piece of text is FOR. The old `design:` flag said what it looked like, which is why
    /// a face could never be swapped: the call site had already decided.
    enum Role { case display, body, mono }

    static func family(_ role: Role) -> String? {
        switch role {
        case .display: return displayFamily
        case .body:    return bodyFamily
        case .mono:    return monoFamily
        }
    }

    /// The one place a font is built. Everything else in the app routes here.
    static func font(role: Role, scaledSize: CGFloat, weight: Font.Weight) -> Font {
        if let family = family(role) {
            return .custom(family, size: scaledSize).weight(weight)
        }
        // No custom family: render exactly what shipped, including the rounded display design.
        let design: Font.Design = role == .display ? .rounded : (role == .mono ? .monospaced : .default)
        return .system(size: scaledSize, weight: weight, design: design)
    }

    /// Bridge for the call sites that still speak in `design:`. A design flag maps to the role it
    /// was standing in for, so 95 sites did not have to be edited to make the face swappable.
    static func role(for design: Font.Design) -> Role {
        switch design {
        case .rounded:    return .display
        case .monospaced: return .mono
        default:          return .body
        }
    }
}

enum AppFont {
    /// 36/heavy — hero numbers (rating, ELO)
    static let display    = AppType.font(role: .display, scaledSize: 34, weight: .heavy)
    /// 28/heavy — section heroes
    static let titleXL    = AppType.font(role: .display, scaledSize: 28, weight: .heavy)
    /// 22/heavy — drill prompt
    static let title      = AppType.font(role: .display, scaledSize: 22, weight: .heavy)
    /// 20/bold — card titles
    static let titleSmall = AppType.font(role: .display, scaledSize: 20, weight: .bold)
    /// 17/semibold — list rows, candidate text
    static let body       = AppType.font(role: .body, scaledSize: 17, weight: .semibold)
    /// 15/regular — body paragraphs
    static let bodySmall  = AppType.font(role: .body, scaledSize: 15, weight: .regular)
    /// 14/medium — metadata
    static let caption    = AppType.font(role: .body, scaledSize: 14, weight: .medium)
    /// 12/semibold uppercase — section labels
    static let microLabel = AppType.font(role: .body, scaledSize: 12, weight: .semibold)
    /// Tabular for ratings, deltas, timers — monospaced digits
    static let tabular    = AppType.font(role: .display, scaledSize: 16, weight: .bold).monospacedDigit()
    static let tabularLg  = AppType.font(role: .display, scaledSize: 28, weight: .heavy).monospacedDigit()
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
        content.font(AppType.font(role: AppType.role(for: design), scaledSize: scaledSize, weight: weight))
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
        return self.font(AppType.font(role: AppType.role(for: design), scaledSize: scaledSize, weight: weight))
    }
}
