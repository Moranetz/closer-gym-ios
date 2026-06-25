# Frame & Fork — puzzle design doctrine (working draft)

Started 2026-06-25 in response to "too on the nose / make the player feel smart and earn
it / not guessable." This is the spine; chess-science, sales-mastery, distractor-science,
and game-feel research are folding in as the loop runs. Self-critique is inline and ongoing.

---

## 0. Core corrections (post red-team) — these OVERRIDE anything below that conflicts

An adversarial red-team broke the first draft. The fixes, in priority order:

1. **The key is set by BUYER-STATE FIT, not by evidence-grading.** The first draft's headline
   — "the best move is the evidence-backed one; the folklore move is the trap" — is refuted by
   all four of its own exemplars, where the best move is *unevidenced* (labeling, silence,
   takeaway, assumptive) and the trap in §4 is the *evidenced* technique (gain-framing +
   social-proof) **mis-targeted.** Resolution: **fit determines the key, full stop.** Evidence
   is demoted to two jobs only: (a) seeding which distractors are *tempting-because-popular*,
   and (b) optional reveal color. There are therefore *two* recurring trap patterns, neither a
   law: the slick folklore move, AND the genuinely-strong technique aimed at the wrong moment.
2. **"The reflex is the trap" is a GENERATOR for the minority of hard items, not a truth about
   sales.** Most trained reflexes are correct — that's why they're trained. Engineer the
   minority case; don't invert "experts are sometimes instructively wrong" into "experts are
   systematically wrong" (that's the same dogma as "always ask a calibrated question," pointed
   the other way). Only a minority of the bank should punish the instinct.
3. **Counter-balance the MOVE axis, not just the form axis.** Otherwise the new tell becomes
   "pick the do-less / withholding / contrarian / most-meta option" — a *stronger* leak than
   the 98% length tell. Hard rules: do-less/withhold keys **≤40%** of the bank; for every
   "silence wins" item author a **do-more twin** where the assertive move wins; decouple
   "names the hidden variable" from correctness; **never render numeric evals to the player.**
   **Release gate:** 5 non-salespeople score **<60%** after 30 items, or the meta-game is alive.
4. **Force the context in the stem.** Single-best-answer can't represent context-dependence, so
   put segment (SMB/mid/enterprise) + leverage + trust + buyer-sophistication *in the stem* so
   the one answer is actually forced. Genuinely contested items go to a **"defend your move"**
   format (pick → see the expert distribution + the conditions each move is right under), never
   the rated ladder. Sales has no Stockfish; don't pretend it does on contested items.
5. **Adjudication protocol = the real "research-graded."** Every rated-ladder key needs **≥3
   expert closers independently (blind) picking the same option before the rationale is
   written**, with a recorded agreement rate. <~70% agreement → add stem context until it
   clears, or reclassify as a "discussion" item. Publish the agreement rate.
