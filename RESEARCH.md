# Frame & Fork — External Research Synthesis

The business-leverage layer above the finished craft. Four parts: competitive white-space,
enablement-buying must-haves, a concrete transfer/efficacy-measurement design, and a defensible
role-play scoring + debrief design. Sources kept inline.

---

## 1. Competitive white-space

### The category's shared shape (the opening)
Every meaningful AI sales-training player sells **top-down enterprise enablement**: opaque
"book-a-demo" pricing, per-seat contracts, manager-assigned reps, dashboards that report up.
They all lead with the **expensive, high-friction artifact — a full voice/video role-play call**
(mic on, minutes long, recorded, scored). The thin self-serve tier is an afterthought. That
shared shape is the structural opening.

| Player | Model | Pricing | Notes |
|---|---|---|---|
| **Hyperbound** | AI roleplay + real-call scoring, "Revenue Activation Platform" | enterprise ~$15K/yr+, capability behind "Custom" | best free-bot funnel (9 bots, no card); real-call ingestion; cleanest manager dashboard |
| **Second Nature** | video/on-camera roleplay, Salesforce AppExchange | est. $30–40/seat/mo, ~$20K min ACV | raised $22M Oct 2025; funded incumbent |
| **Quantified.ai** | roleplay + objective scoring for regulated verticals | est. $85–150+/seat/mo | ComplianceGuard auto-fail; published competency rubric; "assessment-grade reporting" |
| **PitchMonster** | roleplay from your best/worst calls, gamified | ~$1,200/quarter, team min | most SMB-friendly; reviewers say feedback skews speech-mechanics over strategy |
| **Luster.ai** | "Predictive Enablement", schedules practice | none public | predictive skill-gap framing |
| **Replicate Labs** | methodology-coded coaches (Gap Selling) | **Individual $59/mo, Team $75, Ent custom** | rare transparent + individual plan |
| **FullyRamped / Kendo / SellMeThisPen** | ramp roleplay / self-serve / prosumer BYOK | ~$55/seat/mo; SellMeThisPen 1–4 seats BYOK | the only ones near prosumer |
| **Mindtickle / Highspot / Bigtincan** | enablement suites bolting roleplay onto an LMS | 5–6 figure ACV | incumbents |

### Three structural gaps F&F can win on
1. **No light top-of-funnel.** Nobody has chess.com's free *puzzle* — a 10-second, no-mic,
   no-cost, async rep. Hyperbound's free bots are still full calls. F&F's 100-puzzle / daily-drill
   funnel **costs nothing to serve** (offline, no API) — the exact economics that let chess.com
   give puzzles away forever and convert later.
2. **No portable rating.** Every competitor's score is **locked in the employer's dashboard and
   dies when the rep changes jobs.** Nobody owns a public, cross-user, portable closer rating.
   F&F already runs Glicko-2 + a 9-band title ladder + a ShareCard — the makings of a credential
   that follows the rep (and a later "hire a verified Grandmaster Closer" recruiting loop no
   incumbent can copy without rebuilding their GTM).
3. **Shallow feedback / depth.** Recurring review complaint: "robotic personas," "speech-mechanics
   over strategy," "less actionable insight." F&F's Atlas (40 graded/cited techniques with
   contraindications), 5 annotated master games, evidence badges, SRS-of-misses, and the earned
   verdict reveal are the chess.com *Lessons + Analysis* layer the roleplay-only tools lack.

**The wedge:** be the only product that owns the **individual rep before the org buys** — a free
habit-forming puzzle funnel, a rating that's theirs to keep, and metered role-play — then PLG into
a category that only knows how to sell top-down.

