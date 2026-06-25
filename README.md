# Frame & Fork — iOS

> A sparring app for closers. What chess.com did to chess, for sales.

Native iOS port of [closer-gym](https://github.com/Moranetz/closer-gym). Free tier (daily puzzle, 100 hand-authored positions, master games, lessons) ships as a self-contained offline app. Pro tier (bot ladder + free-text play + post-game review) requires a user-supplied Anthropic API key.

**Cluely is the cheat code. We built the gym.**

---

## What you can do

- **Puzzles** — Daily Drill (deterministic per-date) + 100 hand-authored positions across 7 themes (budget / procurement / stall / renewal / multi-stakeholder / endgame / cold open). Pick one of 4 candidate moves; instant reveal with eval scores per candidate, atlas tags on the best move, ELO change via Glicko-2, streak counter.
- **Lessons** — 40-technique Atlas browser. Each lesson lists examples, contraindications, and the responsive-persona pattern.
- **Watch** — 5 annotated master games in the styles of Voss, Klaff, Belfort, Cardone (a deliberately-annotated LOSS), and Burg. Eval-curve chart, per-move technique tags, sticky move-list sheet.
- **Play (Pro)** — 14-persona bot ladder (ELO 1200–2400). Free-text live sparring with on-turn local Atlas detector, eval bar, end-of-game Glicko-2 rating update + intent-vs-fired ledger.
- **Profile** — Three rating buckets (Game / Puzzle / Analysis), title progression (Patzer → Class D → … → Grandmaster Closer), shareable card.

## Stack

- SwiftUI · iOS 17+ · Swift 5.10
- Xcode 26.4 / xcodegen 2.45 (project regenerated from `project.yml`)
- Pure offline persistence for the free tier (`UserDefaults` + JSON-encoded state)
- Core Haptics for the multisensory reveal
- Anthropic Messages API for the Pro bot ladder (user-supplied key, stored in Keychain)
- Zero third-party SDK dependencies

## Run locally

```bash
xcodegen                          # regenerate Frame & Fork.xcodeproj from project.yml
open Frame & Fork.xcodeproj             # opens in Xcode 26.4+
# Build + run target: Frame & Fork → iPhone 17 Pro
```

Or via CLI:

```bash
xcodebuild -project Frame & Fork.xcodeproj -scheme Frame & Fork \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug build
```

## App Store readiness

```bash
./scripts/preflight_check.sh      # bundle ID, team, versions, encryption
                                  # flag, privacy manifest, icon, color sets,
                                  # build success.
```

When all green:

```bash
bundle exec fastlane release      # builds + uploads to TestFlight; the
                                  # Submit-For-Review click happens in the
                                  # ASC web UI.
```

`Fastfile` uses manual signing via `ExportOptions.plist`. Team `Q242KWQD56`, bundle `com.moranetz.Frame & Fork`, profile `com.moranetz.Frame & Fork AppStore`.

## Architecture

```
Frame & Fork/
├── App/
│   ├── Frame & ForkApp.swift             # @main + tint(.brandGreen) + .preferredColorScheme(.dark)
│   └── RootTabView.swift           # 5-tab TabView (chess.com IA)
├── Theme/
│   ├── BrandColors.swift           # chess.com palette
│   ├── Typography.swift            # rounded-heavy SF Pro
│   └── Haptics.swift               # selection / light / medium / success / error / streakMilestone AHAP
├── Models/
│   ├── Technique.swift             # Atlas taxonomy types
│   ├── Persona.swift               # buyer persona schema
│   ├── Puzzle.swift                # single-position drill schema
│   ├── MasterGame.swift            # annotated game schema
│   └── EloBand.swift               # Patzer → GM Closer band table
├── Engine/
│   ├── Glicko2.swift               # Glickman 2013 Glicko-2 port
│   ├── Eval.swift                  # opening detector + running eval curve
│   ├── DetectorLocal.swift         # 19-rule NSRegularExpression Atlas detector
│   ├── AnthropicClient.swift       # URLSession Messages API client
│   ├── Keychain.swift              # API key storage
│   ├── Notifications.swift         # daily-drill scheduler
│   └── Storage.swift               # UserDefaults-backed persistence
├── Data/
│   ├── Techniques.swift            # 40 Atlas techniques
│   ├── Personas.swift              # 14 personas + BotLadder ELO map
│   ├── Puzzles.swift               # 100 hand-authored positions
│   ├── Transcripts.swift           # 13 sourced practitioner transcripts
│   └── MasterGames.swift           # 5 annotated master games
└── Views/
    ├── Tabs/                       # Play / Puzzles / Lessons / Watch / Profile
    ├── Play/                       # PreGameView, LiveGameView, SimpleReviewView
    ├── Puzzle/                     # PuzzleSolveView, candidate button, transcript sheet
    ├── MasterGame/                 # MasterGameViewer, eval curve
    ├── Settings/                   # API key entry, notifications, data reset
    ├── Onboarding/                 # 3-screen first-launch flow
    ├── Profile/                    # ShareCard
    └── Components/                 # TitleBadge, PrimaryButton, FlowLayout
```

## License

MIT — see `LICENSE`.
