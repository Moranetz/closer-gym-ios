# Frame & Fork — Business-Leverage Diagnosis

Ranked by **business leverage** (what gates a dollar of revenue), not by craft polish.
Merges the 200-seat buyer pre-mortem, the moat/retention/content-velocity audit, and the
efficacy/credibility audit. The single-player CRAFT is finished and good (verdict ladder,
conviction bar, Glicko, Atlas, anti-confetti reveal — see `JUICE-DOCTRINE.md`,
`PUZZLE-DOCTRINE.md`, `Models/Verdict.swift`, `Engine/ToneSynth.swift`). Nothing below
re-litigates any of that. This is the layer above the craft: **how a human or a company
can buy, see, defend, and trust it.**

The through-line every analyst reached independently: three loops produced a genuinely good
*measurement instrument*, and it is stranded — there is **no way to transact, no way to see,
no way to defend, and the grade itself is not yet trustworthy.** Each is a separate gate, and
the first one is upstream of everything.

---

## P0 — Nothing can be sold and no value is captured. Fix before anything else.

### P0-1. The monetization model captures zero willingness-to-pay and blocks every buyer (B2C and B2B alike).
**Problem.** "Pro tier" is bring-your-own Anthropic API key. No StoreKit, no IAP, no paywall,
no license, no seat. To use the live role-play — the one thing in the app a competitor can't
trivially clone — a user creates their own Anthropic account, generates a key, pastes it into
Settings, and pays ~$0.50/game directly to Anthropic.

**Evidence.** `Keychain.hasAPIKey()` gates the Play tab (`FrameFork/Engine/Keychain.swift`,
`PlayTab.swift:117` `proLockedBanner`); `AnthropicClient.swift` calls the API with the user's
key; reality map §6: "No IAP, no StoreKit, no paywall." Every external analyst converged on
this as the top blocker:
- *Buyer pre-mortem:* "There is no thing to transact… I cannot route personal-API-key
  reimbursement for 200 people through AP." Deal dies on the first discovery call.
- *Product-moat:* "The moat generates revenue for Anthropic, not for you… every improvement
  to it is a gift to Anthropic's revenue line."
- *Positioning:* "A consumer will never paste an API key (~0% conversion); no enablement org
  lets reps paste personal keys. That single design choice is incompatible with *both*
  destinations." It is a placeholder, not a business model.
- *Enablement-buying research:* names it a *third, prior gate* the roadmap doesn't list.

**Gap-to-fundable.** Kill BYO-key. Stand up a thin server-side LLM proxy so the key lives on
your server (drop client-side `x-api-key` in `AnthropicClient.swift`), absorb the ~$0.50/game
as COGS (cap it / rate-limit / move to Sonnet), and put real billing in front of it — StoreKit
2 subscription for consumers, or per-seat for teams. **This one backend is the no-regret move:
it is simultaneously the minimum to *absorb* LLM cost (the B2C requirement) and the minimum to
own *accounts* (the B2B requirement). You do not need to pick the market to know this commit.**
Until it exists, there is literally nothing to fund. Files: new proxy + StoreKit layer,
`Engine/AnthropicClient.swift`, `Views/Tabs/PlayTab.swift`, `Engine/Keychain.swift`.

---

## P1 — Even once it's sellable, there's no way to SEE value (kills the pilot / the renewal).

### P1-1. No identity, no accounts, no sync — the skill record dies on the device.
**Problem.** Persistence is UserDefaults in the app sandbox. No login, no account model, no
server copy, no cross-device sync. A rep who swaps phones loses their entire rating history and
streak; a manager has no roster to add or deprovision against.

