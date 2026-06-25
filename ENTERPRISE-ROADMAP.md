# Frame & Fork → Enterprise — roadmap

Goal: companies pay to put their sales teams through reps. Researched 2026-06-25
(AI-roleplay competitive landscape + enterprise sales-enablement buying criteria +
in-app training-depth audit). This is a direction document, not a spec — decisions
flagged for you are marked **[decide]**.

---

## The one-paragraph thesis

Every enablement buyer is trying to do the same thing: **replace lagging revenue
indicators (closed/won, quota attainment) with leading, per-rep skill data that
correlates to closed deals.** A manager can't watch every call; they buy a tool that
turns "is this rep getting better" into a number they can see and act on. Frame & Fork
already has the rarest half of that — a *defensible skill measurement* (Glicko-2 over
authored positions + an Atlas-tagged technique model). What it's missing is the
**team layer that exposes that measurement to a manager**, and the **trust layer that
clears security review.** Build those two and the product is enterprise-credible.

---

## Two gates, two stakeholders (the structural insight)

A deal closes only if it clears **both**, and each is judged by a different person:

| Gate | Who scores it | What they require |
|---|---|---|
| **Enablement evaluation** | VP Sales / Enablement / RevOps (your champion) | Manager dashboard, skill→quota analytics, methodology scorecards, custom scenario authoring, assignment + **certification** tracking, CRM/call-recording integration |
| **Security / procurement** | IT / Security / Legal (a *different* person) | **SSO/SAML + SCIM**, **SOC 2 Type II**, GDPR/data-residency, audit trails |

The classic failure: the champion loves the demo, then Security's checklist kills it.
That's why SSO + SOC 2 are Tier-1 *deal-blockers* even though no competitor markets
them as features — they live in the buyer's RFP, not the vendor's landing page.
**Start SOC 2 in parallel with the product build; it's a 3–6 month clock you can't
compress later.** **[decide]** whether to begin SOC 2 now.

Gamification (streaks, leaderboards) is an **adoption lever, not a buying gate** —
it's how you get reps to actually use what the manager assigned, per Mindtickle's own
buyer guide. Keep it; don't oversell it.

---

## Competitive position

The AI-roleplay field (Hyperbound, Second Nature, Quantified, Pitch Monster, Luster,
plus the enablement suites Mindtickle / Highspot / Showpad) almost all do **free-text
or voice live role-play scored by a rubric.** Frame & Fork's live Pro tier is in that
same lane but currently the *weakest* part of the app (keyword detector, no rubric on
the actual words — see Training section). 

The app's genuine differentiators:
1. **The puzzle format itself** — fast, deterministic, offline, ELO-rated reps. Nobody
   else has "chess puzzles for sales." It's the cheapest-to-deliver rep in the market
   (no LLM cost per rep) and the most measurable.
2. **The Atlas** — a graded, cited technique taxonomy with contraindications. Most
   tools assert "good/bad"; this one carries the evidence and the failure mode.
3. **Open competitive wedge: ingest the team's *real* calls.** Every enablement
   incumbent pushes its own walled conversation-intelligence. None lets you pull
   Gong/Salesloft transcripts in and auto-generate *puzzles from your own lost deals*.
   That closes the loop from "practice generic scenarios" to "drill the exact moment
   your team fumbled last quarter." Highest-ceiling feature on this list. **[decide]**

---

## Roadmap, ranked by impact ÷ effort

### Tier 0 — make the single-player product undeniable (client-side, no backend)
These raise the core product quality that everything else sells on. Specced in
`TRAINING-IMPROVEMENTS.md`. Ship these first; they need no accounts.
- **Spaced-repetition review of misses** — the highest training-efficacy lever; the app
  already records every solve but never re-surfaces a miss. (#1 in training doc.)
- **Weakness report** (per-theme accuracy). Data already exists; turns solves into
  "you're 40% on Procurement" — the personal version of the manager analytics below.
  *(Storage API for this is implemented now — see below.)*
- **Puzzle Rush** — timed streak mode the UI already promises ("rolls out v1.1").
- **More expert content** — only 4 puzzles above 2100 ELO; a strong rep exhausts the
  ceiling fast. Authoring, not code.

### Tier 1 — the enablement gate (needs a backend + accounts)
- **Team accounts + manager dashboard.** Per-rep rating, trend, theme weakness,
  assignment completion. This is the thing they actually pay for.
- **Assignments + certification.** Manager assigns a theme/level; rep must pass a
  cert (custom pass score) to clear it; certificate on completion. Named by every
  enablement buyer guide (Mindtickle, Highspot, Showpad).
- **Custom scenario authoring.** Let an enablement lead write their own puzzles /
  personas for their product and objections. Turns a generic tool into *their* tool.
- **Skill→outcome analytics.** Correlate rating/activity with CRM closed-won. This is
  the literal value proposition; even a coarse version is a strong demo.

### Tier 2 — the security gate (parallel track, starts now)
- **SSO/SAML + SCIM**, **SOC 2 Type II**, GDPR/data-residency, audit logs. No revenue
  on its own; without it, no enterprise logo signs.

### Tier 3 — the moat
- **Real-call ingestion (Gong/Salesloft/Salesforce).** Auto-generate puzzles and
  persona calibration from the team's own transcripts. The wedge no incumbent fills.
- **Upgrade the live role-play** from keyword detection to actual rubric scoring of the
  rep's words (LLM-graded against a methodology), with a manager-visible scorecard.

---

## Suggested sequence

1. **Now:** Tier 0 (single-player depth) + kick off SOC 2 clock. The product has to be
   great solo before a manager will roll it out.
2. **Next:** Tier 1 backend (accounts → dashboard → assignments/cert). This is the
   minimum that justifies a per-seat price.
3. **Then:** Tier 2 finishes (close the first enterprise logo) and Tier 3 begins (the
   real-call wedge becomes the differentiated pitch).

## Pricing shape (for context, not a decision)
Per-seat/month is the category norm, gated on the manager dashboard + assignments.
Free/solo tier stays as the top of funnel (it's also the cheapest rep in the market,
since puzzles cost nothing to serve). The Pro/live tier's per-game LLM cost is the one
variable cost — note the model option below.

## Cost note carried from the bug pass
The live role-play now uses `claude-opus-4-8`. For high-volume team reps,
`claude-sonnet-4-6` is ~40% cheaper per game ($3/$15 vs $5/$25 per MTok) and an
excellent buyer role-player — at team scale (seats × games/day) that's the dominant
variable cost. **[decide]** model tier for the team plan; left on Opus for now since
downgrading is a product call, not a bug fix.
