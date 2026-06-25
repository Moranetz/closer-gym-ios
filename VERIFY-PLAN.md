# Frame & Fork — work-email verification + LinkedIn/Slack (the Slack growth model)

Mockups: `mockups/verify-claim.html` (3 framings, A/B/C). This plans the mechanism behind them
to its fullest, pre-empts the flaws, and keeps it honest (per SECURITY.md + the H1 privacy lesson).

## 1. Why work-email verification (it's not data capture, it's the grouping mechanism)
Slack's growth engine: your email *domain* groups you into a workspace; one person joins, their
coworkers discover it, the company ends up paying. Same here. `name@acme.com` →
auto-joins **Acme's closer board**. That domain does four jobs at once:
1. **In-group status** — a rank against your *actual* teammates (far more motivating than a
   global number — the people whose opinion the rep cares about).
2. **Data quality** — verified real reps at real companies (the flywheel input is trustworthy).
3. **The bottom-up enterprise wedge** — reps self-verify free → the manager sees the team is on
   it → buys the dashboard/seats. The verification *is* the PLG motion (RESEARCH.md).
4. **Email + verified company affiliation** — the contact + firmographic data that makes B2B
   outreach and the data flywheel possible.

## 2. The non-negotiable sequencing (the flaw most teams get wrong)
**Do NOT gate the door with verification.** A rep won't surrender his work email before he's seen
value — a signup wall and he's gone (the "overworked rep won't use it" insight). He plays free,
**earns a win**, and verification is offered at the moment of peak status-desire: *"claim this
rank under your real name on your team's board."* Verification rides the win. This single call is
what makes it convert instead of repel. All three mockups ride a just-earned win.

## 3. The three framings (pick one — all capture email→company, all genuinely help the ego type)
- **A · Claim your rank** (in-group): a locked/blurred team board is the tease — verify to see
  where you stand vs. your real team. Lands in-app. Strongest pure-status hook.
- **B · Verified Closer** (credential): Sign in with LinkedIn → a *verified* rating tied to real
  identity, postable as a LinkedIn badge. Career capital + viral on his turf.
- **C · Own the board** (founder): be the first from your company; everyone who joins ranks under
  you; Connect Slack to pull the team. Founder ego + the viral recruitment loop.
They can also combine (A's board + B's LinkedIn credential + C's Slack pull are complementary).

## 4. The verification mechanism
- **Two paths:** (a) **Sign in with LinkedIn** — gives verified identity + current company +
  title with no email plumbing (and it's the rep's native platform); (b) **work-email magic link /
  6-digit code** — for those who won't OAuth. Both prove possession/identity.
- **Domain → company workspace:** first verified rep at a domain *creates* Acme's board (founder
  framing, version C); subsequent reps auto-join. Mirrors Slack exactly.
- **Tiering, not hard-gating** (free-email flaw): work-verified = full status + company board;
  personal/Gmail = "unverified," can play and hold a local rating but no company board. Never hard-
  block (small companies use Gmail; some reps fear work email) — make work-verify the *aspirational*
  state, not the toll booth.

## 5. Why this genuinely helps the high-ego rep (it must, or it's just extraction)
- Real in-group competition against the team he actually cares about beats a meaningless global rank.
- A **verified** rating is a credential that *means* something — "gym numbers" become a real flex
  to his VP and to recruiters (career capital that follows him between jobs — the portable-credential
  white-space no competitor owns).
- Founder/first-mover status (version C) is a genuine ego payoff.
- It connects him to his team's loop where he already performs status.

## 6. LinkedIn integration (fit the platform: it's a status/credential surface)
- **Sign in with LinkedIn** = verified professional identity + company (best verification path).
- **The Closer Card as a LinkedIn post/badge** — the verified "Class A Closer · 1,620" artifact
  is a native LinkedIn flex (the sales-bro's home turf for status). Opt-in, scrubbed of confidential
  intel (shows rank + objection *category* + move, never the raw competitive text he entered).
- **Recruiting loop** (later): a verified rating as a hireable signal — "hire a verified closer."

## 7. Slack integration (fit the platform: it's the team's daily workspace)
- **FnF Slack app** posts to the team channel: win broadcasts ("X just beat a cold budget objection,
  took #2 on Acme"), the weekly board, "most improved." The in-group status runs where they already
  live — automatic social proof + recruitment.
- **Daily-drill nudge in Slack** ("your 5-min drill is ready") — the habit hook in-channel.
- **Workspace = the company grouping** — connect Slack to mirror the team and pull everyone in
  (version C). Manager **assignment notifications** flow through Slack too.

## 8. Flaw pre-emption (every facet)
- **Door-gating →** verify post-win, never at entry (§2).
- **Bottom-rep exposure / surveillance dread** (the killer flaw): the free **peer board** shows
  status-positive signal only — top performers, *your* neighborhood, most-improved — NOT a naked
  "you're last" broadcast to the whole company or the boss. The manager's full per-rep view is the
  **separate, paid B2B dashboard** (and even there, designed "everyone improves"). Copy promises it
  explicitly: *"your team sees your rank, never your misses."* Company-board participation is opt-in.
- **Free-email →** tier it, don't block (§4).
- **Impersonation / fake domains →** email-possession or LinkedIn OAuth proof; you can only join the
  workspace of a domain you control; the company workspace can be admin-claimed.
- **Cold-start (first rep, empty board) →** founder framing + invite loop (version C) turns the empty
  board into an ownership prize.
- **Privacy / consent →** honest disclosure of where email + context go (the H1 lesson — hide the
  *motivational* frame, never the data path); opt-in nudges, not blast marketing; GDPR/CCPA delete-
  my-data; the confidential-intel **scrub** on any shared artifact.
- **Spam / notification fatigue →** email only for verification + opt-in; Slack nudges throttled
  (one daily drill, wins are opt-in-to-broadcast).
- **IT / manager fear →** lead with value-to-him and visibility control; he chooses what's shared.
- **Backend dependency →** all of this needs accounts + email/OAuth + Slack/LinkedIn apps (gated on
  the Phase-0 backend, BACKEND-HANDOFF.md). The mockups are the spec; sequence after the backend.

## 9. The bigger kernel (stated soberly, not overclaimed)
A **verified, portable, meritocratic skill credential for sales** — a real signal of who can
actually close, vs. who interviews well — could change how sales talent is recognized and hired.
That's the "benefit humanity if done right" core: meritocracy over polish. It only works if the
credential is *honestly earned and verified* (which is why §10 matters).

## 10. The ethics guardrail (persuasion, not a dark pattern — and what makes it durable)
- The rank must be **real** (a fake leaderboard is the one thing that kills it — sales bros smell it).
- The win must be **really earned** (the blind coach we hardened).
- The data path stays **honestly disclosed** even while the motivational frame is hidden.
- Sharing is **opt-in** and **scrubbed** of confidential deal intel.
Hide the data-collection *frame*; never hide where the data *goes*. That line is also why it lasts.

## 11. Buildable now vs gated
- **Now (no backend):** the post-win *placement* + the reframed copy + the Closer Card artifact
  (local rating/title) — the front end of all three framings.
- **Gated (Phase-0 backend):** email/LinkedIn verification, domain→workspace grouping, the live team
  board, the Slack/LinkedIn apps. The mockups define exactly what to build when accounts land.