**Evidence.** `Storage.swift` (`framefork:puzzles:v0.1` / `framefork:games:v0.1`); reality map
§3 "Team/Manager/Admin Surfaces: NONE", §4 "No backend, no sync, no cloud." Buyer pre-mortem
P0-2 (offboarding is impossible) and P2-3 (a skill measurement that doesn't survive a device
swap can't be a system of record).

**Gap-to-fundable.** Org→manager→rep identity + auth + server-side sync of the data already
modeled in `Storage.swift`. This is the precondition for *everything* manager-facing. The
in-device resilience work (corrupt-JSON backup, tolerant decode) is good but only protects one
device.

### P1-2. Zero manager visibility — the per-rep weakness data is already computed and then thrown away on-device.
**Problem.** The asset a manager actually buys (who is weak on which theme, who is improving,
who has gone quiet) is *already calculated* and never leaves the phone. There is no dashboard,
leaderboard, or any surface showing another human's data.

**Evidence.** `Store.themeStats()` and `Store.missedPuzzleIds` (`Storage.swift` ~174–212)
compute per-theme accuracy + a miss queue from local `PuzzleState.solves`, transmitted nowhere.
No analytics SDK at all (reality map §5). Buyer pre-mortem P1-1: "I open the product and there
is no screen that shows me another human's data." Enablement-buying research: **gradual
disengagement (reps stop logging in) is the #1 churn tell** — surface "last active"
prominently; adoption *is* the renewal metric.

**Gap-to-fundable.** Sync the existing solve/game history server-side, then render
`themeStats()` across a roster in one manager view with an adoption/last-active signal. This is
the single highest-ROI *team* feature because the computation already exists — it just has no
destination.

### P1-3. No assignment / certification, and no ROI reporting — nothing to require, nothing to defend at renewal.
**Problem.** No assignment model, curriculum builder, pass-score, completion tracking, or CRM
link. Adoption is voluntary (→ ~15% after week two), and at renewal there is no per-rep
activity, skill-trend, or outcome data to put in front of a CFO.

**Evidence.** Reality map §3/§5; `ENTERPRISE-ROADMAP.md` lists all of this as unbuilt Tier-1.
Enablement-buying research: ramp time (68%), usage rate (64%), win-rate-by-skill (61%) are the
demanded metrics; mature programs cite ~4:1 ROI over 90–180 days. Buyer pre-mortem P1-2/P1-3.

**Gap-to-fundable.** Manager-assignable spaced-reinforcement cadence (the SRS backbone in
`Storage.swift` is the closest-to-shipped differentiator — productize "assign a 5-min daily
drill on a theme + see completion") + a pre/post improvement report that aggregates the
on-device weakness analytics server-side. Note the honesty constraint from P2-2 below: report a
*validated leading indicator*, not a fabricated win-rate lift.

---

## P2 — The thing being measured isn't yet trustworthy. Erodes credibility on first use.

### P2-1. The role-play grade is decided by regex, not the AI — the moat is a cosmetic narrator on a keyword referee.
**Problem.** Win/loss is computed entirely by a 19-rule regex detector + flat arithmetic. The
LLM writes the buyer's dialogue but **never scores the rep's words.** A buyer can type "you've
convinced me, send the contract" and if the last turn tripped no responsive keyword, the eval
bar does not move; conversely you can win by keyword-stuffing technique phrasings the buyer
ignored. The grade is decoupled from the conversation.

**Evidence.** `LiveGameView.swift:368-388` `applyEvalShift` (+0.40 responsive / −0.30
contraindicated / ±0.05 drift) off `DetectorLocal.swift` (19 rules, self-described ~70%).
Reality map §10: "no LLM rubric scoring of actual word quality." A richer persona-weighted
grader already exists unported at `closer-gym/src/lib/eval.ts` (308 lines).

**Nuance (not pure downside).** The roleplay-scoring research notes the regex referee
*accidentally dodges* LLM sycophancy — so the fix is **not** "let the persona call grade the
rep" (that walks into score inflation), it's a **separate, blind, process-gated LLM judge**.
See RESEARCH.md §4.

**Gap-to-fundable.** A separate end-of-game judge call (blind to the rep's pre-registered
intent and the live eval), scoring decomposed evidence-anchored criteria, with the **Glicko
rating gated on PROCESS quality, not on whether the bot caved.** This is the precondition for
ever putting a role-play number on a manager dashboard — a sycophantic score destroys
enterprise trust on first use, so it *gates* the team layer rather than running parallel to it.

### P2-2. The efficacy claim is unbacked — the enterprise thesis sells a Level-4 outcome on Level-2 instrumentation that isn't even valid yet.
**Problem.** The value prop ("makes you close better") is a transfer claim. The app can today
honestly claim only L1 reaction. L2 learning is *construct-invalid* because the bank is
guessable; L3 behavior and L4 results have zero instrumentation. The `ENTERPRISE-ROADMAP`
thesis ("per-rep skill data that correlates to closed deals") is an L3/L4 promise an analyst
kills in diligence.

**Evidence.** PUZZLE-DOCTRINE measured the 100 puzzles: correct answer = longest option 98/100,
tagged-only-on-key 96/100 → a rating that rises measures test-savvy, not skill. No analytics
installed (reality map §5). Learning-science: time-on-app/streaks/logins do **not** correlate
with skill gain; far transfer from a multiple-choice task to a live deal is the case the
evidence is most skeptical of.

**Gap-to-fundable.** (1) Ship the non-guessable bank from PUZZLE-DOCTRINE — the construct-
validity precondition. (2) Add a **sealed held-out benchmark set** (never served in Daily/
Browse/SRS) run pre/post — this is the keystone, ships client-side, no backend, and converts
"you got better at our puzzles" into "you got better on a test you never practiced." (3)
Install consented telemetry (PostHog is in-stack) as the aggregation substrate. Full design in
RESEARCH.md §3. Claim ladder discipline: never skip to "we lift quota" with a correlation.

### P2-3. The content catalog is shallow and measured-broken, and there's no engine to refill it.
**Problem.** 100 puzzles get consumed in a week (and were proven guessable); only 4 sit above
2100 ELO, so strong reps exhaust the ceiling in days. The infinite content source — every Pro
role-play game — is destroyed at game end.

**Evidence.** Reality map §10 (4 expert-tier puzzles, "content rewrite pending"). The killer:
`GameRecord` (`Storage.swift:284-295`) stores `evalCurve` + technique-ID arrays only — **it does
not persist the transcript.** You cannot replay a past game, point at "turn 4 was your blunder,"
or mine games into new content. A 104-card FSRS deck sits authored and unused at
`closer-curriculum/curriculum/decks/atlas-techniques.csv`; the quantified evidence atlas
(`closing-evidence-atlas/results/*.csv`, Bayesian effect sizes) is the un-fakeable credibility
layer, only partially wired.

**Gap-to-fundable.** Add `turns: [StoredTurn]` to `GameRecord` (one field unblocks both the
rich debrief AND the content flywheel: great turns → master-game annotations, blunders →
personal "your misses" sets). Author the ~150-item non-guessable v1 bank with ≥3-closer
adjudication. Surface quantified effect-size badges from the evidence atlas on `LessonsTab`.

---

## P3 — Compounds the "single-player hobby app" read; not a standalone blocker.

### P3-1. No security/procurement artifacts (SSO/SCIM/SOC 2/DPA).
The second-stakeholder kill. Reps shipping deal-specific objection language to a third party on
personal accounts with no DPA is an active data-leakage finding, not a missing feature.
SOC 2 Type II is a 3–6 month clock — start it the day the backend (P1-1) lands, not when a deal
needs it. `ENTERPRISE-ROADMAP.md` Tier-2; only relevant *after* a team has paid (see RESEARCH.md
positioning).

### P3-2. No CRM / call-recording (Gong/Salesloft/Salesforce) integration.
Blocks both the efficacy bridge (run the Atlas detector over the rep's *real* calls — the only
true L3 signal) and the differentiated content wedge (generate puzzles from the team's own lost
deals). Today the product can't reflect *my* objections or *my* deals; it stays a generic
library. Correctly sequenced after the team layer.

### P3-3. iOS-only; no web/desktop surface.
B2B reps train at a desk and enablement leads author/review on a laptop. If the destination is
teams, the product is web-first and most of the polished SwiftUI views are a companion + demo
magic-trick, not the platform. The *content and rating IP* port; the views largely don't.

### P3-4. Retention has no hook on the moat, and unbounded variable cost has no governance.
The streak only counts the daily puzzle; completing a role-play game extends nothing, and no
notification ever pulls a user into a live rep. Meanwhile 200 reps × several games/day × $0.50
is unbounded and unmonitored under BYO-key. Both are downstream of P0-1 (own the cost) and the
SRS surfacing already specced in `TRAINING-IMPROVEMENTS.md`.

---

## The order that flips the "no"

1. **Make it sellable** (P0-1): kill BYO-key → LLM proxy + real billing. No market decision
   required; nothing downstream exists without it.
2. **Make it visible** (P1-1 → P1-2): identity + sync, then one manager dashboard rendering the
   `themeStats()` you already compute. This is what turns "nice app" into "fundable."
3. **Make the grade trustworthy** (P2-1 + P2-2): blind process-gated role-play judge + the
   sealed held-out benchmark, so the number on that dashboard survives scrutiny.
4. **Make it defensible** (P1-3, P3-1, P3-2): assignment/cert + ROI report, then SSO + SOC 2
   clock, then CRM bridge — in that order, with revenue and logos already in hand.

The rarest asset (defensible skill measurement) is built. It is stranded behind the four most
ordinary, most non-negotiable prerequisites — and the first of them is simply *being able to
take the customer's money.*
