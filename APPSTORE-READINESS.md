# App Store readiness — Frame & Fork

**Verdict (2026-06-25): the binary is essentially submittable, but it is NOT yet ready to pass
review.** The remaining blockers are not code — they need your accounts, a test key, and one
hosted-file update. Honest go/no-go below.

## ✅ Done / verified (code side)
- Release configuration compiles clean (`xcodebuild -configuration Release`).
- 12 safety tests green (the role-play leakage spine is test-locked).
- `PrivacyInfo.xcprivacy` present; `ITSAppUsesNonExemptEncryption = false`; no ATS exception.
- Substantial **free tier** a reviewer can fully test with no key (Puzzles, Lessons, Master Games).
- No placeholder / "v0.2 coming" beta copy left in the UI (auto-improve pass).
- Privacy + support URLs are **live** (HTTP 200).

## ⛔ Blockers before submit — each needs you

1. **✅ DONE — corrected privacy policy published & verified live.** The prior `privacy.html`
   inaccurately claimed no third-party transmission; the Pro role-play sends conversation +
   Company Profile to Anthropic. Corrected policy now live at
   `moranetz.github.io/apps/frame-fork/privacy.html` (names Anthropic, BYO-key, nothing on a
   dev-controlled server). Also fixed `terms.html` (was 404; now live). Done by me, verified HTTP 200.

2. **CRITICAL — App Review notes + a demo key.** Pro needs an Anthropic key, so reviewers can't
   test it unless you give them one. Draft is at **`fastlane/metadata/review_information/notes.txt`**
   — paste a throwaway test Anthropic key + your support email into the two chips before submitting.
   Without this, expect a 2.1 rejection. *(Mine to draft — done; yours to add the key.)*

3. **ASC metadata + privacy nutrition label.** Confirm the App Store listing (description,
   keywords, screenshots) is complete in App Store Connect, and set the privacy "nutrition label"
   to reflect the one real data flow: user content sent to a third party (Anthropic) for app
   functionality, **not** linked to identity, **not** used for tracking. *(Yours — ASC.)*

4. **Refresh screenshots.** The local `./screenshots/` predate this session's UI changes (Profile
   now has Game history + no dead "Analysis" row; Watch is the new guess-the-move). I can
   regenerate fresh ones from the current build on request. *(Mine, on request.)*

## ⚠️ Lower priority / latent
- ~~`terms.html` → 404~~ **RESOLVED** — fixed with blocker 1; verified HTTP 200 on 2026-07-03
  along with `/apps/frame-fork/`, `privacy.html`, and `support.html`.
- BYO-key model: generally accepted by Apple for AI client apps, given the real free tier + the
  review-notes test path above. Low risk. 2026-07-03: in-app copy reframed from "Pro tier
  locked … each game costs roughly $0.50 on your key" (a quotable 3.1.1 tripwire: paid-tier
  framing + a price claim outside IAP) to utility framing ("connects to your existing Anthropic
  account … billed by Anthropic, not by this app").
- Latent 3.1.2/2.1 hazard if `FeatureFlags.subscriptionsEnabled` is ever flipped before the LLM
  proxy exists: `SubscriptionStore.isPro` unlocks nothing (the only gameplay gate is
  `Keychain.hasAPIKey()`), so a paying subscriber without a key still sees every bot locked.
  Wire `isPro` into the unlock check (and route requests through the proxy) before flipping.

## Not an App Store blocker (but the product's real gap)
The puzzle bank is still largely guessable and the backend/billing tier doesn't exist. Neither
blocks App Review — Apple won't reject for "puzzles are easy." These are product-quality and
business items, tracked separately in ENGINEERING-NOTES.md.
