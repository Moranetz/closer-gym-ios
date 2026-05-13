import SwiftUI

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
    func microLabel(_ color: Color = .textMuted) -> some View {
        self.font(AppFont.microLabel)
            .foregroundStyle(color)
            .textCase(.uppercase)
            .kerning(0.8)
    }
}
