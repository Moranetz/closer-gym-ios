# Frame & Fork — training-quality audit + improvements

What would make the app genuinely better at *teaching reps*, separate from enterprise
plumbing. Grounded in the actual content/engine (2026-06-25). Ranked impact ÷ effort;
each tagged **[client]** (works offline, no backend) or **[backend]**.

## What's strong today
- **100 puzzles, themes well-balanced**: budget 14 · cold-open 16 · endgame 15 ·
  multistakeholder 14 · procurement 13 · renewal 14 · stall 14.
- **Rich per-candidate feedback**: every wrong option carries an `eval` and a specific
  `rationale` explaining the downstream consequence (not just "wrong"). This is already
  better feedback than most competitors' binary scoring.
- **Atlas cross-linking**: best moves tag techniques; lessons link back to puzzles.
- **Defensible measurement**: Glicko-2 with RD, not a naive point counter.

## The core gap: it's a *test*, not yet a *trainer*
The learning loop ends at the reveal. Specifically:

1. **No spaced repetition / miss review.** Every solve is recorded (`PuzzleState.solves`
   with `correct`), but a missed puzzle is never re-surfaced. The single biggest
   evidence-backed lever for skill transfer — re-testing the things you got wrong — is
   absent. A rep can fail a puzzle and never see it again. **[client]**
2. **No weakness visibility.** The data to say "you're 45% on Procurement, 90% on
   Budget" exists (solve → `Puzzles.get(id).theme`), but it's never computed or shown.
   Reps can't aim their practice. **[client]** *(Storage API now implemented — see below.)*
3. **Only two modes**: Daily Drill + free browse. No timed "rush", no theme-focused
   drill, no "redo my misses". The UI itself promises "Puzzle Rush rolls out v1.1". **[client]**
4. **Difficulty ceiling is thin.** 16 beginner / 50 intermediate / 30 advanced / **4
   expert (2100+)**. A strong rep exhausts the top end fast and the adaptive picker
   starts recycling. Content authoring. **[content]**
5. **Live role-play coaches weakly.** `DetectorLocal` is keyword/regex matching, so the
   eval shift and "fired techniques" are approximate, and nothing scores the *quality*
   of the rep's actual words. The post-game ledger shows intent-vs-fired but no rubric.
   Upgrading to LLM rubric scoring is the real fix. **[backend/API]**

## Ranked improvements

| # | Improvement | Impact | Effort | Where |
|---|---|---|---|---|
| 1 | **Review-misses drill** — a mode that serves puzzles you got wrong, oldest-miss-first, and clears them once re-solved correctly | ★★★★★ | M | client |
| 2 | **Weakness report** — per-theme accuracy, lowest first, as a tap-through into that theme's drill | ★★★★☆ | S | client |
| 3 | **Puzzle Rush** — N puzzles, beat the clock, one life; the dopamine mode | ★★★★☆ | M | client |
| 4 | **Per-theme drill entry** — "drill this theme" from the weakness report / lesson | ★★★☆☆ | S | client |
| 5 | **More expert + cold-open-close content** to raise the ceiling | ★★★★☆ | L | content |
| 6 | **Post-game "what to do differently"** — when wrong, lead with the one-line contrast between your pick and the best move (the rationale already exists; surface it more sharply) | ★★★☆☆ | S | client |
| 7 | **Certification runs** — fixed-set, pass-score, no-feedback-until-end exam mode (also the enterprise cert primitive) | ★★★★☆ | M | client→backend |
| 8 | **LLM rubric scoring of live role-play** + manager-visible scorecard | ★★★★★ | L | backend |

## Shipped in this pass (safe, client-side, additive)
- **Weakness analytics API** on `Store`: `themeAccuracy` (per-theme solved/attempted +
  rate) and `missedPuzzleIds` (distinct puzzles answered wrong and not since solved).
  Pure logic over existing `solves` data — zero risk, ready for any UI to consume.
  This is the data backbone for #1, #2, #4 and the personal mirror of the manager
  dashboard.

## Note on UI for the rest
Per your standing workflow (mockup galleries you choose from, never blind edits to a
loved screen), I did **not** unilaterally add new feature *screens*. The analytics
backbone is in place; the screens for review-misses / weakness report / rush should be
designed as option galleries for you to pick from when you're back. The roadmap entries
above are the spec.
