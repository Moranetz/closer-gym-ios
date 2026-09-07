import SwiftUI

/// Frame & Fork brand palette. Matches the web tokens in
/// closer-gym/src/app/globals.css verbatim — same chess.com-derived
/// dark palette. Where possible, prefer the asset-catalog references
/// (Color("BrandGreen") etc.) so dark/light mode hooks work.
extension Color {
    /// Round 155. `bgPage`, `bgPanel`, `bgRail` and `brandGreen` are generated from the asset
    /// catalog, so they cannot be redefined here without ambiguity. These four aliases carry the
    /// world instead, and every call site was moved onto them by a mechanical rename. Off a
    /// world they return the asset colour itself, so the shipped app is untouched.
    static var pageGround: Color { World.current.isWorld ? World.current.page : .bgPage }
    static var panelGround: Color { World.current.isWorld ? World.current.panel : .bgPanel }
    static var railGround: Color { World.current.isWorld ? World.current.rail : .bgRail }
    static var accentInk: Color { World.current.isWorld ? World.current.accent : .brandGreen }

    // Brand — `brandGreen`, `bgPage`, `bgPanel`, `bgRail` come from Assets.xcassets
    // via auto-generated symbols (ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES).
    static let darkBrandGreenHover = Color(red: 0.612, green: 0.784, blue: 0.408)   // #9CC868
    static let paperBrandGreenHover = Color(red: 0.322, green: 0.463, blue: 0.157)   // #527628, Lc 67.3 on the card
    static var brandGreenHover: Color { World.current.isWorld ? paperBrandGreenHover : darkBrandGreenHover }
    static let darkBrandGreenDeep = Color(red: 0.443, green: 0.655, blue: 0.247)   // #71A73F — depth plate
    static let paperBrandGreenDeep = Color(red: 0.310, green: 0.467, blue: 0.165)   // #4F772A, Lc 67.1 on the card
    static var brandGreenDeep: Color { World.current.isWorld ? paperBrandGreenDeep : darkBrandGreenDeep }

    // Additional surfaces (not in asset catalog)
    static let darkBgBanner = Color(red: 0.129, green: 0.125, blue: 0.114)      // #21201D
    static var bgBanner: Color { World.current.isWorld ? World.current.rail : darkBgBanner }
    static let darkBorder        = Color(red: 0.106, green: 0.102, blue: 0.098) // #1B1A19
    static var border: Color { World.current.isWorld ? World.current.border : darkBorder }
    static let darkBorderStrong  = Color(red: 0.239, green: 0.227, blue: 0.216) // #3D3A37
    static var borderStrong: Color { World.current.isWorld ? World.current.border : darkBorderStrong }

    // Text
    static let darkTextPrimary   = Color.white
    /// Round 155: the ink tiers go through the world. `World.shipped` returns the dark values
    /// below unchanged, so the shipped app is pixel-identical; a world gets its own ink
    /// everywhere at once instead of one file at a time.
    static var textPrimary: Color { World.current.isWorld ? World.current.ink : darkTextPrimary }
    static let darkTextSecondary = Color(red: 0.788, green: 0.784, blue: 0.773) // #C9C8C5
    static var textSecondary: Color { World.current.isWorld ? World.current.inkSecondary : darkTextSecondary }
    static let darkTextMuted     = Color(red: 0.608, green: 0.596, blue: 0.576) // #9B9893
    static var textMuted: Color { World.current.isWorld ? World.current.inkMuted : darkTextMuted }
    /// Fleet round 123 (2026-09-05): this measured APCA Lc 23.4 on the panel, an outright fail,
    /// and it is a text colour and only a text colour — 40 call sites, 0 fills. What it carries
    /// is real: the eval chart's axis labels (BUYER, You +3, Even 0), the move count, and the
    /// disclaimer naming the master-game transcripts as constructions in a speaker's voice.
    /// Raised to Lc 53.6. The ladder on this panel now reads body 70.5, label 63.7, this 53.6,
    /// muted 44.0. Despite the name it sits ABOVE muted, which is what its use already assumed:
    /// this tier carries small structural labels, where muted carries secondary content like an
    /// opponent's rating or a buyer's line. Those 73 muted sites are the next measured item.
    static let darkTextFaint     = Color(red: 0.678, green: 0.667, blue: 0.647) // #ADAAA5
    static var textFaint: Color { World.current.isWorld ? World.current.inkFaint : darkTextFaint }
    /// The ink for small-caps section labels, which is what `microLabel` sets by default.
    /// Fleet round 119 (2026-09-05): those labels used `textMuted` and measured APCA Lc 44.0 on
    /// the panel against body text at 70.5 — a 26-point gap, the widest in the fleet, on the type
    /// that names every card in the app. Glass House passes the same sweep with its labels 7
    /// points under its body, so this is set to the same relationship: Lc 63.7. Hierarchy is
    /// kept, and the hue is the same warm neutral as the tier it replaces.
    static let darkTextLabel     = Color(red: 0.749, green: 0.737, blue: 0.718) // #BFBCB7
    static var textLabel: Color { World.current.isWorld ? World.current.inkLabel : darkTextLabel }

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
    static let darkDangerText = Color(red: 0.949, green: 0.651, blue: 0.659)        // #F2A6A8
    static let paperDangerText = Color(red: 0.800, green: 0.098, blue: 0.118)   // #CC191E, Lc 67.2 on the card
    static var dangerText: Color { World.current.isWorld ? paperDangerText : darkDangerText }
    static let darkWarning = Color(red: 0.898, green: 0.647, blue: 0.039)         // #E5A50A
    static let paperWarning = Color(red: 0.553, green: 0.392, blue: 0.012)   // #8D6403, Lc 67.3 on the card
    static var warning: Color { World.current.isWorld ? paperWarning : darkWarning }
    static let darkInfo = Color(red: 0.212, green: 0.573, blue: 0.906)         // #3692E7
    static let paperInfo = Color(red: 0.071, green: 0.427, blue: 0.757)   // #126DC1, Lc 66.8 on the card
    static var info: Color { World.current.isWorld ? paperInfo : darkInfo }
    static let darkBrilliant = Color(red: 0.106, green: 0.667, blue: 0.651)         // #1BAAA6
    static let paperBrilliant = Color(red: 0.063, green: 0.471, blue: 0.459)   // #107875, Lc 67.1 on the card
    static var brilliant: Color { World.current.isWorld ? paperBrilliant : darkBrilliant }

