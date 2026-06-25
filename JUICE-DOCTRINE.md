# Frame & Fork — juice doctrine (earned, not confetti)

The last round's juice (confetti + ELO counter) was the wrong layer: above-detection
spectacle that produces *zero* dopamine within days and reads as noise to skilled users.
This replaces it with an earned-reward system, grounded in research and aligned to Marion's
subliminal-layer discipline ("supply precise material; the nervous system reconstructs the
feeling"). It is a sales port of chess.com's move-classification feel.

## The one law (everything derives from it)
A reward that is **loud, identical, and given on every success** stops producing a neural
reward signal within days (reward-prediction-error: a fully predicted reward → no dopamine;
Schultz 1997) and for skilled users actively reads as intrusive load (expertise-reversal,
Kalyuga 2007). Confetti on every solve is the textbook failure. The premium move is the
opposite: **supply the precise minimum, gate the rare praise hard, let the solver
reconstruct the feeling of having earned it.** That reconstruction is what they keep — and
what won't habituate (meaningful reward resists habituation; hedonic pops decay; Luo 2022).
Robinhood was fined $7.5M for celebratory confetti read as manipulation; sophisticated users
experience loud celebration as something done *to* them. Subtlety signals status (Berger &
Ward 2010, *JCR*). "Less, but better" is also the more effective reward schedule.

## 1. The verdict ladder — the core reward (replaces confetti entirely)
Score each move against the model's best line by **expected-points lost** (chess.com's
Expected Points logic; the app already computes a per-candidate eval — this is a small step).
Six threshold tiers + three special-case overrides. The reward is the **verdict glyph + one
weight class** — never a paragraph of praise.

| Verdict | Glyph | Color | Condition |
|---|---|---|---|
| **The Fork** *(the scarce "Brilliant")* | ‼ | cool teal | see §3 — a sound concession that wins on two fronts |
| **Sharp** *(Great)* | ! | steel blue | best/near-best AND the only line that held or swung the deal |
| **Best** | ◆ | deep green | the model's #1 move |
| **Solid** | ✓ | green | ≤0.02 lost |
| **Fine** | · | muted green | ≤0.05 lost |
| **Loose** | ?! | amber | ≤0.10 lost |
| **Slip** | ? | orange | ≤0.20 lost |
| **Missed** | ✕ | gray | failed to punish the buyer's opening |
| **Tell** *(Blunder)* | ?? | oxblood | >0.20 lost |

**Why this is "earned" where confetti isn't:** the verdict comes from an impartial arbiter
with published math, not vibes — praise from a system that *can't be sweet-talked* lands as
recognition. The same engine that withholds ‼ also calls a ?? a ??. **That symmetry is the
credibility.** (Naming maps the app's existing glyphs — it already shows ★ BEST / ?! / ?? —
so this is an upgrade of execution, not a new system.)

## 2. The conviction bar (the eval bar, done right)
A continuous vertical bar (chess.com style, which the live-play screen half-has and the
puzzle screen lacks): buyer's conviction fills from the bottom, yours from the top, split at
50/50 = undecided. **Critical subtlety: it does NOT swing on a routine correct move** — the
model already priced in the best line — so the satisfying lurch only comes when you genuinely
*find* the strong move or the buyer tips their hand. The advantage is paid out visually, in
real time, and only when earned. Routine bar motion: ~250ms standard easing. A Fork-driven
swing: the emphasized spline (§4).

## 3. The scarce "Fork" — the heart of the system
A **Fork** = a non-obvious move that wins on two fronts at once (the sales analog of a sound
piece sacrifice: e.g. a concession that both unblocks the deal *and* re-anchors you stronger;
a takeaway that both qualifies *and* raises your status). It fires only when ALL hold (mirror
chess.com's gating — the gating *is* the credibility):
1. it's the model's best or near-best line;
2. it's a **genuine concession/risk** — you gave ground (price, a constraint, walked into the
   objection, said the hard thing) and it *worked*;
3. you're not in a losing position after it;
4. **you weren't already winning** — a Fork on a deal that was already closing doesn't count;
5. it was **not the obvious/forced** line — it had to be hard to see;
6. **skill-adjusted** — generous at low ratings, ruthless at the top.

Target rarity: low single-digit % of moves (Carlsen scores Brilliant on ~0.4%). **Never
inflate it to flatter.** Defend the bar publicly the way chess.com does — scarcity defended
is a trust signal. The Fork is the *only* place the full celebration budget is spent.

