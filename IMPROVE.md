# ux-audit — closer-gym-ios
Kind: **ios+web**  ·  Swift files: 42  ·  Web files: 3  ·  LoC: 8,073

Findings: 0 BLOCKER · 0 HIGH · 3 MEDIUM · 2 LOW

## Findings

- **[MEDIUM] TYPE-RAMP**: Type ramp sprawl — 17 distinct font sizes
  Doc 10 prescribes 3–4 tier ramp (e.g. 13/15/17/22 or 11/13/17/96). Sprawl reads as un-designed. Consolidate to a Typography.swift token set.
  - size 13: FrameFork/Views/Tabs/PlayTab.swift:40
  - size 11: FrameFork/Views/Tabs/PlayTab.swift:53
  - size 12: FrameFork/Views/Tabs/PlayTab.swift:102
  - size 14: FrameFork/Views/Tabs/PlayTab.swift:126
  - size 10: FrameFork/Views/Tabs/PlayTab.swift:134 (+1 more)
  Reference: UX/10_TYPOGRAPHY_DAILY_USE

- **[MEDIUM] VIBE-2**: Color flood — 3 file(s) with 6+ distinct hex literals
  Pinterest-tutorial card kit. Color should be a thin hairline accent, not a flood. Move palette to one Colors.swift / tokens.css file.
  - docs/index.html (8 distinct hex colors)
  - docs/support.html (8 distinct hex colors)
  - docs/privacy.html (7 distinct hex colors)
  Reference: UX/1_DESIGN_SYSTEM_PROMPT §1 + §11 + UX/8_BIOPHILIA

- **[MEDIUM] VIBE-3**: Marketing-scale headlines in app surfaces (8)
  30pt+ headlines belong on landing pages, not in-app screens. Drop straight into content.
  - FrameFork/Views/Tabs/ProfileTab.swift:61 (size 48)
  - FrameFork/Views/Profile/ShareCard.swift:32 (size 56)
  - FrameFork/Views/Profile/ShareCard.swift:59 (size 36)
  - FrameFork/Views/Profile/ShareCard.swift:107 (size 56)
  - FrameFork/Views/Onboarding/OnboardingView.swift:149 (size 32) (+3 more)
  Reference: UX/10_TYPOGRAPHY_DAILY_USE

- **[LOW] VIBE-4**: Monospace+caps treatment in 6 file(s)
  Design-system tic. Use one kicker per screen max. Replace remaining instances with sentence-case body.
  - FrameFork/Theme/Typography.swift
  - FrameFork/Views/Tabs/WatchTab.swift
  - FrameFork/Views/Tabs/LessonsTab.swift
  - FrameFork/Views/Tabs/LessonDetailView.swift
  - FrameFork/Views/Tabs/PuzzlesTab.swift (+1 more)
  Reference: UX/vibecoded_ui_smell_test §4

- **[LOW] VIBE-7**: SwiftUI Lego stack signal — generic chrome density
  NavigationLink + ultraThinMaterial + RoundedRectangle.stroke + chevron + Capsule.fill stacked = vibecoded. Commit to a register (Criterion / NYT Mag / Vanity Fair / Pitchfork) and lean.
  - FrameFork/Views/Tabs/LessonDetailView.swift (signal density 10)
  - FrameFork/Views/Tabs/PuzzlesTab.swift (signal density 7)
  - FrameFork/Views/Settings/SettingsView.swift (signal density 7)
  - FrameFork/Views/MasterGame/MasterGameViewer.swift (signal density 6)
  - FrameFork/Views/Play/PreGameView.swift (signal density 6)
  Reference: UX/vibecoded_ui_smell_test §7
