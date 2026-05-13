# Frame & Fork — App Store Listing Draft

Persuasion-Max voice: mechanistic, decompositional, neutral, no moral markers, sparing em-dashes. Edit before submission.

---

## Name (30 char max)

**Frame & Fork**  *(12)*

## Subtitle (30 char max)

**Sparring drills for closers**  *(28)*

Alternates if the above reads off:
- "The gym for sales conversations" (31 — over by 1; trim)
- "Closing practice on chess rails" (31 — over)
- "Sales sparring on chess rails" (29)
- "Mechanistic closing practice" (28)

## Promotional Text (170 char max, editable post-launch)

**100 hand-authored positions across 7 themes. A 35-technique Atlas. 15 buyer personas. Glicko-2 ELO. The gym for closers, not a coaching app.**  *(146)*

## Keywords (100 char max, comma-separated, no spaces)

**sales,sparring,closer,negotiation,sales training,closing,chess,sales practice,sales drills,atlas**  *(98)*

## Description (4000 char max)

```
A sparring app for sales conversations, built on the rails chess.com built for chess.

100 hand-authored puzzle positions across 7 themes (budget, procurement, stall, renewal, multi-stakeholder, endgame, cold open). Each position presents a buyer's line and four candidate moves. Pick one in 30 seconds. Reveal: each candidate's eval score, the mechanism the best move uses, the Atlas technique tag, and the linked transcript from a published practitioner.

Daily Drill rotates a deterministic puzzle per date. Solve correctly and your streak compounds.

35 Atlas techniques across 8 clusters (question-form, framing, compliance, negotiation-anchor, structural-close, post-objection, closing-environment, Cialdini-six). Each lesson surfaces the move's mechanism, where it lands, and where it backfires — sourced from Voss, Klaff, Cialdini, Cardone, Tracy, Belfort.

5 annotated master games. Eval curve, per-move technique tags, master's commentary. Watch the move-by-move trajectory of a real closer's day, in the same format chess.com uses for Kasparov's games.

Three rating buckets (Game / Puzzle / Analysis). Glicko-2 from Glickman 2013, same system chess.com uses for puzzles. Title progression from Patzer to Grandmaster Closer.

═══════════════════════════════════

Free tier (offline):
• Daily Drill
• 100 puzzle positions
• 35 Atlas lessons
• 5 master games with eval curves
• Glicko-2 puzzle rating
• Streak tracker
• Shareable rating card

Pro tier (bring-your-own Anthropic API key):
• 15-persona bot ladder, ELO 1200 to 2400
• Free-text live drill
• On-turn Atlas detector
• Eval bar
• Post-game review with intent-vs-fired ledger
• Glicko-2 game rating

Pro is bring-your-own-key. Your key lives in iOS Keychain on this device only. Every Pro turn calls Anthropic directly from your phone; we never see your key or your conversations. Approximate cost: $0.50 per game on your key.

═══════════════════════════════════

The puzzle voice is intentional. Candidates are compressed tactical notation (notation, not dialogue). Real-conversation texture lives in the Read Full Transcript layer — verbatim source from published Voss / Klaff / Cardone / Tracy / Belfort material. Authored dialogue gives off "this was written by a language model" tells; sourced transcripts do not.

This is the gym, not a coach. No motivational copy, no nudges, no scarcity timers, no streak guilt. The structure does the work.

Part of the Closer Foundation research program. Sister artifacts on GitHub: closer-curriculum (pedagogy layer), closer-sparring (web drill harness), sales-instrument, atlas. All MIT, all public.

Free tier requires no account, no email, no analytics, no third-party SDKs.
```

*(~2200 chars; ~1800 char headroom for edits)*

## What's New (for v1.1+, leave blank for v1.0)

n/a

## Support URL

https://moranetz.github.io/closer-gym-ios/support.html

## Marketing URL

https://moranetz.github.io/closer-gym-ios/

## Privacy Policy URL

https://moranetz.github.io/closer-gym-ios/privacy.html

## Copyright

2026 Marion Moranetz

## Category

**Primary:** Education
**Secondary:** Business

## Age Rating

4+ (no objectionable content)

## App Privacy questionnaire (manual in ASC)

Per privacy.html and the architecture:
- **Data collected:** NONE. (No account, no email, no analytics, no third-party SDKs, no tracking.)
- The Anthropic Pro tier sends conversation text directly from device to Anthropic. Apple treats this as data shared with a third-party processor at the user's direction, NOT data Frame & Fork collects. The questionnaire should reflect that distinction.

Recommended answers to common ASC questions:
- *Does the app use third-party advertising?* No
- *Does the app contain ads?* No
- *Does the app use any third-party SDKs?* No
- *Does the app collect data from this app?* **No** (Pro key + transcript live locally; Anthropic call is user-directed)

If reviewer pushes back on "no data collected" because of Anthropic, switch to:
- Type: **Other Data**
- Linked to user identity: **No**
- Used for tracking: **No**
- Purpose: **App Functionality**

## Encryption export compliance

`ITSAppUsesNonExemptEncryption = false` already in Info.plist. The app uses only Apple's iOS-provided TLS for the Anthropic call. Exempt.

## Screenshots required (6.9" iPhone 17 Pro Max, 1290×2796)

Minimum 3, max 10. Apple requires the 6.9" set; everything else autoscales.

Suggested shot list (in order):
1. **Daily Drill hero** — Puzzles tab, daily card up, streak visible
2. **Puzzle reveal** — solved state, four candidates with eval scores, Atlas tags
3. **Master Game viewer** — eval curve + transcript on Voss "two copies" master game
4. **Lessons (Atlas browser)** — technique grid + one lesson opened
5. **Bot ladder (Pro)** — 5 tiers, persona cards, ELO bands
6. **Live game** — chat in progress, eval bar showing operator advantage, fired-technique chips visible
7. **Post-game review** — eval curve, intent-vs-fired ledger
8. **Profile** — three rating buckets, shareable card

Marion-only step: pose the app in real states and capture via `xcrun simctl io booted screenshot`. See `~/.claude/skills/` for capture pattern.