    // Title-badge tier colors
    static let darkBadgeGM = Color(red: 0.671, green: 0.420, blue: 0.180)          // #AB6B2E
    static let paperBadgeGM = Color(red: 0.600, green: 0.369, blue: 0.149)   // #995E26, Lc 67.1 on the card
    static var badgeGM: Color { World.current.isWorld ? paperBadgeGM : darkBadgeGM }
    static let darkBadgeIM = Color(red: 0.788, green: 0.784, blue: 0.773)          // #C9C8C5
    static let paperBadgeIM = Color(red: 0.435, green: 0.427, blue: 0.404)   // #6F6D67, Lc 66.8 on the card
    static var badgeIM: Color { World.current.isWorld ? paperBadgeIM : darkBadgeIM }
    static let darkBadgeM = Color(red: 0.898, green: 0.647, blue: 0.039)          // #E5A50A
    static let paperBadgeM = Color(red: 0.553, green: 0.392, blue: 0.012)   // #8D6403, Lc 67.3 on the card
    static var badgeM: Color { World.current.isWorld ? paperBadgeM : darkBadgeM }
    static let darkBadgeExp = Color(red: 0.506, green: 0.714, blue: 0.298)          // #81B64C
    static let paperBadgeExp = Color(red: 0.325, green: 0.467, blue: 0.180)   // #53772E, Lc 66.8 on the card
    static var badgeExp: Color { World.current.isWorld ? paperBadgeExp : darkBadgeExp }
    static let badgeLow = Color(red: 0.435, green: 0.427, blue: 0.416)          // #6F6D6A

    // Theme tints (puzzle theme accents — match THEME_COLORS in puzzles.ts)
    static let darkThemeBudget = Color(red: 0.898, green: 0.647, blue: 0.039)  // #E5A50A
    static let paperThemeBudget = Color(red: 0.553, green: 0.392, blue: 0.012)   // #8D6403, Lc 67.3 on the card
    static var themeBudget: Color { World.current.isWorld ? paperThemeBudget : darkThemeBudget }
    static let themeProcurement  = Color(red: 0.643, green: 0.149, blue: 0.173)  // #A4262C
    static let darkThemeStall = Color(red: 0.212, green: 0.573, blue: 0.906)  // #3692E7
    static let paperThemeStall = Color(red: 0.071, green: 0.427, blue: 0.757)   // #126DC1, Lc 66.8 on the card
    static var themeStall: Color { World.current.isWorld ? paperThemeStall : darkThemeStall }
    static let darkThemeRenewal = Color(red: 0.506, green: 0.714, blue: 0.298)  // #81B64C
    static let paperThemeRenewal = Color(red: 0.325, green: 0.467, blue: 0.180)   // #53772E, Lc 66.8 on the card
    static var themeRenewal: Color { World.current.isWorld ? paperThemeRenewal : darkThemeRenewal }
    static let darkThemeMulti = Color(red: 0.671, green: 0.420, blue: 0.180)  // #AB6B2E
    static let paperThemeMulti = Color(red: 0.600, green: 0.369, blue: 0.149)   // #995E26, Lc 67.1 on the card
    static var themeMulti: Color { World.current.isWorld ? paperThemeMulti : darkThemeMulti }
    static let darkThemeEndgame = Color(red: 0.106, green: 0.667, blue: 0.651)  // #1BAAA6
    static let paperThemeEndgame = Color(red: 0.063, green: 0.471, blue: 0.459)   // #107875, Lc 67.1 on the card
    static var themeEndgame: Color { World.current.isWorld ? paperThemeEndgame : darkThemeEndgame }
    static let darkThemeColdOpen = Color(red: 0.608, green: 0.420, blue: 0.647)  // #9B6BA5
    static let paperThemeColdOpen = Color(red: 0.549, green: 0.349, blue: 0.588)   // #8C5996, Lc 67.2 on the card
    static var themeColdOpen: Color { World.current.isWorld ? paperThemeColdOpen : darkThemeColdOpen }
    static let darkThemeSalesAssist = Color(red: 0.420, green: 0.498, blue: 0.647)  // #6B7FA5
    static let paperThemeSalesAssist = Color(red: 0.345, green: 0.427, blue: 0.584)   // #586D95, Lc 67.0 on the card
    static var themeSalesAssist: Color { World.current.isWorld ? paperThemeSalesAssist : darkThemeSalesAssist }
    static let darkThemeForecastCall = Color(red: 0.647, green: 0.565, blue: 0.357)  // #A5905B
    static let paperThemeForecastCall = Color(red: 0.486, green: 0.420, blue: 0.259)   // #7C6B42, Lc 67.0 on the card
    static var themeForecastCall: Color { World.current.isWorld ? paperThemeForecastCall : darkThemeForecastCall }
}
