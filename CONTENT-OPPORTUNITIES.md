# Frame & Fork — content & depth opportunities

Mined from the persuasion IP across the Mac (2026-06-25). The thesis from the
enterprise doc was "the product must be undeniable solo before a manager rolls it
out." This is the ammunition for that: you are sitting on far more graded persuasion
content than the app currently exposes, and two of the biggest wins are *already
authored* — they just need importing.

**IP discipline:** before shipping any text derived from the two sales-book PDFs or
the charisma manual, check `~/Developer/UX/research/IP_DISCIPLINE.md`. Derive original
re-expressions of the *mechanism*; don't copy passages.

---

## The two to build first (low effort, data already exists, daily-returning)

These convert the app's single biggest differentiator — *research-graded* persuasion —
into visible, habit-forming surface, without authoring one new puzzle.

### A. Atlas credibility badges + effect-size ranking
Source: `_archive/sales-persuasion/closing-evidence-atlas/` — a real PRISMA systematic
review (11,785 records → 44 extracted), with **Bayesian posterior effect sizes** for 6
techniques (social-proof μ=0.682, commitment-consistency μ=0.590, loss-framing μ=0.327…
with credible intervals) and a 39-technique evidence-tier inventory: 14 with ≥5 studies,
10 with 1–4, **15 with zero peer-reviewed support ("folklore deserts").**

The app's `Technique` already has `atlasVerdict` (categorical) and `folkloreRisk`. This
upgrades it to **quantified**: a credibility badge + numeric effect size on each lesson,
and a ranked "what actually works" view. Nobody else in the category can show this. It's
the proof behind the whole "Atlas" premise. **Low effort — data exists, additive UI.**

### B. Daily spaced-repetition card layer
Source: `_archive/sales-persuasion/closer-curriculum/decks/atlas-techniques.csv` — a
**104-card FSRS deck** already authored. Spaced repetition is the #1 evidence-backed
transfer lever (it's also training-doc item #1). A "daily review" of 5–10 due cards is
the lowest-effort daily-return loop you can ship and pairs perfectly with the existing
streak. **Low effort — CSV → model + a review screen.**

> Build A+B together: credibility badges on every technique + a 104-card daily review.
> Two low-effort imports that make the app both more credible and more habit-forming.

---

## Full ranked opportunity list

| # | Build | Source (real path) | Volume unlocked | Effort |
|---|---|---|---|---|
| 1 | Atlas effect-size badges + "myth vs evidence" cards | `closing-evidence-atlas/` (6 posteriors, 15 folklore) | all 40 techniques + 15 myth cards | Low |
| 2 | Daily spaced-rep deck | `closer-curriculum/decks/atlas-techniques.csv` | 104 ready cards | Low |
| 3 | Puzzle pack from practitioner books | `~/Downloads/` Founding Sales (475pp) + Gap Selling (98pp) | 40–60 new puzzles, all 7 themes | Medium |
| 4 | Persona library expansion | `closer-curriculum/personas/PERSONAS.md` (~9) + `persuade-me/.../scenarios.ts` (12 NPCs) + 9 web-only personas in `closer-gym/src/lib/personas.ts` | 14 → 25–30+ personas | Medium |
| 5 | Lessons / curriculum tab | `closer-curriculum/` 10 mastery stages (21 files) | full syllabus mapped to the ELO ladder | Med-High |
| 6 | "Tells / reading-the-room" cluster + insight pool | `~/Developer/persuasion-os/` (Biology of Yes, ~50 cards + 6-move toolkit) | new technique cluster + ~50 daily insights | Medium |
| 7 | Offline free-form answer scoring | `~/Developer/cold-read/api/core/` (88-pattern detector, no API key) | live eval w/o key + ~20 fallacy/ethics techniques | High |
| 8 | Scenarios / Open-Play mode | `persuade-me/src/data/scenarios.ts` (12) | non-B2B tier: fundraising, salary, networking | Med-High |
| 9 | Warmth/rapport + cold-open pack | `~/Downloads/Mechanics of Attraction` + WorkFlowy export (5MB) | 15–25 rapport puzzles | Medium (re-skin) |
| 10 | Cross-domain Atlas (Discovery / Negotiation) | `~/Developer/closer-foundation/` plans | two future verticals | High |

---

## "Just port what already exists" — the web `closer-gym` engine wins

The iOS app was ported from `_archive/sales-persuasion/closer-gym/`, and the port left
the *deepest* logic behind. These aren't new authoring — the code exists:

1. **The rich post-game Review.** Web `…/review/ReviewClient.tsx` (484 lines) has blunder
   markers (worst-delta moves), **engine-recommended alternative moves**, a 3-dimension
   scorecard (Delivery / Recognition / Persona-match), and a contraindicated-technique
   red-flag panel. iOS ships `SimpleReviewView.swift` (literally "Simple"): just a
   sparkline + ELO delta. **The entire "why you lost / what to play instead" layer is
   missing** — and that's the coaching, the reason a rep improves. Highest learning-value
   port.
2. **The real eval engine.** Web `src/lib/eval.ts` (308 lines): `scoreOperatorMove` with
   persona-specific contraindicated (−0.55w) vs responsive (+0.45w) scoring, a hidden
   trust/value/urgency state machine, and a **technique-stacking penalty** (3+ techniques
   trips the buyer's persuasion-knowledge). iOS uses a flat ~0.4-per-technique shift with
   no persona awareness. Porting this makes the signature eval bar actually *mean*
   something — and it's the prerequisite that makes the rich Review (#1) real.
3. **4 dropped Persona fields.** `spendAuthorityThreshold`, `firingCriteria`, `appraisal`,
   `statusPosture` exist on the web personas and feed both LLM persona fidelity and the
   eval engine's contraindication routing. Cheap, high-leverage.
4. **9 web-only personas** (`closer-gym/src/lib/personas.ts`): IT-security blocker,
   pre-PMF founder, insurance/real-estate transactional, keynote/podcast/author set —
   fully authored, straight port. Skip web "Analysis mode" — it's a disabled v0.2 stub.

---

## How this ladders to the entertainment + enterprise goals

- **Entertainment / daily return:** the spaced-rep deck (#2) + effect-size reveals (#1)
  + a Scenarios mode (#8) give reasons to open the app daily beyond the one daily puzzle.
- **Credibility moat:** the effect-size data (#1) is the thing no competitor can fake;
  it's the proof layer under the whole pitch.
- **Enterprise:** the curriculum (#5) becomes the *certification path* the enablement
  buyers require; the real eval engine (port #2) + rich Review (port #1) become the
  manager-visible scorecard. The content depth is what justifies a per-seat price.

## Recommended sequence
1. Imports first: A+B (effect-size badges + spaced-rep deck) — biggest credibility/habit
   gain per hour.
2. Port the eval engine + rich Review from `closer-gym` — fixes the weakest part (live
   play coaching) using code that already exists.
3. Persona expansion (#4) + a puzzle pack (#3) for content volume.
4. Curriculum tab (#5) as the spine the enterprise cert path hangs on.