6. **Cover-the-options is a HARD GATE** (an independent expert derives the key from the stem
   alone). The first-draft exemplars *fail* it (you can't derive silence-over-question from
   Ex.2's stem). On-ramp **success floor ≥75%** for the first N items and each new theme's
   first item — reserve the 50%-band + instinct-traps for higher tiers where the schema exists.
7. **Drop Glicko-on-items at this scale.** 100 items can't converge RD, and solve-rate
   confounds difficulty with guessability and ambiguity (it can't tell *hard* from *broken*).
   Instead use **author-difficulty ↔ solve-rate GAP as a leak detector** (high solve-rate on a
   "hard" item = guessable → rewrite). Gate true item-rating behind a ~1000-item bank + real DAU.
8. **Stats honesty + no research-costume to users.** Cite effect sizes *with* uncertainty (CI,
   P(μ>0)) or not at all — social-proof's 95% CI crosses zero (−0.21→1.30) and its posterior
   used k=2, not the n=47 screening count. Tag every empirical anchor **[correlational]** vs
   **[RCT]**; a correlational Gong finding can make a distractor *tempting*, never make a move
   *wrong*. **Never surface μ/τ/PRISMA/Glicko jargon in the app** (it's intimidation to a sales
   audience and misused-stats to a quant one — and violates the anti-research-costume voice
   rule). Keep the rigor internal; the reveal speaks plain coach.
9. **Don't over-anchor on Voss or on Gong medians as laws.** Voss is one (contested) school;
   draw the house voice from multiple closers. "Price early," "raise competitors early," "fewer
   questions" are deal-type-specific medians, not universals — teaching them as laws trains the
   bad reflex the app exists to fix. **Segment-tag every item.**
10. **Production reality:** each item to this bar is ~2–4 expert-hours. v1 = **~150 genuinely
    unguessable, adjudicated items** (not 1000); adaptive serving + Rush are explicitly post-v1
    and depend on bank size. 150 unguessable beats 100 adaptive-but-guessable.

**Addendum (psychometric research, post-loop) — three refinements:**
- **A1. Success target = ~75–85%, not 50%.** 50% is the optimum for *measuring* ability; this
  is a *learning* game, where the rigorously-derived learning optimum is the "85% Rule"
  (Wilson et al. 2019, *Nature Communications*). Serve so the player succeeds ~75–85% of the
  time; reserve ~50–60%-difficulty items for explicit **placement / rank-up** challenges only.
  (Corrects §5.2's "~50% edge-of-skill," which was the measurement figure.)
- **A2. Three functional options beats four dead ones (Rodriguez 2005 meta-analysis).** Most
  4th distractors are non-functional and *invite* the elimination cue. Keep the app's 4-option
  format ONLY if all four are functional; gate it: every distractor picked by **≥5%** of
  solvers with a **negative point-biserial**, the key with a **positive** point-biserial, item
  **discrimination D > 0.30**. Any distractor failing → rewrite or cut to three. These are the
  empirical release-gates that replace authoring-by-feel.
- **A3. Item calibration is sound as a mechanism (Pelánek 2016: Elo *is* the online Rasch/1PL
  model)** — the dual-update `θ += K·(correct−P); d_item += K·(P−correct)` with a guessing
  floor `P = 1/k + (1−1/k)/(1+e^−(θ−d))` and an uncertainty-decreasing K (= Glicko RD) is the
  right engine. BUT the red-team's bank-size caveat holds: at N≈100 it can't converge — use the
  author-difficulty↔solve-rate **gap as a leak detector** now, and turn on true item-rating
  once the bank is ~1000+. Items decay slower than solvers (each item sees many players).

The sections below remain useful as craft detail, read through these corrections.

## 1. The measured diagnosis (why the current puzzles are guessable)

Ran the numbers over all 100 shipped puzzles. The content is gameable without any sales
knowledge:

| Tell | Measured | Consequence |
|---|---|---|
| **Length** | correct answer is the **longest option in 98/100** (eval↔length corr **0.76**) | pick the longest → 98% |
| **Tagging** | correct is tagged while a wrong option is untagged in **96/100** | pick the tagged one → 96% |
| **Move-type** | correct move is "calibrated question" **40%** of the time | pattern-match → win |
| **Eval slotting** | **91%** of correct answers are scored exactly 0.7 or 0.8 | eval isn't calibrated, it's filler |
| **Voice** | "operator" used 197×, "recipient" 76× | depersonalized lab-speak, not a coach |
| **Form** | **0 of ~400** candidates are an actual spoken line | abstract "notation," never what you'd *say* |

Any one of those makes the puzzle free. Together they mean the app currently teaches
nothing and a non-salesperson scores ~98%. This is the root of "amateur" — not the
writing, the structure.

## 2. The deepest unlock: the app contradicts its own evidence base

Frame & Fork brands itself "research-graded against the Atlas literature." But cross-
referencing the actual PRISMA corpus (`closing-evidence-atlas/results/pilot_posterior_summaries.csv`
+ `stage1_by_technique.csv`):

- The app's **#1 "best move" is calibrated-question (40%)** — which has only **k=3** studies
  in the commercial-decision corpus.
- **Alternative-choice close is the best move 11× — and has *zero* studies (folklore).**
  Accusation audit, assumptive close, Ben-Franklin close: all n_include = 0.
- The techniques with **dominant evidence** — gain-framing (n=138), loss-framing (n=112),
  foot-in-the-door (n=105), door-in-the-face (n=70), social-proof, regulatory-fit — are
  rarely the answer.

**This is a recurring trap pattern — NOT the rule for the key** (see §0.1). The key is
always **buyer-state fit.** What evidence-grading buys is the *distractor* design: in a great
chess puzzle the tempting wrong move is the natural-looking one. The two sales analogs, both
tempting traps, are (a) the **slick folklore move** that "sounds like a technique" but has no
support, and (b) the **genuinely strong, evidenced technique aimed at the wrong moment.** The
player feels smart rejecting the move that *sounds* expert; the reveal teaches why — in plain
coach voice (the effect-size detail stays internal, never shown as μ/CI jargon; §0.8).

Effect-size ranking to calibrate evals against (mu = posterior median, P = P(effect>0)):

| Technique | mu | evidence |
|---|---|---|
| social-proof | +0.68 | **unstable — 95% CI −0.21→1.30 crosses zero, posterior k=2** (n=47 is the screening count, not the fit). Treat as "promising, not settled." |
| commitment-consistency | +0.59 | P=.999 |
| regulatory-fit | +0.48 | P=.9998 (n=47) |
| extreme-anchor | +0.43 | n=22 |
| gain-framing | +0.35 | P=1.0, dominant (n=138) |
| loss-framing | +0.33 | P=1.0, dominant (n=112) |
| calibrated-question | — | only k=3 in-domain (strong in MI literature, untested here) |
| accusation-audit / alt-choice close / assumptive | — | **n=0, folklore** |

(Evidence ≠ universal correctness — a strong technique mis-targeted is still wrong; see the
exemplar. But evidence sets the prior, and folklore-as-trap is the recurring motif.)

## 3. Authoring rules (the non-guessable item spec)

1. **Length-match every option** (±~10% characters). The key is as often the *shortest* as
   the longest. Kills the 98% tell outright.
2. **Tag every option**, not just the key. Every option is *a move* deploying *some*
   technique — wrong options deploy contraindicated or folklore techniques. "Has a tag" can
   never indicate correctness.
3. **Options are spoken lines** — what the closer actually *says* — with at most a 2-3 word
   tactic label. No "operator routes the objection." If you can't say it out loud to a
   buyer, it's not an option.
4. **Vary the correct move type.** Cap any single technique (e.g. calibrated-question) at
   ~15% of keys. Sometimes the best move is silence, a label, a walk, an assumptive close,
   or doing nothing. Predictability is the tell.
5. **The tempting distractor is expert-sounding**: either the folklore move that sounds
   slick, or an evidence-backed technique *mis-targeted* (right tool, wrong moment). Every
   distractor must be a move a *trained* rep would genuinely consider — "wait four months"
   is not a distractor, it's filler.
6. **Calibrate eval to evidence × fit**, not a 0.7 slot. A well-targeted strong-evidence
   move scores high; a mis-targeted strong move scores slightly negative; a folklore move
   scores clearly negative. Spread the numbers.
7. **Distractor-level teaching.** Each wrong option's rationale names *why this specific
   tempting move fails here* — that's the learning, and the "ohh, I see" that makes the
   player feel smart.
8. **Coach voice, not lab voice.** Sharp, confident, second person ("you"/"the buyer"),
   names one transferable principle, cites the evidence when it lands. Match the existing
   *transcript* voice (the Voss excerpts), which is already excellent — the puzzles just
   never used it.

## 4. Worked exemplar (self-critiqued against §3)

> **Discovery call, mid-market. The VP has been warm for 20 minutes. You name the price. She pauses.**
> **VP:** "Hm. That's more than I expected. Let me talk to my team and circle back."
>
> **A.** *"Fair enough — what number were you expecting, so I can see if we can get there?"*
>   · anchor concession · **−0.6** — Feels collaborative; it's a flinch. You've made price
>   soft and re-anchored on her number before knowing if price is even the real issue.
> **B.** *"Before you do — is it the number itself, or the timing of the spend?"*
>   · calibrated question · **+0.3** — Good instinct, but it accepts the "talk to my team"
>   exit and treats this as a price problem.
> **C.** *"Sounds like this has to clear people who aren't on this call."*
>   · affect labeling · **+0.8** — Best. A label (not a question she can dodge) that names
>   the real variable — hidden stakeholders — and invites her to correct it. Doesn't touch
>   price, because price isn't the problem. *Affect labeling: Lieberman 2007.*
> **D.** *"Given the ROI we mapped, most teams see payback inside a quarter."*
>   · gain-framing + social-proof · **−0.2** — The trap for the *advanced* player: two
>   genuinely strong, well-evidenced techniques — aimed at the wrong target. She didn't make a
>   price objection; you just talked past the real one. (Trap pattern (b): evidenced ≠ correct
>   when mis-timed. Reveal copy stays plain — no μ/CI shown to the user.)

Self-critique vs the rules: lengths 13/14/12/12 words ✓ matched. All four tagged ✓. All
spoken lines ✓. Correct move is *labeling*, not a calibrated question ✓ (breaks the
pattern; B is the calibrated-question decoy). Evals spread −0.6/+0.3/+0.8/−0.2 ✓ not
slotted. The two traps are expert-sounding (A=collaborative, D=textbook-technique) ✓. The
"feel smart" beat = rejecting D, the move that *looks* most professional. Holds up.

Residual worry to test with research: is C *too* findable because it's the only label? Need
a corpus where the best move rotates across labeling/question/silence/frame/walk so no
single form correlates with correctness. (→ distractor-science + chess agents.)

## 5. The adaptive engine + progression (from chess science)

The cognitive foundation (de Groot 1965; Chase & Simon 1973; Gobet templates; Miller 7±2;
Ericsson): **expertise is a library of automatic pattern-chunks (~50k at master level),
not deeper search.** Working memory holds ~7±2 chunks, so the only path to harder judgment
is to make lower-level *recognition* automatic, then build on it. This dictates the whole
learning architecture:

1. **Rate the PUZZLES, not just the player** (the Lichess move). Each item carries its own
   Glicko-2 rating + RD; every attempt is "a game between player and puzzle" — solve → item
   rating falls, miss → it rises. Difficulty is then **calibrated empirically from real
   solve data, not author guesswork** (which is what produced the 0.7/0.8 slotting). Ship
   items at seed 1500/RD350; never score a user on an uncalibrated (high-RD) item
   (chess.com's pending-puzzle rule). *This is the single highest-leverage engine change.*
2. **Serve at the edge of skill** (~50% expected-correct; Lichess −300/+200; Aagaard's
   "110–120% difficulty"). Flow band = challenge≈skill (Csikszentmihalyi). Beginners get a
   genuinely easy on-ramp; experts get the hard tail. Offer explicit Standard/Hard/Extra-Hard
   bands as a knob.
3. **Concept isolation → integration** (Lichess Practice; Heisman; Polgár). Drill ONE
   "motif" — one objection type, one buyer-state tell — to recognition before mixing. The
   sales motif taxonomy is the analog of fork/pin/skewer (see §6, pending sales research):
   e.g. the-stall-that's-a-stakeholder-tell, the-objection-that-isn't-the-real-one,
   the-premature-discount-trap.
4. **"Seeds of tactical destruction" → sales tells.** Heisman teaches the *triggers* that
   signal a tactic exists (loose piece, exposed king). The sales version: teach the player to
   *recognize the tell* ("buyer defers to 'my team'" = hidden-stakeholder tell; "that's more
   than I expected" + warmth = decoy objection). Recognition-of-tell is the chunk we're
   building; puzzles should be tagged by the tell they train.
5. **SRS of misses, per-item, reset-on-miss** (Chessable SM-2 ladder 4h→1d→3d→1wk→…→6mo;
   prefer FSRS's stability/difficulty model to avoid "ease hell"). Re-serve a *missed* item
   at the forgetting edge — that's where retrieval yields the most learning (Ebbinghaus;
   Bjork). This is the backbone of the "Review misses" feature already specced.
6. **Same-set repetition to automaticity** (de la Maza 7 circles / Woodpecker, scaled to
   50–200 items, 5–7 cycles, halving time each pass). The compressing solve-time is the
   measurable signal a pattern has become a chunk. A "drill a theme to mastery" mode.
7. **Grade-gated tiers** (Yusupov: instruction → unaided exercises → scored test → pass to
   advance; color tiers by rating band). This is also the enterprise certification primitive.
8. **Two separate modes** (chess.com/Lichess): the **rated ladder = pure correctness, no
   clock** (the timer removal was correct — chess.com explicitly moved time OUT of rated
   puzzles); put time pressure + combo-multiplier + escalating ramp in a **separate unrated
   Rush/Storm mode** where accuracy is super-linear (a miss forfeits the combo *and* penalizes
   time). Entertainment lives there, not on the rated ladder.

## 6. Varied-move exemplar battery (proof the key rotates)

The 98%-length-tell and 40%-calibrated-question findings mean the fix isn't one good
puzzle — it's a *set* where no single form correlates with correctness. Four exemplars
below; the best move is a different shape each time (label / silence / takeaway / assumptive
close) and the **calibrated question is deliberately NOT best in two of them.** Each is
length-matched, every option tagged, all options are spoken lines, evals calibrated to
evidence×fit. (Exemplar 1 is in §4.)

**Exemplar 2 — best move = strategic silence (the calibrated question is a trap-adjacent near-miss).**
> **Final terms. You've named your price. The buyer counters low, then goes quiet, watching you.**
> **Buyer:** "We can do $80K. That's the number that works on our side."
> **A.** *"Okay — let me see how close I can get to eighty."* · concede · **−0.7** — You moved toward their number unprompted. You're now negotiating against yourself.
> **B.** *"$80K, hm."* (hold the pause) · calibrated silence · **+0.8** — Best. The counter is a probe; silence makes the gap *their* problem and the next to speak usually moves. The hardest move is to do nothing.
> **C.** *"Help me understand how you got to eighty."* · calibrated question · **+0.2** — Fine, but it releases the silence and invites a rehearsed justification.
> **D.** *"Can't do eighty — I could meet you at ninety-two."* · bracket counter · **−0.3** — Counters into the middle too fast; concedes the anchor and trains them to grind.

**Exemplar 3 — best move = the takeaway/disqualify (over-giving is the trap).**
> **Inbound lead's third "quick question" email this week. No meeting booked. Vague on budget and timeline.**
> **Buyer:** "Can you send enterprise-tier pricing and a comparison vs [competitor]? Just gathering info."
> **A.** *"Absolutely — full pricing and a comparison deck attached. Let me know!"* · over-give · **−0.5** — Feeds an info-gatherer; all the work, no commitment, trains extraction.
> **B.** *"Happy to — what has to be true for this to become a priority this quarter?"* · qualify · **+0.5** — Surfaces intent, but still leans toward giving first.
> **C.** *"Honestly it may be early for enterprise — want me to circle back next quarter?"* · takeaway · **+0.8** — Best. The takeaway flushes real intent: a serious buyer protests, a tire-kicker disengages. Withdrawing teaches you more than giving.
> **D.** *"Most teams your size start on Growth — want a quick call to scope it?"* · downsell + meeting · **+0.2** — Reasonable redirect, but still rewards the fishing.

**Exemplar 4 — best move = the assumptive close ("surface objections" is the trap here).**
> **Champion has said "exactly what we need" twice. Pricing is agreed. Late in the call.**
> **Buyer:** "Yeah, I think this really solves our problem. The team will be happy."
> **A.** *"Love it — let me also show you the analytics module and the roadmap first."* · feature-dump · **−0.6** — Selling past the yes; new info can reopen doubt. The cardinal sin.
> **B.** *"Great — I'll send a recap and we'll find time to get started."* · soft next-step · **+0.2** — Passive; lets the energy cool and the moment pass.
> **C.** *"Perfect — I'll send the order form so you can onboard Monday. Work?"* · assumptive close · **+0.8** — Best. They're bought; name the concrete next step and let them confirm. Drift kills won deals.
> **D.** *"Amazing — any concerns before we move forward?"* · objection-invite · **−0.2** — Usually good practice; here you just invited a manufactured doubt at the moment to close.

**Exemplar 5 — DO-MORE key (assertive move wins; the comfortable passive move is the trap). Segment: enterprise.**
> **$400K enterprise deal. Your single champion (a Director) is enthusiastic: "I've got this internally — just send the deck and I'll walk it up." Two months in: no exec contact, legal hasn't seen it, quarter ends in 3 weeks.**
> **A.** *"Perfect — I'll tailor the deck for the execs and send it today."* · enable champion · **−0.5** — The comfortable move: trust the happy champion. A single-threaded $400K deal relayed by a Director with unproven authority is how no-decisions happen.
> **B.** *"Appreciate it — mind if I join the exec conversation to field the hard questions live?"* · multi-thread · **+0.8** — Best. Multi-threading lifts $50K+ win rates sharply [correlational]; you get the exec read directly and de-risk the relay, and asking permission keeps the champion on side.
> **C.** *"Should we get legal a head start on redlines in parallel?"* · de-risk paper · **+0.4** — Good (parallel-paths the contract) but leaves the bigger risk — the exec relay — unaddressed.
> **D.** *"What's your read on how the CFO reacts to the number?"* · calibrated question · **+0.2** — Useful intel, but a question doesn't fix single-threading; you still can't see the room.

**Exemplar 6 — DO-MORE key (hold the line; the accommodating instinct is the trap). Segment: mid-market, you hold leverage.**
> **Mid-market renewal. You're the incumbent they use daily; switching cost is high. Buyer, fishing: "A competitor quoted 20% less. Match it or we seriously consider switching."**
> **A.** *"I hear you — let me see what discount I can get approved to keep you."* · concede · **−0.6** — Accommodate-the-threat. As the incumbent with high switching cost, folding 20% on a bluff trains every future renewal to open with a competitor quote.
> **B.** *"If price were the only factor you'd have switched already. What's actually making you look?"* · push back w/ permission · **+0.8** — Best. Names the leverage reality and surfaces the real driver; a fisher backs off, a serious buyer tells you the actual problem.
> **C.** *"Happy to revisit pricing at renewal — can we look at what's driving the gap?"* · reframe · **+0.3** — Reasonable, but half-accepts the price frame instead of testing the threat.
> **D.** *"Can't match 20%, but I could add the premium support tier."* · trade · **+0.2** — Better than caving, but concedes the premise that a bluff must be paid.

**What the battery proves:** across the six, the key is label / silence / takeaway /
assumptive-close / multi-thread / push-back — **three "do-less" and three "do-more"** (the
red-team fix: the contrarian-passive option is the key only half the time, so "pick the
withholding move" is not a winning heuristic), and the calibrated question lands as +0.2 (a
*near-miss*, not the key) in four of them. Note Ex.5/6 also **force the context** (segment,
leverage, single-threading, quarter-end) so the one answer is genuinely determined, not an
unstated assumption. A player can't pattern-match "pick the question"
or "pick the longest." Discrimination comes only from reading the buyer's actual state.
And the "feel smart" beat is built in: each set has one move that *looks* most professional
(D in §4, C-as-question elsewhere, "any concerns" in #4) which is precisely the trap.

## 7. The authoring engine (from sales-mastery research)

**The one finding under everything:** *the trained-but-average rep's reflexes are the trap.*
More questions, more talking, more rapport, more value-pitch, more discounting — each feels
diligent and each *lowers* win rates in the data. So: **build every distractor from a
documented reflexive error; build the key from a buyer-state read.** That is what makes the
item hard *and* makes the insight feel earned (the tempting answer is the learner's own
competent instinct).

### 7a. Empirical anchors (use real numbers in scenarios/reveals — Gong corpus + research orgs)
- Winners talk **43% / listen 57%**; population avg is inverted; talk-ratio *creep* 54%→64% marks a losing rep.
- Winners ask **15–16 questions**, losers ~20 — **more questions is worse** (interrogation).
- After an objection, top reps **pause ~5× longer**, **slow to ~176 wpm** (losers speed up to 188), and answer with a question 54% vs 31%.
- **Price early** wins (first call / ~38–49 min), not deferred.
- **Raise competitors early** → +49% win odds; raising them late hurts.
- **58% of forecasted deals die in no-decision; 56% of those from fear/indecision, not status quo.** Buying group **6.8 people**. Multi-threading **+130%** on $50K+ deals. De-risking moves win rate **20%→51%**. Mobilizer-targeting **+31%**.

### 7b. The reflexive-error distractor bank (every wrong option comes from here)
| Trigger | The reflex (→ distractor) | Why it loses |
|---|---|---|
| Awkward pause | fill it with another question | the revealing sentence starts *after* the pause |
| Want to be thorough | ask more discovery | >15 Qs reads as interrogation |
| Buyer engaged | keep pitching | selling past the yes reopens doubt |
| Deal wobbles | talk more to regain control | top reps hold ratio; creep = losing |
| Objection lands | speed up, defend | slow down, pause, clarify |
| Price pressure | discount to unblock | signals distress; trains the grind |
| Indecisive buyer | pile on ROI/value | fear is of failing, not low value — more value worsens it |
| Enthusiastic contact | invest in them as champion | likely a Talker, not a Mobilizer |
| Senior buyer | open with warm small talk | execs earn rapport via relevance; filler lowers status |
| Want to be liked | over-warmth, chase "yes" | eagerness reads as desperation; "no" creates safety |
| Competitor exists | avoid naming them | early naming wins; avoidance cedes the frame |

### 7c. The correct-move MENU (rotate the key across these; cap any one at ~12–15% of the bank)
stay silent · probe · prescribe/recommend · de-risk · hold price · trade a concession ·
walk/disqualify · multi-thread · re-sequence who/when · push back with permission ·
align (don't challenge) · be assumptive · raise the competitor. **Some items' key is "do
less / say nothing"** — the hardest type, where every action option is a competent reflex.

### 7d. Framework collisions = top-tier puzzle fuel (textbook move A vs textbook move B)
- **Challenger reframe vs Voss empathy** — bought-in champion → align (tension costs the ally).
- **SPIN deep-questioning vs JOLT prescribe** — indecisive-but-informed → prescribe (more probing feeds indecision).
- **MEDDIC rigor vs Sandler communication** — early discovery → extract the same info conversationally, don't interrogate.
- **Gap diagnosis vs assumptive close** — buyer already knows what they want → assume.

### 7e. The 15 hard-decision archetypes (the authoring backbone)
pause-after-hedge (→silence) · engaged-demo (→stop, ask) · price-objection (→surface the
real one) · discount-ask (→trade, don't give) · indecisive-but-likes-you (→de-risk, not
more value) · enthusiastic-contact (→find the Mobilizer) · single-senior-name
(→multi-thread) · exec-timing (→enter ~3rd touchpoint) · senior-first-minute (→relevance,
not small talk) · bought-in-champion (→align, don't challenge) · assumptive-vs-consultative
(→go directive when validated) · good-deal-won't-decide (→force decision / lose early) ·
competitor-question (→raise early, box out) · objection-flurry (→slow down, one at a time) ·
ghosted-deal (→no-oriented loss-frame). Author multiple items per archetype at different
ELOs; for each, also author a **minimal contrasting twin** (same setup, one cue changed,
so the textbook move flips to the trap) — that trains discrimination, not recall.

### 7f. Earned-insight reveal science (why the debrief IS the product)
Derived answers are retained and change behavior; told answers are forgotten. Converging
evidence: insight/eureka memory **64% vs 52% at 14 days** (Danek 2013); desirable
difficulty (Bjork); generation effect; **productive failure** — commit to and exhaust a
wrong intuition *before* the reveal (Kapur); testing effect wins at one week, the moment the
rep is in the room (Roediger & Karpicke); **contrasting cases** are the single highest-
leverage format (Schwartz & Bransford). Implications for the reveal:
- Name the **exact tell** ("the pause before 'yeah, makes sense' was the hesitation").
- Explain **why the tempting distractor fails** (distractor-level feedback), not just why the key wins.
- Add a **"what happens next" beat** — show the downstream consequence of the chosen move (trains the mental-simulation half of expert decision-making; Klein RPD).
- **Track distractor pick-rates**: a healthy item has the tempting trap stealing a big share of *early* learners and shrinking as they improve — the empirical signature of a real tell being learned.

### 7g. The anti-guessability pass (run on EVERY authored item)
Cover-the-options test (an expert should derive the key from the stem alone — if you can
only answer by comparing options, rewrite); single-continuum options (all defensible next
moves, none absurd, two close enough that only the buyer-read separates them); equalize
length/specificity/grammar (kill the 98% tell); strip stem↔key word-echo; paraphrase (never
lift the lesson verbatim — also satisfies IP discipline); no all/none-of-the-above, no
absolute-word tells; tag every option; randomize key position; application vignettes only
("what does the top rep do next?", never "what is the term for…").

## 8. Open threads (folding in as the loop runs)
- Chess science → motif taxonomy + only-move tension + adaptive serving (Lichess Glicko-on-puzzles).
- Sales mastery → the catalog of "intuitive move is wrong" archetypes (the distractor mine).
- Distractor science → formal non-guessability checklist + discrimination index targets.
- Game-feel → the earned-emotion reveal + sound (separate JUICE-DOCTRINE).
