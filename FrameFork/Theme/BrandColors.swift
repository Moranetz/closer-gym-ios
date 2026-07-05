import SwiftUI

/// Frame & Fork brand palette. Matches the web tokens in
/// closer-gym/src/app/globals.css verbatim — same chess.com-derived
/// dark palette. Where possible, prefer the asset-catalog references
/// (Color("BrandGreen") etc.) so dark/light mode hooks work.
extension Color {
    // Brand — `brandGreen`, `bgPage`, `bgPanel`, `bgRail` come from Assets.xcassets
    // via auto-generated symbols (ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES).
    static let brandGreenHover = Color(red: 0.612, green: 0.784, blue: 0.408)   // #9CC868
    static let brandGreenDeep  = Color(red: 0.443, green: 0.655, blue: 0.247)   // #71A73F — depth plate

    // Additional surfaces (not in asset catalog)
    static let bgBanner = Color(red: 0.129, green: 0.125, blue: 0.114)          // #21201D
    static let border        = Color(red: 0.106, green: 0.102, blue: 0.098)     // #1B1A19
    static let borderStrong  = Color(red: 0.239, green: 0.227, blue: 0.216)     // #3D3A37

    // Text
    static let textPrimary   = Color.white
    static let textSecondary = Color(red: 0.788, green: 0.784, blue: 0.773)     // #C9C8C5
    static let textMuted     = Color(red: 0.608, green: 0.596, blue: 0.576)     // #9B9893
    static let textFaint     = Color(red: 0.435, green: 0.427, blue: 0.416)     // #6F6D6A

    // Semantic
    static let danger    = Color(red: 0.643, green: 0.149, blue: 0.173)         // #A4262C
    // Text-weight danger: #A4262C measures ~2.1:1 on bgPage (WCAG AA needs 4.5:1) —
    // error copy set in it was near-illegible. Use `danger` for fills/borders only.
    static let dangerText = Color(red: 0.898, green: 0.282, blue: 0.302)        // #E5484D
    static let warning   = Color(red: 0.898, green: 0.647, blue: 0.039)         // #E5A50A
    static let info      = Color(red: 0.212, green: 0.573, blue: 0.906)         // #3692E7
    static let brilliant = Color(red: 0.106, green: 0.667, blue: 0.651)         // #1BAAA6

    // Title-badge tier colors
    static let badgeGM  = Color(red: 0.671, green: 0.420, blue: 0.180)          // #AB6B2E
    static let badgeIM  = Color(red: 0.788, green: 0.784, blue: 0.773)          // #C9C8C5
    static let badgeM   = Color(red: 0.898, green: 0.647, blue: 0.039)          // #E5A50A
    static let badgeExp = Color(red: 0.506, green: 0.714, blue: 0.298)          // #81B64C
    static let badgeLow = Color(red: 0.435, green: 0.427, blue: 0.416)          // #6F6D6A

    // Theme tints (puzzle theme accents — match THEME_COLORS in puzzles.ts)
    static let themeBudget       = Color(red: 0.898, green: 0.647, blue: 0.039)  // #E5A50A
    static let themeProcurement  = Color(red: 0.643, green: 0.149, blue: 0.173)  // #A4262C
    static let themeStall        = Color(red: 0.212, green: 0.573, blue: 0.906)  // #3692E7
    static let themeRenewal      = Color(red: 0.506, green: 0.714, blue: 0.298)  // #81B64C
    static let themeMulti        = Color(red: 0.671, green: 0.420, blue: 0.180)  // #AB6B2E
    static let themeEndgame      = Color(red: 0.106, green: 0.667, blue: 0.651)  // #1BAAA6
    static let themeColdOpen     = Color(red: 0.608, green: 0.420, blue: 0.647)  // #9B6BA5
    static let themeSalesAssist  = Color(red: 0.420, green: 0.498, blue: 0.647)  // #6B7FA5
    static let themeForecastCall = Color(red: 0.647, green: 0.565, blue: 0.357)  // #A5905B
}