## 4. Sound — the missing channel (the app currently has none)
Half of chess.com's feel is sound. Spec: **sine/triangle** oscillators (warm, not arcade —
square/saw read as cheap), fundamentals **~350–750 Hz**, fast attack + percussive decay, a
touch of reverb (~0.3s) to escape "dry beep," **quiet**. Pitch direction is semantic: rising
= success, falling = error (Duolingo: correct = ascending major third, wrong = a descending
tritone — never signal error by just lowering volume).

| Verdict | Sound |
|---|---|
| Solid / Fine (routine) | single soft tone ~350–500Hz, ~100–120ms, near-silent — **the protected noise floor** |
| Best | same tone resolved up a major third (~120ms) — barely more than routine |
| Sharp (!) | ascending perfect fifth, ~160ms |
| Loose / Slip | a descending interval, dry, short — "off," never a buzzer |
| Tell (??) | low descending two-note settle ~200–250ms + low-octave body — lands **heavy, not loud** |
| **The Fork (‼)** | the only fuller sound: full major triad + added low octave, ~350–450ms, ~0.6s reverb, raised top note — special by *fullness and length*, never volume |

Magnitude comes from **duration + low octave + chord-richness**, not loudness (size-perception
research: duration/formant beat raw pitch). **Haptic fires ~12–16ms before** each audio onset
so the two fuse into one "thunk." Routine = one light tick; Fork = a fuller double-beat.
Per IP discipline: derive these intervals/values ourselves (above), never sample chess.com.

## 5. The "verdict landing" choreography (asymmetric — most moves get almost nothing)
- **Routine (Solid/Fine/Best/Loose/Slip): ~150–200ms.** Glyph fades up (standard easing),
  the quiet tone, one light haptic. No count-up, no hold, no celebration. Fast, respectful.
  ~80%+ of verdicts live here — the silence is what lets the Fork be heard.
- **Tell (??): slow it down to ~400ms.** Glyph settles low with a small downward drift, the
  heavy descending sound, fuller haptic. Let it land. **No shame-red strobe, no punish-flash**
  — the weight is the message (also fits Marion's gentle-failure register). The honest
  blunder-call is what makes the Fork credible.
- **The Fork (‼) — the hero, and ONLY here:**
  1. **Anticipation ~350–450ms:** the board holds, the conviction bar pauses mid-swing, a
     faint building cue. (Dopamine ramps harder in anticipation than at delivery — never pay
     off instantly.)
  2. **Verdict lands alone ~450–550ms** (emphasized-decelerate easing, or a spring with one
     mild overshoot): the ‼ arrives center, decelerating into rest — *the deceleration is the
     weight* — with the full-triad sound + double haptic. One focal point; nothing else moves.
  3. **Savor ~150–200ms freeze** on the verdict.
  4. **The line replays, staggered ~120ms:** *your* move highlighted first, then the two
     things it forked — surfacing the user's **own path** ("you did this"; IKEA/effort effect
     beats a generic prize).
  5. **Teaching last, lowest weight:** one line on why it was a Fork, quietly, after the
     moment lands.

## 6. The governing law (asymmetric magnitude)
- **Suppress the routine** (~80%+ of verdicts = the quiet noise floor). Non-negotiable.
- **Spend the full budget only on the Fork.**
- **Let the Tell land heavy but muted** (loss aversion ≈2:1 permits weight — via duration + a
  low settle, never flash).
- **Never confetti, never "Good job!"** The verdict, the conviction bar, the sound, and the
  user's replayed line ARE the reward.

## 7. What to build (and the order)
1. **Verdict ladder + conviction bar on the puzzle reveal** (data already exists; this is
   re-rendering the eval as the hero verdict + animating the bar). Biggest feel upgrade.
2. **Sound layer** (8–10 short AHAP-paired samples, per §4). The missing half of the feel.
   *(Decision for Marion: ship sound? — it's the single biggest jump, but it's a new channel.)*
3. **The scarce Fork** detection (§3) + its choreography (§5). The thing worth paying for.
4. Replace the confetti/ELO-counter reveal entirely.

Reconciliation with Marion's design language: this IS the subliminal layer (below-detection
routine cues compounding across ~18k spikes/year), celebration-reserved-for-earned (the Fork
is the only celebration, gated hard), perceptual-magnitude engineering (asymmetric duration/
weight), and "user reconstructs the emotion" (the arbiter withholds praise so finding a Fork
feels like *your* insight, not the app's applause). Font/system-ui and warm-shadow/grain
premium surface per [[premium_ui_craft_spec]].
