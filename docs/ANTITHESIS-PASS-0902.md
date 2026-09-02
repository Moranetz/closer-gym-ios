# Antithesis pass — 2026-09-02

UI strings shaped "X, not Y" / "X. Not Y." / "X · not Y" (negated antithesis) rewritten as
positive statements. Every caveat and legal meaning kept — the transcript/master-game
disclaimers are legal accuracy (not verbatim, paraphrased-in-style) and still say the same
thing without the negation. `AIConsentSheet.swift` was not touched.

Scope note: the task's own reference count for this repo was 4 known hits. Grepping
`FrameFork/Views/` for the full shape turned up 5 genuine UI-copy hits — the 4 referenced
plus `Views/Puzzle/PuzzleSolveView.swift:324` ("Practice · not rated"), which matches the
"X · not Y" shape called out explicitly. All 5 are logged below. Only `FrameFork/Views/`
was in scope for this pass — every other hit found by the broader grep lives in
`FrameFork/Data/` (puzzle bank, master games, transcripts, personas, techniques), which is
data content, not UI copy, and was left untouched per instructions.

## Changes

### 1. `FrameFork/Views/Tabs/PlayTab.swift:143`
Before: `Sparring vs authored buyers works offline — no key, no account. For free-text play against all \(BotLadder.all.count) personas, connect your own Anthropic key in Settings; usage is billed by Anthropic, not by this app.`
After: `Sparring vs authored buyers works offline — no key, no account. For free-text play against all \(BotLadder.all.count) personas, connect your own Anthropic key in Settings; Anthropic bills that usage directly.`
(The UI test `SparringFlowUITests` anchors on the sibling header string "Bring your own key" — untouched — not on this body text.)

### 2. `FrameFork/Views/Tabs/WatchTab.swift:35`
Before: `Inspired-by-style constructions, not verbatim quotes.`
After: `Inspired-by-style constructions in the speaker's voice.`

### 3. `FrameFork/Views/Puzzle/TranscriptSheet.swift:61`
Before: `Paraphrased reconstruction. Not a verbatim recovered transcript. Sourced from the speaker's published teaching material plus widely-cited reconstructions.`
After: `These lines are reconstructed in the speaker's style from published material.`

### 4. `FrameFork/Views/Settings/SettingsView.swift:195`
Before: `Make role-play buyers argue your real objections, not a generic script.`
After: `Make role-play buyers argue your real objections.`

### 5. `FrameFork/Views/Puzzle/PuzzleSolveView.swift:324`
Before: `Practice · not rated` (the `else` branch of `Text(isDaily ? "Rating unchanged" : "Practice · not rated")`)
After: `Unrated practice`
Meaning preserved exactly (this re-solve does not move the rating); confirmed no test — unit
or UI — asserts on the literal string, only on the underlying `rated: Bool` (`RegressionTests.testReSolve_isUnrated`).

## Not touched
- `FrameFork/Views/Settings/AIConsentSheet.swift` — shipped today, deliberately excluded.
- `FrameFork/Data/*` — puzzle bank, master games, sparring arcs, transcripts, personas,
  techniques all contain this shape (it's part of the sales-negotiation vocabulary being
  taught, e.g. "close on the next conversation, not the sale"). Data content, not UI copy —
  out of scope per instructions.

## Gates
- Unit suite: `xcodebuild test -scheme FrameFork -destination 'id=2C6327A6-7918-4145-9143-308E1CC94926' -derivedDataPath /Users/marion/Library/Developer/Xcode/DerivedData/FrameFork-fleet -only-testing:FrameForkTests` — **44/44 passed**, 0 failures.
- Release build: `xcodebuild -scheme FrameFork -destination 'id=2C6327A6-7918-4145-9143-308E1CC94926' -derivedDataPath /Users/marion/Library/Developer/Xcode/DerivedData/FrameFork-fleet -configuration Release build` — **BUILD SUCCEEDED**.
