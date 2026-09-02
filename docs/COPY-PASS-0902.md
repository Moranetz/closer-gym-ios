# Copy pass — 2026-09-02

Lab-speak out of the UI and the data; onboarding rewritten into the register. Two layers:
A. UI strings (onboarding + PlayTab's opponent picker + Track/theme/ID chips). B. DATA
lab-speak (`operator`/`recipient`/`persuasion-knowledge` as jargon, numeric persona
attributes in prose, puzzle IDs rendering to users, theme labels). Never changed a puzzle's
meaning, correct answer, eval, or technique tags — only the words around them.

## A. UI strings

### Onboarding — `FrameFork/Views/Onboarding/OnboardingView.swift`

Page 1, line 44:
- Before: "Fourteen adversarial buyer personas. A closing ELO that climbs as you win. Per-turn eval, fired-technique tags, Atlas-linked transcripts."
- After: "A buyer says "send me something in writing." Fourteen personas will test you like that, live. Every move earns an ELO that only climbs when you're right."

Page 1, line 45 ("There's no cheat code for a live buyer. We built the gym.") — unchanged, hers.

Page 2, line 57:
- Before: "A fresh Daily Drill every day. 40 Atlas techniques cross-linked to every puzzle, transcript, and master move."
- After: "Solve wrong and the app names the exact technique you missed. It's one of forty, linked straight to the real transcript where it worked."

Page 2, line 58:
- Before: "Watch hand-authored deal studies — Voss, Gap Selling, Challenger, Klaff, Burg, and two cautionary breakdowns of high-pressure tactics. Fully offline, no API key needed."
- After: "Watch hand-authored deal studies drawn from Voss, Gap Selling, Challenger, Klaff, and Burg, plus two cautionary breakdowns of high-pressure tactics. Fully offline, no API key needed." (em-dash removed)

Page 3, line 70:
- Before: "Solve at your own pace. Climb the ELO ladder as your rating rises. Two rating buckets: Game and Puzzle."
- After: "Solve at your own pace. Your puzzle rating and your game rating climb separately, so one rough night against a live buyer never touches your puzzle streak."

Page 3, line 71 (Anthropic key / Settings line) — unchanged, already plain/functional.

### PlayTab — `FrameFork/Views/Tabs/PlayTab.swift`

Line 84 (opponent picker):
- Before: "Pick an opponent. \(count) adversarial buyer personas, ELO \(lo) to \(hi). Win rating to unlock bots up to 200 above you."
- After: "Pick an opponent from \(count) adversarial buyer personas, ELO \(lo) to \(hi). Beat one and the next 200 ELO of the ladder opens up." — restates as what you do / what unlocks, per the brief.

Line 181 (bot row track chip):
- Before: two chips, `Text("Track \(p.track.rawValue.dropFirst())")` + `Text(p.track.label)` → rendered "T2 · Founder-led".
- After: single `Text(p.track.label)` → renders just "Founder-led". Dropped the raw `T2` internal-ID chip entirely.

### Track label — `FrameFork/Models/Persona.swift:37`
- Before: `case .t5: return "Research-operator"`
- After: `case .t5: return "Research-led"` — parallels the existing "Founder-led"/"Enterprise" pattern and drops "operator", which the app's own vocabulary reserves for the player.

### Theme labels — `FrameFork/Models/Puzzle.swift` (`PuzzleTheme.label`)
- Line 80, `.stall`: "Stall / silence" → "Stalls and silence"
- Line 82, `.multistakeholder`: "Multi-stakeholder" → "Committee deals"
- Line 85, `.salesAssist`: "Sales assist" → "Self-serve accounts" — the puzzles under this theme are all about handling an account already using the product; "self-serve accounts" is what a rep would actually call that, not the internal motion-name.
- `.budget`, `.procurement`, `.renewal`, `.endgame` (chess frame — kept, deliberate), `.coldOpen`, `.forecastCall` — already read as something a salesperson would say; left as-is.

### Puzzle ID chips no longer render to users
Puzzle IDs like "P001" were rendering as a UI chip in four places. The `id` field stays in the
data model (used for lookups, seeded shuffles, storage) — only the display chip is gone.
- `FrameFork/Views/Tabs/LessonDetailView.swift:45` — dropped `\(drillPuzzle.id.uppercased()) · ` from the CTA subtitle.
- `FrameFork/Views/Tabs/LessonDetailView.swift:233` — dropped the `Text(p.id.uppercased())` chip from the related-puzzles row.
- `FrameFork/Views/Puzzle/MissReviewView.swift` (was line 64) — dropped the `Text(p.id.uppercased())` chip from the miss row.
- `FrameFork/Views/Tabs/PuzzlesTab.swift` (was line 314) — dropped the `Text(p.id.uppercased())` chip from the theme-list puzzle row.

### Bonus, same jargon class — `FrameFork/Views/Play/PreGameView.swift:59`
- Before: `stat(label: "PK", value: ...)` — an unexplained internal abbreviation ("persuasion knowledge") shown on the pre-game screen.
- After: `stat(label: "Savvy", value: ...)` — same value (low/medium/high/very high), plain label.

## B. DATA lab-speak

### `FrameFork/Data/Personas.swift`
- Line 229, `role`: "Operator-researcher; data team lead" → "Data infrastructure lead; runs the pipeline" (shown in PreGameView's bot card and PlayTab's bot row).
- Line 316, tagline for `t5-research-operator`: "Operator-researcher. Knows the playbook." → "Data-team lead. Knows the playbook cold." (shown as the bot's one-line tagline).
- Line 317, the tagline switch's `default` fallback (currently unreachable — all 14 personas have an explicit case, but this guards any future addition): "\(PK label) PK · valence \(±n) · \(readability) readability" → "\(PK label)-savvy buyer, \(readability) to read." — the old fallback would have rendered raw internal attribute names and a signed number straight to a user.

### `FrameFork/Data/Puzzles.swift` — "operator" (meaning "you") and "recipient" (meaning "the buyer") in user-visible `setup`/`buyerRole`/`themeHint`/`rationale` text, plus "persuasion-knowledge" as a bare clinical term
- Line 49 (`themeHint`): "...The branch offer doubles as a recipient-agency move." → "...The branch offer also hands the CFO the choice, not just the answer."
- Line 56 (`setup`): "Procurement specialist has very high persuasion-knowledge." → "This procurement specialist has seen every tactic in the book."
- Line 240 (`setup`): "...Very high persuasion-knowledge." → "...Nothing you say here will be new to them."
- Line 553 (`setup`): "Counsel has high persuasion-knowledge and is testing operator's terms tolerance." → "Counsel has seen every negotiation tactic in the book and is testing how far your terms bend."
- Line 562 (`themeHint`): "Senior counsel is testing the operator's market knowledge." → "Senior counsel is testing your market knowledge."
- Line 584 (`setup`): "...operator's bid was originally first." → "...your bid was originally first."
- Line 943 (`setup`): "...one finding from the operator's last SOC2." → "...one finding from your last SOC2."
- Line 1005 (`setup`): "Champion VP-Eng prefers operator's solution." → "Champion VP-Eng prefers your solution."
- Line 1114 (`setup`): "Business team prefers operator." → "Business team prefers you."
- Line 1160 (`setup`): "Operator's deal sits at the intersection." → "Your deal sits at the intersection."
- Line 599 (`setup`): "CPO has very high persuasion-knowledge." → "The CPO has run this exact play before, from your side of the table."
- Line 1396 (`rationale`): "...This is the calibrated question's own contraindication." → "...This is exactly how calibrated questions go wrong." (kept the technique name; dropped the clinical "contraindication")
- Line 1513 (`setup`): "Champion intro'd operator to her peer VP." → "Champion intro'd you to her peer VP."
- Line 1528 (`setup`): "Cold email. Recipient is publicly skeptical of the operator's category." → "Cold email. The buyer is publicly skeptical of your category."
- Line 1558 (`buyerRole`): "First-touch with a high-persuasion-knowledge senior executive" → "First-touch with a senior executive who's seen every pitch in the book"
- Line 1562 (`rationale`): "...with a high-persuasion-knowledge buyer, the honest concession..." → "...with a buyer this sharp, the honest concession..."

### `FrameFork/Data/Transcripts.swift` — `techniqueNote` (shown in the "Move sequence" block of the Read-full-transcript sheet)
- Line 24: "...The operator never argues. The mirror does the work." → "...You never argue. The mirror does the work."
- Line 116: "...Buyer qualifies to operator, not the reverse." → "...The buyer ends up qualifying to you, not the other way around."

### `FrameFork/Data/Arcs.swift` — `rationale` (shown as the per-turn coach line in the offline Sparring debrief)
- Line 94: "An implication question on a certainty-four buyer is her contraindicated move by name." → "An implication question is exactly the wrong move on a buyer this sure of herself." (dropped the raw `certainty: 4` persona attribute and the clinical "contraindicated")
- Line 115: "...on the persona whose contraindication list it tops." → "...on exactly the buyer it backfires on hardest."

### Deliberately left alone
- `TranscriptRole.op` / `StoredTurn.role == "operator"` / `isOperator` / `operatorTurnCount` — internal role tags and Swift identifiers. They render as "You" (TranscriptSheet, SimpleReviewView, MasterGameViewer, LiveGameView) — never as the literal word "operator" — so there's nothing to fix.
- `Persona.narrativeArc`, `.hiddenCurveBall`, `.decisionCriteriaHidden/.Stated` — contain "operator" and "persuasion-knowledge" wording but are only ever read into the LLM system prompt (`AnthropicClient.swift`), never rendered to a user (confirmed via `SafetySpineTests.swift`, which asserts these specific fields never leak into the transcript). Left as-is.
- `WatchTab.swift`'s `game.id.uppercased()` (renders e.g. "VOSS-001" next to `game.openingECO`) — this is the master-game analog of a puzzle ID, but it's deliberate chess-notation flavor (paired with a real chess-ECO-style opening code), not the same defect as a bare "P001". Left alone; flagged in the report as a judgment call.
- `PuzzleTheme.endgame` label "Endgame studies" — kept; explicit chess framing ("themeHint" for these puzzles literally says "Mate-in-1"), part of the app's spine per the brief.

## Capture
Debug build installed on sim `2C6327A6-7918-4145-9143-308E1CC94926`, onboarding flag reset,
launched, screenshot at `/Users/marion/Developer/fleet-loop/captures/ff-ios/onboarding-copy.png`.
No clipping — page 1 renders with room to spare below the body text.

## Gates
- `FrameForkTests`: 35/35 passed (baseline).
- `-configuration Release build`: BUILD SUCCEEDED.
- `deslop --detect-only` on the newly-authored onboarding + PlayTab prose (isolated from the
  data-fix word-swaps): 22/100, **STATUS: OK — reads human.**
- `deslop --detect-only` on the full changed-string batch (onboarding/PlayTab prose + the
  puzzle-data word-swaps together): 36/100, **STATUS: MIXED** — floored by 3 "fragment" tics.
  All three are pre-existing house style: `Puzzle.setup`/`buyerRole` fields are written as
  terse fragments across the entire ~100-puzzle bank ("Legal review.", "Final call.",
  "Eighteen minutes into discovery.") and `buyerRole` is always a noun phrase, never a
  sentence — none of that was introduced by this pass; the edits only swapped words inside
  fragments that already existed. Rewriting them into full sentences would break with the
  untouched 90-plus puzzles around them, so left as-is.
