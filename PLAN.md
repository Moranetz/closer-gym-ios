# PLAN.md — from solid to phenomenal
2026-07-26. The umbrella plan. Supersedes nothing — it sequences what PUZZLE-DOCTRINE.md, JUICE-DOCTRINE.md, RESEARCH.md, DIAGNOSIS.md, and the production-bridge note already established, and adds the craft layer none of them cover. Read ENGINEERING-NOTES.md first in any session, as always.

---

## 1 · Where the game actually is (honest ledger)

Shipped/done — do not redo:
- 1.0.1 live (b4a602e); 1.1.0(5) resubmission prepped (4752b8c) — **release train is mid-flight; nothing below may destabilize it.**
- Engine: verdict ladder + conviction bar + ToneSynth/haptics (loop 4) · blind tool-call judge, injection-hardened (loops 5–6) · StoreKit 2 behind flag (loop 7) · offline Play tab, keyless dead-ends killed (7968e16).
- Strategy implemented: Atlas evidence re-anchored to won-deal data (f5a4f22) · fraud endorsement dropped from master roster (3103b25) · rating as daily spine w/ progress hero (fd10337) · adaptive serving at edge-of-ability + theme interleave (1007019).
- Designed, awaiting HER ratification: production bridge (Pick / Think-first / Type-it + DetectorLocal offline grading, 9a993f4).

The gap, in the repo's own words (ENGINEERING-NOTES): **the 127-puzzle bank is still the pre-doctrine, 98%-guessable content; operator/recipient lab-speak still lives in the DATA; two move-quality vocabularies coexist.** Everything else got rebuilt around a bank that was never rebuilt. That is why the game still feels juvenile: the engine grades like chess.com, but the positions are tic-tac-toe.

## 2 · What "phenomenal" means here (the craft laws)

PUZZLE-DOCTRINE solved *fairness* (no leaks, functional distractors, buyer-state keys). Award-winning needs five more laws on top — these are the delta between a fair quiz and a great game:

