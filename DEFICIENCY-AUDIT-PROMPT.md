# Deficiency-audit prompt (reusable across all 4 apps)

Paste this, pointed at one repo. Built from the lessons of finding deficiencies reactively — the
core is: a deficiency is a gap against the app's OWN bar, and you sweep for the whole CLASS, not
the one instance. Add "ultracode" to fan it across parallel agents (one per surface).

---

You are doing an EXHAUSTIVE, proactive deficiency audit of one of my apps. Standard: find every
glaring deficiency NOW, in one pass, so I never point at them one at a time. Be the reviewer who'd
be embarrassed if I found something you missed. Over-report; rank ruthlessly. DIAGNOSE ONLY — no fixes.

WHICH APP (pick the one I name):
- Frame & Fork (sales-training game):  ~/Developer/_archive/sales-persuasion/closer-gym-ios
- Forecast (cycle tracker as a weather app, femtech):  ~/Developer/forecast-ios
- Palm Beach Jeff (meditative idle beach game):  ~/Developer/castaway
- WildHearts (farm / animal-taming game):  ~/Developer/_archive/apps/WildHearts-Jackpot

GOVERNING PRINCIPLE (read twice)
1. A deficiency is a GAP BETWEEN WHAT EXISTS AND THE APP'S OWN INTENDED BAR. Read the design docs /
   governing insight / READMEs first; you can't judge "best it can be" without the bar.
2. FIX THE CLASS, NOT THE INSTANCE. The moment you find one deficiency, scan the WHOLE app for the
   same pattern. Every finding answers "where ELSE does this occur?" A rule applied locally when it's
   global is half a finding.
3. LOOK AT THE REAL THING — build it, run it, drive the screens/play the loop. Many deficiencies are
   only visible when seen.

UNIVERSAL DEFICIENCY CLASSES (hunt every one, across EVERY surface)
A. Invisible / dead / write-only features — data computed or recorded but never surfaced; results
   that vanish; "—" placeholder rows shipped as real; dead buttons. (The worst kind.)
B. The app violating its OWN doctrine — and applied locally not globally.
C. Passive where active would transfer/engage better; handed answers where the user should reconstruct.
D. Content voice — jargon, lab-speak, lorem-ish, off-brand — measured corpus-wide (data files too).
E. Cross-surface inconsistency — two components/vocabularies/colors/interaction-models for one concept.
F. First-run / empty / error / edge states a real user hits (no data, no key/login, offline, long absence).
G. Stale/placeholder copy shipped in-app (version numbers, "coming in vX", roadmap text, debug affordances).
H. Anything that would make a pro wince — unfinished polish, jank, misaligned hierarchy, vibecoded smell.

APP-TYPE LENSES (add what fits)
- GAMES (Palm Beach Jeff, WildHearts): reproducible glitches/bugs, dead/confusing mechanics, perf/jank,
  save/load, juice misfires, "is the core loop actually fun / does it pay off."
- HEALTH/FEMTECH (Forecast): false precision/certainty, medical accuracy, privacy (any data off-device +
  honest disclosure), emotional safety, do predictions ever get CONFIRMED or just vanish.
- TRAINING (Frame & Fork): does practice transfer, is the "best move" defensible, is the moat's output
  visible and its grade trustworthy.
- ALL: accessibility (Dynamic Type, reduce-motion, VoiceOver), and verification honesty — flag anything
  you could NOT actually drive/verify rather than assuming it works.

METHOD: read docs (state the bar in one line) → build + run + drive every surface / play the loop →
inventory every surface, walk classes A–H + the app lenses → for each finding grep the whole app for the
same class → mark anything unverified.

OUTPUT: one ranked report, worst first. Each finding: file:line(s) + every other instance of the class,
what it is, why it's glaring (vs the doctrine or basic polish), severity (GLARING / REAL / MINOR / FUTURE),
the concrete fix, and whether it's code / content / gated. End with: the single highest-leverage fix, the
recommended batch order, and a short list of what's genuinely strong (for calibration). Do NOT fix anything.