*Sources:* [Hyperbound pricing](https://www.hyperbound.ai/pricing) · [AgentRank Hyperbound review](https://www.agentrank.tech/blog/hyperbound-review-ai-sales-roleplay-training) · [Second Nature pricing (Alpharun)](https://www.alpharun.com/blog/second-nature-ai-pricing) · [Second Nature $22M (SiliconANGLE)](https://siliconangle.com/2025/10/17/second-nature-raises-22m-ai-sales-training-platform/) · [PitchMonster pricing](https://www.pitchmonster.io/pricing) · [Quantified (Software Finder)](https://softwarefinder.com/sales-tools/quantified-ai) · [Luster](https://www.luster.ai/) · [Replicate Labs (Prospeo)](https://prospeo.io/s/replicate-labs-pricing-reviews-pros-and-cons) · [FullyRamped pricing](https://fullyramped.com/pricing) · [Kendo — best roleplay tools](https://kendo.ai/blogs/best-ai-sales-roleplaying-tools) · [SellMeThisPen pricing](https://www.sellmethispen.ai/pricing) · [Mindtickle — best roleplay tools](https://www.mindtickle.com/blog/best-ai-role-play-tools/) · [PLG vs SLG (GTM Playbook)](https://discover.gtmplaybook.co/bottom-up-vs-top-down-adoption) · [McKinsey — product-led sales](https://www.mckinsey.com/industries/technology-media-and-telecommunications/our-insights/from-product-led-growth-to-product-led-sales-beyond-the-plg-hype)

---

## 2. Enablement-buying must-haves (what gates a B2B dollar)

### Who actually buys (it's a committee, ~13 stakeholders)
- **Champion / owner:** Sales Enablement Manager — runs the eval, cares about rep adoption and
  looking good. Cannot champion a tool that gives them *zero rep visibility*.
- **Economic buyer:** VP Sales / CRO / RevOps — signs; cares about ramp, quota, risk, not features.
- **Budget gate:** demands ROI proof, cost justification, predictable payback.
- **Blocking buyer:** IT/Security/Procurement — a *different* person who can disqualify you before
  the functional eval (SSO/SOC 2). The classic kill: champion loves the demo, Security's checklist
  ends it.

### What drives RENEW vs CHURN
Renewal is driven by **visible behavior change + adoption, not content quality.** The dominant
churn tell is **gradual disengagement (reps stop logging in)** — "hardest to spot, most important
to catch early." Surface *last-active* prominently. Customers who fully adopt churn less; CSMs
renew when they can pull adoption + skill data in one system and intervene 60–90 days early.

### The #1 substantive buying criterion for *training* tools: forgetting-curve reinforcement
Reps lose ~70% of training within a day, ~84–90% within 90 days. The category sells on **spaced
reinforcement + manager-embedded practice**, and reframes the standing objection ("no time for
daily practice") as a priority problem solved by short, assignable reps. **This is the one
criterion where F&F is already architecturally ahead** — the SRS/spaced-serving engine
(`Store.missedPuzzleIds`, `themeStats()`, Glicko 75–85% serving in PUZZLE-DOCTRINE) *is* a
forgetting-curve machine. It just isn't packaged or assignable.

### ROI proof buyers expect (in order of prevalence)
Time-to-productivity / ramp (68%) · tool usage rate (64%) · win-rate by skill area (61%) · quota
attainment (59%) · deal size, cycle length, revenue per rep. Anchors: ~4:1 ROI for mature
programs; impact shows in 90–180 days; they expect *attribution*, not vanity logins.

### Ranked must-haves (each notes the codebase blocker)
1. **Kill BYO-key → vendor-hosted LLM + per-seat billing.** The largest, most upstream blocker.
   No enterprise lets reps paste personal keys (no central billing, unpredictable cost, a security
   finding on its face). Until there's an account + paid-seat construct there is nothing to fund.
   (`Keychain.hasAPIKey()`, `AnthropicClient.swift`.)
2. **Multi-tenant backend: org accounts, auth, roster.** Everything depends on it. (Today:
   single-player, UserDefaults, `Storage.swift`.) `ENTERPRISE-ROADMAP.md` Tier 1.
3. **Manager dashboard: per-rep skill + the adoption signal.** The renewal engine + the champion's
   reason to buy. Data already designed for it (`themeStats()`, `solves`, `GameRecord.evalCurve`,
   Glicko trajectory) — it just has to flow to a manager view. Lead with *last-active*.
4. **SOC 2 Type II + SSO/SAML + SCIM.** The procurement gate that disqualifies before functional
   eval. Start the SOC 2 clock the day the backend lands (3–6 mo, uncompressible).
5. **ROI / outcome reporting** (ramp, adoption, win-rate-by-skill, pre/post improvement) with the
   90–180-day / 4:1 framing built in. Seed from on-device analytics; aggregate server-side.
6. **Manager-assignable spaced-reinforcement cadence** — productize the forgetting-curve wedge
   (F&F's sharpest differentiator, closest to shipped). Assign a daily 5-min themed drill + see
   completion. This is the language the category buys in.
7. **CRM integration (Salesforce/HubSpot).** A value multiplier, not a gate: seeds content from a
   team's own loss data and bridges practice scores to real outcomes for the attribution in #5.
8. **Certification / competency rubric tied to a named framework.** Packaging on assets you already
   own (evidence-graded Atlas + Glicko title ladder) → manager-issued "certified on cold-open."

*Sources:* [Aircover — buyer roles](https://www.aircover.ai/blog/buyer-roles) · [Brevet — death of the economic buyer](https://blog.thebrevetgroup.com/death-of-the-economic-buyer) · [Dock — who owns enablement](https://www.dock.us/library/who-owns-sales-enablement) · [Traction Complete — buying committee](https://tractioncomplete.com/articles/mapping-the-b2b-buying-committee/) · [Gainsight — churn guide](https://www.gainsight.com/essential-guide/churn/) · [Salesforce — customer churn](https://www.salesforce.com/sales/analytics/customer-churn/) · [Proactive Training — spaced reinforcement](https://proactivetrainingsolutions.com/salespeople-forget-training-spaced-reinforcement/) · [sales-coach.ai — forgetting curve](https://sales-coach.ai/blog?lang=en&post=016-sales-training-transfer-problem-forgetting-curve) · [Articulate — enablement KPIs](https://www.articulate.com/blog/sales-enablement-kpis/) · [Highspot — enablement ROI](https://www.highspot.com/sales-enablement/sales-enablement-roi/) · [Dock — enablement metrics](https://www.dock.us/library/sales-enablement-metrics)

---

## 3. Transfer / efficacy-measurement design (the claim you can defend)

### The honest standing
"Makes you close better" is a transfer claim (Kirkpatrick L3/L4). The load-bearing finding is the
**decoupling between levels**: strong L1 reaction predicts almost nothing about L3 transfer, and
**engagement ≠ learning** — time-on-app, logins, streaks, session length do *not* correlate (and
sometimes negatively correlate) with skill gain. F&F's whole juice/streak/Glicko layer lives in
exactly the metrics that *look* like learning and aren't. Transfer to the job is ~10–20% of what's
trained and decays; far transfer from a decontextualized computerized task (a multiple-choice
puzzle) to a live deal is the case the evidence is *most* skeptical of.

| Level | Requires | F&F today | Status |
|---|---|---|---|
| L1 Reaction | engagement | streaks, Glicko climb, verdict juice | supported — but means least |
| L2 Learning | valid skill measure | Glicko on puzzles | **construct-invalid** (bank is guessable) |
| L3 Behavior | applied on real calls | nothing | zero |
| L4 Results / L5 ROI | closed-won, isolated | nothing | zero |

**The strategic fact:** the enterprise thesis sells L4 ("correlates to closed deals") on L2
instrumentation that isn't even valid yet. That's the overclaim a RevOps analyst catches in
diligence.

### What to instrument — concrete, against the real data model

**Step 0 — construct-validity gate (precondition).** No efficacy claim is possible on a guessable
instrument. Ship the non-guessable bank from PUZZLE-DOCTRINE first, then *prove* it with
item-discrimination stats computable from existing `PuzzleState.solves`: point-biserial per item
(does getting this item right correlate with overall rating?) + difficulty drift. Add
`Store.itemDiscrimination()` beside `themeStats()`. This turns "we have ratings" into "we have a
measured psychometric instrument."

**Client-side, no backend, ship now:**
1. **Separate engagement from learning at the schema level.** Tag every metric L1 vs L2; never
   co-mingle them in a dashboard. Streak/time = adoption; learning = first-exposure accuracy on
   never-seen items + delayed-retrieval accuracy.
2. **Sealed held-out benchmark set (the keystone).** Carve ~24 adjudicated items into a "Benchmark"
   set **never served in Daily / Browse / SRS.** Run it as a timed assessment at onboarding (pre)
   and every ~30 days (post). Because the rep only ever sees these items in the benchmark, the
   score can't be inflated by practice — it isolates *transferable skill* from *item familiarity*.
   Practice-bank rating = the engagement number; held-out rating = **the efficacy number.** New
   `BenchmarkRun { date; setVersion; score; perTheme; rd }`. Ships client-side; this is the literal
   answer to "how would we KNOW."
3. **Retention/decay curve.** You store `solvedAt` and have an SRS queue; instrument *delayed
   retrieval* — when a concept is re-served after a gap, record correct/incorrect tagged with the
   interval. `Store.retentionByInterval()`. The only in-app signal that survives the
   engagement-gap critique, and the renewal story managers actually believe.
4. **Calibration capture.** Optional one-tap confidence before the verdict reveal → Brier score /
   over-confidence index. Converts a weak self-report into a *measured*, coachable miscalibration
   metric. (Self-report/self-efficacy is only a proxy for *past* performance — never a competence
   measure.)
5. **Role-play behavior ledger (near-L3 proxy, not L3).** `GameRecord` already carries
   `intentTechniques` vs `firedTechniques` + `evalCurve`; instrument technique-application-rate
   under pressure + recovery-after-a-losing-turn. Label it *simulated*, but it's the most
   contextualized surface (the literature's condition for transfer).

**Backend / enterprise (the real validation design):**
6. **True L3 = the transfer bridge: run the Atlas detector over the rep's REAL calls.** Reuses
   `DetectorLocal` + the Atlas you already own. Paste-a-transcript MVP can start client-side
   (Gong/Salesloft later). Score practice and real calls with the *same* model → "before training
   this rep labeled emotion on 8% of objection moments; after 4 weeks, 34%." Same behavior the
   puzzles drill, appearing on real calls = L3 measured directly. (~70% detector accuracy is fine
   as a *rate over many calls*, not a per-call verdict.) A manager *critical-behaviors checklist*
   against a recorded call is the gold-standard human L3.
7. **Required drivers are a feature, not overhead.** Assignments + certification + manager nudges
   *are* New World Kirkpatrick's "required drivers" — the systems that *cause* transfer. Reframes
   the Tier-1 roadmap items from "table-stakes plumbing" to "the mechanism of efficacy."
8. **L4 done defensibly = stepped-wedge rollout, not correlation.** "Correlate rating with
   closed-won" dies on selection bias (motivated reps train AND win anyway). Instead, **stagger
   access in 2-week randomized waves** when a team onboards — each rep is their own control,
   staggered starts cancel the "good quarter" confound. Costs only a rollout schedule + the CRM
   join. Claim: "win-rate rose X pts in the 8 weeks after a rep's access wave vs the 8 before,
   controlling for wave." You can't retrofit this after rollout — design it in before the first
   team onboards.
9. **Leading-indicator proxy** so ROI shows in weeks: Atlas-detected behavior (leading) + a fast
   CRM micro-outcome (stage-advance, multi-thread added, next-meeting booked), reported with n and
   lag, labeled `[correlational]`.

### Claimable vs overclaiming
- **Claimable (post non-guessable rewrite + discrimination + benchmark):** "a rated, reliable
  instrument that measures whether a rep can identify the higher-EV move"; "improves *retention* of
  technique recognition over time"; "calibrates over-confidence"; all L1 metrics *labeled as
  engagement.*
- **Overclaiming — flag before any deck ships:** "improves close rates/quota/revenue" (far-transfer
  L4 with zero transfer instrumentation); Glicko on the guessable bank as "skill"; streak/time as
  proficiency; self-reported confidence as competence; any ROI number without a control/baseline.

**The business reframe:** stop promising a lagging outcome you can't isolate; own the **validated
leading indicator**. "We measure a reliable, decay-tracked skill signal and prove its correlation
to *your* pipeline with a control cohort" is both more honest and harder to attack than "we lift
quota." Every competitor overclaims the outcome — **shipping the efficacy proof itself
(item-discrimination report + retention curves + stepped-wedge readout) is a category-
differentiating artifact no competitor hands the buyer.**

*Sources:* [Devlin Peck — Kirkpatrick](https://www.devlinpeck.com/content/kirkpatrick-model-evaluation) · [Kirkpatrick Partners — New World model (PDF)](https://www.kirkpatrickpartners.com/wp-content/uploads/2021/11/Introduction-to-The-New-World-Kirkpatrick%C2%AE-Model.pdf) · [Baldwin & Ford 1988 — transfer review (PDF)](https://flip.tools/wp-content/uploads/2023/11/01.-Transfer-of-training-1988_Baldwin-Ford.pdf) · [The 10% delusion (ResearchGate)](https://www.researchgate.net/publication/264267034) · [arXiv — predicting outcomes from EdTech logs](https://arxiv.org/html/2412.15473) · [Open Praxis — engagement time vs achievement](https://openpraxis.org/articles/10.5944/openpraxis.11.2.920) · [Pitt LRDC — self-report bias](https://www.lrdc.pitt.edu/Departments/Communications/featured-briefs/How-Self-report-Measures-Can-Be-Biased) · [PubMed 15998181 — self-efficacy ≈ past performance](https://pubmed.ncbi.nlm.nih.gov/15998181/) · [Yale Poorvu — transfer of knowledge](https://poorvucenter.yale.edu/transfer-of-knowledge-to-new-contexts) · [NCBI — cognitive-training transfer RCT](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10637678/) · [Whatfix — Phillips ROI](https://whatfix.com/blog/phillips-roi-model/) · [Training Industry — sales training ROI metrics](https://trainingindustry.com/articles/sales/proving-the-roi-of-sales-training-metrics-that-matter/)

---

## 4. Defensible role-play scoring + debrief design

Scope: the `Play` tab (`LiveGameView` → `SimpleReviewView`), the weakest surface. Current flow:
local regex detector → per-turn eval shift → terminal eval → win/draw/loss → Glicko. **The LLM
writes the buyer's reply; it never judges the rep.** That's the gap and the leverage.

### How the best products score
Methodology-anchored **scorecards**, not holistic vibes — rubric built around a named methodology
(MEDDIC/BANT/SPIN/Challenger/Sandler) and per-stage (discovery ≠ demo ≠ negotiation). The general
method underneath is **LLM-as-judge with rubric decomposition + reasoning-before-score (G-Eval)**:
the judge reasons through explicit criteria first, then scores; exemplar answers anchor consistency;
criteria broken into binary sub-decisions to cut variance.

### Where they fail (the four, with mechanism)
- **Sycophancy / gaming.** LLM judges systematically inflate — verbosity bias swings preference
  15–30 pts for longer answers, position bias 10–15, plus self-preference, bandwagon, authority,
  leniency drift. The role-play-specific version is worse: if the call that *plays* the buyer also
  *scores* the rep, the buyer "wants to be helpful" → caves → praises. **F&F's regex referee
  accidentally dodges this — but adding naive LLM scoring walks straight into it.**
- **Generic feedback.** "Rate 1–10 + advice" is interchangeable. Fix: decomposed, *evidence-
  anchored* criteria where the judge must **quote the exact turn** that earns/loses each point —
  no quote, no credit.
- **Unrealistic personas.** Top rep complaint: "feels fake," bots cave, can't handle the
  unexpected. A bot persuaded by any textbook move is both unrealistic *and* the root of score
  inflation.
- **No transfer.** Behavioral Skills Training needs instruction + modeling + rehearsal + feedback;
  transfer from sim needs deliberate practice, variability, and a *structured debrief*, not a score
  dashboard.

### The design (concrete enough to build)

**4a. Split the buyer from the judge (non-negotiable).** Add a **second, separate** judge pass at
game end: one call, full transcript, own system prompt, structured JSON out. Keep the regex
detector for the live coarse conviction bar (free/instant/offline). Marginal cost = one extra
Claude call/game (~$0.75–1.00 total), not per-turn. New `judgeTranscript()` in `AnthropicClient`,
new `Engine/RubricJudge.swift`, parsed into a `RubricResult` on `GameRecord`. The judge is **blind
to** the rep's pre-registered `intentTechniques` (else it rationalizes intent into credit) and the
live eval bar (else it anchors on outcome). It sees only the transcript + the persona's *public*
profile.

**4b. Score PROCESS, not just OUTCOME — and gate the rating on process.** Today `score` = terminal
eval = did you win → a sycophantic buyer hands you inflated ELO. Split:
- **Outcome** (did the deal concretely advance) — cheap, from terminal state.
- **Process** (rubric quality) — **the Glicko update is gated on this.** A rep who closes a buyer
  that should not have closed gets high-outcome/low-process and a flat-to-negative rating move.
  This single change makes the number trustworthy enough to put on a manager dashboard, and it's a
  clean marketing line: *"your rating doesn't move just because the bot was easy."* It's the honest
  differentiator vs Hyperbound/Second Nature, which score the call you *had*.

**4c. The rubric — decomposed, anchored, mapped to assets you own.** Five criteria, each 0/1/2 with
a **required verbatim quote** (no quote → forced 0):
1. **Diagnosis** — surfaced the persona's stated *and hidden* criteria before pitching (both fields
   already modeled in `Personas.swift`).
2. **Buyer-state fit** *(load-bearing)* — moves matched valence/certainty/agency/persuasion-
   knowledge. This is the exact thesis PUZZLE-DOCTRINE was forced to ("the key is buyer-state fit;
   evidence only seeds tempting distractors"). The judge should inherit that doctrine **verbatim**
   so puzzle and role-play teach the same lesson.
3. **Objection handling** — acknowledged/labeled before reframing; no premature rebuttal.
4. **Advancement** — secured a concrete next commitment, not "I'll think about it."
5. **Restraint** *(anti-gaming)* — did NOT technique-spam, over-talk, or reflex-discount.

**4d. Anti-gaming, built in.** Don't show the rep a precise live eval number (same logic that
killed the puzzle "pick-biggest-number" leak, doctrine §0.3 — the coarse bar is fine, a `+0.40`
ticker invites gradient-hacking the words). Restraint criterion docks technique-naming theater.
Keep the rubric **hidden pre-game** (reveal only in debrief) so reps don't train to the test. Give
each persona a **hidden resistance budget** that depletes only on buyer-state-fit moves + a forced
curve-ball + a non-zero chance of *not* being moved by a textbook-correct line (variability →
transfer). Make the existing `narrative arc` + `hidden curve ball` fields mandatory-fire and
budget-gated — this fixes "feels fake / caves" *and* inflation simultaneously.

**4e. Calibration (what lets you ever say "validated").** Reuse the ≥3-expert-closer adjudication
already specced for puzzles to label ~30–50 held-out role-play transcripts. Measure judge-vs-expert
agreement; tune the rubric prompt until acceptable; **pin the model version** (leniency drifts —
`claude-opus-4-8` is the judge baseline); use 2–4 expert exemplar transcripts as few-shot anchors
(never one — single reference makes "the ideal answer the only acceptable answer"). This labeled,
expert-adjudicated set is itself a defensible asset a prompt-wrapper can't cheaply copy.

**4f. The debrief that teaches — PEARLS, not a dashboard.** Rebuild `SimpleReviewView`:
1. **Focus on 1–3 pivotal turns** (largest eval swings + biggest miss; judge returns indices) —
   deliberate practice concentrates on the decisive moment, not even coverage.
2. **Plus-delta self-assessment first** — before revealing the verdict on a pivot, ask "what worked
   / what would you change?" (generation effect raises retention, lowers defensiveness).
3. **Advocacy-inquiry per pivot** — not "wrong move," but observation + ask rationale: *"You went
   to a discount on turn 6 — what did you read that made price the lever?"* then show the buyer's
   actual hidden state + the model line + which Atlas technique fit and why.
4. **Rewind-and-redo the pivotal turn** (Rapid-Cycle Deliberate Practice) — re-run just that one
   exchange against the same persona state. Highest-transfer mechanic, nobody in the consumer space
   ships it, one extra short call. This turns a score into a skill.
5. **One concrete next assignment** — route the missed concept into `Store.missedPuzzleIds` or serve
   the matching puzzle theme. The debrief hands the rep their next rep.

### Business leverage
The **judge + calibration set is the moat; the puzzles are commoditizable.** A calibrated, anti-
sycophantic, evidence-anchored role-play score that survives manager scrutiny is what an enterprise
pays for and the precondition for the `ENTERPRISE-ROADMAP` dashboard — a sycophantic score destroys
trust on first use, so this *gates* the roadmap rather than running parallel. The eventual real bar
is **criterion validity** ("in-app score predicts real-world improvement") — cheap proxy now: log
whether role-play process-score predicts later puzzle-accuracy gains (instrument it before you have
analytics so the claim is available later).

**Build order (smallest defensible slice first):** (1) `RubricJudge.swift` + `judgeTranscript()`
(separate, blind, 5-criterion JSON with required quotes) → store on `GameRecord` — note this
*requires* persisting `turns`, the same one-field unlock as the content flywheel; (2) gate Glicko on
process, split outcome vs process; (3) rebuild `SimpleReviewView` as PEARLS; (4) persona resistance
budget + forced curve-ball; (5) rewind-the-pivot RCDP; (6) calibration set via ≥3-closer
adjudication, pin model, few-shot anchors.

*Sources:* [Hyperbound — call scoring framework](https://www.hyperbound.ai/blog/ai-call-scoring-framework) · [Hyperbound — roleplays redefining enablement (rep criticism)](https://www.hyperbound.ai/blog/how-ai-roleplays-are-redefining-sales-enablement-in-2026) · [Second Nature — product](https://secondnature.ai/product/) · [Evaluating Scoring Bias in LLM-as-a-Judge (arXiv)](https://arxiv.org/pdf/2506.22316) · [Self-Preference Bias in Rubric Evaluation (arXiv)](https://arxiv.org/pdf/2604.06996) · [12 LLM-judge biases (Channel)](https://www.channel.tel/blog/llm-judge-12-biases) · [G-Eval guide (Confident AI)](https://www.confident-ai.com/blog/g-eval-the-definitive-guide) · [Rulers — locked rubrics + evidence-anchored scoring (arXiv)](https://arxiv.org/html/2601.08654v1) · [Criterion Validity of LLM-as-Judge for Business Outcomes (arXiv)](https://arxiv.org/pdf/2604.00022) · [Behavioral Skills Training](https://www.gratefulcareaba.com/blog/behavioral-skills-training-bst-in-aba-therapy) · [Transfer from simulation (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8285558/) · [Rapid Cycle Deliberate Practice (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8651942/) · [PEARLS debriefing (Debrief2Learn)](https://debrief2learn.org/resources/promoting-excellence-and-reflective-learning-in-simulation-pearls-a-blended-approach-to-debriefing/)
