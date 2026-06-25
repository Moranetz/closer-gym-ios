# Frame & Fork — Bug-fix pass (2026-06-25)

Autonomous correctness pass. Five parallel read-only audits (navigation, persistence,
engine math, API client, data integrity) → fixes applied + verified. Build stays green
(`xcodebuild … iPhone 17 Pro`) after every change; the headline navigation fix was
verified interactively in the Simulator (solve → rating update → streak → Next advances).

No commits/pushes were made (per the autonomous-push policy) — review and commit at will.

---

## CRITICAL / HIGH — broken controls (the reported "buttons don't work")

1. **Puzzle "Next Puzzle" was a dead button.** `PuzzleSolveView.advanceToNext()` set
   `navigateTo`, wired to a `hiddenNavLink` that **was never added to the view tree** —
   and even if it had been, it used value-based `NavigationLink(value:)` with no matching
   `.navigationDestination(for: Puzzle.self)` registered. Fixed by making `puzzle`/`isDaily`
   `@State` and loading the next puzzle **in place** (reset reveal/timer/scroll-to-top). No
   growing back-stack. *Verified in Simulator.*

2. **Play "Done" dropped the user onto the dead finished game.** `SimpleReviewView`'s Done
   called `dismiss()`, which popped one level back to the terminal `LiveGameView`. Converted
   the whole Play flow (`PlayTab` → `PreGameView` → `LiveGameView` → `SimpleReviewView`) to
   value-based navigation (`PlayRoute` + `[PlayRoute]` path); Done now `path.removeAll()` →
   one clean pop to the bot ladder.

3. **Master-game "Next master game" force-unwrapped and stacked infinitely.**
   `MasterGameViewer` used `MasterGames.get(nextGameId)!` inside a `NavigationLink(destination:)`,
   pushing a new viewer every tap. Now loads the next game in place with a guarded unwrap.

4. **`LiveGameView` "End" could be tapped while awaiting / twice.** Added
   `.disabled(transcript.isEmpty || finishedScore != nil)` and a re-entrancy guard in `endGame`.

## CRITICAL / HIGH — data integrity & persistence

5. **Daily streak used UTC, not local time** (`Store.todayKey`). For any user west of UTC the
   "day" flipped mid-afternoon, corrupting one-daily-per-day, streaks, and the displayed date.
   `todayKey`/`yesterdayKey` now format `yyyy-MM-dd` in `TimeZone.current`.

6. **Daily drill could be re-rolled for a clean streak.** A wrong daily didn't stamp
   `lastDailyDate`, so a retry could reach the `+1` branch; a correct daily could later be
   zeroed by a re-entry. Now stamped on *both* outcomes + one-attempt-per-day, with a matching
   UI lock on the Daily hero card ("Done today · back tomorrow").

7. **Streak displayed stale between sessions.** `currentStreak` only refreshed at solve time, so
   a broken streak still showed its old value until the next solve. Added
   `Store.effectiveCurrentStreak` (0 unless the last daily was today/yesterday), reconciled on
   launch, and wired into every display site (Puzzles, Profile, Settings, share card).

8. **Corrupt/incompatible persisted JSON silently wiped all history.** `try?` decode → fresh
   state → overwritten on next save. Now backs up the raw bytes under a `:corrupt-backup` key
   and uses tolerant `decodeIfPresent` decoders on `PuzzleState`/`GameState` so an additive
   schema change can't erase a user's ratings/streak on update.

## MEDIUM — engine math hardening (latent NaN/crash paths)

9. **Glicko-2 could produce NaN/Inf.** Clamped `E()` away from {0,1} (so `vInverse` can't be 0
   → `v = +Inf`), guarded `v = 1/vInverse`, and capped the volatility bracket-expansion loop.
10. **Title lookup fell through on out-of-range ratings.** `titleForRating` now clamps to
    `[0, 9999]` and guards NaN, so a sub-zero (long loss streak; Glicko has no floor) or >9999
    rating still maps to a real band instead of defaulting to "Patzer".

## MEDIUM — Pro tier / API client

11. **Deprecated model id.** `claude-opus-4-5` → `claude-opus-4-8` (current Opus). *(Cost note:
    for high-volume enterprise reps, `claude-sonnet-4-6` is ~40% cheaper per game and an
    excellent buyer role-player — left as a product decision, see ENTERPRISE-ROADMAP.md.)*
12. **Raw JSON errors shown to users.** Anthropic error bodies are now parsed and mapped to
    actionable copy (401 → "re-enter your key", 429 → "rate limited", 529/5xx → "busy, retry").
13. **No retry / timeout.** Added a 45s request timeout + backoff retry (×3) on 429/5xx/network.
14. **Safety refusals masqueraded as a "…" reply.** A 200 with `stop_reason:"refusal"` (empty
    content) is now surfaced as a distinct error.
15. **Keychain save failures were silent.** `saveAPIKey` now returns success (`@discardableResult`).
    *(Kept the existing `com.melmarion.FrameFork` service string — changing it would orphan
    already-stored keys on upgrade.)*

## MEDIUM / LOW — content & links

16. **Dead privacy/support URLs (App Store pull risk).** Settings linked
    `moranetz.github.io/closer-gym-ios/…` (no such path) → fixed to the live
    `moranetz.github.io/apps/frame-fork/…`.
17. **Dangling `"contrast"` atlas tag on 5 puzzles** (p026/p048/p058/p064/p090) referenced a
    technique that didn't exist → added a proper, cited `contrast` (perceptual contrast) entry
    to the Atlas. Those puzzles now light up the lesson cross-link.
18. **Count copy mismatches.** App/README claimed 35 techniques / 15 personas; actual is
    39 / 14. Fixed in onboarding, Lessons, Play, Profile, source comments, and README — using
    live counts (`AtlasTechniques.all.count`, `BotLadder.all.count`) where possible so they
    can't drift again.
19. **Wrong master-game name in onboarding.** "Tracy" → "Burg" (the 5th game is Bob Burg).
20. **Latent crash guard.** Candidate letters were a hardcoded `["A","B","C","D"]` indexed by
    position; now derived from the index so a future >4-candidate puzzle can't crash.

## Folded-in staged fixes (from the May triage, never applied back)

- `Keychain` service string + `RootTabView` `FF_INITIAL_TAB` env hook — reviewed; the env hook
  is a screenshot helper (kept), the service-string rename was **not** applied (see #15).

## Known non-bugs / deferred (noted, not changed)

- `Eval.detectOpening` is dead code (defined, never called) — harmless; left in place.
- `solves`/`games` arrays grow unbounded — fine for now; pruning would need aggregate counters
  to preserve the "solved" count (noted in ENTERPRISE-ROADMAP.md).
- SwiftUI controls expose no accessibility labels — VoiceOver gap; roadmap item.
