# The production bridge — design note (2026-07-18, for Marion to ratify)

## The ceiling this removes
Every surface in Frame & Fork trains **recognition**: read the situation, pick the line.
Nobody on a live call gets four candidates. The gap between "picks the best move" and
"produces the move under pressure" is the app's honest ceiling — named on the web
prototype in July and never bridged on iOS.

## Prior art that already settled the hard question
The web prototype fought this out with Marion on 2026-07-10 and landed on her call:
*"not sure a user wants to constantly type … maybe a setting … low friction + enjoyable
+ helpful."* The result was a three-mode input setting, and it ports directly:

- **Pick** — options immediately. Today's behavior, fastest.
- **Think first** (default) — one tap: "I've got my line" → then options reveal. Zero
  typing, but generation happens before recognition. The cheapest real production rep
  that exists.
- **Type it** (opt-in) — compose your line → lock it → options reveal → a "your words
  vs the model" comparison card after the solve.

## The new piece iOS can do that the web couldn't
**DetectorLocal already exists and runs offline.** Run it on the typed line: *"In YOUR
line, these fired: [labeling] [calibrated-question]"* — then set that against the best
candidate's tags. That is real, machine-graded production feedback with no API key, no
network, no cost. v1 self-comparison (web's version) is the floor; the detector chips
are the genuine bridge. BYO-key LLM judging of the typed line stays v3 — later,
optional, never required.

## Rating integrity (the trap this design avoids)
The typed line sits **upstream of the existing pick**. After composing, she still picks
among the candidates, and only the pick is rated — Glicko never sees the typed text.
No new farming vector, no fairness question, the re-solve lessons all still hold.

## Scope of the build (when ratified)
1. Settings: `moveInput` (pick / thinkFirst / typeIt), default thinkFirst, persisted.
2. Puzzle flow first (single turn, safest); sparring arcs second.
3. Solve screen: compose field or think-gate ahead of candidate reveal per mode.
4. Post-solve: comparison card (typed line + detector chips vs best's tags).
5. Tests: mode routing; detector-on-typed-line; rated-pick unaffected in every mode.

## Open taste calls (hers)
- Is Think-first the right default on iOS, or Pick? (Web shipped Think-first.)
- Does the comparison card celebrate overlap ("your line fired the same move") — a real
  earned moment — or stay flat-observational?
