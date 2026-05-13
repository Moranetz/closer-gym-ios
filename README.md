# Closer Gym — iOS

> The gym for closers. What chess.com did to chess, for sales.

Native iOS port of [closer-gym](https://github.com/Moranetz/closer-gym). Free tier (daily puzzle, 20 hand-authored positions, master games) ships as a self-contained offline app. Pro tier (bot ladder + free-text play + call analysis) arrives in v0.2.

**Cluely is the cheat code. We built the gym.**

---

## What you can do (v0.1)

- **Puzzles** — Daily Drill (deterministic per-date) + 20 hand-authored positions across 7 themes (budget / procurement / stall / renewal / multi-stakeholder / endgame / cold open). Pick one of 4 candidate moves in 30 seconds; instant reveal with eval scores per candidate, atlas tags on the best move, ELO change via Glicko-2, streak counter.
- **Watch** — 5 annotated master games in the styles of Voss, Klaff, Belfort, Cardone (a deliberately-annotated LOSS), and Burg. Eval-curve chart, per-move technique tags, master's commentary pop-out under each operator move, sticky move-list sheet with click-to-jump.
- **Profile** — Three rating buckets (Game / Puzzle / Analysis), title progression (Patzer → Class D → … → Grandmaster Closer).
- **Play / Lessons** — Scaffolded for v0.2.

## Stack

- SwiftUI · iOS 17+ · Swift 5.10
- Xcode 26.4 / xcodegen 2.45 (project regenerated from `project.yml`)
- Pure offline persistence (`UserDefaults` + JSON-encoded `PuzzleState`)
- Core Haptics for the multisensory reveal (success / error / streak-milestone AHAP)
- Zero third-party dependencies

## Run locally

```bash
xcodegen                          # regenerate CloserGym.xcodeproj from project.yml
open CloserGym.xcodeproj          # opens in Xcode 26.4+
# Build + run target: CloserGym → iPhone 17 Pro
```

Or via CLI:

```bash
xcodebuild -project CloserGym.xcodeproj -scheme CloserGym \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug build
```

## App Store readiness

```bash
./scripts/preflight_check.sh      # 8-point check: bundle ID, team, versions,
                                  # encryption flag, privacy manifest, icon,
                                  # color sets, build success.
```

When all green:

```bash
bundle exec fastlane release      # creates ASC record (if missing) + builds +
                                  # uploads to TestFlight.
```

`Fastfile` uses manual signing via `ExportOptions.plist`. Team `Q242KWQD56`, bundle `com.melmarion.CloserGym`, profile `com.melmarion.CloserGym AppStore`.

## Architecture

```
CloserGym/
├── App/
│   ├── CloserGymApp.swift          # @main + tint(.brandGreen) + .preferredColorScheme(.dark)
│   └── RootTabView.swift           # 5-tab TabView (chess.com IA)
├── Theme/
│   ├── BrandColors.swift           # color extensions — chess.com palette
│   ├── Typography.swift            # type ramp (rounded-heavy SF Pro approximating Duolingo Feather)
│   └── Haptics.swift               # selection / light / medium / success / error / streakMilestone AHAP
├── Models/
│   ├── Technique.swift             # Atlas taxonomy types
│   ├── Persona.swift               # buyer persona schema
│   ├── Puzzle.swift                # single-position drill schema
│   ├── MasterGame.swift            # annotated game schema + MoveQuality + classifyMove
│   └── EloBand.swift               # Patzer → GM Closer band table
├── Engine/
│   ├── Glicko2.swift               # full Glickman 2013 Glicko-2 port from web
│   ├── Eval.swift                  # opening detector + running eval curve
│   └── Storage.swift               # UserDefaults-backed persistence + recordSolve()
├── Data/
│   ├── Techniques.swift            # 35 Atlas techniques (verbatim from web)
│   ├── Personas.swift              # 15 persona id → role label
│   ├── Puzzles.swift               # 20 hand-authored positions
│   └── MasterGames.swift           # 5 annotated master games
└── Views/
    ├── Tabs/
    │   ├── PlayTab.swift           # Pro tier placeholder
    │   ├── PuzzlesTab.swift        # Daily Drill hero + 7 themes + 20 rows
    │   ├── LessonsTab.swift        # v0.2 scaffold
    │   ├── WatchTab.swift          # Master Games index
    │   └── ProfileTab.swift        # rating buckets + free/Pro
    ├── Puzzle/
    │   ├── PuzzleSolveView.swift   # Position card + 4 candidates + 30s timer + reveal
    │   └── PuzzleCandidateButton.swift  # Duolingo-style depth-plate button
    ├── MasterGame/
    │   ├── MasterGameViewer.swift  # transcript + eval curve + move sheet
    │   └── EvalCurveView.swift     # SwiftUI Path-based eval curve
    └── Components/
        ├── TitleBadge.swift        # tier-colored pill (Patzer / Class D / … / GM)
        └── PrimaryButton.swift     # Duolingo depth-plate primary CTA
```

## Honest limits · v0.1

- **No real App Icon yet.** A 1024×1024 PNG belongs in `Assets.xcassets/AppIcon.appiconset/` before App Store submit. Preflight will warn.
- **Eval function v1 is heuristic** — same Atlas-literature-calibrated heuristic as the web. Not a learned policy.
- **Local persistence only.** No iCloud sync; resetting the app resets your rating + streak.
- **Pro tier deferred.** Live LLM bot ladder + free-text play arrives in v0.2 once a Settings screen for API key entry ships.

## License

MIT — see `LICENSE`.
