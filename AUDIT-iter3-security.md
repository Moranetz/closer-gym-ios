# Security Audit — Frame & Fork (closer-gym-ios) — portfolio-fix iter3

Date: 2026-05-15 · Skill: raroque-repo-audit · Scope: read-only, no outward-facing changes
Stack: SwiftUI iOS, **no backend**, BYOK Anthropic (user-supplied key), no payments, public GitHub repo (Moranetz/closer-gym-ios), LIVE on App Store (v1.0; v1.1 Pro-tier planned).

## VERDICT: **PASS** — cleared to publish

Findings: **0 Critical · 0 High · 1 Medium · 4 Low**. No open Critical/High → PASS.
This app is a *positive* example of the BYOK pattern; the long tail is advisory.

## What it gets RIGHT (verified, not assumed)

- **Keychain done correctly.** `Keychain.swift` uses `kSecClassGenericPassword` +
  `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` → key is NOT in iCloud Keychain
  and NOT in encrypted device backups. Directly defeats the backup-extraction vector
  Raroque calls out. Not UserDefaults. (MASVS-STORAGE-1 ✓)
- **No hardcoded secret** in source OR git history (public repo scanned with -S over
  all refs): only `sk-ant-...` placeholder strings. (CWE-798 ✓ clean)
- **Transport**: key sent as `x-api-key` to `https://api.anthropic.com` over TLS; no
  `NSAllowsArbitraryLoads`; ATS intact. (MASVS-NETWORK-1 ✓)
- **Key not logged**; loaded from Keychain at call time, never persisted elsewhere.
- **PrivacyInfo.xcprivacy** present AND wired into the pbxproj (4 refs) — not the
  "file exists but not in Resources phase" trap.

## Findings

**MEDIUM · CWE-770 · OWASP-AI (no usage/spend guardrail)**
File: `FrameFork/Engine/AnthropicClient.swift:52-87`
What: no client-side cap on conversation length / request volume; `max_tokens:600`
per call but unbounded turns, no soft spend ceiling.
Impact: a runaway or long session silently runs up the *user's* Anthropic bill (BYOK
→ user's money, not Marion's — hence Medium not High; no developer-cost exposure).
Fix: add a soft per-session turn/token budget + a "you've used N requests this
session" notice; cap history length sent.
Source: Raroque AI checklist (server-side caps → here, client-side advisory for BYOK).

**LOW · CWE-703** — `Keychain.saveAPIKey` ignores `SecItemAdd` OSStatus; a failed
write fails silently → user believes key saved when it wasn't (correctness/UX).
Fix: check status, surface a "couldn't save key" error.

**LOW · CWE-209** — `ClientError.httpError(code, bodyText)` surfaces the full upstream
response body in a user-visible error string. Anthropic does not echo the key, so no
secret leak; still verbose error disclosure. Fix: show status + generic message, log
body only in debug.

**LOW** — `URLSession.shared` with no explicit request timeout (default 60s) on the
AI call; a hung network leaves the UI waiting. Fix: dedicated session, ~30s timeout.

**LOW** — `SettingsView.swift:256` uses a plaintext `TextField("sk-ant-...")` adjacent
to a `SecureField` (:261) — almost certainly a user-initiated show/hide toggle
(acceptable UX). Confirm the plaintext field is only shown on explicit reveal.

## Cross-cluster note (high-leverage)

`Keychain.swift` + `AnthropicClient.swift` look like the shared BYOK template across
the AI cluster (persuasion-coach, persuasive-copy, hook, land, linkedin-optimizer).
Because THIS implementation is clean, the likely-correct play is: diff each sibling's
copy against this known-good pair rather than re-auditing each from zero. The 5
Low/Medium fixes, if applied to the canonical template, propagate the fix fleet-wide.

## Required to publish
Nothing blocking. Track the Medium (spend guardrail) + Lows as issues for the v1.1
Pro-tier work; none gate the current shipped build.
