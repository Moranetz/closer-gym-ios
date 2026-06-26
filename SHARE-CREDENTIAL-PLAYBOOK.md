# Share / credential / viral-loop playbook (reuse this)

Saved design thinking for the verify-claim share work (`mockups/verify-claim.html`), so the next
time we build something like it the reasoning is on hand and the amateur mistakes don't recur.
Marion's locked likes from this round are at the top — honor them.

## Locked preferences (Marion picked these — reuse, don't re-litigate)
- **"Turn this into a verified closer credential" framing** (verify-claim Version B). The flex is
  a *verified* credential tied to real identity — career capital, not a vanity number. This is the
  default voice for any share/credential surface.
- **The RARE badge gating.** The credential is earned and scarce (gated to a Fork/rare moment), not
  handed out. Scarcity is the value — never inflate it.
- **The blur-tease mechanic** (verify-claim Version A): show the thing they want (the team board,
  the credential) *blurred/locked*, so the reveal is the reason to act. Curiosity + in-group pull.

## The one principle everything serves
**You never ask for data or a share. You make the user chase status, and the data/share falls out
the back.** The moment a screen reads "complete your profile" / "invite friends for points," the
ego-driven user is gone. Reframe every ask as *getting an edge* or *claiming status*.

## The mechanics that work (and why), for the sales-bro archetype
- **Ride a win, never gate the door.** Offer verification/credential/share at the moment of peak
  status-desire (just after an earned win), never as a signup wall. This single sequencing call is
  what converts vs. repels.
- **Blur-tease** the locked status object (board/credential) → the reveal is the CTA.
- **In-group > global.** Rank against the user's *actual* team (work-email/Slack grouping) beats a
  global number; it's also the bottom-up enterprise wedge.
- **Future-pace + presuppose status.** "You're 40 points from Class A" presupposes the climb;
  "walk into Thursday's pipeline review already prepped" paints the future self.
- **The status object is the share.** A credential card so good the user posts it unprompted — the
  viral/recruit/data loops are hidden *inside* the status, never framed as any of them.

## The anti-amateur checklist (the mistakes we actually made / nearly made — do not repeat)
1. **Don't ship a share/deep link you haven't verified END TO END.** The LinkedIn `/feed/?text=`
   deep link does NOT reliably prefill the composer — it would've been a dead-end flex. We had to
   walk back a "functions fully" claim. RULE: a share affordance must be driven to its real
   destination before you call it done. The reliable iOS path for an image flex is `ShareLink`
   (native sheet → the platform is one tap); platform "post with prefilled image" deep links from a
   third-party app mostly don't exist.
2. **Never claim functionality you only partially verified.** "The endpoint returns 302" ≠ "the
   composer prefills." State exactly what you confirmed and what still needs a real-device tap.
3. **Real status only.** Fake/inflated rank or a fabricated cohort is the one thing this archetype
   smells instantly. The rating must be earned and (once teams exist) server-recomputed.
4. **Not on the nose.** No "Share to unlock," no points-for-invites, no "profile 40% complete." The
   pull is a status object worth flaunting + a blurred reveal, not a transactional CTA.
5. **No numbers/jargon leaked to the user** where a glyph/plain line does the job (the §0.3 lesson).
6. **Hide the data-collection FRAME, never the data PATH.** Reframe the motivation (status, not
   "give us data"), but keep the privacy disclosure truthful — a false-impression privacy line
   ("stays on your device" while it's sent to a third party) is worse than none.
7. **Protect the bottom rep.** A team board that broadcasts "you're last" to the manager kills
   adoption. Peer board = status-positive only (top + your neighborhood + most-improved); the full
   per-rep view is the separate, paid manager surface. Copy: "your team sees your rank, never your
   misses."
8. **Scrub shared artifacts of confidential intel.** A shareable card shows rank + move + objection
   *category*, never the raw competitive text a user typed.
9. **Don't ship a paywall/credential that unlocks nothing** — flag it off until it's real and
   server-verified (avoids App-Store + trust failure).

## Honest status of the in-app share today (so the next session isn't misled)
- BUILT + functional now: the rendered **Closer Card image share** via the native sheet (toolbar +
  the subtle "Add to LinkedIn" on Profile, which routes through `ShareLink` after the deep-link
  walk-back).
- MOCKUP ONLY (backend-gated): the full **verify-claim** experience — work-email/LinkedIn
  verification, the team board, the blurred-board tease, the verified-credential badge. The design
  is locked in `mockups/verify-claim.html` + `VERIFY-PLAN.md`; it lights up when accounts exist.