1. **Refutation lines.** Every option has a scripted continuation (2–3 turns). Wrong moves get *punished on screen* — you watch the buyer go polite and cold. The key plays out the door it opens. Verdict card comes AFTER the continuation. School → consequence.
2. **Unannounced decision points.** Stems never name the theme. Several live signals, one load-bearing, sometimes planted two turns back; "keep listening" is a first-class option and occasionally the key. The tested skill becomes *detection*, not selection.
3. **Competing goods.** The flagship difficulty is best-practice-wrong-NOW vs. quiet-move-right-here (the red team's buyer-state-fit law, weaponized). Hard = two defensible moves, not one good and three dumb.
4. **Production before recognition.** The already-designed bridge (Think-first / Type-it + DetectorLocal) is the ceiling-remover — build it once ratified. Typed line stays upstream of the rated pick (no farming vector, per the note).
5. **The prose is the difficulty.** Every stem reads like an overheard call — names, interruptions, subtext, a buyer being polite while leaving. Zero lab-speak in data (the standing remaining item). If a stem could open a textbook chapter, it fails.

Plus one held promise: **the Fork becomes reachable.** 8–12 authored fork positions (a concession that wins on two fronts) with `isFork`/`forkRationale` — the scarce verdict finally exists in the wild. Never inflated.

## 3 · The phases (order is the argument)

**Phase 0 — Ratify + stabilize (hers + hygiene, days).**
Three decisions only she can make, batched once: (a) production-bridge build per the note; (b) ONE move-quality vocabulary app-wide (recommend Verdict; MoveQuality retires); (c) adjudication panel — who are the ≥2 closers beside her, or accept the provisional-pool fallback (below). Meanwhile: merge `audit-lexicon-2026-07` → main once 1.1.0 clears review (12 commits, fully pushed, clean FF).
*Why first:* every later phase forks on these; building ahead of ratification is how spec-drift happens.

**Phase 1 — Lock the form with exemplars (1 session).**
Five puzzles authored to ALL five laws, as an interactive HTML gallery (her standing verdict instrument: side-by-side, playable, Keep/♥/Cut + /5): one detection puzzle, one competing-goods, one fork position, one with the key = silence, one production-variant of a current-bank position for direct old/new contrast. Continuations play out; sound/verdict choreography simulated.
*Why before engine:* the exemplars ARE the spec. Engine and pipeline get built to the form she ratifies, not the reverse. Cheapest possible place to discover the form is wrong.

**Phase 2 — Engine deltas (1–2 sessions, small by design).**
Only what the ratified form demands: continuation playback state in PuzzleSolveView (option → scripted turns → verdict hero) · `stay silent` as candidate type · fork flags + forkRationale surfacing · planted-detail stems (multi-turn scroll-back) · production bridge per the note (DetectorLocal; judge-graded Type-it stays key-gated) · per-option pick-count logging (local; feeds calibration later). All on a 1.2.0 branch; 1.1.0 train untouched. Re-run `xcodegen` after every new file (notes, rule 1).

**Phase 3 — The bank campaign (the spine; several sessions, batched).**
Pipeline per batch of ~10: **source** (framing-corpus: ~25–30 buyer-facing moves w/ Tell/Counter + 48 "common wrong answer" distractor seeds + CONTESTED quarantine as tempting-traps + ELM as the buyer-state arbiter; the 13 transcripts + master games for verbal texture; JOLT/won-deal process content from RESEARCH.md) → **dramatize** (dialogue pass; lab-speak ban-list lint; deslop on stems) → **doctrine gates** (cover-the-options, length/tag balance, 3-functional-options) → **continuation-author** (every option, incl. the punish lines) → **adjudicate** (her + panel per Phase 0c; items that skip the panel enter PROVISIONAL — unrated for users, self-calibrating via item-Glicko as real results accumulate; promotion to rated pool needs either panel sign-off or convergent data).
Targets: first 30 new-form items replace nothing — old bank demotes to an unrated "Fundamentals" warm-up tier (protects the rating's integrity without deleting content); rated pool opens at ~40–50; campaign target 150. Interleave authoring across CALL-MAP order (open→discover→advance→close) so every batch ships a playable spread, not one theme.
*Why the bank is Phase 3 not 1:* authoring 150 items to a form that then changes is the one unrecoverable waste in this plan.

**Phase 4 — Feel + identity pass (parallel-late, 1–2 sessions).**
The ux-audit's findings (17-size type ramp → token set; marketing-scale headlines out of app surfaces; monospace-caps down to one kicker per screen) + the JUICE-DOCTRINE items the new content finally justifies: fork anticipation-lead choreography now fires on real forks; continuation typing-rhythm as the new tension beat. This is what makes the craft *visible* to App Store editors and reviewers — but it polishes the new form, so it follows Phase 2/3's first batch, not precedes it.

**Phase 5 — Measure what matters (continuous once Phase 3 ships).**
Transfer = accuracy on UNSEEN items at matched difficulty (the honest skill signal; streaks/DAU demoted per RESEARCH.md) · per-option pick distributions prune non-functional distractors locally · full population psychometrics + the P0 business track (proxy, billing flag-flip, accounts) stay EXACTLY as gated in BACKEND-HANDOFF.md/SECURITY.md — unchanged by this plan, unblocked only by her accounts/$.

## 4 · Risks, named
- **Adjudication is the bottleneck.** No panel → provisional-pool fallback works but slows rated-pool growth and shifts trust to data. Her Phase-0 call.
- **Content cost is real.** A law-compliant puzzle is a ~400–600-word scripted scene. ~10/batch is honest throughput; 150 is a campaign, not a sprint. Resist padding — a 60-item phenomenal bank beats 150 at the old bar.
- **Two sources of truth during transition.** Old bank + new bank must never share a rating pool or a vocabulary. The Fundamentals demotion and single-Verdict decision close this.
- **Release-train collision.** All new-form work on the 1.2.0 branch until 1.1.0 clears review.
- **The judge's e2e test still needs a live key on device** (standing caveat since loop 5); Type-it mode inherits it. DetectorLocal path has no such dependency — ship it first.

## 5 · First moves (next session)
1. Phase 0 asks to her, batched (bridge ratification · vocabulary · panel).
2. Build the Phase-1 exemplar gallery.
3. Nothing else until she's judged the exemplars.
