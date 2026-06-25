# Frame & Fork — engineering notes (lessons & recurring mistakes)

A living, cross-session log of what tends to go wrong and how to avoid it. Read this first in a
new session. Add to it whenever a mistake repeats. Newest lessons at the top of each section.

## Recurring mistakes I actually made this session (avoid next time)
1. **Added a Swift file but forgot to re-run `xcodegen` → "cannot find type X".** This is an
   xcodegen project: new/removed files don't enter the build until `xcodegen` regenerates the
   `.xcodeproj`. Hit this twice (RolePlayJudgment, SubscriptionStore). RULE: after creating or
   deleting any source file, run `xcodegen` BEFORE `xcodebuild`. If a brand-new type is "not
   found" and you're sure it exists, the cause is almost always a missing regenerate, not the code.
2. **Chased SourceKit single-file diagnostics that were noise.** "Cannot find type 'Persona' /
   'Color' has no member 'bgPage'" appear constantly because the linter analyzes one file without
   the rest of the module. They are NOT real. `xcodebuild ... | grep -E "error:|BUILD"` is the
   only source of truth. Don't edit code to satisfy SourceKit.
3. **One-sided range patterns in `switch` (`case 0.3...:`) failed the type-checker** on a Double.
   Use explicit `if x >= 0.3 { … }` comparison ladders instead — clearer and they compile.
4. **A commit-once guard set the flag AFTER the `await` doesn't guard anything.** `didCommit`
   must be set immediately after the `guard`, before the suspension point, or a re-entry during
   the await double-records. (SimpleReviewView.) Same shape for any "run exactly once" async work.
5. **Custom `init(from:)` belongs in an EXTENSION, not the struct body**, when you still want the
   synthesized memberwise init that callers use (GameRecord). Declaring any init in the body
   suppresses the memberwise init.
6. **Two classification systems on one screen drift apart.** The card glyph used `classifyMove`
   while the hero used `Verdict` — same move could read two different labels. One vocabulary per
   surface; derive both from the same source.

## iOS / Swift / Xcode gotchas (this project)
- Build: `xcodegen` then `xcodebuild -project FrameFork.xcodeproj -scheme FrameFork -destination
  'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath <tmp> build`. Filter for
  `error:|warning:|BUILD`.
- Sim: app exposes NO accessibility labels → drive by coordinate (`cliclick`), not by name; taps
  can miss/land on the tab bar (verify the screenshot before trusting an interaction). Skip
  onboarding: `simctl spawn booted defaults write com.melmarion.FrameFork
  "framefork:hasSeenOnboarding:v1" -bool true`.
- AVAudioSession / UIKit show as "unavailable in macOS" in SourceKit — fine, the target is iOS.
- StoreKit config in the scheme: xcodegen DOES accept `schemes.<name>.run.storeKitConfiguration:
  <path>`. The `.storekit` lives OUTSIDE the `sources` glob so it isn't bundled as a resource.

## StoreKit 2 — the mistakes that bite (from the IAP integration)
- Start the `Transaction.updates` listener at APP LAUNCH (in the store's init), not inside
  `purchase()`. Out-of-band transactions (Ask-to-Buy approval, renewals, refunds/revocations,
  cross-device restores) only arrive there.
- ALWAYS `await transaction.finish()` after granting — unfinished transactions re-deliver forever.
- Always unwrap `VerificationResult` (.verified vs .unverified); never grant on .unverified.
- Handle every `PurchaseResult`: `.success`, `.pending` (Ask-to-Buy/SCA — entitlement comes via
  the listener, not the return value), `.userCancelled`, `@unknown default`.
- Entitlement = iterate `Transaction.currentEntitlements`, filter product IDs, exclude
  `revocationDate != nil`. Recompute after purchase/restore/launch/update.
- Restore = `AppStore.sync()` then recompute.
- **Client entitlement is NOT a security boundary** — see SECURITY.md. Verify server-to-Apple
  before it gates anything that costs money. Don't ship a paywall that unlocks nothing or isn't
  server-verified (flag it off until the backend exists).

## Security / architecture principles (earned this session)
- The client is untrusted. Anything that confers money or status (ratings, entitlements) must be
  recomputed/verified server-side. A client boolean gate is a UX hint, never a boundary.
- An LLM that grades user free-text is a forgery vector: use tool-use (not brace-scraped JSON),
  sandbox user text in a per-request random delimiter as untrusted DATA, instruct the model to
  score manipulation attempts as failure, and fail closed (no default score).
- Route external calls through ONE chokepoint (`AnthropicClient.performRequest`) so swapping to a
  proxy is a one-function change.

## Process / working with Marion
- Lead with the ONE governing insight, then let phases serve it (don't deliver a flat checklist).
- Diagnose with NUMBERS before fixing; red-team your own plan before implementing; show rendered
  before/after for anything visual; offer multiple UI versions.
- "Don't stop until 100%" = 100% of what's autonomously doable. Be explicit and honest about what
  is GATED (needs accounts / money / content adjudication / a device) and why — never pad or fake.
- Explicit "push this" is authorized; rebase cleanly if the remote diverged.

## Device-test TODOs (could NOT be verified headlessly — verify on a real run)
- The blind role-play **judge** (tool-use): the Play tab is key-gated, so the judge call can't be
  exercised in a headless sim. Run a real game with a key and confirm a tool_use grade returns,
  injection attempts score low, and the rating reflects the judge.
- StoreKit **purchase flow**: the system purchase sheet isn't drivable headlessly. With the
  `Pro.storekit` config selected in Xcode (or ASC sandbox), verify products load, purchase,
  restore, and `isPro` flips. (Currently behind `FeatureFlags.subscriptionsEnabled = false`.)
- The verdict-reveal **sound** (ToneSynth) needs a real device to actually hear.
