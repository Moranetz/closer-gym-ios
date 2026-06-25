# Frame & Fork — P0 backend/billing handoff (needs Marion's accounts + money)

This is the one thing an autonomous loop can't finish: it requires your Anthropic billing, a
deploy target, App Store Connect IAP setup, and (later) Stripe. Everything below is specced so
you — or a focused build session with your accounts — can execute fast. Context: DIAGNOSIS.md P0-1.

## The problem in one line
"Pro" today = each user pastes their own Anthropic API key and pays Anthropic directly. So
revenue flows to Anthropic (not you), consumers convert at ~0%, and no enterprise will let reps
paste personal keys. There is currently nothing to sell.

## The fix (no market decision required — this is the no-regret commit)
Kill bring-your-own-key. Put a thin server proxy in front of the model and real billing in front
of the proxy. The same backend is the minimum for BOTH a consumer subscription and team seats.

### 1. Server proxy (holds the key, caps the cost)
- A thin endpoint (Vercel function / Cloudflare Worker / Firebase Function — all in your stack)
  that forwards to the Anthropic Messages API with the key stored server-side as a secret.
- Per-request: verify the caller's auth token, check entitlement, rate-limit, and cap cost
  (hard per-user daily ceiling; downshift role-play to Sonnet if needed — DIAGNOSIS P3-4 notes
  cost is currently unbounded/unmonitored).
- **Client change is tiny and already isolated:** both LLM calls now route through ONE function,
  `AnthropicClient.postMessage(system:messages:maxTokens:)`. Point that at the proxy URL and send
  the user's auth token instead of `x-api-key`. `sendPersonaTurn` and the new blind `judgeGame`
  both flow through it unchanged — one chokepoint to swap.
- Files: `Engine/AnthropicClient.swift` (endpoint + header), `Engine/Keychain.swift` (store an
  auth/session token, not an Anthropic key).

### 2. Accounts / auth (minimum viable)
- Sign in with Apple → a stable user id (zero-friction on iOS, required for IAP receipts anyway),
  or Firebase Auth if you want cross-platform later. Server stores account + entitlement state.
- This is also the precondition for P1 (cross-device sync, manager rosters) — the data already
  modeled in `Storage.swift` just needs a server copy.

### 3. Billing
- **Consumer:** StoreKit 2 auto-renewable subscription (~$12–15/mo per the chess.com/Duolingo
  comps in RESEARCH.md). Gate the role-play on the entitlement instead of `Keychain.hasAPIKey()`
  (`PlayTab.swift` `proLockedBanner`/`hasKey`). Server validates the receipt before the proxy
  serves a game.
- **Small teams (the recommended PLG path, later):** Stripe per-seat, credit-card, 5–30 seats,
  no SSO/procurement yet. This is the cheap experiment that resolves B2C-vs-B2B (RESEARCH.md
  positioning): if small teams pay per seat, climb to enterprise with revenue + logos in hand.
- Remove the paste-your-key UI in `Views/Settings/SettingsView.swift`; replace with
  Subscribe / Restore Purchases.

## What needs YOU (the gated inputs)
1. An Anthropic account with billing for the proxy's server key (you absorb ~$0.50/game as COGS).
2. A deploy target + secret store (Vercel / Cloudflare / Firebase — your call).
3. App Store Connect: create the auto-renewable subscription product(s) + pricing.
4. (Later, for teams) a Stripe account + the legal-entity info ASC is already prompting for.

## Suggested sequence
1. Proxy + Sign in with Apple + StoreKit 2 consumer sub → **the app can now take money.**
2. Server sync of the existing `Storage` data → the precondition for any manager view.
3. THEN the team layer (P1-2 manager dashboard rendering `Store.themeStats()` across a roster) +
   the held-out benchmark + assignment (P1-3). The blind judge shipped in this pass is what makes
   a role-play number trustworthy enough to put on that dashboard (DIAGNOSIS P2-1).

## What's already done (this pass, no backend needed)
- Blind, process-gated LLM role-play **judge** (grades craft, not whether the buyer caved) —
  `Engine/AnthropicClient.judgeGame` + `Models/RolePlayJudgment.swift`. Works behind the proxy
  unchanged.
- Role-play **transcript persistence** (`GameRecord.turns`) — unblocks the rich debrief AND the
  content flywheel (mine games into new puzzles).
- Rich **debrief** with the strongest/weakest turn called out — `Views/Play/SimpleReviewView`.
- Rating now **gated on the judge's process score**, not the regex eval.

Net: the moat (the role-play) is now genuinely good and its grade is defensible. The remaining
P0 is purely the commercial plumbing above — which is yours to unlock.
