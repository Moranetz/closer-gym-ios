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

1. **CRITICAL — publish the corrected privacy policy.** The current live
   `privacy.html` is INACCURATE: it claims the app transmits nothing to any third party, but the
   Pro role-play sends your typed conversation + Company Profile to **Anthropic**. Submitting
   against it risks rejection (5.1.1) and is a real misrepresentation. I wrote a corrected
   version at **`appstore/privacy.html`** — publish it to `moranetz.github.io/apps/frame-fork/privacy.html`.
   *(Mine to draft — done; yours to publish.)*

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
- `terms.html` → **404**, linked only from `PaywallView`, which is behind
  `FeatureFlags.subscriptionsEnabled = false` (unreachable today). Host a terms page *before* you
  ever flip subscriptions on, or drop the link. Not an active blocker.
- BYO-key model: generally accepted by Apple for AI client apps, given the real free tier + the
  review-notes test path above. Low risk; keep as-is.

## Not an App Store blocker (but the product's real gap)
The puzzle bank is still largely guessable and the backend/billing tier doesn't exist. Neither
blocks App Review — Apple won't reject for "puzzles are easy." These are product-quality and
business items, tracked separately in ENGINEERING-NOTES.md.
