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
    /// Fleet round 123 (2026-09-05): this measured APCA Lc 23.4 on the panel, an outright fail,
    /// and it is a text colour and only a text colour — 40 call sites, 0 fills. What it carries
    /// is real: the eval chart's axis labels (BUYER, You +3, Even 0), the move count, and the
    /// disclaimer naming the master-game transcripts as constructions in a speaker's voice.
    /// Raised to Lc 53.6. The ladder on this panel now reads body 70.5, label 63.7, this 53.6,
    /// muted 44.0. Despite the name it sits ABOVE muted, which is what its use already assumed:
    /// this tier carries small structural labels, where muted carries secondary content like an
    /// opponent's rating or a buyer's line. Those 73 muted sites are the next measured item.
    static let textFaint     = Color(red: 0.678, green: 0.667, blue: 0.647)     // #ADAAA5
    /// The ink for small-caps section labels, which is what `microLabel` sets by default.
    /// Fleet round 119 (2026-09-05): those labels used `textMuted` and measured APCA Lc 44.0 on
    /// the panel against body text at 70.5 — a 26-point gap, the widest in the fleet, on the type
    /// that names every card in the app. Glass House passes the same sweep with its labels 7
    /// points under its body, so this is set to the same relationship: Lc 63.7. Hierarchy is
    /// kept, and the hue is the same warm neutral as the tier it replaces.
    static let textLabel     = Color(red: 0.749, green: 0.737, blue: 0.718)     // #BFBCB7

    // Semantic
    static let danger    = Color(red: 0.643, green: 0.149, blue: 0.173)         // #A4262C
    // Text-weight danger. Use `danger` for fills and borders only: #A4262C measures ~2.1:1 on
    // bgPage and error copy set in it was near-illegible.
    //
    // That earlier pass fixed the ratio and stopped short of the reading. #E5484D measured APCA
    // Lc 33.0 on the live game's error banner — below the app's metadata tier of 42.1 and a third
    // of the 90.0 of the card sitting under it, so the line telling a player why the app just
    // refused to do anything was the faintest thing on the screen. Fleet round 139.
    //
    // #F2A6A8 holds the hue at 358 and the saturation at 75% and moves lightness only, landing at
    // Lc 62.0 on the banner, 60.4 on bgPanel and 62.4 on bgPage. Changing the token rather than
    // one call site is safe here BECAUSE those three grounds are within two points of each other,
    // which was measured rather than assumed — the same token in Squatch read 72.6 on cream and
    // 28.5 on green, and a blanket swap there would have broken a working screen.
    static let dangerText = Color(red: 0.949, green: 0.651, blue: 0.659)        // #F2A6A8
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
