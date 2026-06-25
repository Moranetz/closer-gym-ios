# Frame & Fork — integration plan for the highest-leverage opportunities

This plan turns the diagnosis (`DIAGNOSIS.md`), the research (`RESEARCH.md`), the security
contract (`SECURITY.md`), and Marion's product notes into a sequenced, executable build — with
the rep's experience, not the feature list, as the spine. It is written to be implemented
carefully and in order. Read `ENGINEERING-NOTES.md` first; it lists the mistakes that recur.

---

## 0. The strategy in one sentence
Be the sales-training tool that is **trained on *your* product and mandated by *your* manager** —
because generic AI role-play is already a commodity, and the only things that produce both a moat
and actual daily usage are **relevance** (it's about the deals the rep is really losing) and
**mandate** (the company assigns it). Everything below serves that sentence.

## 1. What we're building, and what we're deliberately NOT building

**Building (highest leverage, in dependency order):**
1. **The foundation** — a server proxy + accounts + per-seat licensing + server-side rating.
   Already specced in `BACKEND-HANDOFF.md` and gated by `SECURITY.md`. It is the prerequisite for
   every item below; nothing here works until it exists.
2. **The moat — company-trained content.** Personas and puzzles generated from the customer's own
   product, ICP, and real objections. This is simultaneously the differentiator *and* the
   adoption fix (relevance is what gets a tired rep to open it).
3. **The retention engine — team visibility, assignment, and a trustworthy leaderboard.** What the
   manager buys, what makes them renew, and the competition that taps a rep's status drive.

**Deliberately deferred, with the reason (so they aren't silently dropped):**
- **Hand-built verticals** (healthcare / fintech / security as separate "modes"). Subsumed by #2:
  the customer's own data *is* the vertical adaptation. The only net-new per vertical is compliance
  copy and a higher security bar (see §7). Don't build vertical modes; build the data pipeline.
- **Hearts / lives (Duolingo-style lockout).** Cut, on purpose. It's a B2C-casual friction-to-
  convert mechanic; this is a B2B mandated tool where the manager wants the rep to practice *more*.
  A lockout that stops a rep mid-practice fights our own core insight ("a tired rep won't use it
  unless it's relevant"). The instinct under it — stakes per answer, a reason to return — is right
  and is already served better by the rating drop (real loss-aversion, no gate), the streak, and
  the leaderboard. Keep the stakes; never gate practice.
- **CRM / call-recording ingestion** (Gong/Salesforce). High value later (real-call grounding is
  the only true on-the-job signal), but it's a Phase-4 enrichment of #2, not a v1 dependency.
- **A web app.** Only if enterprise buyers demand desk-based authoring/review. The content + rating
  IP ports; most SwiftUI views don't. Decide when a real deal requires it, not before.

---

## 2. The user journeys (the spine — design everything to make these seamless)

### 2a. The admin / enablement lead (sets it up — also busy, so near-zero friction)
1. Buys N seats, creates the org, invites the team (Sign in with Apple).
2. **The setup interview, not a data dump.** A guided 5-minute flow asks only what produces
   relevance: *what do you sell* (1–2 lines), *who you sell to* (segment/ICP), *the top 5–8
   objections you actually hear*, *2–3 competitors*, *your real differentiators*, *your deal
   stages*. Optional paste: a product one-pager, a few anonymized objection lines. Everything is
   editable later — start minimal, enrich over time.
3. The system **generates** custom buyer personas + a starter puzzle set from those inputs.
4. **The quality gate (non-negotiable):** generated content lands in a *review* state, never live.
   The admin sees each persona and each puzzle with its generated rationale, edits or approves.
   Nothing reaches a rep unreviewed. (This is the line between "research-grade" and "auto-slop" —
   see §6.)
5. The admin assigns a starting cadence (e.g. "a 5-minute daily drill on pricing objections") to
   the team, or trusts the auto-assignment default.

### 2b. The manager (drives usage and reads the result — weekly, 2 minutes)
- Opens the dashboard: per-rep weakness by theme (already computed by `Store.themeStats()`),
  **last-active** (the #1 churn signal per the enablement research — surface it first), skill
  trend, and assignment completion.
- Assigns or reassigns a theme + cadence in two taps, to an individual or the team.
- Sees the leaderboard and the "most improved" — the things they'll forward to their own boss.

### 2c. The rep (the whole point — must feel relevant in 60 seconds, natural to return daily)
- First open after getting a license: not a generic puzzle — **a puzzle about their product**, the
  objection their team actually loses on. Relevance is the hook; earn the second session here.
- Daily: a notification that names the relevance ("5-min drill: the discount objection, on
  [product]"), not "practice sales." Opens it because it's their product and the manager assigned
  it.
- Plays a puzzle or a live role-play against a *company* persona; gets the earned verdict and the
  blind coach grade (already built); sees their rank move and their streak hold.
- Returns tomorrow because: it's relevant, it's assigned, the streak is alive, and they're three
  spots from passing a teammate.

**The design test for every screen in this plan:** does it make one of these three journeys more
seamless? If not, cut it.

---

## 3. Phase 0 — Foundation (the gate; needs Marion's accounts/money)

Detail lives in `BACKEND-HANDOFF.md` and the mandatory controls in `SECURITY.md` §"backend
contract". Summary of what must exist before anything else in this plan:
- **Server LLM proxy** holding the Anthropic key; client never sees it; routes through the single
  `AnthropicClient.performRequest` chokepoint already in place. Server owns model/tokens/system
  prompt; per-user + global rate limits; hard daily cost cap + kill-switch.
- **Accounts + org model:** org → manager → rep, Sign in with Apple, server-side sync of the data
  already modeled in `Storage.swift`.
- **Per-seat licensing** (the StoreKit layer is built and flag-gated; flip `FeatureFlags
  .subscriptionsEnabled` on only when this exists, and add `appAccountToken` at purchase per the
  note in `SubscriptionStore.purchase`).
- **Server-side rating recompute** — the server sees the real transcript + the real judge tool
  output, runs Glicko itself, and stores the authoritative rating. The client renders a read-only
  copy. This is what makes the Phase-3 leaderboard trustworthy; it is not optional.

**Acceptance:** a rep on a seat can run a role-play whose LLM cost hits the owner's metered,
capped proxy; their rating is computed and stored server-side; a manager can add/remove them.

---

## 4. Phase 1 — Team visibility (the bridge; cheapest high-value team feature)

The weakness data a manager buys is *already computed* and currently dies on the device. Once
Phase 0 sync exists, surfacing it is the highest-ROI team feature because the computation already
exists.

- **Manager dashboard:** roster with per-rep theme accuracy (`themeStats()`), last-active (lead
  with it), rating + trend, miss queue size. Server-read, never a client upload.
- **Acceptance:** a manager sees every rep's weakness and who's gone quiet, in one screen, with
  data that can't be forged from a client (server-recomputed).
- **UX:** quiet, scannable, sorted by "needs attention" (gone-quiet or declining first), not
  alphabetically. The manager's job is triage; design for triage.

This phase is also the precondition for assignment and the leaderboard (Phase 3).

---

## 5. Phase 2 — The moat: company-trained content (where the detail concentrates)

This is the feature that makes the product defensible and relevant. Treat it as three sub-systems.

### 5a. The setup interview (input)
- A guided, progressive flow (§2a). **Minimum viable inputs** produce a usable result; everything
  else is optional enrichment added later. Do not gate go-live on a complete data set.
- Store inputs as **structured org config** (products, ICP, objections, competitors,
  differentiators, stages), not free text, so generation is controllable and re-runnable.
- Frame it as "tell us what you sell," never "train a model." (It's grounding/RAG/config, not
  fine-tuning — set that expectation in the copy to avoid a capability mismatch.)

### 5b. Generation (transform)
- From the org config, generate: (a) **custom buyer personas** grounded in the ICP + real
  objections + the existing persona schema (`Persona`), and (b) **a starter puzzle set** tied to
  their objections and deal stages, authored to `PUZZLE-DOCTRINE.md` — forced-context stems,
  non-guessable options, length-matched, the *defensible-key* bar, segment-tagged.
- Run generation through the proxy (cost-metered; give generation its own budget separate from the
  per-rep play budget).
- Re-runnable: when the admin edits the config, they can regenerate (into review, never auto-live).

### 5c. The quality gate (the make-or-break — this is where credibility lives)
- **No generated puzzle or persona goes live unreviewed.** The admin reviews each item with its
  generated rationale shown; edits or approves. This is the human-in-the-loop adjudication that
  `PUZZLE-DOCTRINE.md` requires and the thing that separates this from a slop generator.
- Automate what you can to make review fast and to catch the worst items: apply the
  cover-the-options test (can the key be derived from the stem alone?), flag low-confidence or
  guessable items (e.g. longest-option-is-key, single-tagged-key) for mandatory edit, and never
  surface a numeric eval to the rep (doctrine §0.3).
- For genuinely contested calls (sales has no Stockfish), prefer a "defend your move" framing over
  a false single-best-answer. Honesty about uncertainty is the credibility, not a fake certainty.

### 5d. Rep-facing relevance (output — the adoption payoff)
- Once approved, the rep's puzzles and role-play personas are the *company's*. First session serves
  a company puzzle. The role-play buyer argues with the company's real objections.
- **Vertical adaptation falls out here for free:** a healthcare/fintech/security customer inputs
  their context; the only net-new is compliance copy + the higher security bar (§7).

**Acceptance:** an admin can go from zero to an approved, company-specific persona + a handful of
reviewed puzzles in under ~15 minutes, and a rep's first session is visibly about their product.

---

## 6. Phase 3 — The retention engine: assignment + the trustworthy leaderboard

### 6a. Assignment (makes the mandate real)
- Manager assigns a theme + cadence to individuals or the team in two taps.
- **Auto-assignment default (critical):** if the manager is passive, the system still assigns each
  rep a short daily drill computed from *their* weakest themes (`themeStats`/`missedPuzzleIds`)
  crossed with the company's priority objections. The product must work without an active manager,
  because many managers will be passive — but it must reward an active one.
- Completion is visible to the manager (the renewal-defensible "they're using it" signal).

### 6b. The leaderboard (the "measure closers" ask — done so it motivates, not demoralizes)
- Ranks on the **server-recomputed** rating (untrusted client → see §7; a leaderboard on a
  forgeable score is worse than none, and the judge had to be made injection-proof for exactly
  this reason).
- **Design for "everyone improves," not raw bottom-shaming:** show the rep their rank *neighborhood*
  (a few above/below), their **personal best**, **most-improved this week**, and tier bands — not a
  naked full-team ranking that tells the bottom third they're last. The manager wants the whole team
  to climb; the board should make every rep feel a reachable next rung.
- Optional later: an **anonymized cross-company "global closer rank"** — the portable-credential
  white-space no competitor owns (a rep's rating follows them; a "verified Grandmaster Closer"
  recruiting loop is a moat an incumbent can't copy without rebuilding their GTM).

### 6c. The relevance-driven habit (what actually produces daily opens)
- Notifications name the relevance ("5-min drill: discount objection on [product]"), never generic.
- The streak + the leaderboard-neighborhood nudge + the assigned drill compose the return loop.
  No hearts; the rating drop is the only "cost," and it's informational, not a lockout.

**Acceptance:** a rep with a passive manager still gets a relevant daily drill; an active manager
can assign and see completion; the leaderboard moves on a score that can't be forged.

---

## 7. Cross-cutting requirements (the no-mistakes guardrails — apply to every phase)

- **Tenancy & data security.** You are now storing customers' *sales* data (products, objections,
  maybe call snippets). That's sensitive, and the chosen verticals (healthcare/fintech/security)
  raise the bar further. Multi-tenant isolation, encryption at rest + in transit, a DPA, and the
  SOC 2 clock (start it when Phase 0 lands, not when a deal needs it). The privacy posture flips
  from "all on-device" to "we hold customer business data" — design for it from day one.
- **Trust = server-side.** Every number that confers status or costs money (ratings, entitlements)
  is recomputed/verified server-side. The client is untrusted. The leaderboard *requires* this.
- **Credibility = the quality gate.** Auto-generated content with a wrong "best move" destroys
  trust on first contact with a real VP. The §5c review gate is the single most important quality
  control in the whole plan. Never auto-publish unreviewed generated content.
- **Cost governance.** Per-company generation + per-rep play both hit the owner's key. Separate,
  capped budgets; the kill-switch from `SECURITY.md`; monitor spend per org.
- **Expectation setting.** "Train" = configure/ground, not ML fine-tuning. Message accordingly.

---

## 8. Self-scrutiny — the risks and the hardest unsolved problems (read this twice)

- **The auto-generated single-best-answer problem is the deepest risk.** Sales has no Stockfish;
  a generated "best move" is one model's opinion dressed as fact. Mitigations: the human review
  gate (§5c), constraining generation to the doctrine's defensible patterns, confidence flags, and
  a "defend your move / experts may differ" framing for contested items. Be honest internally that
  at scale this is the quality ceiling — over-promising "research-graded" on auto-generated content
  is how a sharp buyer catches you. Under-claim and let the review gate carry it.
- **Cold-start.** A brand-new org has no leaderboard data, no rating history, no reviewed content.
  Bridge with the generic ladder + a fast first-session relevance win + "your first week" framing
  so day one isn't empty.
- **Manager passivity.** If usage depends on an active manager, most teams churn. The auto-assign
  default (§6a) is the hedge; the product must be valuable to a rep whose manager does nothing.
- **Input burden vs relevance.** Ask for too much up front and the admin abandons setup; ask for
  too little and the content is generic. Progressive enrichment (minimal to start, add over time)
  is the resolution — but watch the drop-off in the setup funnel and keep the minimum truly minimal.
- **Competition can demotivate.** A raw rank shames the bottom; the §6b "everyone improves" design
  is the mitigation. Test it — if reps in the bottom half stop opening the app after the board ships,
  the design failed.
- **Generation cost** can balloon per org; cap and monitor.
- **The privacy flip** is a real reputational exposure for a femtech-adjacent... (not this app, but
  the same discipline) — for a sales tool holding deal data, a leak is a B2B-trust crisis. Treat
  customer data as you'd treat the API key.

---

## 9. Sequencing & dependency map (do not reorder)

```
Phase 0  Foundation (proxy + accounts + per-seat + server-side rating)   [GATED on accounts/$]
   │  unlocks everything
   ├─► Phase 1  Team visibility (manager dashboard on existing themeStats)
   │        │ precondition for assignment + leaderboard
   ├─► Phase 2  Company-trained content (interview → generate → REVIEW GATE → rep relevance)
   │        │ the moat + the adoption fix; depends only on Phase 0 (accounts + proxy)
   └─► Phase 3  Retention engine (assignment + auto-assign + trustworthy leaderboard + habit)
            │ depends on Phase 1 (visibility/sync) + Phase 0 (server rating)
Phase 4 (later)  CRM/call ingestion, web authoring, SOC 2 for enterprise, global rank
```
Phase 2 and Phase 1 can proceed in parallel after Phase 0. Phase 3 needs both.

## 10. Success metrics (how you'll know it's working, per phase)
- **Activation:** % of licensed reps who open within 48h of receiving a seat (relevance hook works).
- **Adoption / the renewal tell:** weekly-active reps per org (the #1 churn predictor — watch
  last-active religiously).
- **Relevance proxy:** share of sessions on company-trained content vs generic.
- **Skill signal:** pre/post on the held-out benchmark (the honest efficacy claim — `DIAGNOSIS`
  P2-2); never claim quota lift from a correlation.
- **Habit:** streak length distribution, daily-drill completion rate.
- **Competition health:** leaderboard engagement AND bottom-half retention (if the bottom half
  churns after the board ships, the design is wrong).
- **Business:** seat expansion within an org, logo renewal at 90–180 days.

## 11. Open decisions for Marion (the genuine forks — decide before building the dependent phase)
1. **Pricing/packaging:** per-seat tiers, and whether there's a free individual funnel (PLG) feeding
   teams, or pure top-down. (Affects Phase 0 billing + whether any B2C surface exists.)
2. **How much admin review to force** in the §5c gate: approve-every-item (max credibility, more
   setup friction) vs approve-by-exception with auto-publish above a confidence bar (faster, riskier).
   Recommendation: start strict (approve every item); loosen only with data.
3. **Cross-company global rank** (the portable credential) — build it (white-space moat) or skip for
   focus? Recommendation: skip in v1, design the rating so it's possible later.
4. **Beachhead vertical beyond IT-SaaS** — which of healthcare/fintech/security first? Drives the
   first compliance + SOC 2 investment.
5. **Build vs. buy the backend** — roll your own proxy/accounts/billing vs. a BaaS (Firebase/Supabase
   + RevenueCat for receipts). Recommendation: BaaS + RevenueCat to reach revenue faster; the
   `SECURITY.md` contract still applies to whatever you choose.

---

The through-line: every high-leverage item here converges on the same prerequisite (the backend)
and the same insight (relevance + mandate beat a generic library). Build the foundation, make the
content the customer's own behind a strict quality gate, and wrap it in a manager-driven, everyone-
improves competitive loop. Hold the credibility line (the review gate) and the trust line (server-
side everything), and the tired rep finally has a reason to open it tomorrow.
