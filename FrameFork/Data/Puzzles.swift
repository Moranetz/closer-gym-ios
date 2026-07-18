import Foundation

/// 127 hand-authored puzzle positions (originally a 20-puzzle port from web
/// src/lib/puzzle-library.ts; batches 2+ authored natively — the section banners
/// below reflect the original batch only, so group by `theme`, not by banner).
///
/// Candidates are compressed tactical descriptions (notation, not dialogue). The
/// puzzle question is "which move type fits this position", not "which exact
/// English sentence sounds best."
///
/// A puzzle MAY point to a real sourced transcript (Transcripts.swift) via
/// transcriptId — only where the transcript honestly demonstrates the best
/// move's technique class. No honest match → nil (the reveal hides the link).
///
/// INVARIANT (machine-checked in tests): every puzzle currently has bestIndex 0
/// with the strictly-top eval. Candidates must NEVER be rendered in data order —
/// PuzzleSolveView shuffles with an id-seeded RNG; any new consumer must too.
public enum Puzzles {
    public static let all: [Puzzle] = [
        // ─── Budget (4) ─────────────────────────────────────────────────
        Puzzle(
            id: "p001", theme: .budget, difficulty: 1300,
            buyerRole: "VP Operations, mid-market SaaS",
            setup: "Eighteen minutes into discovery. You've established the onboarding-churn problem. Buyer just heard pricing.",
            buyerLine: "It's just not in the FY26 envelope. We'd have to pull from training or shift the hire freeze around, and neither one's going to fly with the board.",
            candidates: [
                PuzzleCandidate(text: "Sounds like the real question isn't what this costs — it's what pulling from training or moving the freeze would cost you personally in front of the board.", eval: 0.8, rationale: "They listed two levers they've already rejected — that's a board-defensibility problem wearing a budget costume. A label names it without demanding an answer; they'll correct it or confirm it, and either way you've found the real ceiling.", atlasTags: ["labeling"]),
                PuzzleCandidate(text: "Which one's actually the harder sell upstairs — touching training, or moving the freeze?", eval: 0.3, rationale: "Right diagnosis, dodgeable instrument. The lever question re-runs the same budget script they've already performed for the board — and a question can be deflected in a way a label can't.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Every quarter the onboarding churn runs, it costs you more than the training line. Deferring is the expensive path here.", eval: -0.4, rationale: "Strong evidence aimed at the wrong target. They never disputed the cost — they disputed the fundability. Stacking more cost onto a funding objection reads as not listening.", atlasTags: ["loss-framing"]),
                PuzzleCandidate(text: "What if I got the number inside the FY26 envelope — if we can sign this quarter?", eval: -0.9, rationale: "You just priced an objection that was never about price. Your anchor is gone, the board problem is still standing, and procurement now knows exactly how flexible you are.", atlasTags: ["sharp-angle", "scarcity"]),
            ],
            bestIndex: 0,
            themeHint: "Budget-as-policy and budget-as-priority require different responses. Most reps treat both as price.",
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p002", theme: .budget, difficulty: 1600,
            buyerRole: "CFO, $200M revenue SaaS",
            setup: "Fourth meeting. Champion VP-Eng on the call. Value mapped at $1.2M last week. CFO just joined.",
            buyerLine: "I need a payback number I can defend to the board. Anything past 14 months and I'm not pushing this up. What's your math?",
            candidates: [
                PuzzleCandidate(text: "Halden's CFO defended an 11-month payback to their board in March — I can walk you through their math, or we can build yours from your numbers. Which is more useful?", eval: 0.8, rationale: "A named peer with a specific number is hard to dismiss as vendor math, and the either/or hands the CFO the choice of method. They shift from evaluating your cost to evaluating the math — you're now solving their board problem with them.", atlasTags: ["social-proof", "alternative-choice"]),
                PuzzleCandidate(text: "Most customers see payback inside a year — I'll send the full breakdown after the call.", eval: -0.3, rationale: "A generic stat plus a follow-up promise gives them nothing defensible in the room where they asked for it. The CFO stays uncertain, and uncertain CFOs don't push deals up.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Let me build you a custom payback model on your actual numbers — I'll have it to you by end of week. [To champion] Can you get me the usage and cost data before Friday?", eval: -0.5, rationale: "You just volunteered a week of work and moved the decision into an email thread. The live moment dies, and your champion has to rebuild all the urgency you let dissipate.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "What payback number would you need to see to push this up? We can work backward from there.", eval: -1.1, rationale: "You handed the CFO the framing pen. Whatever number they name becomes the ceiling — you've pre-positioned a concession nobody even asked for.", atlasTags: ["calibrated-question"]),
            ],
            bestIndex: 0,
            themeHint: "On prestige-driven C-level, named-peer specificity outperforms generic stats. The branch offer doubles as a recipient-agency move.",
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p003", theme: .procurement, difficulty: 1800,
            buyerRole: "Procurement specialist, F500",
            setup: "First procurement call after business team agreed in principle. Procurement specialist has very high persuasion-knowledge.",
            buyerLine: "Our procurement guidelines flag anything above 12% premium versus the next bid. You're at 15. Either we close the delta or this goes to a re-bid process I can't accelerate.",
            candidates: [
                PuzzleCandidate(text: "Before we work the delta — can we put both SOWs side by side, line for line? Fifteen percent against a matched scope is a different number than fifteen against list.", eval: 0.7, rationale: "The 12% guideline only binds against comparable bids. Moving the reference point from list price to matched scope changes what the premium is judged from — and procurement respects comparison rigor, because it's their own daily work.", atlasTags: ["contrast", "concrete-construal"]),
                PuzzleCandidate(text: "What did the other bid actually scope before we invoke the twelve percent?", eval: 0.4, rationale: "Right instinct, weaker instrument. An open question lets a specialist this savvy choose what to disclose; the side-by-side artifact forces the comparison onto the record.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "I can get to twelve if it keeps us out of the re-bid — call it a one-time accommodation to the guideline.", eval: -0.5, rationale: "A concession inside the first procurement turn. The guideline just became your price, the accommodation became the precedent, and the next guideline arrives at renewal.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "The business team already accepted this number in principle — the premium's been signed off at the level that owns the budget, so I'd hate to re-litigate something leadership has already agreed to.", eval: -0.9, rationale: "You just tried to route around procurement's mandate, and a specialist at this level reads it as exactly that. The re-bid stops being their threat and becomes their process.", atlasTags: ["authority"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p004", theme: .budget, difficulty: 1500,
            buyerRole: "Founder, Series A startup",
            setup: "Cash-conscious founder, real burn-rate constraints, also genuinely interested. Twenty-eight minutes in.",
            buyerLine: "Real talk, we're burning $310K a month and can't push the round. $30K is what I have. If your product isn't a $30K product, we'll find a workaround.",
            candidates: [
                PuzzleCandidate(text: "Let's not discount — let's scope. Give me 24 hours to design a starter package that's genuinely a $30K product, and if it isn't one, I'll tell you straight and we part clean.", eval: 0.7, rationale: "She gets a yes-to-something path plus an explicit no-fit exit — exactly the register a real-talk founder respects. And the 24-hour deadline moves you out of chase posture into fit-evaluation posture.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Let me take this back to my team and see what I can do on the number. Can we grab 30 minutes Thursday? I don't want this losing steam while I check — I think there's a real fit here.", eval: 0.1, rationale: "Buys time, adds nothing. She's in exactly the same place when you come back — except colder, because the conversation that was live is now a calendar entry.", atlasTags: ["mutual-close-plan"]),
                PuzzleCandidate(text: "What if we locked in three years to bring year one down to your number?", eval: -0.3, rationale: "You just proposed a multi-year lock-in to a founder who told you her runway is uncertain. She hears it as proof you weren't listening.", atlasTags: ["lowball"]),
                PuzzleCandidate(text: "Honestly, the workaround will cost you more than the delta — you'll pay for it slowly instead of once.", eval: -1.0, rationale: "Arguing runway math with the person who lives in that spreadsheet is structurally implausible — she knows her burn better than you ever will. Reactance fires and the warmth is gone.", atlasTags: ["loss-framing", "authority"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-money-reframe"
        ),

        // ─── Procurement (3 more) ────────────────────────────────────────
        Puzzle(
            id: "p005", theme: .procurement, difficulty: 1900,
            buyerRole: "Senior procurement specialist",
            setup: "Late stage. Champion verbally committed. Procurement running 'standard process.'",
            buyerLine: "We've been burned twice in the last 18 months on year-one cancellations. Procurement now requires a 90-day evaluation period before any multi-year. That's policy, not preference.",
            candidates: [
                PuzzleCandidate(text: "The 90 days is fine — we'll run it. Two things to make it work: what does a pass look like at day 90, and should we flag to your sponsor what a quarter of delay costs their team?", eval: 0.9, rationale: "You absorb the policy without contest, then open two doors in the same breath: procurement's exit criteria and the sponsor's cost of delay. That's multi-threading embedded inside compliance — the policy stays intact and the deal keeps moving.", atlasTags: ["calibrated-question", "multi-threading"], isFork: true),
                PuzzleCandidate(text: "Any way we could compress the evaluation to 30 days?", eval: -0.2, rationale: "You're negotiating the timeline without touching the policy frame. They told you it's policy, not preference — haggling the number tells procurement you need this deal more than they need the eval.", atlasTags: ["extreme-anchor"]),
                PuzzleCandidate(text: "Would our SOC 2 and ISO 27001 packages cover what the evaluation is checking for? I can also set up reference calls with two security teams who've been through year one with us and renewed.", eval: -0.5, rationale: "You just offered paperwork as a substitute for a step they framed as non-negotiable. To a procurement specialist that reads as substitution, and the generic reference offer lands as every vendor's move.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "What if we papered the multi-year now with a 90-day out clause — same protection, no eval period?", eval: -1.0, rationale: "That's a route around procurement's authority dressed up as cleverness. They read it as either ignorance of their mandate or an attempt to dodge it — both cost you trust you can't buy back.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: nil
        ),

        Puzzle(
            id: "p006", theme: .procurement, difficulty: 2100,
            buyerRole: "Procurement counterparty in adversarial negotiation",
            setup: "You've named your number. They've named theirs. Gap is $40K.",
            buyerLine: "We're $40K apart. Before either of us makes a move, what's your last quarter's win-loss ratio at our deal size? I want to know what the next vendor in line costs us.",
            candidates: [
                PuzzleCandidate(text: "I don't have that number in a form I'd stand behind, so I'm not going to guess at it. What I can defend is the deployment math — you said the six-week install was worth real money to your team. Let's price that.", eval: 0.6, rationale: "You refused to invent a number you can't defend and re-anchored on a dimension they already told you they value. The conversation now sits on ground you can actually hold.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Honestly? About three in five at your size — small sample.", eval: 0.1, rationale: "Honest, and free. They pocket the data point with zero obligation — you disclosed information without extracting anything in return.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Let's just split the difference — meet at twenty and both stop negotiating.", eval: 0.2, rationale: "Workable, but you just told procurement you can move twenty grand. They'll be back for a second pass at half of it.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "Take the full forty off if we sign by Friday — and I'll put a signed delivery guarantee on top to make it easy.", eval: -1.1, rationale: "They don't read that as generosity — they read it as a rep hitting a quarter-end number. Full capitulation plus manufactured urgency confirms every lever they suspected they had.", atlasTags: ["scarcity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p007", theme: .procurement, difficulty: 1700,
            buyerRole: "IT security architect, technical evaluator",
            setup: "Security review meeting. Architect finished walking through their concerns.",
            buyerLine: "SOC2's fine. FedRAMP's the issue. We're under a federal data-sharing agreement and audit's been getting more aggressive. Even a Moderate ATO would unblock us.",
            candidates: [
                PuzzleCandidate(text: "Straight answer: we don't hold a FedRAMP ATO today, and I won't pretend otherwise. When does the audit actually land? If it's Q4, this is a different timing conversation than if it's next month.", eval: 0.6, rationale: "You named the gap accurately and surfaced a timing question the architect can actually answer. They walk away reading you as audit-literate — which is worth more than a promise you can't keep.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "We're targeting Moderate ATO next year. If that unblocks you, we'll put the date in the MSA as a milestone with remedies attached — and I'll send you the roadmap doc so your team can verify exactly where we are.", eval: 0.3, rationale: "Works if you can genuinely hold the date. If your roadmap slips, you've converted a compliance gap into a contract breach and a reputation hit.", atlasTags: ["commitment-consistency"]),
                PuzzleCandidate(text: "Are you sure FedRAMP applies here? SOC 2 covers most of that same surface.", eval: -0.5, rationale: "You're arguing with a security architect about their own stated requirement. Even if you're technically defensible, you're spending credibility you'll need downstream.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "We're FedRAMP-equivalent — same control set, different auditor. It'll clear your audit.", eval: -0.9, rationale: "The architect is positioned to check that claim in five minutes, and it won't survive the check. Misrepresentation to a technical evaluator surfaces immediately.", atlasTags: ["authority"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        // ─── Stall (3) ───────────────────────────────────────────────────
        Puzzle(
            id: "p008", theme: .stall, difficulty: 1400,
            buyerRole: "VP Sales, mid-market",
            setup: "Second meeting. Proposal sent three weeks ago. Follow-ups unanswered. You finally got them back on a call.",
            buyerLine: "Yeah. I should've gotten back to you. We're still in it but I'm not the priority right now. Leadership has me on a sales-comp redesign that's eating my Q.",
            candidates: [
                PuzzleCandidate(text: "Two options: we park it till your Q clears, or I shrink it to one team. Which is real?", eval: 0.7, rationale: "Both options respect the constraint they named, and the pick does your diagnostic work for you: park means genuinely deprioritized, shrink means the interest is still alive.", atlasTags: ["calibrated-question", "alternative-choice"]),
                PuzzleCandidate(text: "Totally understand. Want me to check back in six weeks?", eval: -0.3, rationale: "You just scheduled the same conversation for six weeks from now. Nothing about their priority stack will have changed by then.", atlasTags: ["mutual-close-plan"]),
                PuzzleCandidate(text: "What if I built the whole rollout plan and the internal deck for you — zero lift on your side?", eval: -0.4, rationale: "The deck gets delivered; the attention doesn't. You've traded real work for the same silence, and the pattern repeats.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Just so you know — the pricing we scoped expires end of month, and with your Q this packed we should lock it now before it resets.", eval: -0.8, rationale: "Fake urgency stacked on a real capacity constraint tells them you're quota-driven, not customer-driven. The stall doesn't break — it hardens.", atlasTags: ["scarcity", "loss-framing"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-think-it-over"
        ),

        Puzzle(
            id: "p009", theme: .stall, difficulty: 1700,
            buyerRole: "Founder, post-Series B",
            setup: "Founder said yes 30 days ago to a $200K contract. Legal review has been 'in progress' for three weeks.",
            buyerLine: "Still with legal. They bumped it for a vendor dispute that broke this week. I'll get them back on it Monday.",
            candidates: [
                PuzzleCandidate(text: "Monday works. While legal's tied up — is there anything else on your side that could bump this again, and does the vendor dispute touch anything in our contract?", eval: 0.7, rationale: "You didn't press the legal team's availability — you surfaced the blockers actually inside their control. The wait state becomes information whichever way they answer.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Want me to take the coordination off your plate entirely? I'll get our counsel and yours into one working session Monday morning and we'll clear the redlines in an hour.", eval: 0.3, rationale: "Useful if legal really is the blocker. If legal is a proxy for cold feet, the session gets deflected and the deprioritization finally shows itself — an expensive way to find out.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "No problem at all — I'll check in Monday.", eval: -0.2, rationale: "You accepted the frame wholesale. They drop back into low-attention mode, and Monday quietly becomes next Thursday.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "Heads up — our new rate card lands next week and this pricing resets with it. Any way legal moves faster?", eval: -0.7, rationale: "Pressure keyed to an event they can't control reads as your quota anxiety, not their problem. Trust degrades and the stall stays.", atlasTags: ["scarcity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "cardone-snapbacks"
        ),

        Puzzle(
            id: "p010", theme: .stall, difficulty: 2000,
            buyerRole: "Champion VP-Eng",
            setup: "You've pushed for close for two weeks. Champion unusually quiet after a month of high engagement.",
            buyerLine: "Have to push to Q3. CTO's been pulled into the Series B prep and the spend committee is on hold until that closes. Not a no. Just a wrong-quarter.",
            candidates: [
                PuzzleCandidate(text: "Q3's fine — no pressure on the date from me. One thing I want straight: is this a calendar problem, or has something shifted in the deal itself?", eval: 0.7, rationale: "Releasing the schedule pressure costs you nothing; the calendar-versus-content question buys you everything. The answer tells you whether this is a procedural deferral or lost air cover — actionable either way.", atlasTags: ["calibrated-question", "labeling"]),
                PuzzleCandidate(text: "Understood — let's pick it up in Q3.", eval: -0.2, rationale: "Graceful and empty. You leave without learning whether Q3 is real or a soft no — the one thing this call could have told you.", atlasTags: ["liking", "silence"]),
                PuzzleCandidate(text: "While the CTO's heads-down, would it help if I walked your ops lead through the rollout plan so Q3 starts warm?", eval: 0.3, rationale: "Works if your champion welcomes the coverage, backfires if it smells like a bypass. Multi-threading during their stated capacity crunch is a coin-flip you don't have to take today.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "One thing — our pricing holds through June only, so the wait has a cost. Should I take fifteen minutes directly with the CTO so this doesn't die in committee?", eval: -0.9, rationale: "Fake price pressure plus an end-run to the one person they told you is unavailable. Your champion hears self-interest overriding everything they just said.", atlasTags: ["scarcity", "authority"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-think-it-over"
        ),

        // ─── Renewal (3) ─────────────────────────────────────────────────
        Puzzle(
            id: "p011", theme: .renewal, difficulty: 1500,
            buyerRole: "New VP Operations, renewal contact",
            setup: "Thirty days before renewal. Usage data shows heavy team adoption. New VP doesn't know you.",
            buyerLine: "I inherited this and three other contracts in a similar range. I'm running a baseline-vs-replace evaluation across all of them this quarter. Walk me through what your team's been getting.",
            candidates: [
                PuzzleCandidate(text: "Happy to walk you through it. First, though — what does 'keep' need to look like in your evaluation? I'd rather map our value to your criteria than to ours.", eval: 0.7, rationale: "Asking for the evaluation criteria signals you understand this review is systematic, not personal — and now the value story lands inside their framework instead of bouncing off it.", atlasTags: ["calibrated-question", "alternative-choice"]),
                PuzzleCandidate(text: "I'll export the full usage data right after this call — daily actives, feature depth, all of it. The two adoption curves worth flagging are your CS team and the field org; both are still climbing.", eval: 0.2, rationale: "Data without context. The numbers are real but they don't connect to the evaluation framework they just described — you answered a framework question with an export.", atlasTags: ["concrete-construal"]),
                PuzzleCandidate(text: "Want me to run the baseline-versus-replace comparison for you?", eval: -0.3, rationale: "The comparison will arrive and displace nothing — a new VP isn't outsourcing the judgment they were hired to make. You've spent real hours on a lateral move.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "One thing to be aware of — teams that cut this mid-adoption usually pay double to reinstate it later.", eval: -1.2, rationale: "Consequence-pressure on a first call, against someone who has zero relationship equity with you. They file you under vendors who threaten, and the eval gets easier to run against you.", atlasTags: ["loss-framing"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-prize-frame"
        ),

        Puzzle(
            id: "p012", theme: .renewal, difficulty: 1900,
            buyerRole: "CFO at renewal, considering seat downgrade",
            setup: "Quarterly business review just ended. CFO questioning the seat count.",
            buyerLine: "We pay for 200, 130 are active by your dashboard. I have a board-asked-question on idle seats and I need an answer before close-of-quarter. Tell me why I shouldn't cut to 130.",
            candidates: [
                PuzzleCandidate(text: "Here's the answer you can forward: 130 is your seasonal trough, not your baseline — and cutting 70 seats saves less this year than a single re-expansion at list price will cost you at the next peak.", eval: 0.8, rationale: "The CFO asked for a defensible answer, and the defensible answer is a loss number, not a question. Trough data plus re-buy pricing turns 'idle seats' into 'cheap insurance' — in the same language the board question was written in.", atlasTags: ["loss-framing", "concrete-construal"]),
                PuzzleCandidate(text: "Let's step it to 150 in two moves — 25 seats now, before your close-of-quarter, and 25 more next quarter if the trough holds. The board sees movement on idle seats and you're not stranded at peak.", eval: 0.2, rationale: "Workable, but you're negotiating a question that wasn't a negotiation yet. You've accepted 'cut' as the frame — and next quarter you'll have this same conversation again, starting from 150.", atlasTags: ["anchor-with-range"]),
                PuzzleCandidate(text: "For context, 65% utilization is right at the median for companies your size — most accounts at this ARR run between 60 and 70.", eval: -0.5, rationale: "Aggregate stats against a specific board-asked question. The CFO can't forward a benchmark to the board; they can forward a ledger.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Worth noting the contract holds the 200-seat floor through the term regardless of utilization — so the real conversation is renewal, not now.", eval: -0.7, rationale: "Technically true and relationally fatal. A CFO holding a board question hears 'we collect either way' — and starts pricing the exit.", atlasTags: ["authority", "commitment-consistency"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: nil
        ),

        Puzzle(
            id: "p013", theme: .renewal, difficulty: 1700,
            buyerRole: "Champion being recruited elsewhere",
            setup: "Champion has hinted they may not be at the company at renewal time. Renewal in 60 days.",
            buyerLine: "Heads up. I've got an offer I'm probably taking. Renewal's in 60 days and the new person will want to look at things from scratch. Just so you can plan.",
            candidates: [
                PuzzleCandidate(text: "Thank you for the straight warning. Two asks: would you intro me to whoever inherits this, and would it help if I restructured the renewal so the new person isn't locked into a call you made?", eval: 0.7, rationale: "You took the courtesy signal without pressuring the one person doing you a favor, and the successor-friendly structure is a real concession that lowers the new owner's switching cost. Both moves compound.", atlasTags: ["multi-threading", "reciprocity"]),
                PuzzleCandidate(text: "Any chance we could paper the renewal before you leave? Sixty days is tight for someone brand new.", eval: -0.3, rationale: "Your champion hears self-interest — and even if they sign it, a successor who wants to look at everything from scratch can kill a contract they never chose. You'd be locking a door the new person owns the key to.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Who's likely to inherit this? I'd love an intro before you go.", eval: 0.4, rationale: "Useful but transactional. You might get the name; the introduction — the thing that actually transfers trust — is a separate favor you didn't ask for.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Congrats! I'm sure the renewal will go just fine.", eval: 0.0, rationale: "They just handed you a risk flag as a personal courtesy, and you waved it off. What registers is that you didn't hear them.", atlasTags: ["social-proof"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-accusation-audit"
        ),

        // ─── Multi-stakeholder (2) ──────────────────────────────────────
        Puzzle(
            id: "p014", theme: .multistakeholder, difficulty: 1700,
            buyerRole: "Champion VP-Eng, with quiet CFO on the call",
            setup: "Joint call with champion + CFO. Champion enthusiastic for 35 minutes. CFO has said almost nothing.",
            buyerLine: "[CFO finally speaks] Deployment risk. What's the operational profile? I've been through three vendor rollouts where the technical part went fine and the operational part broke a process owner.",
            candidates: [
                PuzzleCandidate(text: "Two ways this breaks operationally: a process owner inherits a workflow nobody redesigned, or approvals move and nobody re-maps them. Which did your three look like?", eval: 0.8, rationale: "You named concrete failure modes in the CFO's own framing — operational, not technical — and the branch question makes them specify which pattern they're actually afraid of. The quiet CFO just became a participant.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Fair concern — for what it's worth, across 200-plus deployments our operational escalation rate is under two percent.", eval: -0.4, rationale: "An aggregate stat doesn't touch the three specific incidents the CFO lived through. They're not asking about your average — they're asking about their scar tissue.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "[To champion] You've been closest to how our rollout would touch your team's day-to-day processes — want to walk through how the three incidents map onto ours? I'll add color afterward.", eval: -0.2, rationale: "Your champion probably doesn't carry the process-owner-failure framing, and watching them fumble it deepens the exact hesitation you're trying to close.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "The honest answer is that the operational profile depends on discovery we haven't done yet.", eval: -0.5, rationale: "The CFO hears deflection — and a CFO who finally spoke after 35 minutes of silence doesn't give you a second opening.", atlasTags: ["takeaway"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        Puzzle(
            id: "p015", theme: .multistakeholder, difficulty: 2000,
            buyerRole: "Independent board director joining the eval call",
            setup: "Board director with audit-committee experience has joined a deal call. Very high persuasion-knowledge.",
            buyerLine: "If this vendor blows up in eighteen months, what does the proxy paragraph look like? I've sat through two of those and I want to know what I'm signing up for.",
            candidates: [
                PuzzleCandidate(text: "If this blows up, the paragraph reads 'inadequate vendor diligence' or 'no exit provisions.' We can pre-empt both in the contract — annual audit rights and a tested transition plan.", eval: 0.8, rationale: "You answered a narrative-risk question with the two sentences the proxy paragraph would actually contain, plus the structure that pre-empts them. The director now reads you as audit-committee-literate, and the conversation moves into their home domain.", atlasTags: ["calibrated-question", "authority", "labeling"]),
                PuzzleCandidate(text: "We work with a lot of board-governed enterprises — governance questions like this come up often, and our customers are comfortable.", eval: -0.5, rationale: "Board directors have heard 'lots of board-level customers' from every vendor who ever pitched them. It lands as content-free.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "I'd point you to our SOC 2, the ISO cert, and our contractual templates — in fact, I can walk you through the audit-committee mapping document clause by clause right now if that's useful.", eval: 0.3, rationale: "Necessary but insufficient. They asked what the story looks like when it blows up, and you answered with paperwork — documentation risk isn't narrative risk.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Honestly, the failure scenario you're describing is remote — the risk here is very low.", eval: -1.0, rationale: "Telling a director who has sat through two vendor blow-ups that the risk is low signals you don't understand the job. They're not pricing probability — they're pricing the paragraph.", atlasTags: ["authority"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-accusation-audit"
        ),

        // ─── Endgame (2) ────────────────────────────────────────────────
        Puzzle(
            id: "p016", theme: .endgame, difficulty: 1800,
            buyerRole: "Champion who has just verbally committed",
            setup: "Champion just said yes. You have 30 seconds before they pivot to another meeting.",
            buyerLine: "Yeah, this is making sense. I'm in. What do you need from me?",
            candidates: [
                PuzzleCandidate(text: "Three things while we're still on: who should the MSA go to, what's a realistic turnaround on your side, and let's put the signing call on the calendar right now — does Thursday work?", eval: 0.8, rationale: "Three procedural commitments in one breath, while the yes is still warm. 'While we're still on' converts champion momentum into calendar state — and calendar state survives the week in a way enthusiasm doesn't.", atlasTags: ["mutual-close-plan", "alternative-choice"]),
                PuzzleCandidate(text: "Fantastic — I'll let you get to your next meeting. I'll send a recap tonight capturing where we landed and proposing a procurement kickoff window, and we can touch base tomorrow once you've read it.", eval: 0.1, rationale: "By tomorrow they've been through three other meetings and the yes has cooled to 'let me re-read that email.' You had thirty seconds of peak momentum and spent them on politeness.", atlasTags: ["summary-close", "mutual-close-plan"]),
                PuzzleCandidate(text: "Amazing. Any chance we can get the signature done today?", eval: -0.4, rationale: "They said yes — they didn't say they sign contracts unilaterally. Pushing for same-day signature says you don't understand how their org buys.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Great — before you run, let me send over two more case studies and a reference list.", eval: -0.9, rationale: "They already said yes — selling past it reads as hedging, and now they wonder what you're hedging against. You've created doubt where there wasn't any.", atlasTags: ["social-proof"]),
            ],
            bestIndex: 0,
            themeHint: "Mate-in-1. The verbal yes is the move; procedural commitments in the next 30 seconds determine whether it survives the week.",
            transcriptId: "cardone-yay-or-nay"
        ),

        Puzzle(
            id: "p017", theme: .endgame, difficulty: 2200,
            buyerRole: "Procurement, final call before signature",
            setup: "Final call. They've sent redlines. You're walking through.",
            buyerLine: "Last item. Unilateral termination at 90 days, 50% refund. That's the clause language. Standard in our vendor contracts since the [redacted competitor] incident.",
            candidates: [
                PuzzleCandidate(text: "The policy makes sense — I won't fight the why. Could we hit the same protection another way: quarterly performance gates with a cure period, accountability without the refund accounting?", eval: 0.7, rationale: "You took the policy at face value and offered equivalent accountability without the refund plumbing. Procurement experiences you as policy-aware — which, on a final call, is the fastest route through.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "We can live with 30 days' notice and no refund — that's as far as this clause moves.", eval: -0.3, rationale: "You countered the terms without acknowledging why the clause exists. Procurement hears a vendor who wasn't listening — on the last call, on the last item.", atlasTags: ["anchor-with-range"]),
                PuzzleCandidate(text: "Before I respond to the clause language — which vendor incident actually wrote this into your playbook? I'd much rather understand and solve the failure you're protecting against than argue the symptom.", eval: 0.4, rationale: "Structurally a fine question — three calls ago. This late in the cycle, digging into the incident history reads as reopening a negotiation everyone thought was closing.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "If the clause is truly a must-have, this may not be the right contract for us.", eval: -0.5, rationale: "A takeaway only works when the walk is credible — and with this much pipeline cost sunk, they know you won't. Bluffs read as bluffs.", atlasTags: ["takeaway"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: nil
        ),

        // ─── Cold open (3) ──────────────────────────────────────────────
        Puzzle(
            id: "p018", theme: .coldOpen, difficulty: 1300,
            buyerRole: "VP at a target account who just answered the cold call",
            setup: "Cold call to a senior VP who actually picked up. You have eight seconds before they say 'not interested.'",
            buyerLine: "Hello?",
            candidates: [
                PuzzleCandidate(text: "Hi [Name] — this is a cold call, I'll say that up front. You can hang up now, or give me 27 seconds and then decide. Which would you prefer?", eval: 0.7, rationale: "Naming the call type out loud kills the script-detection reflex, and handing over the time control means they decide to stay — the only version of staying that lasts.", atlasTags: ["accusation-audit"]),
                PuzzleCandidate(text: "Hi, this is Alex over at Vantage — hope I'm not catching you at a bad time?", eval: -0.6, rationale: "The softener IS the script. 'Bad time' hands them the exit line, and the reflex fires inside four seconds.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Hi [Name] — I read your post on ramp times last week.", eval: 0.1, rationale: "Buys you three extra seconds of curiosity, but it's still recognizably a sales wind-up — pattern recognition catches up shortly after.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Hi — do you have two quick minutes?", eval: -0.4, rationale: "If yes, you still haven't earned the next sentence. If no, they hang up. A yes/no question in second one is a coin-flip you built yourself.", atlasTags: ["fitd"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p019", theme: .coldOpen, difficulty: 1700,
            buyerRole: "Senior procurement lead, intro email reply",
            setup: "You sent a referral-led cold email. They replied with a two-word question.",
            buyerLine: "What do you do? Need under thirty seconds.",
            candidates: [
                PuzzleCandidate(text: "We cut Meridian Health's contract-cycle time from 41 days to 12 by automating redline triage. If that's not a problem you own, say so and I'll leave you alone.", eval: 0.7, rationale: "Named peer, specific number, concrete mechanism, and a genuine out — all inside the thirty seconds. A procurement lead reads that as time-respect, which is the whole first impression.", atlasTags: ["social-proof", "concrete-construal"]),
                PuzzleCandidate(text: "We're the leading contract-intelligence platform — hundreds of enterprise customers across your industry.", eval: -0.5, rationale: "Procurement discounts 'leading platform' claims by default — they read a hundred of these a week. You spent your thirty seconds on noise.", atlasTags: ["social-proof", "authority"]),
                PuzzleCandidate(text: "Easier shown than told — mind if I send a one-pager that lays it out?", eval: -0.3, rationale: "They gave you thirty seconds and you asked for a document review instead. The handoff fails the exact constraint they just set.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Sam said we should talk — worth a quick call?", eval: 0.0, rationale: "Courtesy might get you the meeting, but a referral with no substance converts at almost nothing. You used the name and wasted the window.", atlasTags: ["liking"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "belfort-aerotyne"
        ),

        Puzzle(
            id: "p020", theme: .coldOpen, difficulty: 1500,
            buyerRole: "Founder, intro Zoom — first 60 seconds",
            setup: "First Zoom. Founder opens before you can.",
            buyerLine: "Okay. Pitch me. I've got 18 minutes.",
            candidates: [
                PuzzleCandidate(text: "I could pitch, but half of it wouldn't apply to you. Give me five minutes of questions first — if I hear what I think I'll hear, the pitch takes six minutes and you keep the other seven.", eval: 0.7, rationale: "You flipped 'pitch me' into qualification while handing the time back — that reads as homework-done and time-respecting. The demo in minute six is twice as sharp because of minutes one through five.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Great — we help founders scale operations. Let me share my screen.", eval: -0.8, rationale: "A generic opener plus a deck is exactly what they braced for when they said 'pitch me.' They're on their phone before slide three.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Here's the two-minute version — three problems we kill, one number for each. Then you steer.", eval: 0.4, rationale: "Better than the deck walk — but you still own the demonstration frame, so you're presenting at them instead of diagnosing with them.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Quick one before I start — on a 1-to-10, how ready are you to fix this this quarter?", eval: -0.4, rationale: "A scripted 1-to-10 in the opening minute pattern-matches to sales-coach training. Credibility drains before your content ever lands.", atlasTags: ["trial-close"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        // ─── Budget batch 2 ─────────────────────────────────────────────
        Puzzle(
            id: "p021", theme: .budget, difficulty: 1400,
            buyerRole: "Director of RevOps, 800-employee SaaS",
            setup: "Mid-pricing call. Champion in the room. Number landed cold.",
            buyerLine: "That number's a stretch. We capped tooling spend at $40k per team for the year and you're at $58.",
            candidates: [
                PuzzleCandidate(text: "Let's break the 58 into what the cap was written against — per-seat versus per-event. My bet is only one of those lines is actually capped, and I want to know which.", eval: 0.7, rationale: "Decomposing unbundles a flat number into the vectors the cap was actually written against. Often only one is binding — and the conversation shifts from line-item rejection to figuring out which constraint is real.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "I can take 30% off if we can get to a signature this week.", eval: -0.5, rationale: "A concession plus time pressure in the first turn. You surrendered the anchor before learning anything, and tagged the move as quota-driven while you did it.", atlasTags: ["scarcity", "sharp-angle"]),
                PuzzleCandidate(text: "We can meet the 40.", eval: -0.8, rationale: "The cap just became your price — permanently. Every future negotiation recalibrates around it, and the ROI conversation dies without ever being had.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Let me put together a written proposal after this — three tiers, the ROI case up front — and time it so it's in your hands for Monday's leadership sync. Would that be useful?", eval: -0.4, rationale: "You moved the live friction into a document review cycle. Now your champion has to re-mobilize a room you already had.", atlasTags: ["extreme-anchor", "contrast"]),
            ],
            bestIndex: 0,
            themeHint: "Caps are usually composite numbers. Decomposing reveals which vector is binding.",
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p022", theme: .budget, difficulty: 1500,
            buyerRole: "VP Finance, holdco-owned manufacturer",
            setup: "Third call. Operations VP has championed. Finance was just looped in.",
            buyerLine: "The holdco mandates 18-month payback on operational tools. You're showing me 22. Walk me through the assumptions.",
            candidates: [
                PuzzleCandidate(text: "Let's walk it right now. Two assumptions carry the 22 — the adoption ramp and the soft-savings line. Strip it to hard savings only, re-run it here, and let's see which side of 18 it lands on before anyone talks about touching the price.", eval: 0.8, rationale: "They asked for the assumptions — supply them at operating altitude. A finance audience trusts the number they watched get built, and the hard-versus-soft split shows whether the mandate even binds. You find out without conceding a cent.", atlasTags: ["concrete-construal"]),
                PuzzleCandidate(text: "Before we go through it — does the holdco's 18-month rule count soft savings, or hard savings only?", eval: 0.4, rationale: "The right discriminator hiding inside the wrong move. 'Walk me through the assumptions' is a direct ask; answering it with a question sounds like you don't have the math.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Let me take the model back, rebuild it to 18, and get it to you Friday.", eval: -0.4, rationale: "You just volunteered a recalculation the mandate may not require — and quietly accepted the stricter rule for every future ROI conversation with this holdco.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "One of your sister portfolio companies cleared this exact tool at 22 months — I'm happy to connect you with their finance lead as a reference.", eval: 0.1, rationale: "The named-peer exception is real ammunition — for the second half of the meeting. Led with, it asks a finance VP to defy their own mandate on an anecdote.", atlasTags: ["social-proof"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p023", theme: .budget, difficulty: 1700,
            buyerRole: "VP Engineering, Series C SaaS",
            setup: "Five-month cycle. Verbal alignment. Pricing reveal call.",
            buyerLine: "Look, I want this. But we're 80% through OpEx for the half and I can't get net-new approved until July.",
            candidates: [
                PuzzleCandidate(text: "What if May and June run as a flat-fee pilot — priced inside the budget you already have — and full rate starts in July with the pilot credited back? Different approval path, same start date.", eval: 0.8, rationale: "You re-routed a net-new approval into within-period pilot spend, which clears a different sign-off threshold. Your champion gets a path their finance partner can absorb — and you get May instead of July.", atlasTags: ["concrete-construal", "alternative-choice"]),
                PuzzleCandidate(text: "Let's lock July now so nothing drifts — I'll put the kickoff on both calendars today, send a recap you can forward at quarterly close, and drop you one genuinely useful thing a month so this stays warm until the budget opens.", eval: -0.4, rationale: "All the mechanics of momentum with none of the substance. A two-month gap scatters the stakeholders, and your champion has to re-mobilize every one of them in July.", atlasTags: ["mutual-close-plan", "reciprocity"]),
                PuzzleCandidate(text: "Run it free through July — I'll lock full pricing now and the meter starts when your budget opens.", eval: -0.7, rationale: "Free trains them to consume without spending. When the meter starts in July, conversion drops — you've made the paid version the disruption.", atlasTags: ["puppy-dog"]),
                PuzzleCandidate(text: "Honestly, waiting until July will cost you more than the OpEx gap does.", eval: -0.5, rationale: "You're pressuring a constraint they surfaced in good faith. Your champion is now caught between you and their finance team — the one place a champion stops championing.", atlasTags: ["loss-framing"]),
            ],
            bestIndex: 0,
            themeHint: "Period-split structures often clear sign-off thresholds that net-new requests cannot.",
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p024", theme: .budget, difficulty: 1300,
            buyerRole: "Director of Marketing, growth-stage B2B",
            setup: "Demo two. Director seemed engaged. Pricing came at the end.",
            buyerLine: "That's higher than I was thinking. Honestly I had $25k in my head and you're at $48.",
            candidates: [
                PuzzleCandidate(text: "Appreciate you naming the number. Where does the 25 come from — a quote on a comparable tool? And is that tool delivering the outcome you want?", eval: 0.7, rationale: "You surfaced the anchor's provenance instead of fighting the number. Nine times out of ten the 25 is a competitor's list price for a different scope — and once that's visible, the gap explains itself.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Let's just meet in the middle at 36.", eval: -0.7, rationale: "You split an anchor you never tested. The 36 confirms the 25 was a legitimate expectation — and you paid twelve grand to validate it.", atlasTags: ["bracketing"]),
                PuzzleCandidate(text: "The 48 holds up line by line — let me pull up the comparison matrix and walk you through both competitors feature by feature, including where each one falls short.", eval: -0.3, rationale: "A feature-by-feature defense commoditizes the conversation. They stop evaluating outcome and route you to procurement for a spec comparison you can only lose.", atlasTags: ["contrast"]),
                PuzzleCandidate(text: "We can do the 25 if we sign terms this week.", eval: -1.2, rationale: "Their first number just became your price, with a discount reflex attached. Every future expansion conversation starts from 25.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p025", theme: .budget, difficulty: 1900,
            buyerRole: "CFO, Series B SaaS, board-driven discipline",
            setup: "Last call before contract. CFO has been the gate.",
            buyerLine: "I've reviewed your pricing against three vendors in this category. You're 22% above the median. Walk me through what justifies that.",
            candidates: [
                PuzzleCandidate(text: "Here's the 22, line by line: implementation is scoped in, the SLA is a tier above what the median bids carry, and the integrations they quote as add-ons come included.", eval: 0.7, rationale: "The CFO offered you the floor — take it. A line-itemed premium is precise, and precision signals information: hard to adjust downward, hard to dismiss. Dodge the question and procurement will do the itemizing for you.", atlasTags: ["precise-anchor", "contrast"]),
                PuzzleCandidate(text: "Which two of the three made your shortlist, and what scope did each one actually price?", eval: 0.4, rationale: "The scope question is legitimate — after the walk-through. Leading with it dodges a direct C-level ask, and calibrated questions fail exactly where a factual answer was required.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "A peer of yours picked the cheaper vendor in this category last year — the failed implementation ran them $1.2M.", eval: 0.2, rationale: "Strong material, cherry-pickable. Without the line-item walk first, the horror story reads as deflection from a math question.", atlasTags: ["social-proof", "loss-framing"]),
                PuzzleCandidate(text: "We can meet the median if we get signatures this quarter — and you can position the drop to your board as an end-of-evaluation accommodation rather than a concession on our side, which keeps the optics clean.", eval: -0.7, rationale: "You answered 'justify your premium' with 'there is no premium.' The CFO stores the concession and the quarter-end tell — and year-two pricing starts 22% lower.", atlasTags: ["sharp-angle", "scarcity"]),
            ],
            bestIndex: 0,
            themeHint: "Comparison-medians without scope are CFO theater. Surfacing scope shifts the conversation back to value.",
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p026", theme: .budget, difficulty: 1600,
            buyerRole: "Head of Operations, family-owned mid-market",
            setup: "Owner is approving. Head of Ops is the messenger. Number lands as a multiple of the family's tolerance.",
            buyerLine: "The owner's going to balk. He thinks software shouldn't cost more than a hire.",
            candidates: [
                PuzzleCandidate(text: "He's already comparing it to a hire — so finish the comparison for him. Tell him this replaces the ops coordinator he'd otherwise be hiring, at 60% of the loaded cost and zero ramp time.", eval: 0.7, rationale: "The owner already thinks in hires — you're not fighting the frame, you're completing it. And you handed your messenger a defensible one-liner, which is the actual job here.", atlasTags: ["contrast", "concrete-construal"]),
                PuzzleCandidate(text: "Would it help if I made the case to the owner directly?", eval: 0.0, rationale: "Possible upside if the owner takes the meeting — but you'd be going over your champion's head, and the standing it costs them doesn't come back.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "What if we billed monthly, so it reads like a salary line instead of a lump sum?", eval: -0.3, rationale: "Cash-flow gymnastics without touching the mental model. The owner annualizes it eventually, and you're back at the same objection with less credibility.", atlasTags: ["contrast"]),
                PuzzleCandidate(text: "We could do half if he signs today.", eval: -1.1, rationale: "A 50% drop trains everyone in that family business that your price is an opening bid. The brand damage outlasts the deal.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p027", theme: .budget, difficulty: 1500,
            buyerRole: "VP People, 600-person scaleup",
            setup: "Discovery confirmed. ROI mapped. Pricing reveal mid-call.",
            buyerLine: "Our finance partner won't approve any new SaaS spend without a documented displacement. What are we cutting?",
            candidates: [
                PuzzleCandidate(text: "You're already paying for this three times — the survey tool, the LMS module, the engagement add-on. I'll hand you a one-pager your finance partner can lift straight into the approval.", eval: 0.8, rationale: "You took the work off your champion's plate and answered the constraint in exactly the form finance asked for it. It routes upward with zero friction — which is the whole game when your buyer is a messenger.", atlasTags: ["concrete-construal", "reciprocity"]),
                PuzzleCandidate(text: "Honestly, displacement math undersells this — it's a growth investment, not a like-for-like swap.", eval: -0.4, rationale: "You're arguing with a constraint your champion didn't invent. The finance partner set the rule; pushing back just puts your champion in the crossfire.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "What if we simply priced it under the displacement gap?", eval: -0.6, rationale: "Discounting accepts the finance partner's frame as your permanent price ceiling — and every future expansion gets evaluated under the same rule.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Should we bring procurement in now? It de-risks the paper process early, and I can run the displacement math in their own template in parallel so your finance partner sees it in a format they already trust.", eval: -0.3, rationale: "Procurement before your champion has the displacement story means you and procurement re-debate value from scratch — the exact conversation the one-pager exists to prevent.", atlasTags: ["multi-threading"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p028", theme: .budget, difficulty: 1800,
            buyerRole: "CRO, public company, $400M revenue",
            setup: "Final pricing call. CFO and CRO present.",
            buyerLine: "I've got room for one new tool this year. You're one of three I'm evaluating. Make your case in five minutes.",
            candidates: [
                PuzzleCandidate(text: "I'll do better than a pitch. Of the three ways revenue leaks at your scale — pipeline coverage, rep ramp, win-rate decay — which one actually scares you for 2026? I'll map us against that one, with numbers.", eval: 0.8, rationale: "You re-framed a pitch contest into a diagnosis contest. A CRO responds to diagnosis-first because it proves you did the homework on their specific revenue equation — while the other two vendors pitch.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Five minutes, three customers. The closest comparable to you added nine points of NRR in two quarters — I'll quantify each outcome against the growth target you've published, and I'll end on a fit question, not a close.", eval: 0.3, rationale: "Competent, and it loses the frame. You're now competing on demonstrated outcomes — which is exactly the contest a three-vendor bake-off is built to commoditize.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Five minutes it is — and at the end, tell me if we're your pick.", eval: -0.4, rationale: "A trial close at minute five says you want the decision more than the diagnosis. The CRO routes you to procurement for a spec comparison.", atlasTags: ["trial-close"]),
                PuzzleCandidate(text: "Could you and I take this separately? The CFO conversation is really a different one.", eval: -0.3, rationale: "The CFO has joint sign-off and is sitting right there. Trying to peel the CRO away doesn't create intimacy — it creates a blocker with a title.", atlasTags: ["multi-threading"]),
            ],
            bestIndex: 0,
            themeHint: "Diagnosis-first is harder to commoditize than feature parity.",
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p029", theme: .budget, difficulty: 1400,
            buyerRole: "Founder/CEO, 40-person startup",
            setup: "Founder running the call solo. Cash management is on her mind.",
            buyerLine: "I burn $480k a month. I'm not adding $5k/month to that line unless it pays for itself by Q3.",
            candidates: [
                PuzzleCandidate(text: "Name the Q3 metric that would make this pay for itself, and I'll build the 90-day deployment plan around it — with payments tied to the milestones, so if we're not delivering, you're not paying.", eval: 0.8, rationale: "Her frame is cash out versus cash in across two quarters — so put your money where her risk is. Milestone-tied payments map your risk to hers, and the metric she names becomes the shared scoreboard.", atlasTags: ["concrete-construal", "commitment-consistency"]),
                PuzzleCandidate(text: "Zoom out from the monthly line for a second — over three years this returns eight times its cost.", eval: -0.5, rationale: "Lifetime ROI doesn't survive a $480K-a-month burn conversation. She files you under vendors who don't get it — politely, and permanently.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "First quarter's free — start today.", eval: -0.3, rationale: "Free delays the question without answering it. In Q3 she still has to make the pay-for-itself math work — you've moved the reckoning, not removed it.", atlasTags: ["tna"]),
                PuzzleCandidate(text: "We could start you on a smaller tier at $1.5K a month and scale up once the Q3 numbers prove out.", eval: 0.2, rationale: "A smaller number — but possibly a smaller outcome too. If the starter tier can't move the Q3 metric, you've priced yourself into failing her test. Only works if the small tier still hits the number.", atlasTags: ["ditf"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p030", theme: .budget, difficulty: 2000,
            buyerRole: "Treasury VP, $1.2B revenue enterprise",
            setup: "Procurement is involved. Treasury is the cash gatekeeper.",
            buyerLine: "We pay quarterly in arrears on everything above $100k. That's the policy. Take it or we re-tier you.",
            candidates: [
                PuzzleCandidate(text: "Quarterly in arrears works — we'll take the policy as written. In exchange, let's talk term: three years, with net-15 on each invoice once the quarter closes.", eval: 0.7, rationale: "You accepted the wall and countered on the levers next to it — term length and net-days — where Treasury has far less policy. That's the trade: give them the cadence, take the structure.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "Our own finance policy requires monthly billing on contracts this size — what if we route an exception request through your team's sponsor and see whose policy has more give?", eval: -0.4, rationale: "Policy-versus-policy contests don't move treasuries — on cash policy they outrank every vendor in the building, and your champion can't save you from that fight. You picked the one battle the building is designed to win.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Understood — quarterly in arrears is fine. Same price.", eval: -0.5, rationale: "You just absorbed a cash-flow hit with no compensating counter. Nothing visibly breaks — your NPV just quietly degrades for the length of the term.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Then re-tier us. We can't take those terms.", eval: -1.0, rationale: "Walking over payment cadence torches a multi-year deal whose value math survives a 90-day NPV adjustment. Run the arithmetic before you posture.", atlasTags: ["takeaway"]),
            ],
            bestIndex: 0,
            themeHint: "Treasury policy is the wall. Adjacent levers (term, net-days, autorenewal) are negotiable.",
            transcriptId: "tracy-think-it-over"
        ),

        Puzzle(
            id: "p031", theme: .budget, difficulty: 1700,
            buyerRole: "Chief of Staff, mid-market PE-backed",
            setup: "PE sponsor reviews all new SaaS over $50k. Chief of Staff prepares the memo.",
            buyerLine: "The sponsor's going to ask for two things: a comparable spend at a portfolio peer, and an exit-impact statement. Got them?",
            candidates: [
                PuzzleCandidate(text: "Both, by Thursday: Crestline Group's spend on us — same sector, sponsor-approved — and a one-line exit-impact statement tied to the multiple your sponsor pays for in this space. Formatted to drop straight into the memo.", eval: 0.8, rationale: "You handed over exactly the two artifacts the sponsor will ask for, formatted for the memo flow that already exists. The Chief of Staff's job just got easier — and easy routes upward fast.", atlasTags: ["social-proof", "concrete-construal", "reciprocity"]),
                PuzzleCandidate(text: "Honestly, this would move faster if I presented to the sponsor directly — could you get me twenty minutes with them?", eval: -0.2, rationale: "PE sponsors rarely take vendor meetings, and asking costs you the goodwill of the one person who actually writes the memo. You'd trade a working channel for a door that won't open.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "I'll send over our standard ROI deck tonight.", eval: -0.5, rationale: "Generic decks fail the memo format — the Chief of Staff has to rewrite everything, which turns your deck into their homework. Homework gets deprioritized.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "What if I just drafted the whole memo for you — your name on it?", eval: 0.1, rationale: "Tempting reciprocity play, but a memo in the wrong voice gets caught, and it's their name on it. Give them structured inputs they compose — not a ghost-written draft.", atlasTags: ["reciprocity"]),
            ],
            bestIndex: 0,
            themeHint: "PE-backed deals are memo-driven. Pre-packaging the inputs the memo needs is high-leverage.",
            transcriptId: "tracy-money-reframe"
        ),

        // ─── Procurement batch 2 ────────────────────────────────────────
        Puzzle(
            id: "p032", theme: .procurement, difficulty: 1700,
            buyerRole: "Strategic sourcing manager, F500 healthcare",
            setup: "Second procurement call. Business case approved internally; procurement is the gate.",
            buyerLine: "I need three things by end of week: BAFO, MSA red-lines, and a security questionnaire. Standard.",
            candidates: [
                PuzzleCandidate(text: "Red-lines and the questionnaire land Friday. BAFO comes 48 hours after we lock the SOW — I'll send you the dated sequence today.", eval: 0.7, rationale: "You met procurement at tempo on the two artifacts that are ready and gave the third a date instead of a refusal. A written sequence with owners reads as process competence — the currency strategic sourcing actually trades in.", atlasTags: ["mutual-close-plan", "commitment-consistency"]),
                PuzzleCandidate(text: "Standard practice is that best-and-final follows scope-final, not the other way around — that sequencing exists for a reason, and it protects your evaluation as much as our number.", eval: 0.1, rationale: "The right rule delivered as a lecture. The sourcing manager knows the rule; what they're testing is whether you can run a sequence, not recite one.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "You'll have all three by Friday, BAFO included — and I've sharpened the number about ten percent to show good faith on where we can land.", eval: -0.4, rationale: "A BAFO before scope-final is a bid against yourself — and the ten percent 'good faith' just taught them that deadlines produce discounts.", atlasTags: ["reciprocity", "sharp-angle"]),
                PuzzleCandidate(text: "A best-and-final before the SOW is final isn't something I can responsibly give you, so I won't put a date on it — and I'll keep saying that however many times the Friday deadline comes back around.", eval: -0.2, rationale: "The substance is right and the shape is wrong. A stand without a date is friction; the same content delivered as a dated sequence is competence.", atlasTags: ["commitment-consistency"]),
            ],
            bestIndex: 0,
            themeHint: "Strategic sourcing operates on sequence. BAFO before SOW is procedural; routing the sequence is permitted.",
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p033", theme: .procurement, difficulty: 1900,
            buyerRole: "Procurement director, defense contractor",
            setup: "Compliance overlay. Standard cycle is six months minimum.",
            buyerLine: "We need DFARS, ITAR, and a CMMC L3 attestation. Without all three you're not getting a PO.",
            candidates: [
                PuzzleCandidate(text: "DFARS and ITAR we hold today. On CMMC L3 — before I promise any timeline, which program is this for? The attestation scope is usually the program subset, not the whole environment.", eval: 0.7, rationale: "Defense compliance asks routinely overstate scope. Confirming the two you hold and scoping the third moves the conversation from full-compliance to in-scope compliance — before you've committed to a date you can't hit.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "We'll have full L3 inside 90 days.", eval: -0.6, rationale: "Compliance timelines are the one thing you can't reliably promise on a procurement call. Miss the 90 days and the credibility damage outruns the original gap.", atlasTags: ["commitment-consistency"]),
                PuzzleCandidate(text: "We can bridge through a partner who already holds L3 — I'll bring their compliance officer to our next call and pre-draft the assignment-of-rights structure so your team can review it before anything moves.", eval: 0.2, rationale: "Partner-mediated compliance is a legitimate bridge — but only if procurement signs off on the assignment-of-rights structure. It's a real path with a real dependency, not a done deal.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Is the L3 requirement firm? For this data class, L2 has covered every contract we've seen.", eval: -0.4, rationale: "Arguing with a compliance requirement tells a defense procurement director you don't understand the threat model. They don't debate — they disengage.", atlasTags: ["authority"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p034", theme: .procurement, difficulty: 1600,
            buyerRole: "Procurement analyst, education sector",
            setup: "First procurement call after a year-long pilot. Pilot success documented.",
            buyerLine: "Our standard template caps the per-user fee at $9. You're at $14. Pilot or not, that's the template.",
            candidates: [
                PuzzleCandidate(text: "Totally hear you on the template. What if the nine dollars covers the base license and we break the platform services out onto their own line? The pilot data you already have supports both pieces.", eval: 0.8, rationale: "Templates are rigid on the line they cover, not on structure. When you present the compliant line structure yourself, procurement can say yes without breaking their own rules.", atlasTags: ["alternative-choice", "concrete-construal"]),
                PuzzleCandidate(text: "We'll meet the nine. The pilot earned that.", eval: -0.5, rationale: "You just made the template the price. Every renewal from here re-anchors downward off that concession.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Could we take this to your procurement lead as an exception? I'll draft the memo with the pilot's usage data as the body of evidence, route it through your champion for sponsorship — and tell me, which precedent cases have cleared before?", eval: -0.2, rationale: "You can win an exception if a path already exists — but a cold ask to procurement leadership with no supporting structure underwhelms.", atlasTags: ["authority", "social-proof"]),
                PuzzleCandidate(text: "Then the pilot terms were conditional. Renewal is at risk.", eval: -1.0, rationale: "You threatened after a year-long pilot. That reads as bad faith, and procurement archives the relationship.", atlasTags: ["takeaway"]),
            ],
            bestIndex: 0,
            themeHint: "Templates restrict by line. Re-organizing into compliant lines is a routine path.",
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p035", theme: .procurement, difficulty: 2000,
            buyerRole: "Senior counsel, large law firm",
            setup: "Legal review. Counsel has high persuasion-knowledge and is testing operator's terms tolerance.",
            buyerLine: "We're going to need uncapped indemnity, no limitation on consequential damages, and unilateral termination for convenience. Standard.",
            candidates: [
                PuzzleCandidate(text: "We can give you uncapped indemnity scoped to IP and confidentiality, consequential damages capped at deal value, and termination for convenience with sixty days' notice and a pro-rata refund. Each of those is the symmetric market position.", eval: 0.8, rationale: "Senior counsel respects you when you counter from defensible market positions. Every one of these is the recognized vendor counter for that exact ask.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "Done. All three.", eval: -1.0, rationale: "Uncapped consequential damages on a SaaS contract is an existence-level risk. Counsel also files your instant fold as a calibration point for everything that follows.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Our standard MSA stands. No exceptions.", eval: -0.4, rationale: "Stand-on-standard rarely survives senior counsel review. You've turned a negotiation into an MSA contest you'll lose.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Let me take all three to our counsel before I respond. I'll package the clauses with full deal context and your rationale, commit to a forty-eight-hour turnaround, and let's get the joint redline call on the calendar before we hang up today.", eval: -0.2, rationale: "If you exit the legal conversation, you cede the counter-framing entirely. Your own counsel, working without you, will concede more than necessary.", atlasTags: ["mutual-close-plan"]),
            ],
            bestIndex: 0,
            themeHint: "Senior counsel is testing the operator's market knowledge. Counters in market positions land; pure rejection does not.",
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p036", theme: .procurement, difficulty: 1500,
            buyerRole: "Procurement specialist, retail chain",
            setup: "First procurement call. Business team unenthused; procurement is performing the gate.",
            buyerLine: "We're benchmarking your category against four other vendors. I'll need a final-and-final by Thursday.",
            candidates: [
                PuzzleCandidate(text: "If nobody on the business side owns the outcome, we'll sit Thursday out.", eval: 0.7, rationale: "Four vendors, a flat business team, and a price-only gate is a contest you lose by winning. The takeaway flushes the truth: a real evaluation produces the business owner, a theater one accepts your exit. Either answer beats a blind best-and-final.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "Before Thursday — what outcome is the chain actually benchmarking for? I'd rather scope our final number to that than to the feature-parity sheet everyone's filling in.", eval: 0.3, rationale: "It's the textbook move, one call too late. With no business enthusiasm behind the gate there's no outcome owner to scope for — your question lands on a spreadsheet, not a buyer.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "You'll have our final-and-final by Thursday — fifteen percent under list, with the full parity sheet against all four competitors.", eval: -0.6, rationale: "You just priced a deal nobody on the business side is pulling for. Best case you win a discounted contract with no sponsor; worst case your number calibrates the next four benchmarks.", atlasTags: ["reciprocity", "sharp-angle"]),
                PuzzleCandidate(text: "Thursday works if we wrap a real evaluation around it — scoring criteria, a business-team readout, and a decision date we all commit to.", eval: -0.2, rationale: "That's process on top of a hollow process. Your plan assumes an engaged buyer the setup tells you does not exist.", atlasTags: ["mutual-close-plan"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p037", theme: .procurement, difficulty: 1800,
            buyerRole: "Director of procurement, government contractor",
            setup: "Second procurement call. RFP scoring weights have shifted; operator's bid was originally first.",
            buyerLine: "Scoring weights got revised. You're now second behind a competitor at lower cost. I need a 7% reduction or a written justification for the gap.",
            candidates: [
                PuzzleCandidate(text: "Can you share the revised rubric? If a specific weighting change drives the seven percent, we'll respond to it directly — and worth noting, we still score higher on every weight that didn't change.", eval: 0.7, rationale: "Scoring shifts are usually procedural and defensible. When you tie your response to the specific weight changes, you route the conversation back to the rubric the director has to defend.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "We'll match the seven.", eval: -0.4, rationale: "You validated the new rubric without ever testing it. Every future bid re-anchors to the lower number.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "The original weights had it right, and our bid stands exactly as submitted. We're not revising the number over a rubric change we haven't even seen defended.", eval: -0.3, rationale: "You're arguing with a process the director owns. The director routes your bid lower and stops taking your calls.", atlasTags: ["commitment-consistency"]),
                PuzzleCandidate(text: "We're withdrawing the bid. See you at the next RFP.", eval: -1.0, rationale: "You forfeited the live opportunity and the relationship leverage with it. The next RFP rarely shows up on the timeline you're counting on.", atlasTags: ["takeaway"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p038", theme: .procurement, difficulty: 2100,
            buyerRole: "Chief procurement officer, $5B enterprise",
            setup: "Final call. Business team aligned. CPO has very high persuasion-knowledge.",
            buyerLine: "I've seen this dance a hundred times. You'll give me 12% off if I sign today, 18% if I sign for two years. Let's skip to the part where I tell you neither is acceptable.",
            candidates: [
                PuzzleCandidate(text: "You're right — you've seen that dance, so let's not do it. The one lever you haven't named is multi-year with a price-lock and a joint-marketing offset. What would make that worth your time to evaluate?", eval: 0.9, rationale: "The CPO just told you they've memorized the standard discount tree. You surface a lever they haven't priced and ask for their value frame on it — that's the pattern-break, and it's the only credible move left.", atlasTags: ["calibrated-question"], isSharp: true),
                PuzzleCandidate(text: "Twenty-two percent. Sign today, three years.", eval: -0.6, rationale: "You escalated the exact discount tree the CPO just named. You've been pattern-matched as predictable, which is the one thing this buyer punishes.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "The value justifies list, and I'd rather re-walk the business case with your own sponsors in the room. Let's quantify what the capability gap the competitor leaves open actually costs, and we'll hold list while your process runs.", eval: -0.4, rationale: "Value-justifies-list to a CPO who has already signaled procurement readiness just disengages them. You're pitching past the person in front of you.", atlasTags: ["loss-framing", "contrast"]),
                PuzzleCandidate(text: "Then we're not ready. I'll step back here.", eval: -1.1, rationale: "Walking on a final call after full business alignment torches the sunk cost. The CPO archives you as unstable, not principled.", atlasTags: ["takeaway"]),
            ],
            bestIndex: 0,
            themeHint: "Procurement professionals signal pattern recognition. Pattern-break is the only credible move.",
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p039", theme: .procurement, difficulty: 1400,
            buyerRole: "Procurement coordinator, mid-market services",
            setup: "First procurement call. Cycle has been low-friction.",
            buyerLine: "Looks good. Can you get me references at three named peers in the next 48 hours?",
            candidates: [
                PuzzleCandidate(text: "You'll have two warm references inside twenty-four hours. The third peer you named is under NDA, so I'll swap in a peer at the same revenue band — fair?", eval: 0.6, rationale: "You delivered on tempo and on substance. A substitute peer with the reason disclosed is a routine procurement swap, and naming the NDA makes it credible.", atlasTags: ["concrete-construal", "social-proof"]),
                PuzzleCandidate(text: "All three, forty-eight hours. Done.", eval: 0.1, rationale: "There's upside if all three come through — but one peer ghosting inside your own deadline costs you more credibility than the ask was worth.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Honestly, our reference customers are stretched thin right now.", eval: -0.6, rationale: "Reference fatigue is real, but raised cold it reads as evasion. The coordinator escalates instead of sympathizing.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "How about case studies instead?", eval: -0.4, rationale: "Case studies are public and don't satisfy a named-peer ask. Procurement files you under non-responsive.", atlasTags: ["social-proof"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p040", theme: .procurement, difficulty: 1700,
            buyerRole: "Procurement manager, insurance carrier",
            setup: "Renewal procurement call. Original deal was three years; renewal is up.",
            buyerLine: "Three-year renewal at flat pricing or we'll RFP this and you'll compete.",
            candidates: [
                PuzzleCandidate(text: "We'll do flat for year one, with years two and three indexed to inflation and capped at four percent. Flat across all three years would actually sit below your own procurement inflation policy.", eval: 0.9, rationale: "Carrier procurement policies almost always index inflation on multi-year contracts. When you surface that mismatch, your counter becomes the position the procurement manager can defend internally.", atlasTags: ["calibrated-question", "alternative-choice"], isFork: true),
                PuzzleCandidate(text: "Flat for three years works. Done.", eval: -0.6, rationale: "You just absorbed three years of inflation risk on your side of the table. The NPV degrades silently.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Run the RFP. We'll bid.", eval: -0.3, rationale: "You might win it — but you've spent cycle time and incumbency credit to find out. Only take this road if you're confident re-winning.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "We'd actually need ten percent in year one — the usage-growth data justifies the bump. Years two and three go CPI-indexed, and we'll add a rebate clause on our side if adoption targets are missed.", eval: -0.4, rationale: "A ten percent bump on renewal is the move that triggers the RFP. You overshot the manager's tolerance and handed them the exit.", atlasTags: ["extreme-anchor"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-think-it-over"
        ),

        // ─── Stall batch 2 ──────────────────────────────────────────────
        Puzzle(
            id: "p041", theme: .stall, difficulty: 1400,
            buyerRole: "VP Marketing, post-demo, six days of radio silence",
            setup: "Strong demo last week. Two follow-ups unanswered.",
            buyerLine: "[no reply for six days, then on the seventh:] Hey — got pulled into a campaign launch. Can we push to next month?",
            candidates: [
                PuzzleCandidate(text: "Happy to work around the launch. You mentioned the campaign post-mortem and Q-end planning in the demo — next month lands after both. I've got two twenty-five-minute slots inside the campaign window; would either work?", eval: 0.7, rationale: "Push-to-next-month is a deprioritization signal. When you tie the timing to a milestone the VP herself named, you re-anchor the urgency without applying any pressure.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Of course — I'll send an invite four weeks out.", eval: -0.4, rationale: "You accepted the push without testing what's underneath it. The probability of the next push just compounded.", atlasTags: ["mutual-close-plan"]),
                PuzzleCandidate(text: "Got it. We'll pull the proposal off the table.", eval: -0.6, rationale: "A takeaway after one push reads as theatrical. The VP files the move in her pattern-recognition folder and trusts you less.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "No problem — I'll send a case study over.", eval: -0.2, rationale: "You added asymmetric work with no live-moment leverage. The buyer absorbs it as noise.", atlasTags: ["social-proof"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        Puzzle(
            id: "p042", theme: .stall, difficulty: 1600,
            buyerRole: "Director of Sales Ops, ghosting after pricing",
            setup: "Pricing reveal landed cold. Two follow-ups unanswered.",
            buyerLine: "[silence]",
            candidates: [
                PuzzleCandidate(text: "I imagine the pricing landed differently than you expected, and you're probably thinking we're overpriced. If that's where you are, tell me straight — I'd rather hear it than keep guessing at the silence.", eval: 0.7, rationale: "The accusation audit names the appraisal the buyer is already making silently. Sales Ops leaders respect you for saying the likely truth out loud — and it gives the real signal somewhere to land.", atlasTags: ["accusation-audit"]),
                PuzzleCandidate(text: "If price is the blocker, we can do fifteen off.", eval: -0.8, rationale: "You discounted into a silence with no surfaced objection. You just trained the buyer that going quiet is a price lever.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Just circling back to see where things stand on your side — nothing new from me, no rush at all, happy to find a time whenever works for you.", eval: -0.4, rationale: "A generic check-in after two ignored follow-ups has near-zero re-engagement rate. You're adding to the pile.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Here's how we stack up against the field.", eval: -0.5, rationale: "You added work the buyer never asked for. Silence stays the path of least resistance.", atlasTags: ["contrast"]),
            ],
            bestIndex: 0,
            themeHint: "Silence is a signal. Accusation audit names the likely appraisal and re-opens the conversation.",
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p043", theme: .stall, difficulty: 1500,
            buyerRole: "Champion VP Engineering, internal review pending for three weeks",
            setup: "Champion warm. Internal review keeps slipping.",
            buyerLine: "Sorry for the delay. Trying to get on my CFO's calendar. Should have something by end of next week.",
            candidates: [
                PuzzleCandidate(text: "What if we grabbed twenty minutes with your CFO directly this week? You shouldn't have to be the one fighting his calendar for us.", eval: 0.7, rationale: "Your champion is bottlenecked on calendar access, not conviction. When you carry the meeting request yourself, you move the constraint to a path the champion can't solve alone.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Let me build you a one-page ROI doc on your own numbers, formatted so you can forward it to your CFO without touching a thing. Would that make the conversation easier once you're on his calendar?", eval: 0.3, rationale: "It's a useful artifact — but the champion told you the constraint is calendar, not content. You're solving the wrong bottleneck.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "End of next week works — I'll check in then.", eval: -0.4, rationale: "The three-week pattern just continued with your blessing. Every week of slip decays the deal's momentum.", atlasTags: ["mutual-close-plan"]),
                PuzzleCandidate(text: "Is this still real on your end? Three weeks now.", eval: -0.5, rationale: "The champion is real; the calendar is the constraint. Pushing on the person absorbing the friction damages the one relationship carrying the deal.", atlasTags: ["takeaway"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        Puzzle(
            id: "p044", theme: .stall, difficulty: 1700,
            buyerRole: "VP Customer Success, deal stalled in legal for eight weeks",
            setup: "Business alignment confirmed. MSA red-lines bouncing.",
            buyerLine: "Legal's slow. We're still on red-line round three. They'll get there.",
            candidates: [
                PuzzleCandidate(text: "What if we got both legal teams on a thirty-minute call and walked the open red-lines together, live? Round three almost always clears in a single synchronous session.", eval: 0.7, rationale: "Async legal cycles compound delay by design. Offering the sync session — and naming that round three usually clears in one — routes the conversation toward a path everyone can accept.", atlasTags: ["concrete-construal", "multi-threading"]),
                PuzzleCandidate(text: "We'll accept the open red-lines as they stand. Clear it.", eval: -0.7, rationale: "You made material legal concessions just to clear a stall. The buyer learned your flexibility, and the NPV degrades.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Could you raise this internally? Frame it as protecting the renewal date rather than pressuring legal — and I'll tell you exactly which redline is gating signature so you walk in armed.", eval: 0.1, rationale: "This works only if the VP has the authority and the appetite to push their own legal team. Many don't, and you're spending relationship capital to find out.", atlasTags: ["authority", "multi-threading"]),
                PuzzleCandidate(text: "Understood. We'll sit tight.", eval: -0.5, rationale: "Eight weeks of waiting with no surfaced friction tells the buyer you don't understand how legal cycles actually move.", atlasTags: ["silence"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            // CQ-INTRINSIC (blind panel 3/3, 2026-07-18): a declarative mutual-close-plan re-key lost
            // unanimously — discovery-before-prescription IS the move here. Do not re-litigate for the
            // CQ-concentration metric (same class as p010).
            id: "p045", theme: .stall, difficulty: 1300,
            buyerRole: "Director, mid-funnel, vague timeline",
            setup: "Director engaged in demo. Timeline cited as Q2 with no specifics.",
            buyerLine: "We're targeting Q2. Hard to be more specific until the planning cycle closes.",
            candidates: [
                PuzzleCandidate(text: "What actually has to happen for Q2 to go from a target to a scheduled project? I'd like the right artifact ready before your planning cycle closes, not after.", eval: 0.7, rationale: "You surfaced the trigger event. Planning cycles run on specific trigger criteria, and tying your next move to the trigger gets you into the cycle before procurement does.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Q2 works — I'll check in with you in thirty days.", eval: -0.3, rationale: "Accept-and-defer with nothing surfaced. Q2 stays exactly as vague as it was when the call started.", atlasTags: ["mutual-close-plan"]),
                PuzzleCandidate(text: "Which week in Q2 are we talking?", eval: -0.5, rationale: "You pressured a timeline the buyer just told you is inherently vague. It signals you don't respect how their planning cycle works.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "I'll send over a Q2-readiness checklist.", eval: -0.2, rationale: "Asymmetric work, mistimed. The checklist arrives before the buyer is ready to act on any of it.", atlasTags: ["reciprocity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p046", theme: .stall, difficulty: 1900,
            buyerRole: "C-suite executive, ghost after exec call",
            setup: "Executive call appeared positive. Three weeks of silence.",
            buyerLine: "[no reply to four follow-ups across three weeks]",
            candidates: [
                PuzzleCandidate(text: "It sounds like the timing didn't line up on your end — I'm going to archive this on our side unless you'd like to revisit. Either way, no more follow-ups from me.", eval: 0.6, rationale: "After four ignored follow-ups, the takeaway is the highest-information move you have left. Executives respond to permission-to-disengage at higher rates than to another nudge.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "One more thought — new numbers attached.", eval: -0.5, rationale: "A fifth follow-up after four ignores just reinforces the silence pattern. The executive archives you, not the attachment.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Could your chief of staff help us find fifteen minutes?", eval: -0.4, rationale: "Going around the executive damages the relationship and almost never produces re-engagement. They notice.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Closing the loop on my side — thought you'd want to see what a peer at your scale in your vertical just did with this. One line, no ask, and I'm happy to share their playbook whenever it's useful.", eval: -0.6, rationale: "You added noise to someone who has signaled disengagement four times. Every extra touch lowers the odds of a real re-engagement.", atlasTags: ["social-proof", "takeaway"]),
            ],
            bestIndex: 0,
            themeHint: "Takeaway after multiple ignored follow-ups is the highest-information move.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p047", theme: .stall, difficulty: 1600,
            buyerRole: "Procurement coordinator, delayed on security review",
            setup: "Security questionnaire submitted three weeks ago. No response.",
            buyerLine: "Security team is backed up. Probably another two weeks.",
            candidates: [
                PuzzleCandidate(text: "What if I walked your security reviewer through the questionnaire live — thirty minutes, no document back-and-forth? That's usually where the weeks go.", eval: 0.7, rationale: "Async security reviews compound delay. A live walk-through swaps document ping-pong for one synchronous clarification cycle — a routine path coordinators say yes to.", atlasTags: ["multi-threading", "reciprocity"]),
                PuzzleCandidate(text: "Two weeks is fine — I'll follow up with you then.", eval: -0.3, rationale: "You accepted the estimate without surfacing the friction that produced it. Two weeks like these have a habit of becoming four.", atlasTags: ["mutual-close-plan"]),
                PuzzleCandidate(text: "Here's how we stack up on security.", eval: -0.4, rationale: "Wrong vector entirely. Security review is an internal process — it won't weigh a vendor-supplied competitor comparison.", atlasTags: ["contrast"]),
                PuzzleCandidate(text: "Can we go to your director?", eval: -0.2, rationale: "Escalating around the security team usually slows the cycle further. You've traded a queue for a process argument.", atlasTags: ["authority"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        Puzzle(
            id: "p048", theme: .stall, difficulty: 1800,
            buyerRole: "VP Engineering, deal paused at hiring freeze",
            setup: "Verbal commit. Headcount freeze announced two days later.",
            buyerLine: "We're frozen on net-new spend until the freeze lifts. No ETA.",
            candidates: [
                PuzzleCandidate(text: "Most headcount freezes are written against new hires, not existing operational tooling — and this reduces your hiring pressure, which makes it freeze mitigation. I'll write a three-line note for your CFO making exactly that case.", eval: 0.8, rationale: "Freezes target headcount; tooling that reduces hiring pressure usually sits outside them. The re-classification is a routine path, and the three-line note is ammunition your champion can actually use.", atlasTags: ["contrast", "reciprocity"]),
                PuzzleCandidate(text: "We'll wait for it to lift.", eval: -0.4, rationale: "Freezes commonly extend. You just let a verbal commit sit in the open air while its momentum drains.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "Would half off get this through the freeze?", eval: -0.7, rationale: "You discounted against a freeze that was never a price objection. Margin gone, classification problem untouched.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Honestly, this spend sits outside the freeze's intent — you've already committed two workflows to it, so it's not net-new. Can you carry that distinction to finance before the freeze hardens into next quarter's baseline? I'd hate to watch a hiring policy freeze the thing that reduces hiring.", eval: -0.5, rationale: "You're pushing back on an internal policy the VP has to live under — and asking them to fight finance with your framing. That's a champion relationship you're spending, not building.", atlasTags: ["commitment-consistency"]),
            ],
            bestIndex: 0,
            themeHint: "Hiring freezes are usually written against headcount, not against productivity tooling. Re-classification is permitted.",
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p049", theme: .stall, difficulty: 1500,
            buyerRole: "Director, partial team buy-in, two skeptics",
            setup: "Demo done. Director enthused. Two team members visibly skeptical.",
            buyerLine: "I love it. But two of my people aren't sold. Give me a week to bring them around.",
            candidates: [
                PuzzleCandidate(text: "What if I took thirty minutes directly with your two skeptics — structured Q&A? When the objections are technical, having me in the room converts better than making you carry it alone for a week.", eval: 0.7, rationale: "The champion's internal-selling job is asymmetric work when the skeptics' objections are technical. You in the room converts at higher rates, and it frees the director from a lift they didn't sign up for.", atlasTags: ["multi-threading", "reciprocity"]),
                PuzzleCandidate(text: "Let me build you an FAQ aimed at their three named objections — deployment evidence for each, plus talk-track bullets for the follow-ups they're likely to raise — so you've got everything you need to bring them around yourself.", eval: 0.2, rationale: "It's a useful artifact, but you just handed the conversion work back to the director. Only works if their appetite for that lift is real.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Take the week — I'll follow up Friday.", eval: -0.3, rationale: "Skeptic conversion without support from you fails more often than it succeeds. The week becomes two.", atlasTags: ["mutual-close-plan"]),
                PuzzleCandidate(text: "You're the director — can't you just make the call?", eval: -0.6, rationale: "An override torches the director's standing with their own team, and the resentment surfaces at rollout.", atlasTags: ["authority"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        Puzzle(
            id: "p050", theme: .stall, difficulty: 2000,
            buyerRole: "Chief of Staff to CFO, deal paused for board cycle",
            setup: "Board cycle delay. Decision waiting for next quarterly board meeting.",
            buyerLine: "Board meets in six weeks. CFO won't approve anything net-new before then.",
            candidates: [
                PuzzleCandidate(text: "Let me pre-package the board narrative for your CFO — a two-page memo, a named-peer comparable, and the exit-impact line — so when the cycle opens he's presenting a decision, not opening a discussion.", eval: 0.8, rationale: "Six-week board cycles compound risk. When the CFO arrives with a decision-ready memo instead of a starting position, you've routed yourself into the board cycle through the messenger's own workflow.", atlasTags: ["reciprocity", "concrete-construal", "social-proof"]),
                PuzzleCandidate(text: "We'll wait for the board.", eval: -0.4, rationale: "Six weeks of passive waiting is where deals get deprioritized. When the cycle opens, other priorities have taken your seat.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "Any chance the CFO approves this outside the cycle?", eval: -0.6, rationale: "You asked a CFO to bypass their own board process. The relationship takes the hit and the deal gets routed lower.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "What if we scoped a pilot under the CFO's discretionary threshold right now, with graduation criteria tied to the board cycle? I'll even pre-write the full-rollout line item for the board packet so the path is already on paper.", eval: 0.1, rationale: "Pilots can clear smaller thresholds — but without a structurally defined path to full rollout, the pilot becomes the permanent state. Conditional at best.", atlasTags: ["puppy-dog", "fitd"]),
            ],
            bestIndex: 0,
            themeHint: "Board cycles are pre-packaging opportunities. The memo-shape matters more than the substance the CFO already knows.",
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p051", theme: .stall, difficulty: 1700,
            buyerRole: "VP Operations, deal stalled on a technical integration concern",
            setup: "Discovery completed. Technical due-diligence raised a single integration question.",
            buyerLine: "Our infra team flagged a question about your auth model. We need to get it resolved before we move forward.",
            candidates: [
                PuzzleCandidate(text: "Let's book forty-five minutes with your infra team and our solutions engineer, together. Auth-model questions like this one resolve in a single session nine times out of ten once both teams are looking at the same docs.", eval: 0.7, rationale: "Technical due-diligence stalls usually clear in one synchronous session. Naming the session shape and the resolution rate routes the buyer toward saying yes to it.", atlasTags: ["concrete-construal", "multi-threading"]),
                PuzzleCandidate(text: "I'll send the auth documentation annotated against your exact SSO topology, flag the two sections that answer their stated concern, and include a sandbox tenant so your team can verify it directly instead of taking my word for it.", eval: 0.1, rationale: "Async review stretches the cycle even when the doc is excellent. Default to the live session; send the doc as the follow-up, not the plan.", atlasTags: ["reciprocity", "puppy-dog"]),
                PuzzleCandidate(text: "Can we call it a verbal yes while the auth question closes out?", eval: -0.6, rationale: "A verbal commit taken before technical resolution gets rescinded the moment the infra team flags the issue — and the VP remembers who asked.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "There's a workaround that sidesteps auth.", eval: -0.4, rationale: "Dodging the infra team's specific concern tells them you don't take their technical input seriously. The stall deepens.", atlasTags: ["alternative-choice"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        // ─── Renewal batch 2 ────────────────────────────────────────────
        Puzzle(
            id: "p052", theme: .renewal, difficulty: 1500,
            buyerRole: "Existing customer, VP Engineering, 8 months into deployment",
            setup: "Renewal call in four months. Usage flat; champion engaged.",
            buyerLine: "Usage hasn't grown the way we expected. I'm questioning whether the seat count still makes sense.",
            candidates: [
                PuzzleCandidate(text: "Three of your teams haven't onboarded yet — that's where the flatness lives. Give me sixty days and a weekly check-in to activate them, and then let's have the seat-count conversation against real usage.", eval: 0.8, rationale: "Flat usage eight months in is an onboarding gap, not a seat-count problem. Re-routing to activation turns a contraction conversation into a growth-recovery one.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "We can take thirty percent off the seat count.", eval: -0.6, rationale: "You conceded contraction before even surfacing the activation gap. NPV down, and the customer learns that voicing doubt moves your price.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Contractually, the seat minimums do stand.", eval: -0.5, rationale: "Leading with the contract in a usage conversation damages the relationship. The VP starts signaling churn.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Let's table it and dig in at the renewal call.", eval: -0.4, rationale: "Four months of unaddressed flat usage compounds the contraction signal. By renewal, this exact conversation is harder.", atlasTags: ["silence"]),
            ],
            bestIndex: 0,
            themeHint: "Flat usage 8 months in is an onboarding gap, not a seat-count problem. Route to activation.",
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p053", theme: .renewal, difficulty: 1600,
            buyerRole: "Existing customer, CRO, year two renewal",
            setup: "Year one saw 22% revenue impact attributed to the tool. CRO opens the renewal call.",
            buyerLine: "Numbers look good. We're ready to renew. Same terms?",
            candidates: [
                PuzzleCandidate(text: "Glad to renew. Given the twenty-two percent revenue impact you saw this year, we'd be at a twelve percent increase tied to the year-two value-add modules — that's standard outcome-indexed pricing.", eval: 0.8, rationale: "A strong year one is your renewal lever. Same-terms leaves NPV on the table; re-anchoring to the outcome data is the standard move when the numbers are on your side.", atlasTags: ["anchor-with-range", "concrete-construal"]),
                PuzzleCandidate(text: "Same terms. Let's sign.", eval: -0.5, rationale: "You renewed a strong year flat. You gave away the upside and taught the customer that your pricing never moves.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Let's renew at twenty percent off — a loyalty thank-you.", eval: -1.0, rationale: "A unilateral discount on a strong-renewal call is anti-leveraged. The customer files it under 'doesn't understand their own value.'", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Same terms works if we pair it with a multi-year lock — that's budget predictability through your planning cycle. We'd add an annual CPI floor and trade the term length for an expansion-tier option on your side.", eval: 0.2, rationale: "The lock has some value, but it caps the upside the year-one data earned you. Only worth it if the customer has real multi-year intent.", atlasTags: ["commitment-consistency", "gain-framing"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p054", theme: .renewal, difficulty: 1700,
            buyerRole: "Existing customer, Head of Procurement, year three renewal",
            setup: "Year three. Procurement has taken over the renewal conversation. Business team still happy.",
            buyerLine: "We're benchmarking against three alternatives this cycle. I'll need a 12% reduction or you go to RFP.",
            candidates: [
                PuzzleCandidate(text: "Before we talk percentages — switching means data migration, retraining, and rebuilding every integration. That's specific dollars and specific weeks, and I'll map both. Priced against that, we're actually proposing four percent up.", eval: 0.8, rationale: "Benchmarking ignores switching cost by default. When you put specific dollars and weeks on the table, the conversation moves to total cost of switching instead of new-vendor sticker price.", atlasTags: ["loss-framing", "concrete-construal"]),
                PuzzleCandidate(text: "We can meet the twelve.", eval: -0.6, rationale: "You conceded to the benchmark without ever surfacing switching cost. Year four now anchors from the lower number.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Split it — six percent and we're done.", eval: -0.4, rationale: "Splitting the number trains procurement on year-over-year erosion. It compounds across every renewal after this one.", atlasTags: ["bracketing"]),
                PuzzleCandidate(text: "Let me brief your business sponsor on the switching-cost math first — they can raise the continuity risk in their own words, and I'll stay out of the room while that conversation runs. If they carry it, this benchmark conversation changes shape.", eval: -0.3, rationale: "Routing around procurement damages the process relationship — and the business team may simply fail to deliver the override you're betting on.", atlasTags: ["multi-threading", "loss-framing"]),
            ],
            bestIndex: 0,
            themeHint: "Switching cost is the renewal-incumbent's anchor. Specific dollars and weeks beat aspirational appeals.",
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p055", theme: .renewal, difficulty: 1400,
            buyerRole: "Existing customer, VP Sales, mid-cycle expansion conversation",
            setup: "Quarter four of a three-year deal. VP Sales mid-cycle.",
            buyerLine: "We're growing fast. Probably need to add 40 seats by end of year.",
            candidates: [
                PuzzleCandidate(text: "Forty by end of year — let's lock it in now, co-termed to your existing contract so billing stays on one date, with a thirty-day onboarding plan keyed to your revenue target.", eval: 0.7, rationale: "Co-terming consolidates billing on the existing renewal date and locks the expansion while the growth is live. It's the lowest-friction path for a customer moving fast.", atlasTags: ["concrete-construal", "commitment-consistency"]),
                PuzzleCandidate(text: "Let's bundle the forty into renewal next year.", eval: -0.4, rationale: "Eight months is a long time in a fast-growing team. You're leaving room for a competitor to land, or for the number to shrink.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "The forty seats price at the list rate.", eval: 0.0, rationale: "List works — but you walked past the co-term. Functional, and it leaves the cleaner structure on the table.", atlasTags: ["precise-anchor"]),
                PuzzleCandidate(text: "We'll discount the forty to get this moving fast.", eval: -0.5, rationale: "They're expanding because they need the product. A discount nobody asked for just erodes expansion margin.", atlasTags: ["reciprocity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p056", theme: .renewal, difficulty: 1900,
            buyerRole: "Existing customer, executive sponsor, renewal at risk after exec change",
            setup: "Original exec sponsor left. New sponsor inherited the deal four months ago.",
            buyerLine: "Honestly, I didn't pick this tool. I need to see why I should keep paying for it.",
            candidates: [
                PuzzleCandidate(text: "Fair — you didn't pick it, so let's not pretend you did. Give me thirty minutes on what you're actually trying to do, and I'll map what the tool already does against your priorities. Fresh eyes, no history assumed.", eval: 0.7, rationale: "An inherited sponsor is a net-new buyer wearing a renewal's clothing. When you re-discover and earn the buy explicitly, you convert at far higher rates than leaning on a history they don't own.", atlasTags: ["labeling"]),
                PuzzleCandidate(text: "Let me rebuild the ROI picture against your priorities instead of your predecessor's business case — one page, your numbers, this week. If it's useful, I'll walk you through it live in fifteen minutes whenever suits.", eval: 0.2, rationale: "Better than nothing, but it assumes the new sponsor cares about numbers built for a predecessor. Often they don't — discovery comes first.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "What if we did a renewal discount?", eval: -0.6, rationale: "You discounted before re-discovering. The new sponsor's first lesson about you is that pressure moves your price.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "I'd like to loop in someone above you on this.", eval: -0.5, rationale: "Going around the new sponsor poisons the working relationship on day one — and the renewal is their call, not their boss's.", atlasTags: ["authority"]),
            ],
            bestIndex: 0,
            themeHint: "Inherited sponsors are net-new buyers. Re-discovery first.",
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p057", theme: .renewal, difficulty: 1500,
            buyerRole: "Existing customer, Director of CS, mid-cycle support-quality concern",
            setup: "Director frustrated with three escalations in 60 days.",
            buyerLine: "Honestly, support quality has dropped. I'm not sure we can recommend renewal at full pricing.",
            candidates: [
                PuzzleCandidate(text: "I know exactly which three escalations you mean, and how each one resolved. Let's run a corrective sprint — ninety days of named support, weekly check-ins, straight through the renewal window.", eval: 0.7, rationale: "Naming the specific escalations converts an abstract complaint into a discussable diagnosis. The named-support arrangement is a recovery path CS directors recognize and accept.", atlasTags: ["labeling", "concrete-construal", "reciprocity"]),
                PuzzleCandidate(text: "We'll take ten percent off the renewal.", eval: -0.3, rationale: "The discount buys a quarter of quiet without touching support quality. The same conversation returns at the next renewal, angrier.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Honestly, all three resolutions landed inside SLA.", eval: -0.6, rationale: "SLA-correct is still relationship-wrong. Dismissing a perception complaint on the numbers pushes the customer toward churn.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "I want our VP of Support to apologize to you directly — she'll speak to each of the three escalations specifically on that call, present the remediation plan, and commit to a thirty-day follow-up review with you.", eval: 0.2, rationale: "Right move for a severe breach — for three escalations, the named-support sprint is the more operational fix. Keep the VP call in reserve.", atlasTags: ["labeling", "authority"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p058", theme: .renewal, difficulty: 1800,
            buyerRole: "Existing customer, CFO, year-two renewal with budget squeeze",
            setup: "Year-two renewal. CFO has signaled budget pressure across all SaaS.",
            buyerLine: "We're cutting 18% across the SaaS line this year. You're going to need to absorb part of that.",
            candidates: [
                PuzzleCandidate(text: "Instead of cutting us, cut around us. There are two vendors sitting next to us in your stack that we can replace under a consolidated renewal — that's net savings to the SaaS line, not a haircut on the tool that's working.", eval: 0.8, rationale: "Consolidation converts a margin-compression conversation into an expansion one. It's the CFO-friendly pattern — when your product map actually supports the replacement.", atlasTags: ["alternative-choice", "contrast"]),
                PuzzleCandidate(text: "We can absorb it.", eval: -0.7, rationale: "Board-mandated cuts don't reward line-for-line compliance. You just taught the CFO you're purely flexible, and years three and four re-anchor accordingly.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "The year-one ROI speaks for itself here.", eval: -0.4, rationale: "ROI doesn't survive a board-level cost directive. The CFO files you under 'doesn't get it' and moves on.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "We can take the cut if it comes with a three-year lock — priced so the term extension clears the concession, with CPI indexing from year two. That gives you a board-visible win without gutting the one line item that's producing.", eval: 0.0, rationale: "Workable only if the lock's NPV genuinely clears the concession. Run the math before you offer the structure, not after.", atlasTags: ["sharp-angle", "commitment-consistency"]),
            ],
            bestIndex: 0,
            themeHint: "Across-the-board cuts are addressable through consolidation, not concession.",
            transcriptId: "tracy-think-it-over"
        ),

        Puzzle(
            id: "p059", theme: .renewal, difficulty: 1300,
            buyerRole: "Existing customer, Director of Ops, low-friction renewal",
            setup: "Three-year customer. Usage grew 40%. Director engaged.",
            buyerLine: "Renewal looks straightforward. What are we doing on terms?",
            candidates: [
                PuzzleCandidate(text: "Your usage grew forty percent this cycle, so we're proposing six percent — the growth plus our standard market-rate adjustment. The usage data is the anchor here.", eval: 0.7, rationale: "A usage-tied increase is a recognized renewal mechanism, and the director already knows the growth number. Your job is just to map it to defensible pricing.", atlasTags: ["concrete-construal"]),
                PuzzleCandidate(text: "Flat. Same terms as now.", eval: -0.3, rationale: "Nobody asked you for flat. The hesitation is self-imposed, and it forfeits the increment the value growth earned.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Given the growth, we'd be looking at fifteen percent up.", eval: 0.0, rationale: "Defensible on paper, but you're overshooting a low-friction renewal that would have signed at six. Don't turn an easy yes into a negotiation.", atlasTags: ["extreme-anchor"]),
                PuzzleCandidate(text: "How about a multi-year lock at today's pricing?", eval: -0.4, rationale: "You just froze a growing account at a static price. The customer takes that deal every time — that's the tell.", atlasTags: ["commitment-consistency"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p060", theme: .renewal, difficulty: 2000,
            buyerRole: "Existing customer, IT Director, security-driven renewal pressure",
            setup: "Renewal call. IT director has been the executive sponsor; security review surfaced one finding from the operator's last SOC2.",
            buyerLine: "There's one finding in your last SOC2 that our CISO wants closed before we renew.",
            candidates: [
                PuzzleCandidate(text: "I know the finding. The compensating control is already deployed, and full remediation closes next quarter — I'll send the dated timeline. Want me to set up a call between our CISO and yours to walk the closure path directly?", eval: 0.8, rationale: "Security findings are remediation-path questions, not verdicts. Specificity — the compensating control, the date — plus CISO-to-CISO routing converts security pressure into procedural confidence.", atlasTags: ["concrete-construal", "multi-threading"]),
                PuzzleCandidate(text: "That finding isn't material.", eval: -0.7, rationale: "You just disputed a CISO-flagged finding. That reads as disrespect for their security process, and the renewal walks into an RFP.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Let's hold the renewal until the finding closes. I'll publish a remediation timeline with named owners, give your CISO's team a mid-cycle verification checkpoint, and keep the commercial terms locked so nothing re-prices during the gap.", eval: -0.3, rationale: "Deferring extends the cycle and opens the door to competitors — even with a clean plan attached. It's a conditional path, not the highest-information move here.", atlasTags: ["mutual-close-plan"]),
                PuzzleCandidate(text: "What if we discounted the renewal and closed the finding after?", eval: -0.5, rationale: "A discount tied to a security risk is offensive to a CISO. You just spent the security trust you needed most.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0,
            themeHint: "Security findings convert through specificity and CISO-to-CISO routing, not through dispute.",
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p061", theme: .renewal, difficulty: 1600,
            buyerRole: "Existing customer, VP Marketing, multi-year renewal at neutral usage",
            setup: "Year three renewal. Usage neutral, customer satisfied but not advocating expansion.",
            buyerLine: "We're happy. But I'm not sure I can defend a price increase. Same terms?",
            candidates: [
                PuzzleCandidate(text: "Keep year four flat — and we'll add the new feature bundle at no charge, with year five moving to full market rate once the bundle has proven itself in your stack.", eval: 0.7, rationale: "The buyer told you they can't defend an increase at neutral usage. The bundled uplift turns a flat-price standoff into a value-expansion story that justifies the year-five step.", atlasTags: ["alternative-choice", "commitment-consistency"]),
                PuzzleCandidate(text: "Same terms it is.", eval: -0.2, rationale: "Acceptable on a neutral account — but you walked past the upsell vector entirely. Depends on how much this account matters.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Market's up — we need ten percent this cycle.", eval: -0.5, rationale: "You pushed a market-rate case at someone who just told you they can't defend an increase internally. Renewal probability drops.", atlasTags: ["extreme-anchor", "authority"]),
                PuzzleCandidate(text: "Let's do five off — a year-three thank-you from us.", eval: -0.6, rationale: "A unilateral discount on a satisfied account is anti-leveraged. You've filed yourself under flexible-by-default.", atlasTags: ["reciprocity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p062", theme: .renewal, difficulty: 1700,
            buyerRole: "Existing customer, COO, renewal during M&A integration",
            setup: "Customer was acquired. New parent company has competing tooling in stack.",
            buyerLine: "Our parent's standard is a different vendor. We need to consolidate.",
            candidates: [
                PuzzleCandidate(text: "Before anything's decided — could I get thirty minutes with your parent's procurement and IT to scope the consolidation specifically? In these situations the deeper deployment survives more often than not, and yours is the deeper one by a distance.", eval: 0.7, rationale: "M&A consolidations aren't predetermined — the surviving vendor usually comes down to deployment depth and integration cost. Getting the scoping meeting moves the fight onto your strongest ground.", atlasTags: ["concrete-construal", "social-proof", "multi-threading"]),
                PuzzleCandidate(text: "If consolidation is the direction, let's at least make the exit clean — data-migration support, a reference clause, and a right-to-rebid at the parent's next vendor review. A graceful exit is the thing their procurement group remembers at the next cycle, and I'd rather be the vendor they remember well than the one who clung.", eval: -0.5, rationale: "You accepted the outcome before testing it. Graceful exits are fine craft — but you may have been the surviving vendor if you'd made the case first.", atlasTags: ["reciprocity", "liking"]),
                PuzzleCandidate(text: "Would twenty-five off change the answer?", eval: -0.6, rationale: "Discounting into an M&A consolidation almost never changes the outcome — it just trains the account on discount-at-renewal.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Let's revisit once the integration settles.", eval: -0.4, rationale: "Integration timelines compound the risk. While you wait, the consolidation quietly defaults to the parent's vendor.", atlasTags: ["silence"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        // ─── Multistakeholder batch 2 ───────────────────────────────────
        Puzzle(
            id: "p063", theme: .multistakeholder, difficulty: 1500,
            buyerRole: "Champion VP Operations, hostile CFO joining call",
            setup: "Champion has run discovery. CFO joins for first time. CFO's first words.",
            buyerLine: "I haven't seen anything on this yet. Walk me through why we're spending money on it.",
            candidates: [
                PuzzleCandidate(text: "Actually — before I say anything: [to the champion] this started with your team, so walk us through the problem you pulled me in on. Then I'll pick up what the current state costs and what the outcome data shows once the problem's on the table from your side.", eval: 0.7, rationale: "A cold CFO discounts vendor narrative by default and extends real credit to their own VP. Sequencing champion-first spends each voice where it carries: the champion on the problem, you on the evidence.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "What threshold would this spend need to clear for you?", eval: 0.2, rationale: "Reasonable in a warm room. Asked cold, before any problem anchoring, it reads as fishing for the answer key in front of the one person scoring the test.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Happy to walk you through it — full ROI story, I've got the deck ready.", eval: -0.3, rationale: "You're competing on raw pitch against a hostile decision-maker while the strongest asset in the room — the champion's credibility — sits unused.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "This deserves better than a group walk-through — could you and I take thirty minutes one-on-one?", eval: -0.6, rationale: "You just bypassed your champion mid-meeting. The CFO notes it, the champion remembers it, and you now own a relationship you haven't earned.", atlasTags: ["authority"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        Puzzle(
            id: "p064", theme: .multistakeholder, difficulty: 1700,
            buyerRole: "Champion + economic buyer split on solution choice",
            setup: "Champion VP-Eng prefers operator's solution. Economic buyer CFO prefers competitor.",
            buyerLine: "[Champion privately] He's going to ask for a side-by-side. I told him you'd send one.",
            candidates: [
                PuzzleCandidate(text: "I'll build it around the three outcomes you've all agreed are the decision criteria — leading with the ones we win. Where the competitor takes a category, we'll say so, with a short note on how much it actually matters. Honest beats airtight with a CFO.", eval: 0.9, rationale: "Visible neutrality is what earns the CFO's trust, and champion-coordinated criteria win you the dimensions that matter. Conceding where it's honest is exactly what makes the rest of the document believable.", atlasTags: ["concrete-construal", "contrast"], isFork: true),
                PuzzleCandidate(text: "I'll send one where we win every single category — leading with the two biggest deltas, structured around the CFO's stated evaluation criteria, third-party benchmarks in every row, plus a summary paragraph written so you can forward it straight upward. He won't have an angle left to argue when it lands.", eval: -0.5, rationale: "CFOs discount unanimous-win comparisons as marketing on sight. Worse, your champion forwarded it — so their standing takes the hit alongside yours.", atlasTags: ["contrast", "social-proof"]),
                PuzzleCandidate(text: "Let's skip the side-by-side — your recommendation should carry it.", eval: -0.7, rationale: "CFOs respond to structured comparisons; refusing one signals your data won't survive daylight. He defaults to the competitor.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "I'll send the comparison straight to the CFO and save you the relay.", eval: -0.6, rationale: "You bypassed the champion on their own play. They lose standing, and a champion who loses standing can reverse a recommendation.", atlasTags: ["contrast"]),
            ],
            bestIndex: 0,
            themeHint: "Side-by-sides are champion-coordination tools. Concession-where-honest earns credibility.",
            transcriptId: "klaff-prize-frame"
        ),

        Puzzle(
            id: "p065", theme: .multistakeholder, difficulty: 1800,
            buyerRole: "Champion at risk; new stakeholder added late",
            setup: "Five months in. Champion VP Sales aligned. CRO surprise-added in week 22.",
            buyerLine: "[CRO] I just got pulled in. I'm not sure why we'd pick this over the platform we already have.",
            candidates: [
                PuzzleCandidate(text: "Fair question — could I take thirty minutes with you directly, anchored on your revenue equation? I'd rather not assume five months of someone else's framing transfers to you.", eval: 0.7, rationale: "A stakeholder added in week twenty-two is a net-new buyer. Re-discovering with the CRO and earning the buy explicitly converts far better than trusting the champion's handoff to carry it.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "[to the champion] Go make our case to him.", eval: -0.3, rationale: "You just assigned your champion asymmetric work in front of their boss. Their standing degrades either way it goes.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Let me send over our closest revenue-comparable customer, with one line on why it's relevant. [to the champion] Which metric does he screen for first when something new crosses his desk?", eval: -0.2, rationale: "A case study without re-discovery underwhelms a CRO — you get absorbed as the vendor who didn't do the homework.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "What if we took twenty-five off to clear the friction?", eval: -0.6, rationale: "You discounted to a brand-new stakeholder before discovering anything. Their first data point about you: discount-by-default.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0,
            themeHint: "Late-stage stakeholders are net-new buyers; re-discover.",
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p066", theme: .multistakeholder, difficulty: 1600,
            buyerRole: "Three-person buying committee, one blocker",
            setup: "Champion + champion's peer aligned. Third committee member is a blocker.",
            buyerLine: "[committee call] [Third member] I don't think the integration risk is acceptable. I'd vote no.",
            candidates: [
                PuzzleCandidate(text: "Which integration risk specifically has you at a no? We've resolved that exact risk two ways — an architectural change, or a scoped integration-services engagement — and I'd like to walk both with your infra lead in a follow-up session.", eval: 0.7, rationale: "A blocker's objection is always specific. Generic reassurance hardens the block; naming the risk and offering concrete resolution paths is what converts it.", atlasTags: ["calibrated-question", "concrete-construal", "multi-threading"]),
                PuzzleCandidate(text: "Two of three votes is a yes in my book.", eval: -0.7, rationale: "Forcing a two-to-one decision over a stated blocker poisons the rollout. That blocker now has you on their list, permanently.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "[to the champion, afterward] Give it two weeks to run internally — you work on him, we'll hold a weekly check-in for signal, and I'll stay entirely out of the technical debate so the resolution reads as yours rather than ours when it lands.", eval: -0.3, rationale: "Champion-to-blocker conversion on a technical objection usually fails without your support. You're betting the deal on a conversation you've chosen not to attend.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "I'll send over our technical FAQ.", eval: -0.2, rationale: "The FAQ assumes the blocker's question is in the FAQ. Specific risks need specific resolutions, not a document.", atlasTags: ["reciprocity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        Puzzle(
            id: "p067", theme: .multistakeholder, difficulty: 1900,
            buyerRole: "Senior executive + skeptical CISO joint call",
            setup: "Final-stage call. Senior executive supportive. CISO present and skeptical of data residency.",
            buyerLine: "[CISO] Our customer data cannot leave the region. Where does your processing happen?",
            candidates: [
                PuzzleCandidate(text: "All our processing stays in your region — I'll send you the SOC 2 control reference behind that today. Want 30 minutes with your security team and our architect to walk the residency design?", eval: 0.8, rationale: "CISOs convert on specifics — the region, the control reference, the invitation to inspect. You answered the question and opened up the architecture; that's how you stop getting filed under doesn't-know-their-own-product.", atlasTags: ["concrete-construal", "multi-threading"]),
                PuzzleCandidate(text: "That deserves a precise written answer — give me 24 hours and I'll get you a document structured around your three regions, with your compliance lead copied so it lands with the right internal weight behind it.", eval: -0.5, rationale: "You deferred a security question to a follow-up doc, and a skeptical CISO hears one thing: you don't have the answer ready. That's how deals get routed to procurement to die quietly.", atlasTags: ["reciprocity", "authority"]),
                PuzzleCandidate(text: "We can also run this as an enclaved deployment inside your region.", eval: 0.2, rationale: "Maybe a real path — but if that deployment model doesn't actually exist yet, you just overpromised to the one person in the room who will check.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "[to the executive] I know security has concerns — can I count on you to keep this moving?", eval: -1.0, rationale: "Executives do not overrule CISOs on data residency, ever. You just damaged both relationships with one sentence.", atlasTags: ["authority"]),
            ],
            bestIndex: 0,
            themeHint: "CISO objections require specificity. Architectural references and joint sessions convert; vague reassurance does not.",
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p068", theme: .multistakeholder, difficulty: 1500,
            buyerRole: "Buying committee chair signaling tempo, not consensus",
            setup: "Chair runs committee processes. Process-driven, not outcome-driven.",
            buyerLine: "We'll get back to you in two weeks with the committee's response.",
            candidates: [
                PuzzleCandidate(text: "Happy to work with your process — what path does the committee follow from here, and who needs what by when? I can get each member a tailored one-page brief 24 hours before you convene.", eval: 0.7, rationale: "A process-driven chair respects the rep who works the mechanics. Per-member briefs the day before the meeting cut committee friction — and put your words in a room you can't enter.", atlasTags: ["calibrated-question", "multi-threading", "reciprocity"]),
                PuzzleCandidate(text: "Sounds good — we'll wait to hear from you in two weeks.", eval: -0.3, rationale: "You accepted the timeline and gave up your one window to shape the committee's read. Two weeks has a way of becoming six.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "Two weeks is a while — is there any way we could get an answer sooner?", eval: -0.5, rationale: "Pressuring a process-driven chair on tempo costs you the chair. They'll route you lower and let the process bury you.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "I'll send over a deck you can circulate to the committee.", eval: -0.2, rationale: "One generic deck assumes the committee is one audience. It isn't — each member scores on their own question, and a circulated deck answers none of them.", atlasTags: ["gain-framing"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p069", theme: .multistakeholder, difficulty: 2000,
            buyerRole: "Champion neutralized by political constraint",
            setup: "Strong champion, but the champion's boss publicly favored a competitor and is unlikely to reverse.",
            buyerLine: "[champion privately] He's not going to switch. The political cost is too high.",
            candidates: [
                PuzzleCandidate(text: "What if nobody has to switch positions? Propose both vendors run in parallel against a published rubric — that way your boss isn't reversing himself in front of anyone, he's just following the data wherever it lands.", eval: 0.9, rationale: "Political cost is face-saving cost. A head-to-head against a published rubric gives the boss a way to change his mind without ever admitting he changed it — he's not reversing, he's following the data.", atlasTags: ["concrete-construal", "alternative-choice"], isFork: true),
                PuzzleCandidate(text: "Could you push it up to him one more time?", eval: -0.7, rationale: "You just asked your champion to spend their standing challenging the boss's public position. That's how champions get destroyed.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Let's give it a few months and see if things cool off.", eval: -0.5, rationale: "Political positions calcify with time — they don't fade. Waiting hands the deal to the choice already made.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "What if we just beat their price outright — a gap big enough to force a re-evaluation, plus a switching-cost credit so the total-cost story clearly wins?", eval: -0.4, rationale: "Price was never the issue — face is. A discount doesn't buy the boss a way out of his own public commitment.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0,
            themeHint: "Political constraints need face-saving paths. POV-with-rubric is the standard mechanism.",
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p070", theme: .multistakeholder, difficulty: 1400,
            buyerRole: "Two champions across two teams, fragmented buy-in",
            setup: "VP Engineering and VP Marketing both champion. Each owns half the use case.",
            buyerLine: "[VP Eng] We'll sponsor it together. We just need to align on which budget it comes from.",
            candidates: [
                PuzzleCandidate(text: "Let me make this easy on both of you: I'll put a recommended 60/40 split in writing, weighted to how each team uses it, with a named budget owner on each side. Deals like this close about 30% faster that way.", eval: 0.7, rationale: "Joint-budget deals stall on exactly this question. When you recommend the split in writing with named owners, you hand both champions a shared decision they can carry upward — instead of a fight they have to referee.", atlasTags: ["concrete-construal", "alternative-choice"]),
                PuzzleCandidate(text: "You two know your budgets better than I do — I'll send you both the same cost breakdown so you're working from one set of numbers, and we can set up the three-way call once you've had the internal conversation and landed somewhere.", eval: -0.4, rationale: "You just delegated the hardest question in the deal to the two people most likely to fight over it. That coordination job was yours, and your silence is the missed move.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "Honestly, this goes faster if one of you owns the whole budget.", eval: -0.3, rationale: "Faster on paper — but you just asked one champion to absorb the entire political cost, and demoted the other one inside their own building.", atlasTags: ["commitment-consistency"]),
                PuzzleCandidate(text: "What if I took 10% off so the split hurts less?", eval: -0.5, rationale: "The budget split isn't a price objection. Cutting price misreads the constraint and buys you nothing.", atlasTags: ["reciprocity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        Puzzle(
            id: "p071", theme: .multistakeholder, difficulty: 1700,
            buyerRole: "Procurement + business team disagreement on vendor selection",
            setup: "Business team prefers operator. Procurement is pushing for a lower-cost competitor.",
            buyerLine: "[procurement] The business team likes you. But on a total-cost view I have to recommend the competitor.",
            candidates: [
                PuzzleCandidate(text: "Fair enough — rather than argue your output, can I offer better inputs? I have implementation costs and the year-three switching premium from two named deployments in your revenue band; drop them into your own TCO sheet and see where it lands.", eval: 0.7, rationale: "A TCO recommendation moves when its inputs move, and inputs move on evidence, not advocacy. Named-peer actuals are the one data class procurement can defend substituting — the model stays theirs, the numbers become yours.", atlasTags: ["social-proof", "concrete-construal"]),
                PuzzleCandidate(text: "Could you walk me through the TCO model — which assumptions move the total the most?", eval: 0.4, rationale: "Right diagnosis, half a move. You opened the model but arrived empty-handed — without substitute data, the review closes on the same recommendation.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "The business team has been clear about their preference — I'd let that carry it.", eval: -0.5, rationale: "Overriding procurement wins you one recommendation and loses you the function. Remember who writes the renewal terms.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "We'll match their number and close the gap.", eval: -0.4, rationale: "Matching confirms their sheet instead of correcting it. That match is your new list price — the cheaper competitor now sets your pricing from here on.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p072", theme: .multistakeholder, difficulty: 1600,
            buyerRole: "C-suite champion, mid-level skeptic owning daily usage",
            setup: "CEO sponsors deal. Director of Ops would own daily operation and is unconvinced.",
            buyerLine: "[Director] The CEO likes it. I'm the one who's going to live with the workflow. I've got concerns.",
            candidates: [
                PuzzleCandidate(text: "You're the one who has to live in it, so let's do this properly — give me 45 minutes and we'll walk your actual daily workflow step by step against the product. If it doesn't hold up at your desk, the CEO's opinion doesn't matter.", eval: 0.7, rationale: "C-suite mandates without end-user buy-in produce shelfware. Sit down inside the Director's real workflow and earn the yes — that's how the skeptic becomes your daily advocate instead of your quiet saboteur.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "I'll talk with the CEO about making the rollout a directive.", eval: -0.7, rationale: "Mandated adoption is the express lane to shelfware. Force it through the CEO and the Director becomes your internal opposition.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Let me put together a full side-by-side of your current process against the new one — every step mapped, the time saved per analyst per week quantified, the two steps that don't change at all flagged so the migration looks honest — and then if it's useful we can find time for a working session whenever your calendar opens up.", eval: 0.1, rationale: "A document assumes a skeptic will read it sympathetically. They won't — a live working session converts where paper gets skimmed, filed, and quietly held against you.", atlasTags: ["contrast", "concrete-construal"]),
                PuzzleCandidate(text: "What if I sharpened the price to ease your concerns?", eval: -0.6, rationale: "The Director's concerns are workflow-shaped, not price-shaped. A discount answers a question nobody asked.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0,
            themeHint: "End-user champions outperform C-suite mandates for adoption.",
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p073", theme: .multistakeholder, difficulty: 1800,
            buyerRole: "Champion VP + competing internal initiative for the same budget",
            setup: "Champion supportive but their VP-peer is pitching a competing internal build for the same budget line.",
            buyerLine: "[champion privately] I'm pretty sure the build pitch is going to win. He's got the CEO's ear.",
            candidates: [
                PuzzleCandidate(text: "Let me arm you properly: a one-pager on the build-vs-buy math — time to deploy, fully-loaded engineering cost, and what those engineers won't ship while they're building this — plus two named companies that started this same build and abandoned it.", eval: 0.7, rationale: "Build-vs-buy contests turn on engineering opportunity cost, not sticker price. Named peers who abandoned the build give your champion a brief the CEO will actually absorb.", atlasTags: ["loss-framing", "social-proof", "concrete-construal"]),
                PuzzleCandidate(text: "What if we priced under what the build will really cost them?", eval: -0.4, rationale: "Build advocacy is rarely price-driven. Matching the implied build cost rewards the wrong comparison — and cheapens you in the process.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Any way to get me in front of the CEO directly?", eval: -0.6, rationale: "Going over the VP's head burns your champion and makes an enemy of the peer. Even if the override lands, you've poisoned the account.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Let's not fight it head-on. Keep a light monthly check-in going with me, I'll track their hiring posts and roadmap slippage from the outside, and the moment that first internal milestone slips we come back in with the re-entry case ready — positioned right when the estimate meets reality.", eval: -0.5, rationale: "Internal builds with executive air cover survive scrutiny far longer than you expect. Waiting for the collapse is how you watch the budget line disappear.", atlasTags: ["silence"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p074", theme: .multistakeholder, difficulty: 1900,
            buyerRole: "Cross-functional steering committee with rotating decision authority",
            setup: "Three executives rotate decision authority across capabilities. Operator's deal sits at the intersection.",
            buyerLine: "[committee] We're going to ask each function leader to score this independently. We'll convene next month.",
            candidates: [
                PuzzleCandidate(text: "Could you share the scoring rubric? I'd like to offer each function leader a 30-minute working session on how we map to their specific metric — it should make everyone's scoring faster, not slower.", eval: 0.8, rationale: "Committees that score independently converge when each leader sees the mapping to their own metric. Working sessions shrink each scorer's homework — you're accelerating their process, not fighting it.", atlasTags: ["multi-threading", "reciprocity", "concrete-construal"]),
                PuzzleCandidate(text: "I'll build one deck for the full committee — leading with the shared business case, pitched at the cross-functional altitude you've described — and route it through you with an offer to walk it live when you convene next month.", eval: 0.0, rationale: "One joint deck assumes joint evaluation. They just told you the scoring is independent — without per-function content, your story dies in translation three separate times.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "Any way we could get a read before next month?", eval: -0.4, rationale: "Leaning on a committee's tempo reads as disrespect for the process. The chair hears it — and routes you down.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "We trust the process — see you next month.", eval: -0.3, rationale: "Trusting the process forfeits your only chance to shape three independent scores. Committees that convene without your input converge on someone else.", atlasTags: ["silence"]),
            ],
            bestIndex: 0,
            themeHint: "Cross-functional committees converge through per-function articulation, not joint pitches.",
            transcriptId: "voss-live-label"
        ),

        // ─── Endgame batch 2 ────────────────────────────────────────────
        Puzzle(
            id: "p075", theme: .endgame, difficulty: 1500,
            buyerRole: "Verbal commit obtained; final paperwork pending",
            setup: "Champion verbally committed. Paperwork drafted. Signature pending one week.",
            buyerLine: "We're good. Sending to legal Friday for sign-off.",
            candidates: [
                PuzzleCandidate(text: "Love it. Before Friday, let's put a quick close plan on paper — who owns sign-off, the kick-off date, your onboarding lead — because in our data that cuts post-commit slippage by more than half.", eval: 0.7, rationale: "Verbal-to-signature is where 20-30% of committed deals slip. Named owners and dates turn a promise into a plan with joint accountability — that's the whole game after the yes.", atlasTags: ["mutual-close-plan", "commitment-consistency"]),
                PuzzleCandidate(text: "Perfect — everything's coming over today: a pre-filled signature packet with our counter-signature already applied, a one-line summary of the agreed terms, and if legal has a question on any clause I'm available same-day to walk it through with them.", eval: -0.3, rationale: "Sending paperwork and waiting accepts the slippage rate as given. Frictionless, sure — but you built no shared plan and you hold no lever on tempo.", atlasTags: ["assumptive", "summary-close"]),
                PuzzleCandidate(text: "Any chance we could get signature in before Friday?", eval: -0.4, rationale: "They just told you the path. Pushing for earlier now spends champion goodwill to buy days you don't need.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "If you can sign this week, I'll add a kickoff bonus for you.", eval: -0.5, rationale: "A bonus for signing this week teaches them — one week before close — that your terms bend under pressure. That lesson survives into every renewal.", atlasTags: ["sharp-angle", "scarcity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: nil
        ),

        Puzzle(
            id: "p076", theme: .endgame, difficulty: 1700,
            buyerRole: "Late-stage redline on indemnity scope",
            setup: "Final legal review. One open issue.",
            buyerLine: "[legal] We need IP indemnity uncapped. Everything else looks good.",
            candidates: [
                PuzzleCandidate(text: "We can go uncapped on IP indemnity if it's scoped to our own patents and copyrights — and we'd ask for the same obligation on content your side supplies. That's the symmetric position you'll see across the market.", eval: 0.7, rationale: "Uncapped IP indemnity scoped to your own IP is a recognized vendor concession — you're covering what you actually control. Asking for symmetry on customer-supplied content is the standard counter that survives legal review.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "Done — uncapped IP indemnity it is.", eval: -0.8, rationale: "Uncapped and unscoped means you're on the hook for IP claims arising from content they supply. That's existence-level exposure, signed away in one sentence.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "We can't do uncapped — capped indemnity is standard across every enterprise agreement we hold. I'll attach the insurance certificate showing our coverage limits, and I'm glad to set up a call between our counsel and yours to walk the precedent, so you can see this is policy, not posture.", eval: -0.3, rationale: "A flat rejection on the final redline is how signatures die. You might win the precedent argument and lose the deal.", atlasTags: ["authority", "social-proof"]),
                PuzzleCandidate(text: "Could we park the indemnity question in a side letter and sign the rest?", eval: -0.4, rationale: "Legal teams resist side letters on final redlines — you just extended the cycle to dodge a question you'll have to answer anyway.", atlasTags: ["isolate-and-conquer"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p077", theme: .endgame, difficulty: 1900,
            buyerRole: "Late-stage discount ask, deal contingent",
            setup: "Procurement, final call. Verbal commit dependent on one final ask.",
            buyerLine: "Look, we're a yes if you give me one more 5 percent. Otherwise this goes back to committee.",
            candidates: [
                PuzzleCandidate(text: "I can do 3 — if we extend the term twelve months and add a published case-study clause. Five is a nice round number; three with structure behind it is a real one.", eval: 0.8, rationale: "A round 5% at the finish line is procurement theater. Counter with structurally different levers — term, case study — and they get a defensible win to carry inside while your anchor stays intact.", atlasTags: ["alternative-choice", "anchor-with-range"]),
                PuzzleCandidate(text: "Okay — 5% and we're done.", eval: -0.4, rationale: "You just paid the theater price. A clean 5% at the end teaches procurement exactly how you fold — and next renewal opens from there.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Can't do it. Take it back to committee if you need to.", eval: -0.6, rationale: "Walking over 5% at the finish line torches your sunk position. The committee reopens the decision — and the competitor is still in the building.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "You can have the 5% if we sign today — I'll paper it into the order form with an expiration stamp, and on our side it gets framed as quarter-end capacity planning, not price flexibility.", eval: -0.2, rationale: "Full concession plus a deadline is the most predictable branch of procurement's discount tree. They absorb it as routine — and remember the fold, not the framing.", atlasTags: ["sharp-angle", "scarcity"]),
            ],
            bestIndex: 0,
            themeHint: "Round-number concession asks are procurement-theater. Structurally-different counters preserve the anchor.",
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p078", theme: .endgame, difficulty: 1600,
            buyerRole: "Endgame stall: signature delayed by holiday",
            setup: "Verbal commit. Signature delayed by holiday calendar.",
            buyerLine: "We're closing the office for the holiday. Back in two weeks.",
            candidates: [
                PuzzleCandidate(text: "Totally understand — enjoy the break. Let me pre-stage everything on our side: a one-click DocuSign envelope ready to go, and if you can name one person who can sign when you're back, there's zero friction on the return.", eval: 0.7, rationale: "Holiday-delayed signatures slip badly when nothing is staged. A pre-loaded envelope and one named signer on return costs you nothing and insures the close.", atlasTags: ["concrete-construal", "commitment-consistency"]),
                PuzzleCandidate(text: "No problem — talk in two weeks.", eval: -0.3, rationale: "Accept-and-wait accepts the slippage rate along with it. Deals really do die over a holiday-extended quiet period.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "Any chance we could squeeze the signature in before you close up?", eval: -0.4, rationale: "Pressuring someone against their own holiday reads as your quota, not their interest. It costs the relationship more than two weeks costs you.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "If you can get it signed before the holiday, I can take a little more off the price.", eval: -0.5, rationale: "A discount to beat a holiday teaches them your price bends under calendar pressure — a lesson they'll cash in at year two.", atlasTags: ["sharp-angle", "scarcity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: nil
        ),

        Puzzle(
            id: "p079", theme: .endgame, difficulty: 2000,
            buyerRole: "Endgame politics: customer's general counsel inserting new clauses",
            setup: "Last week of cycle. GC opens new clauses not raised in red-lines.",
            buyerLine: "[GC] We need a most-favored-nation clause, a unilateral price-cap, and a competitor non-compete.",
            candidates: [
                PuzzleCandidate(text: "We can take the price cap, scoped to year-over-year increases above 6% — that's within our standard tolerance. The MFN and the non-compete we can't do; neither is market-standard, and I can show you the enterprise norms we benchmark against.", eval: 0.8, rationale: "Differentiate and you signal market fluency: accept what's standard — a scoped price cap — and reject what isn't. GCs respect a vendor who demonstrably knows the norms.", atlasTags: ["alternative-choice", "concrete-construal"]),
                PuzzleCandidate(text: "We can work with all three.", eval: -1.2, rationale: "MFN plus a non-compete plus a unilateral price cap hands them asymmetric leverage forever. That's existence-level NPV damage, accepted in one breath.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "None of the three will work for us.", eval: -0.5, rationale: "Blanket rejection stalls the close — and the price cap was legitimate territory. You just told the GC you can't tell standard from non-standard.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "Could we move all three into a side letter? We'd sequence it so the price cap — the one with real territory — lands first with agreed language, then hold the MFN and the non-compete for a scheduled counsel-to-counsel session with a named date, so the deferral reads as process rather than avoidance.", eval: -0.4, rationale: "Three clauses in a side letter is complexity legal teams refuse. You've delayed the close and may have collapsed it.", atlasTags: ["isolate-and-conquer", "mutual-close-plan"]),
            ],
            bestIndex: 0,
            themeHint: "Late-stage GC clause insertion requires differentiated response: accept market-standard, reject non-standard.",
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p080", theme: .endgame, difficulty: 1500,
            buyerRole: "Verbal commit; champion has lost momentum internally",
            setup: "Verbal commit two weeks ago. Champion has not advanced the paperwork.",
            buyerLine: "Sorry, been swamped. I'll get the paperwork to legal this week.",
            candidates: [
                PuzzleCandidate(text: "I know how much internal routing this stuff takes — want me to draft the routing email and the legal-handoff doc for you? You'd just review and hit send.", eval: 0.7, rationale: "Post-commit stalls are almost always routing friction, not doubt. Draft the email and the handoff doc yourself — taking the work off the champion's plate is the standard endgame intervention.", atlasTags: ["reciprocity", "concrete-construal"]),
                PuzzleCandidate(text: "No worries — this week works.", eval: -0.4, rationale: "'This week' from a swamped champion means nothing yet. Wait passively and you watch the momentum decay one week at a time.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "Is there someone above you who could help push it through faster?", eval: -0.5, rationale: "Pushing a stalled champion to escalate presses on the exact spot where their standing may already be weak. You'll damage the person who got you here.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "If we can get signature this week, I can add an implementation credit on top — papered with a hard expiration date so it never touches your renewal baseline at year two.", eval: -0.5, rationale: "A discount nobody asked for, offered into a stall, teaches your champion that delay pays. It also sours the dynamic right before you become a line item they defend.", atlasTags: ["sharp-angle", "scarcity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p081", theme: .endgame, difficulty: 1800,
            buyerRole: "Procurement insertion at endgame asking for a fourth signer",
            setup: "Final paperwork. Procurement inserts a new requirement.",
            buyerLine: "Our process requires an additional VP-level signoff. Adds two weeks.",
            candidates: [
                PuzzleCandidate(text: "Completely understand — process is process. Would it help if I gave the new signer a 15-minute briefing on the deal at whatever time suits them, just to shrink their review load?", eval: 0.7, rationale: "An added signer is standard endgame friction — treat them as an audience, not an obstacle. A short briefing shrinks the VP's review and puts your framing in front of the decision.", atlasTags: ["multi-threading", "reciprocity"]),
                PuzzleCandidate(text: "Is there any way to waive the extra signoff? We had a plan for Friday.", eval: -0.4, rationale: "Procurement doesn't waive its own process, and asking them to marks you adversarial for the entire post-purchase relationship.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "That's fine — we'll use the two weeks well: I'll tighten up the implementation plan, confirm the countersignature logistics with our legal team, and hold the kickoff date steady so the delay doesn't cost us anything downstream.", eval: -0.3, rationale: "Productive-looking patience — but you surrendered the one thing that matters: shaping how the new signer sees the deal before they judge it.", atlasTags: ["silence", "mutual-close-plan"]),
                PuzzleCandidate(text: "What if I improved the price to skip the extra signer?", eval: -0.7, rationale: "You just offered procurement money to break their own rules. That's not a discount, it's an insult — and they'll remember it.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p082", theme: .endgame, difficulty: 2100,
            buyerRole: "Champion suddenly silent at endgame",
            setup: "Verbal commit three weeks ago. Champion has not responded in 10 days.",
            buyerLine: "[silence]",
            candidates: [
                PuzzleCandidate(text: "You've probably gone quiet because something changed — budget pulled, another vendor in the mix, or someone senior stepped in. Whichever it is, I'd rather hear it straight. If not, I'll assume the timing's wrong and step away.", eval: 0.8, rationale: "Ten days of silence after a verbal commit means one of three specific things happened. Name them out loud — you give the champion permission to tell you the truth, and the takeaway gives them a reason to answer now.", atlasTags: ["accusation-audit", "takeaway"]),
                PuzzleCandidate(text: "Just floating this back to the top of your inbox!", eval: -0.5, rationale: "Another cheerful bump reinforces the silence pattern. You've become the notification they archive.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "[to the exec, champion cc'd] Wanted to check in on the Q3 priority you flagged at our kickoff — no rush at all on the agreement itself, just making sure you have everything you need from us while things are clearly busy on your side. Happy to help however is useful.", eval: -0.4, rationale: "Going over a silent champion's head rarely re-engages them and often finishes them. Even copied on the thread, they'll read it as a bypass.", atlasTags: ["authority", "commitment-consistency"]),
                PuzzleCandidate(text: "Would another 10% off help get this over the line?", eval: -0.8, rationale: "A discount thrown into silence — with no objection on the table — teaches every future champion that going quiet is the lever that moves your price.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0,
            themeHint: "Late-stage silence usually signals a specific event. Accusation audit surfaces it.",
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p083", theme: .endgame, difficulty: 1700,
            buyerRole: "Customer wants payment-term concession at endgame",
            setup: "Final paperwork. Customer requests net-90 instead of net-30.",
            buyerLine: "Our standard is net-90. Can we get that on the contract?",
            candidates: [
                PuzzleCandidate(text: "We can meet you at net-60, paired with a small price adjustment indexed to our working-capital cost — that keeps the whole thing NPV-neutral for both sides instead of a one-way transfer.", eval: 0.7, rationale: "Payment terms are an NPV transfer wearing a process costume. Meet at the midpoint and index the difference to your working-capital cost — symmetric, defensible, done.", atlasTags: ["anchor-with-range", "concrete-construal"]),
                PuzzleCandidate(text: "Sure — net-90 at the same price works.", eval: -0.5, rationale: "Sixty extra days at the same price is a silent price cut. You just absorbed their financing cost and called it goodwill.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "We can't move off net-30.", eval: -0.3, rationale: "A flat no on a standard ask, this late, stalls a deal that's already agreed in spirit. Concede-with-counter beats the stonewall here.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "We could do net-90 if you go on autopay.", eval: 0.3, rationale: "Autopay trims collection cost, not working-capital cost. Useful garnish — but it isn't the counter.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-think-it-over"
        ),

        Puzzle(
            id: "p084", theme: .endgame, difficulty: 1900,
            buyerRole: "Final discount ask from procurement, contingent",
            setup: "Final negotiations. Procurement signals one more concession need.",
            buyerLine: "Give me 7%. I'll get the deal closed by Friday. That's the absolute last ask.",
            candidates: [
                PuzzleCandidate(text: "Here's what I can do: 4% — if we sign Friday, extend the term six months, and add a published case-study clause. Every concession comes with a lever attached, not just a smaller number.", eval: 0.8, rationale: "The 'absolute last ask' is procurement's last-shot play. A multi-lever counter holds your anchor and still hands them a face-saving win to carry inside.", atlasTags: ["alternative-choice", "scarcity"]),
                PuzzleCandidate(text: "Done — 7% for a Friday signature.", eval: -0.4, rationale: "You hit their number with a single lever. Procurement logs the fold, and year two opens from the new, lower anchor.", atlasTags: ["sharp-angle", "scarcity"]),
                PuzzleCandidate(text: "The number stands. Your own stakeholders signed off on the value case, and the price already reflects everything we negotiated into the scope — so if it needs to go back to committee, I'm comfortable with that.", eval: -0.6, rationale: "Calling the bluff on a winnable 7-point spread risks the whole deal to win an argument. Only defensible if you're certain of their posture — and you're not.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "Okay — we'll do the 7%.", eval: -0.7, rationale: "Unconditional surrender is the worst branch: they record the concession and the absence of any counter. You just priced next year's negotiation for them.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p085", theme: .endgame, difficulty: 1600,
            buyerRole: "Champion needs internal positioning help for signature",
            setup: "Verbal commit. Champion asks for help framing the deal upward.",
            buyerLine: "Honestly I need help selling this internally. What's the best way to position it to my CFO?",
            candidates: [
                PuzzleCandidate(text: "I'll build you a one-page CFO memo: the outcome data behind our value claim, a named peer in your revenue band, and a one-line risk-mitigation statement — formatted so you can drop it straight into your own memo.", eval: 0.8, rationale: "Your champion just asked you to do the work — so do all of it. A drop-in CFO memo removes the last piece of cognitive load between verbal commit and signature.", atlasTags: ["reciprocity", "social-proof", "concrete-construal"]),
                PuzzleCandidate(text: "What if I presented to your CFO directly?", eval: 0.4, rationale: "Useful if the CFO is responsive — but offered uninvited, it can read as going around your champion's own internal positioning. Their call, not yours.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "I'll send over our ROI deck.", eval: -0.2, rationale: "They asked for help selling upward and you handed them homework. A generic deck assumes the champion will repackage it — the ask was for you to.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "You know your CFO better than I ever will — I'd trust your instincts on framing.", eval: -0.5, rationale: "Flattery isn't help. The champion told you plainly they need material, and you left them to carry the load alone.", atlasTags: ["silence"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p086", theme: .endgame, difficulty: 1700,
            buyerRole: "Customer asks for parallel-vendor language in contract",
            setup: "Final legal review. Customer requests right-to-evaluate-competitor language.",
            buyerLine: "[legal] We want a clause permitting us to evaluate parallel vendors during the term without contract penalty.",
            candidates: [
                PuzzleCandidate(text: "That's fine as a stated business right — we'd just add a 30-day notice obligation before any active competitor evaluation begins. Symmetric process clarity, for both sides.", eval: 0.7, rationale: "The right to evaluate exists whether or not it's written down. Grant the clause, add 30 days' notice, and you've bought yourself reaction time for the price of ink.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "We can't include that — the standard MSA governs.", eval: -0.4, rationale: "Refusing to write down a right they already hold signals insecurity, not strength. The clause was cheap; the message you just sent wasn't.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Absolutely — we'll add it as written. Honestly, we read it as a vote of confidence: you've told us you intend to standardize on the platform, and if you ever do run an evaluation, that's exactly the signal our customer-success team should be hearing and managing anyway.", eval: -0.3, rationale: "Unscoped, that clause is permission to run silent parallel pilots. You reframed a threat as a compliment — and gave away your reaction time to do it.", atlasTags: ["reciprocity", "liking"]),
                PuzzleCandidate(text: "What if we took something off the price to drop the clause?", eval: -0.6, rationale: "Paying to remove the clause tells them it terrifies you — which prices it for them. It comes back at renewal with a number attached.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p087", theme: .endgame, difficulty: 2000,
            buyerRole: "Last-minute exec change midway through endgame paperwork",
            setup: "Verbal commit. CFO who approved leaves the company. New CFO inherits.",
            buyerLine: "[champion] New CFO wants to re-review before signing. Adds two weeks minimum.",
            candidates: [
                PuzzleCandidate(text: "Makes sense — a new CFO should absolutely look at this. Let me package it decision-ready: the full memo, named peer references, and the rationale the prior CFO approved on, so the review is a confirmation rather than a restart.", eval: 0.8, rationale: "An inherited executive is a net-new buyer wearing an old approval. Hand them a decision-ready memo that carries the prior rationale forward and you shrink the review — and the odds it becomes a re-decision.", atlasTags: ["reciprocity", "social-proof"]),
                PuzzleCandidate(text: "Any way to get signature in before the new CFO settles in?", eval: -0.8, rationale: "Racing the new CFO's review reads as exactly what it is: bad faith. Even if you win the race, you lose the post-purchase relationship you have to live in.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "Of course — we'll stand down completely while the new CFO gets up to speed: no outreach from our side, the close plan stays exactly as drafted, and if any questions come out of the transition, surface them whenever the timing works for you.", eval: -0.5, rationale: "Standing down feels respectful and costs you the deal. Inherited-CFO transitions reverse a frightening share of pre-approved decisions when nobody re-positions.", atlasTags: ["silence"]),
                PuzzleCandidate(text: "Would a discount help smooth the transition?", eval: -0.6, rationale: "Discounting to a buyer you haven't even met teaches them — before their first conversation with you — that your price is soft. The cap only moves down from here.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0,
            themeHint: "Inherited executives at endgame are net-new buyers. Re-positioning beats waiting.",
            transcriptId: "voss-haiti-how"
        ),

        // ─── Cold open batch 2 ──────────────────────────────────────────
        Puzzle(
            id: "p088", theme: .coldOpen, difficulty: 1300,
            buyerRole: "First-time intro Zoom, founder, expecting a pitch",
            setup: "First Zoom. Founder accepted via warm intro. Opens skeptical.",
            buyerLine: "Okay, so what does this thing do?",
            candidates: [
                PuzzleCandidate(text: "Before I answer that — which of these two is more painful at your company right now: [problem one] or [problem two]? Then I can show you exactly what we do about the one that actually hurts.", eval: 0.7, rationale: "A skeptical founder reads a diagnosis-first open as homework done and time respected. You flipped a pitch request into fit-discovery — the frame you actually want.", atlasTags: ["calibrated-question", "alternative-choice"]),
                PuzzleCandidate(text: "So, we're a platform that...", eval: -0.4, rationale: "Pitching into skepticism feeds the skepticism. The founder asked what it does; a generic monologue tells them what you are — another vendor.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "One of our customers, [X], told us we save them 30 hours a week.", eval: 0.0, rationale: "Works only if the named customer maps tightly to this founder's world. Otherwise it registers as marketing — heard, discounted, forgotten.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "If I can show you it works, would you buy it?", eval: -0.7, rationale: "A trial close in minute one smells like a sales course. The founder files you under low-credibility before you finish the sentence.", atlasTags: ["trial-close"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p089", theme: .coldOpen, difficulty: 1500,
            buyerRole: "VP Engineering, cold reply via referral",
            setup: "Cold email mentioning a specific shared peer. VP replied with a three-word question.",
            buyerLine: "What's the differentiator?",
            candidates: [
                PuzzleCandidate(text: "We deploy inside your VPC, not ours — same integration surface, about a tenth of the ops overhead.", eval: 0.7, rationale: "A three-word question earns a one-sentence answer. One concrete, checkable, stack-specific fact proves you know their world — that's what earns the reply.", atlasTags: ["concrete-construal"]),
                PuzzleCandidate(text: "Good question — before I answer, which dimension matters most for your stack: deployment, integrations, or cost?", eval: 0.2, rationale: "You answered a direct factual question with a question, and a VP of Engineering reads that deflection in one line. This is the calibrated question's own contraindication.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "I'll send a three-column comparison against the two vendors you're probably weighing — advantage rows bolded so you can scan it in a minute.", eval: -0.3, rationale: "A comparison grid claims everything and therefore proves nothing to an engineer. It's marketing-shaped, and the question was engineering-shaped.", atlasTags: ["contrast"]),
                PuzzleCandidate(text: "You know [the referrer] — after his team switched, they shipped their event pipeline in six weeks. Happy to walk you through what changed; the differentiator is inside that story.", eval: 0.1, rationale: "The warm thread is real, but the question was technical. Story-first reads as dodging the spec — the peer belongs one message later, as evidence.", atlasTags: ["social-proof"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "belfort-aerotyne"
        ),

        Puzzle(
            id: "p090", theme: .coldOpen, difficulty: 1400,
            buyerRole: "Cold outreach reply from a Director, skeptical tone",
            setup: "Cold outreach via LinkedIn. Director replied with one sentence.",
            buyerLine: "We already have a vendor for this. What's different?",
            candidates: [
                PuzzleCandidate(text: "Which one are you on — [vendor A] or [vendor B]? And what's the one outcome it isn't delivering yet? I'd rather answer 'what's different' against that than in the abstract.", eval: 0.7, rationale: "'We already have a vendor' is the discovery surface, not the wall. Get the vendor and the gap, and 'what's different' becomes a fit conversation instead of a brochure.", atlasTags: ["calibrated-question", "contrast"]),
                PuzzleCandidate(text: "Three things set us apart: speed, accuracy, and price.", eval: -0.4, rationale: "A generic differentiator list, with no gap surfaced, just reminds the Director how expensive switching is. You argued for the incumbent.", atlasTags: ["contrast"]),
                PuzzleCandidate(text: "How about a two-week parallel evaluation on one workflow, using your own data, with your current vendor as the baseline to beat? I'll pre-build the comparison scorecard so all the lift stays on our side of the table.", eval: -0.3, rationale: "You asked for asymmetric commitment before earning any interest. An eval offer this early reads as presumptuous, not confident.", atlasTags: ["puppy-dog", "contrast"]),
                PuzzleCandidate(text: "Honestly, that vendor has a rough reputation.", eval: -1.0, rationale: "Trash the vendor and you trash the person who chose them. The Director hears an insult to their own judgment — and archives you.", atlasTags: ["contrast"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-prize-frame"
        ),

        Puzzle(
            id: "p091", theme: .coldOpen, difficulty: 1600,
            buyerRole: "Cold outreach to a CFO, terse reply",
            setup: "Cold email with specific revenue impact claim. CFO replied within an hour.",
            buyerLine: "Send me the math. 15 minutes.",
            candidates: [
                PuzzleCandidate(text: "Here it is on one page: three assumptions, all specified, a named peer in your revenue band, and a single payback number. If the math holds up for you, my calendar link is at the bottom.", eval: 0.8, rationale: "A CFO who says '15 minutes' is telling you the format. One page, three assumptions, one payback number — specificity in their language is what converts here.", atlasTags: ["concrete-construal", "social-proof"]),
                PuzzleCandidate(text: "Sending our full deck — the math's inside.", eval: -0.6, rationale: "Twelve slides into a 15-minute frame is a filing instruction. The CFO archives it unread — and remembers you can't follow directions.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "Rather than email the math, could we take the 15 minutes live and walk it together?", eval: -0.3, rationale: "They asked for math and you asked for a meeting. The pivot says you're not comfortable with your own numbers.", atlasTags: ["fitd"]),
                PuzzleCandidate(text: "Here's our ROI calculator, pre-loaded with industry-average assumptions for your vertical — every input cell is unlocked so your finance team can stress-test the model, and there's a methodology note covering where each default comes from.", eval: -0.4, rationale: "Industry-average assumptions don't survive CFO scrutiny — the first default they disagree with kills the whole model. No named peer, no credibility.", atlasTags: ["gain-framing"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "tracy-money-reframe"
        ),

        Puzzle(
            id: "p092", theme: .coldOpen, difficulty: 1500,
            buyerRole: "Cold call interception, gatekeeper administrative assistant",
            setup: "Cold call to a target executive. Reached the executive assistant.",
            buyerLine: "What's this regarding? She's in back-to-back meetings.",
            candidates: [
                PuzzleCandidate(text: "You'd know best how to route this — it's about the international expansion she announced last month. Would she rather get a short email with the context from you, so you can vet it first, or would a 30-second call with me be easier to pass along?", eval: 0.7, rationale: "Assistants aren't obstacles — they're routers with judgment. Give a specific reason tied to the executive's actual priority and let them choose the path; you made their job easier, and they remember who does that.", atlasTags: ["alternative-choice", "liking"]),
                PuzzleCandidate(text: "I really do need a few minutes with her live — it's time-sensitive. Rather than leave a message, is there any way you could get me a transfer today?", eval: -0.7, rationale: "Pressure on a gatekeeper buys you one bad transfer at most and a permanent flag at worst. This person controls your access for years.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "Just following up on something with her.", eval: -0.5, rationale: "'Following up' is the phrase that routes straight to voicemail. Vague answers make the assistant's decision easy — against you.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "She and I have spoken before — she'll know what it's about.", eval: -1.1, rationale: "The lie works until it's checked, and assistants check. When it surfaces, you're finished in that building permanently.", atlasTags: ["liking"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "belfort-aerotyne"
        ),

        Puzzle(
            id: "p093", theme: .coldOpen, difficulty: 1700,
            buyerRole: "Cold reply from a CRO, single-line skepticism",
            setup: "Cold email with peer-outcome anchor. CRO replied within hours.",
            buyerLine: "I've heard this pitch before. What's actually different?",
            candidates: [
                PuzzleCandidate(text: "Fair — you've heard the category pitch. What you haven't heard: we staff customer success at one-to-eight instead of the usual one-to-forty, and that's why [named peer] renewed at three times the original contract. That part doesn't fit on a slide.", eval: 0.7, rationale: "A CRO has heard the category pitch dozens of times. The operational facts that don't fit on a slide — staffing ratios, deployment depth, one named peer's specific outcome — are what earn conversation two.", atlasTags: ["concrete-construal", "social-proof"]),
                PuzzleCandidate(text: "I hear that a lot — but honestly, the pitch is the pitch because it works.", eval: -0.6, rationale: "Repeating the pitch with more conviction confirms the complaint. You just became the ordinary they accused you of being.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "Easier shown than told — got 20 minutes for a demo?", eval: -0.2, rationale: "A demo without answering what's-different wastes the opening — they asked a question and you offered a show. Recoverable, but you spent the moment.", atlasTags: ["concrete-construal"]),
                PuzzleCandidate(text: "What would it take to get a discovery call on your calendar?", eval: -0.3, rationale: "Trial-closing before answering tells the CRO you want the meeting more than they need the answer. That asymmetry kills cold replies.", atlasTags: ["trial-close"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-prize-frame"
        ),

        Puzzle(
            id: "p094", theme: .coldOpen, difficulty: 1400,
            buyerRole: "Cold outreach reply, Operations Director, neutral tone",
            setup: "Cold LinkedIn message. Director replied a week later.",
            buyerLine: "Possibly relevant. Send me more info.",
            candidates: [
                PuzzleCandidate(text: "Attached is one page I built for your function specifically — three peer outcomes at named companies are inside. No meeting ask attached; if it's relevant, you'll know what to do with it.", eval: 0.6, rationale: "'Send me more info' is a low-effort probe, and asymmetric work converts it. A page that cost you an hour and costs them ninety seconds creates pull — and withholding the ask is exactly what makes it read as a gift.", atlasTags: ["reciprocity", "social-proof"]),
                PuzzleCandidate(text: "Happy to — two quick questions first so I can send something actually scoped to your function: what does your current stack look like, and where does the process break down most often today? I'll build the material around your answers.", eval: 0.3, rationale: "Discovery-before-delivery is your trained reflex, and here it taxes a lukewarm stranger with homework before any value has landed. The questions belong inside the artifact, not in front of it.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Here's our full deck — the platform story is best end to end.", eval: -0.3, rationale: "Volume isn't tailoring. Twelve slides into a 'possibly relevant' is how you get archived.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "Here's my calendar — I held two times this week.", eval: -0.5, rationale: "You converted a maybe into a demand. They signaled reading interest, not meeting intent — the calendar-first move misreads the temperature by a full stage.", atlasTags: ["assumptive"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-live-label"
        ),

        Puzzle(
            id: "p095", theme: .coldOpen, difficulty: 1800,
            buyerRole: "Cold event-conversation with a senior executive",
            setup: "Conference. Senior executive in the hallway, scanning for an exit.",
            buyerLine: "[two-second window before exit]",
            candidates: [
                PuzzleCandidate(text: "Thirty seconds: we cut [named peer]'s onboarding time forty percent — is that a problem your team has too?", eval: 0.7, rationale: "The hallway gives you one sentence before the exit. Named peer, specific outcome, and a question that invites them to claim the problem — the highest-information shape that fits the window.", atlasTags: ["social-proof", "concrete-construal"]),
                PuzzleCandidate(text: "Got two minutes? So, we're a platform that—", eval: -1.0, rationale: "You asked for two minutes you don't have. The executive was already scanning for the door; now they've found it.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "Loved your talk — especially the point about consolidating the data stack. You know [shared contact], right? I'd love to pick that exact thread back up with you sometime this week if you're around.", eval: -0.3, rationale: "A compliment burns the window without landing your value. Pleasant, remembered for zero minutes — and the follow-up ask arrives with nothing attached.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Here's my card — great meeting you, let's connect.", eval: -0.4, rationale: "The card goes in a pocket and the pocket goes to the dry cleaner. Contact without context converts at roughly zero.", atlasTags: ["reciprocity"]),
            ],
            bestIndex: 0,
            themeHint: "Hallway windows are tight. Named-peer + outcome + invitation-question is the highest-information shape.",
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p096", theme: .coldOpen, difficulty: 1600,
            buyerRole: "Cold reply from a Procurement specialist, no business engagement yet",
            setup: "Cold email reached procurement instead of the business team. Procurement replied first.",
            buyerLine: "If you want to engage with us, please complete the RFI in our vendor portal first.",
            candidates: [
                PuzzleCandidate(text: "Absolutely — we'll get the RFI completed promptly. One quick question so we answer it well: who on the business side owns this use case day to day? It'd help us write to the actual workflow.", eval: 0.6, rationale: "Procurement respects vendors who follow the process — so follow it, and use one polite question to locate the business owner. You honored the gate and found the user without going around anyone.", atlasTags: ["calibrated-question", "liking"]),
                PuzzleCandidate(text: "We'll pass on the portal for now and reach the business team directly.", eval: -0.7, rationale: "Bypass the portal and you get flagged in it. Procurement's memory is long and their systems are longer — future access dies with this move.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "We'll complete the RFI in full — every section answered at depth, the differentiated capabilities front-loaded in the executive summary, submitted two days ahead of your deadline — and in the transmittal note we'd welcome any guidance on evaluation criteria and scoring weights.", eval: 0.0, rationale: "Compliant but slow. A flawless RFI with no business pull sits in the queue indefinitely — procurement processes paper; it doesn't champion deals.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Could you intro me to the business team first?", eval: -0.4, rationale: "Asking procurement to speed you past their own gate tells them you don't respect the role. You needed them neutral — now they're not.", atlasTags: ["scarcity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "klaff-time-reversal"
        ),

        Puzzle(
            id: "p097", theme: .coldOpen, difficulty: 1500,
            buyerRole: "First-touch from a warm-intro champion's peer, indirect skepticism",
            setup: "Champion intro'd operator to her peer VP. Peer expresses skepticism on intro call.",
            buyerLine: "[champion's peer] She's enthusiastic, but I don't see the same problem on my side. Convince me.",
            candidates: [
                PuzzleCandidate(text: "I'd rather not convince you of a problem you don't have. What's the biggest operational drag in your function right now? If we map to it, I'll show you exactly how — and if we don't, I'll be the first to say so.", eval: 0.7, rationale: "'Convince me' is an invitation to overreach — decline it. Diagnose first, and be willing to say 'we may not fit'; the honest no is what earns the peer's trust and the second conversation.", atlasTags: ["calibrated-question", "takeaway"]),
                PuzzleCandidate(text: "Happy to — here's why this matters on your side too.", eval: -0.5, rationale: "You accepted the defensive frame. Now every claim you make is testimony under cross-examination — and skeptics grade testimony harshly.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "Well, she's seen the impact firsthand — that should count for something.", eval: -0.3, rationale: "The peer already knows the champion is enthusiastic — that's why you're on the call. Re-citing it adds no information and spends her credibility on your behalf.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Let's set up a proper discovery session later.", eval: 0.2, rationale: "Acceptable, but you just parked the live moment. The function-specific drag was askable right now — and later has a way of becoming never.", atlasTags: ["mutual-close-plan"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p098", theme: .coldOpen, difficulty: 1700,
            buyerRole: "Cold reply from a category-skeptic, pointed first message",
            setup: "Cold email. Recipient is publicly skeptical of the operator's category.",
            buyerLine: "I don't believe in this category. You'll have to convince me it's not snake oil.",
            candidates: [
                PuzzleCandidate(text: "I've read your piece on this — your core objection is that the results don't survive scale. Let me answer that one point mechanically, because I won't defend the category as a whole; most of it has earned your skepticism.", eval: 0.7, rationale: "A category skeptic respects the vendor who engages their specific objection instead of defending the abstraction. A mechanistic answer to the named objection — plus conceding the category's sins — earns conversation two.", atlasTags: ["labeling", "concrete-construal"]),
                PuzzleCandidate(text: "The category is real — the industry results speak for themselves.", eval: -0.5, rationale: "Broad category defense is exactly the snake oil they described. You confirmed their thesis in one sentence.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "Three companies at your scale run on us — [logo one], [logo two], and [logo three] — with 96% retention across the cohort. I'd be glad to set up a call with the closest peer so you hear the case from a buyer instead of a vendor.", eval: -0.3, rationale: "Aggregate adoption is the standard category claim — the skeptic discounted it before you hit send. Logos answer a question they didn't ask.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Sounds like we're not a fit — all good.", eval: -0.4, rationale: "You folded a winnable hand. Skeptics convert at surprising rates when their actual objection gets engaged — most have never seen a vendor do it.", atlasTags: ["takeaway"]),
            ],
            bestIndex: 0,
            themeHint: "Engage the specific objection, not the abstraction.",
            transcriptId: "voss-accusation-audit"
        ),

        Puzzle(
            id: "p099", theme: .coldOpen, difficulty: 1400,
            buyerRole: "Cold call interception, prospect picks up unexpectedly",
            setup: "Cold call. Prospect answered directly. Sounds rushed.",
            buyerLine: "Yeah, hi. What is this?",
            candidates: [
                PuzzleCandidate(text: "Thirty seconds and you decide: [named peer] cut invoice processing in half with us — worth continuing right now, or should I grab ten minutes on your calendar instead?", eval: 0.7, rationale: "A rushed tone is a time budget, and thirty seconds with a two-path exit respects it. Whichever path they pick, you kept your credibility — and delivered one concrete outcome that earns the next step.", atlasTags: ["social-proof", "alternative-choice"]),
                PuzzleCandidate(text: "Great! So let me tell you about our platform —", eval: -0.7, rationale: "A two-minute pitch into a rushed hello ends in a dial tone. You heard the constraint and ignored it.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "Sounds hectic — could I book 15 minutes later this week?", eval: 0.1, rationale: "Polite, but you spent the live moment asking for a future one — without giving a single reason the meeting is worth having.", atlasTags: ["fitd"]),
                PuzzleCandidate(text: "Sorry to catch you off guard — I'll try you again tomorrow.", eval: -0.3, rationale: "You apologized for reaching the person you called. Tomorrow's call rarely happens — the live moment was the asset, and you handed it back.", atlasTags: ["liking"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "belfort-aerotyne"
        ),

        Puzzle(
            id: "p100", theme: .coldOpen, difficulty: 2000,
            buyerRole: "First-touch with a high-persuasion-knowledge senior executive",
            setup: "Cold email with named-peer-and-outcome anchor. Senior executive (board director, ex-VC) replied with one pointed sentence.",
            buyerLine: "Your peer outcome citation doesn't match the public data I've seen on that company. Care to explain?",
            candidates: [
                PuzzleCandidate(text: "You're right to flag it. That number is Year-1, post-implementation, in a single business unit — not company-wide — and I'll send you the granular reference. If our framing implied more than that, that's on us.", eval: 0.8, rationale: "The executive just tested your data integrity — that's the whole email. Scope the claim precisely and concede whatever the framing overstated; with a high-persuasion-knowledge buyer, the honest concession is worth more than the citation ever was.", atlasTags: ["labeling", "concrete-construal"]),
                PuzzleCandidate(text: "The citation is accurate — we stand by it.", eval: -1.0, rationale: "Defending a number a board director flagged against public data is credibility suicide. Even if you're technically right, you chose defense over rigor in front of someone who tests for exactly that.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "That one may be a data-vintage issue — let me point you to a cleaner example instead: [different peer] published their results last quarter, they're honestly a closer comparable to your business anyway, and I think you'll find their numbers stand up to any diligence you'd want to run.", eval: -0.5, rationale: "Swapping in a fresh logo while the flagged one slides quietly out of the thread — an ex-VC sees that move instantly. You just answered an integrity question with an evasion.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Understood — please disregard that citation entirely.", eval: -0.4, rationale: "Retracting without explaining reads as evasion: was it wrong, or just inconvenient? You left the doubt standing and the question open.", atlasTags: ["silence"]),
            ],
            bestIndex: 0,
            themeHint: "High-PK executives test data integrity. Specific scoping + honest concession converts; defense destroys.",
            transcriptId: "voss-accusation-audit"
        ),

        // ─── Panel batch (7): upfront-contract cold opens + renewal saves ──
        Puzzle(
            id: "p101", theme: .coldOpen, difficulty: 1500,
            buyerRole: "SVP Operations, enterprise; took the meeting as a favor",
            setup: "Cold-sourced meeting an internal contact pushed onto the SVP's calendar. She joins two minutes late, camera off.",
            buyerLine: "You've got fifteen minutes. Go.",
            candidates: [
                PuzzleCandidate(text: "Let's spend them well, then — ten minutes on the one problem I think you have, and at minute twelve you tell me straight whether this is dead or worth a real meeting.", eval: 0.7, rationale: "You set the contract before spending the clock: what the call is for, how long it runs, and what a yes or a no looks like at the end. The reluctant exec relaxes because you handed her the exit — and a named exit is what turns fifteen grudging minutes into an actual decision instead of a polite run-out.", atlasTags: ["upfront-contract", "mutual-close-plan", "calibrated-question"]),
                PuzzleCandidate(text: "Before I touch your fifteen minutes — what made you take this meeting at all? I'd rather spend the time on whatever that was than on my standard opening.", eval: 0.3, rationale: "Good instinct, half a move. The question earns relevance, but the call still has no agreed shape — she can pull the ripcord at any minute because you never named what the fifteen minutes are for or how they end.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "I'll be fast, then. Three things: who we are, the two outcomes we drove for a company in your space last year, and the one number their COO cared about. Stop me anywhere.", eval: -0.5, rationale: "The time-respect reflex: talk faster. Compressing a pitch into a reluctant window is still pitching at someone who never agreed to be pitched — she runs out the clock politely and you leave with nothing decided.", atlasTags: ["gain-framing", "social-proof"]),
                PuzzleCandidate(text: "I promise not to run over. Before we dive in, though — I saw the expansion announcement last week, congratulations, that has to feel great. How's the integration been landing on your side so far?", eval: -0.8, rationale: "Warm-up small talk is a status move pointed the wrong way. Execs grant rapport after relevance, not before — you just spent ninety seconds of a fifteen-minute favor proving the meeting was skippable.", atlasTags: ["liking"]),
            ],
            bestIndex: 0,
            themeHint: "Before you spend a reluctant clock, agree what it buys.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p102", theme: .coldOpen, difficulty: 1700,
            buyerRole: "Head of RevOps, mid-market; inbound demo request",
            setup: "Inbound form fill asking for 'a quick demo.' On the call, he has a spreadsheet open and two competitor tabs visible.",
            buyerLine: "We're evaluating a few tools this week. Just run me through the demo and send pricing after — we're mostly there on requirements.",
            candidates: [
                PuzzleCandidate(text: "Happy to demo, and I'll give you pricing up front so we're not dancing around it — but first, can we agree what this demo has to show for us to earn a real next step, so you're not just filling in a column?", eval: 0.7, rationale: "You called the fish without calling it a fish. Price up front kills the evasion game, and the agreed bar — what the demo must prove to earn a next step — converts a comparison-shopper into someone who just handed you the buying criteria. And if he won't agree to a bar, you learned that for free too.", atlasTags: ["upfront-contract", "calibrated-question", "mutual-close-plan"]),
                PuzzleCandidate(text: "I'd rather hold pricing until you've seen the value — numbers without context always look expensive. Let me walk you through the product first and we'll get to cost at the end if it resonates.", eval: -0.5, rationale: "The value-before-price reflex, and he's heard it from every vendor this week. To a buyer who asked for the number, withholding it reads as 'it's expensive' — you confirmed his suspicion and taught him nothing else.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "Sure, let's dive straight in. I'll run the standard thirty-minute walkthrough, you flag anything that matters for your evaluation, and the full pricing sheet will be in your inbox before end of day.", eval: -0.3, rationale: "Maximum compliance, zero information. You ran the demo he asked for, he filled in his column, and your pricing sheet lands in a spreadsheet where the cheapest row wins.", atlasTags: ["puppy-dog"]),
                PuzzleCandidate(text: "Before any demo — walk me through budget, who signs, and the timeline you're working against. I want to be sure we're actually a fit before either of us spends thirty minutes on features.", eval: 0.2, rationale: "Right worry, wrong instrument. BANT-gating an inbound reads as a bouncer at the door — and everything you'd interrogate for surfaces anyway the moment he agrees on what the demo has to prove.", atlasTags: ["calibrated-question"]),
            ],
            bestIndex: 0,
            themeHint: "An inbound asking for a demo is asking for a row in a spreadsheet — negotiate what the row means first.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p103", theme: .coldOpen, difficulty: 1400,
            buyerRole: "VP Marketing, Series B; warm referral from her former colleague",
            setup: "Your customer Dana intro'd you to her old teammate. The VP joined cheerful, no agenda, coffee in hand.",
            buyerLine: "So — Dana says you two are doing great work together. What have you got for me?",
            candidates: [
                PuzzleCandidate(text: "One suggestion first: ten minutes on what's slowing your team down, then I'll say straight whether we're relevant — and we book a real meeting only if we both want one.", eval: 0.6, rationale: "You gave the friendly, agenda-less call the one thing it was missing: a destination. Ten minutes, an honest verdict, and a mutual gate on the next step — Dana's name never gets spent on a pitch, and 'only if we both want one' is what makes your eventual recommendation credible.", atlasTags: ["upfront-contract", "mutual-close-plan", "calibrated-question"]),
                PuzzleCandidate(text: "Before anything from my side — tell me about your team's setup right now. What's the stack, where does the data live, and where does the reporting actually hurt day to day at the moment?", eval: 0.4, rationale: "The right question a step too early. Without an agreed shape, good discovery becomes pleasant conversation — you'll learn the stack, the call will end warmly, and nobody will know what was decided because nothing was.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Honestly, the best answer is whatever Dana already told you — she's seen it up close for a year. I can walk you through exactly what her team runs with us, and you can judge how much of it maps over to yours.", eval: -0.3, rationale: "Dana's endorsement already happened — it's why she's on the call. Re-citing it adds no new information and quietly tells her you have nothing of your own to say.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Well — Dana's team cut their reporting time roughly in half last quarter, and the short version is we do the same thing for marketing teams your size. Let me walk you through how the pieces fit together.", eval: -0.6, rationale: "Warmth is not permission. She asked a polite question, not for a pitch, and leading with Dana's numbers turns a fresh relationship into a re-run of someone else's — the cheerful referral call that never converts.", atlasTags: ["gain-framing", "social-proof"]),
            ],
            bestIndex: 0,
            themeHint: "A warm intro buys you the meeting, not the agenda — set one, or the warmth is all you leave with.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p104", theme: .renewal, difficulty: 1600,
            buyerRole: "VP Customer Experience, mid-market; landed account, month seven",
            setup: "Landed 40 seats seven months ago. Usage data: the analytics module has sat at its seat cap for six weeks, and two adjacent teams have requested access. Renewal is five months out. Quarterly check-in call.",
            buyerLine: "Team's happy, numbers look good. Let's keep everything steady and just revisit it all at renewal in the spring.",
            candidates: [
                PuzzleCandidate(text: "Steady works for me — one flag, though: you've been capped on analytics for six weeks now and two teams are waiting on access. Want me to scope unblocking them today, rather than making them wait for spring?", eval: 0.7, rationale: "You timed expansion off the usage signal, which is the entire land-and-expand playbook: a capped module plus waiting teams is live demand, today. Raise it now and it's an access problem you're solving; park it until spring and the same demand gets netted against your renewal price by procurement.", atlasTags: ["concrete-construal", "gain-framing"]),
                PuzzleCandidate(text: "That's exactly what I like to hear. I'll put time on our calendars for early spring so we get ahead of the renewal properly, and we can look at seats, pricing, and any adjustments all in one clean conversation then.", eval: -0.4, rationale: "The keep-the-happy-account-happy reflex. Filing live demand under 'renewal business' converts your best expansion moment into a spring bargaining chip — and hands the buyer five months to discover the waiting teams managed fine without you.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Happy to hear it. While I have you — how are you thinking about next year? Anything changing on the team side that I should be planning around when we get to the renewal conversation?", eval: 0.3, rationale: "Pleasant, and it leaves the one hard fact in your pocket. The seat cap and the waiting teams never make it onto the table, so the demand cools — or finds a workaround — long before spring.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Actually, this feels like the moment to think bigger — let me bring our engineer next time and walk you through the full enterprise platform, multi-year pricing included.", eval: -0.7, rationale: "The signal said two teams want access; you pitched a re-platform. Overshooting a specific, scoped demand with an enterprise motion makes the easy yes disappear inside a big-ticket no.", atlasTags: ["extreme-anchor", "gain-framing"]),
            ],
            bestIndex: 0,
            themeHint: "Expansion has a clock, and it's set by usage — not by the renewal date.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p105", theme: .renewal, difficulty: 1800,
            buyerRole: "Director of Operations, mid-market; renewal in 60 days",
            setup: "Renewal in 60 days. Email this morning: they want to drop from 100 seats to 60. Weekly active usage has been sliding since March. You called; she picked up.",
            buyerLine: "Nothing's wrong — honestly it's just budget tidying across every vendor. Can you send over updated pricing for sixty seats?",
            candidates: [
                PuzzleCandidate(text: "I'll send it today — that's the easy part. But usage has been sliding since March, and now a forty-percent cut. Level with me: what actually changed?", eval: 0.8, rationale: "You read the tell. A downsell is almost never a pricing event — it's the last stop before churn, and 'budget tidying' on top of three months of sliding usage is the pattern. Agreeing to send pricing keeps her safe; the direct question is what buys you sixty days to fix whatever actually broke.", atlasTags: ["labeling", "calibrated-question"]),
                PuzzleCandidate(text: "Of course. Separately — it's been a while since I caught up with Sam on the exec side. I'd love to hear how the broader team is thinking about the platform going into next year's planning.", eval: 0.2, rationale: "Right instinct filed under the wrong urgency. Going wide to the exec sponsor before you've diagnosed the Director burns your one honest source — she told you a cover story, and your next move told her you didn't believe it enough to ask her.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Absolutely, no problem at all. I'll have sixty-seat pricing in your inbox within the hour, and I'll make sure the seat transition is completely painless on your side — nobody loses any saved work.", eval: -0.6, rationale: "Frictionless surrender. You priced the exit ramp and called it customer service — the account that renews at sixty seats in spring churns at zero the year after, the usage slide that caused it still unexamined.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Before you cut seats — what if I could get you all one hundred at close to the sixty-seat price? Let me see what I can get approved if we can wrap this up inside the month.", eval: -0.9, rationale: "You negotiated the price of a problem nobody named. Discounting into a churn tell buys back seats nobody is using, teaches her that cuts produce discounts, and leaves whatever broke in March fully intact.", atlasTags: ["sharp-angle", "scarcity"]),
            ],
            bestIndex: 0,
            themeHint: "A downsell request is a churn forecast wearing a budget costume.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p107", theme: .renewal, difficulty: 1400,
            buyerRole: "Operations Manager, SMB; renewal 90 days out",
            setup: "SMB account, renewal in 90 days. The company has grown headcount roughly 30% since signing, and your admin panel shows steady logins from more names than they have licenses. Casual monthly check-in.",
            buyerLine: "All good on our end — I guess we'll just sort everything out at the renewal, right?",
            candidates: [
                PuzzleCandidate(text: "We can — though you've hired a lot since we signed, and I can see more people logging in than you've got seats. Want to true that up now, so renewal day itself stays boring?", eval: 0.7, rationale: "You raised seat growth while it's still an operations chat, not a negotiation. Ninety days out, a true-up is housekeeping he can wave through; inside the renewal it's a surprise line item that sours the whole table. Naming the shared logins plainly — no threat attached — is what keeps it friendly.", atlasTags: ["concrete-construal", "mutual-close-plan"]),
                PuzzleCandidate(text: "Right, that's the standard way to do it. I'll send a calendar hold for about three weeks out from the date, and we'll walk through everything together then — usage, seats, pricing, the whole picture in one go.", eval: -0.5, rationale: "Bundling growth into the renewal feels tidy and plays badly: the true-up arrives as a price increase inside a price negotiation, and the goodwill you're enjoying today is exactly what it costs.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "One thing I do have to raise: we're seeing shared logins on your account, which sits outside the license terms. I'd rather we sort it out together than have our compliance process pick it up.", eval: -1.0, rationale: "You turned your best growth signal into a policing moment. Compliance language aimed at an SMB that simply out-hired its contract converts a happy over-user into a defensive negotiator — ninety days before you need him friendly.", atlasTags: ["authority", "loss-framing"]),
                PuzzleCandidate(text: "Glad it's all smooth. How's the hiring wave been landing, by the way — are the newer folks getting set up in the tool okay?", eval: 0.3, rationale: "Warm, and it walks right past the fact you already have. You don't need to ask how the new hires are doing in the tool — the login data told you. The conversation stays pleasant and the seat gap stays invisible until renewal.", atlasTags: ["calibrated-question"]),
            ],
            bestIndex: 0,
            themeHint: "Over-usage is good news — bill it as growth before renewal reprices it as a dispute.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p108", theme: .renewal, difficulty: 1900,
            buyerRole: "Newly promoted VP, your champion of two years; renewal six months out",
            setup: "Your champion was just promoted to VP over three additional teams, none of which use your product. She's in week two of the new role. Renewal is six months out. You called to congratulate her.",
            buyerLine: "Thank you! It's total chaos over here — let's catch up properly once I've got my feet under me, maybe next quarter.",
            candidates: [
                PuzzleCandidate(text: "Take the quarter. One offer before I go: I'll map what your new teams still do by hand that yours automated, so your ninety-day plan has an easy win in it. Twenty minutes, whenever you want it.", eval: 0.7, rationale: "You read the promotion as the expansion trigger it is — a champion who just inherited three manual teams is assembling her ninety-day agenda right now — and you pitched it as her win, not your deal. A gift-shaped offer with the timing left in her hands is the only expansion move a buried week-two exec can say yes to.", atlasTags: ["reciprocity", "gain-framing"]),
                PuzzleCandidate(text: "Completely understood — new-role chaos is real. I'll drop a placeholder on our calendars for early next quarter, and in the meantime don't hesitate to reach out if anything at all comes up on the platform side.", eval: -0.4, rationale: "Politeness with a cost. New execs set their ninety-day agenda in the first few weeks — by next quarter hers is written, the budget map drawn, and your expansion case is competing with commitments she's already made publicly.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Congrats again — and no action needed from you at all. I'll just reach out to a couple of leads on your new teams directly and start learning their workflows, so we're ready whenever you are.", eval: -0.2, rationale: "'No action needed' is doing a lot of work there. Threading into her new teams without her blessing — in the exact weeks she's establishing authority over them — risks the champion relationship at its most valuable moment. Multi-thread later, with her, not around her.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Congratulations — and honestly the timing is perfect: you now run three teams doing manually what yours automated. Let me send an expansion proposal over this week while it's fresh.", eval: -0.8, rationale: "Right analysis, ambulance-chasing execution. Pitching a proposal at a buried week-two exec converts your two-year champion into someone managing a vendor — you spent the relationship's best moment proving you see her promotion as your pipeline.", atlasTags: ["assumptive", "scarcity"]),
            ],
            bestIndex: 0,
            themeHint: "A champion's promotion is the loudest expansion trigger there is — serve it as her quick win, or lose the window.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p109", theme: .salesAssist, difficulty: 1500,
            buyerRole: "Engineering lead, Series B startup; free-tier power account, first sales touch ever",
            setup: "PQL outreach. His team has hit the free tier's API rate cap on 14 of the last 20 workdays, and someone shipped a retry wrapper around it. You emailed; he replied with one wary line.",
            buyerLine: "Not looking to get on a sales call. What do you want?",
            candidates: [
                PuzzleCandidate(text: "No call needed. You've hit the rate cap fourteen of the last twenty days and someone built a retry wrapper around it — the paid tier removes that wall. Want the number right here in this thread?", eval: 0.7, rationale: "His usage already did the discovery, so you skipped to the only question left: whether removing a wall his team feels daily is worth a price. Answering in-thread honors the self-serve preference his wariness is broadcasting — a PQL is qualified by behavior, and the winning move is to act like you noticed.", atlasTags: ["concrete-construal", "gain-framing"]),
                PuzzleCandidate(text: "Totally understand, no pressure at all! Would you be open to just fifteen minutes sometime this week so I can learn a bit about your stack and what you're building? No pitch — purely discovery, so I can actually be useful to you.", eval: -0.6, rationale: "Form-fill-era discovery aimed at a product-qualified lead. He's been in the product for months — asking to 'learn about your stack' announces you never looked, and converts a warm usage signal into the cold call he just declined.", atlasTags: ["calibrated-question", "liking"]),
                PuzzleCandidate(text: "Fair enough — quick one, then: how about a personalized demo of the paid tier instead? Twenty minutes on a screen-share, I'll walk the whole workflow end to end, and you'll know exactly what the upgrade looks like.", eval: -0.3, rationale: "A demo of a product he already runs in production. Your walkthrough teaches him nothing his own tenancy hasn't, and it costs him the meeting he opened by refusing — you fired the demo-trap reflex at the one buyer it can't work on.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "Understood — I'll leave you to it. If the free tier ever stops being enough, you know where to find me.", eval: 0.1, rationale: "Graceful, and it walks away from a team that already outgrew the free tier — the retry wrapper is them telling you it stopped being enough weeks ago. A takeaway flushes tire-kickers; this account is the opposite of one.", atlasTags: ["takeaway"]),
            ],
            bestIndex: 0,
            themeHint: "A PQL's usage already answered your discovery questions — open with what you saw, not what you'd like to ask.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p110", theme: .salesAssist, difficulty: 1600,
            buyerRole: "Product manager, mid-market; 14-day team trial ends Friday",
            setup: "Team trial expires Friday. Eleven of twelve invited users are active, 40-plus boards built, the Jira sync is live. The PM emailed this morning.",
            buyerLine: "The team's still evaluating — any chance you can extend the trial another two weeks?",
            candidates: [
                PuzzleCandidate(text: "I can extend it — help me make it count. Eleven of twelve of you are in daily and the Jira sync is live, so: what's still unproven, and who besides you has to see it proven?", eval: 0.7, rationale: "An extension with a purpose. The usage says the team finished evaluating — so 'still evaluating' means something specific is unproven, or someone unnamed hasn't signed off. Tie the two weeks to that answer and you convert free runway into a close plan; grant them blind and you've only moved the same conversation two weeks further away.", atlasTags: ["mutual-close-plan", "calibrated-question"]),
                PuzzleCandidate(text: "Of course — done, you're extended through the end of the month, no strings attached. Take whatever time the team needs to feel completely sure about it.", eval: -0.4, rationale: "Frictionless generosity, and it teaches the account that trials are infinite. A team with eleven daily actives doesn't need more time to be sure — it needs a reason to decide, and you just deleted the only one on the calendar.", atlasTags: ["liking", "puppy-dog"]),
                PuzzleCandidate(text: "I can't extend it, but I can do you one better — get it signed by Friday and I'll take fifteen percent off the first year. That's the best lever I've got.", eval: -0.7, rationale: "You answered a runway question with a countdown and a coupon. Discount pressure on a team that hasn't even asked about price reads as exactly what it is — your quarter, not their decision — and it poisons the real pricing conversation before it starts.", atlasTags: ["scarcity", "sharp-angle"]),
                PuzzleCandidate(text: "Happy to — and to make the extra two weeks really count, want me to run the team through everything you haven't touched yet? There's a lot in the product the trial barely surfaces.", eval: 0.2, rationale: "The demo-trap reflex wearing a helpful hat. Untouched features aren't the blocker — a team this active has seen what it came to see. Another product tour spends your extension delaying the only conversation you actually need: what turns proven usage into a signature.", atlasTags: ["gain-framing"]),
            ],
            bestIndex: 0,
            themeHint: "When usage says the evaluation is over, an extension request is about something unproven or someone unnamed.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p111", theme: .salesAssist, difficulty: 1800,
            buyerRole: "Staff engineer, enterprise; organic champion of a 40-user footprint",
            setup: "Bottom-up adoption: 40 engineers across three squads on self-serve, expensed monthly. IT flagged the spend, and now a security review plus procurement stand between the tool and an annual contract. Your champion pinged you.",
            buyerLine: "So apparently this has to go through our VP and procurement now. I've never bought software in my life — what do I do?",
            candidates: [
                PuzzleCandidate(text: "You don't have to become a buyer — you have to introduce one. Get me thirty minutes with your VP: you open with what the squads ship on it, I take security and procurement from there.", eval: 0.8, rationale: "He told you his ceiling — he's a user, not a buyer — and the move is to lift the buying weight off him, not coach him to carry it. Joining the VP conversation splits the roles cleanly: his credibility on the work, yours on the process. Forty organic users is the pitch; the paperwork is your job.", atlasTags: ["multi-threading", "mutual-close-plan"]),
                PuzzleCandidate(text: "Step one is a business case. I'll send you a deck template plus ROI numbers built from your team's usage — walk your VP through it, and loop me in whenever procurement starts asking questions.", eval: 0.3, rationale: "Right artifact, wrong carrier. Arming a first-time buyer to run an exec conversation solo is how bottom-up deals stall — he relays your slides badly, the VP's hard questions land on someone who's never fielded them, and you hear about it six weeks later.", atlasTags: ["gain-framing", "concrete-construal"]),
                PuzzleCandidate(text: "Honestly, easiest if I take it from the top — what's your VP's email? I'll reach out directly, reference the team's adoption numbers, and get the procurement ball rolling myself so you're out of it.", eval: -0.8, rationale: "Around your champion in the same breath he asked for help. A cold email to a VP citing usage data she didn't know you had reads as surveillance — and the engineer who built you a forty-user footprint just learned you'll spend him for access.", atlasTags: ["authority", "assumptive"]),
                PuzzleCandidate(text: "Keep doing exactly what you're doing. Forty users and climbing is the loudest business case there is — once it's big enough, the VP comes to you and the deal basically signs itself.", eval: -0.5, rationale: "Bottom-up dogma past its expiry date. Adoption got the tool into the building; it doesn't answer security questionnaires. IT has already flagged the spend — from here, momentum without an exec sponsor doesn't compound, it gets shut off, and you just told your champion to sit and wait for that.", atlasTags: ["social-proof", "silence"]),
            ],
            bestIndex: 0,
            themeHint: "Bottom-up adoption gets you into the building — someone still has to walk it into the VP's office, and it shouldn't be your engineer alone.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p112", theme: .salesAssist, difficulty: 1700,
            buyerRole: "Head of Data, mid-market; three weeks of near-daily usage, booked the call herself",
            setup: "Self-serve signup 22 days ago. Sixty-plus queries run, two dashboards already shared internally. She booked time through the in-app calendar link.",
            buyerLine: "Thanks for making time — can you show me the product? A proper demo, start to finish.",
            candidates: [
                PuzzleCandidate(text: "Gladly — though you've been in it daily for three weeks, so a full tour would waste you. Who's the demo for? If you're showing someone, let's build it on your dashboards, not sample data.", eval: 0.7, rationale: "A power user asking for a 'proper demo' is a tell: the demo isn't for her. There's a boss, a team, or a budget holder she needs to convince — and by naming that, you turned a feature tour into prep for the meeting that actually decides. Her own dashboards are your deck.", atlasTags: ["calibrated-question", "labeling"]),
                PuzzleCandidate(text: "Absolutely. Let me grab my screen — I'll start at the data layer, move through the query builder, then finish on dashboards, sharing, and permissions. Jump in with questions anywhere you like.", eval: -0.6, rationale: "The demo trap, textbook. Three weeks of daily usage already answered everything a walkthrough covers — replaying it on sample data tells her you never looked at her account, and burns the call she booked for a reason she hasn't said yet.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "Before we look at screens — walk me through your team, your current data stack, and the problem you're ultimately trying to solve. I want to make sure we're a fit before we spend time on features.", eval: -0.2, rationale: "Form-fill discovery on someone whose sixty queries already answered it. You'd be interviewing her about facts your own product analytics hand you for free — and she arrived with a specific ask that you've now deferred instead of decoded.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Sure — and to keep it useful I'll skip everything you already use and show only what you haven't touched: the API layer, scheduled reports, and the access controls.", eval: 0.3, rationale: "Smarter than the standard tour — you read the usage — but it answers the literal request instead of the reason behind it. The delta-demo is a strong second move; the first is finding out who the demo is really for.", atlasTags: ["concrete-construal", "gain-framing"]),
            ],
            bestIndex: 0,
            themeHint: "When a three-week power user asks for a demo, the demo has an audience you haven't met yet.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p113", theme: .salesAssist, difficulty: 1500,
            buyerRole: "Founder, eight-person startup; paying self-serve customer, first sales contact",
            setup: "Self-serve customer, $190 a month on a card, eight months of tenure. Your new sales-assist motion flagged the account and you emailed to introduce yourself.",
            buyerLine: "Honestly, being handed a 'dedicated account executive' makes me nervous. Does this mean pricing changes, or that we can't just use the product anymore?",
            candidates: [
                PuzzleCandidate(text: "Nothing changes — same product, same price, the card keeps working, and you may never need me. I exist for what checkout can't do: security reviews, invoicing, volume pricing if you grow. Otherwise, delete this email guilt-free.", eval: 0.6, rationale: "You answered the fear before anything else — that's the whole handoff. A self-serve buyer's nightmare is that a rep's arrival means the product just grew a gate; naming exactly what stays the same, and scoping yourself to jobs self-serve can't do, keeps the motion intact. The best sales-assist intro reads like an opt-in, not a reassignment.", atlasTags: ["accusation-audit", "labeling"]),
                PuzzleCandidate(text: "Not at all — quite the opposite! I'd love to grab twenty minutes to learn about your business and your roadmap, and to explore where we might help you get even more value out of the platform.", eval: -0.5, rationale: "A discovery ask fired into a nervousness signal. He asked a yes-or-no question about pricing and access, and you answered with a calendar request — confirming the exact fear he named: sales showed up, and now the product comes with meetings.", atlasTags: ["liking", "calibrated-question"]),
                PuzzleCandidate(text: "Great timing, actually — you're on a legacy plan, and accounts your size typically move up to our Team tier. Let me walk you through what it unlocks and put together some upgraded pricing options.", eval: -0.9, rationale: "You made his fear come true in one email. He asked whether pricing changes and your answer was a tier-migration pitch — eight months of quiet, happy self-serve revenue just learned that talking to you costs money, which is the fastest way to teach an account never to answer sales again.", atlasTags: ["assumptive", "gain-framing"]),
                PuzzleCandidate(text: "Fair reaction — honestly, ignore the title. All it really means is that if anything ever comes up, you've now got an actual human instead of the support queue.", eval: 0.2, rationale: "Warm, and you dodged the question he actually asked. 'Does pricing change' deserves a direct no; vague friendliness leaves the worry alive, and a worried self-serve founder starts quietly reading the data-export page.", atlasTags: ["liking"]),
            ],
            bestIndex: 0,
            themeHint: "A sales-assist handoff succeeds by naming what will NOT change before anything else.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p114", theme: .salesAssist, difficulty: 1900,
            buyerRole: "Senior analyst, enterprise; heaviest user on the account, zero budget authority",
            setup: "She logs more sessions than the next three users combined and built the templates the whole team runs on. On a check-in call, you floated the annual plan.",
            buyerLine: "Oh, I'd buy it tomorrow — but I don't control budget. That's Priya, our director, and she's never opened the tool once.",
            candidates: [
                PuzzleCandidate(text: "Then let's make the case in Priya's language. Twenty minutes: we turn what the team ships through your templates into one page — her team's numbers, not vendor slides. You hand it over; I'm on call if she wants a vendor to grill.", eval: 0.8, rationale: "You turned a fan into a mobilizer. A director who's never opened the tool won't be moved by your deck or by enthusiasm — she'll be moved by her own team's output, assembled by her own analyst. Co-building the page keeps the analyst its author, which is what gets it read; staying on call keeps you out of a relay you'd lose.", atlasTags: ["commitment-consistency", "concrete-construal"]),
                PuzzleCandidate(text: "Would you be up for introducing me to Priya? Even a two-line email works — I can take it from there and walk her through the value story directly, no heavy lift on your side.", eval: 0.1, rationale: "The right destination reached too crudely. An intro request spends the analyst's capital before any case exists — and 'a vendor wants to walk you through the value story' is precisely the email a director who's never opened the tool deletes on sight.", atlasTags: ["multi-threading", "liking"]),
                PuzzleCandidate(text: "That's okay — you're clearly getting real value, and that's what counts. Meanwhile, let me show you some of the advanced features you haven't tried; the budget side usually sorts itself out around renewal.", eval: -0.7, rationale: "Selling harder to the person who's already sold. Every feature you show her deepens usage the buyer can't see — this account's value and its budget live in different rooms, and you just chose to visit the wrong one again.", atlasTags: ["gain-framing", "liking"]),
                PuzzleCandidate(text: "Good to know — I'll just reach out to Priya directly, then. Usage this strong makes its own case; she really should see what her team has built on top of us.", eval: -0.4, rationale: "Around your best advocate the moment she told you her limits. A cold vendor email citing her team's usage puts the analyst in the position of explaining you to her boss — the person who would have carried your case is now managing the fallout from it.", atlasTags: ["authority", "social-proof"]),
            ],
            bestIndex: 0,
            themeHint: "A power user without budget isn't your buyer — she's your co-author. The case has to arrive in the buyer's language, carried by someone the buyer already trusts.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p115", theme: .salesAssist, difficulty: 1400,
            buyerRole: "Design lead, 20-person agency; free plan with a three-editor cap",
            setup: "Free plan, capped at three editor seats per project. Account data: seven people rotate through the three seats, and view-only teammates leave comments asking to be toggled in. She replied to your check-in email.",
            buyerLine: "We're fine, honestly! We've got a rotation going for the editor seats — bit of a dance, but it works.",
            candidates: [
                PuzzleCandidate(text: "The dance is the tell — seven people, three seats, someone waiting to work every day. What's a week of that costing you? If the math says upgrade, I'll price it; if not, keep dancing.", eval: 0.6, rationale: "She named the pain and filed it under 'fine' — your job is to un-file it, gently. Making her put a cost on the seat rotation converts a workaround she's proud of into a line item she can weigh against a price. And the honest exit — keep dancing — is what makes the question feel like math instead of a trap.", atlasTags: ["spin-implication", "takeaway"]),
                PuzzleCandidate(text: "Glad it's working! Since I've got you, though — can I show you what the Pro plan looks like? There's a lot beyond editor seats: version history, shared libraries, advanced permissions. Genuinely worth a look.", eval: -0.5, rationale: "A feature tour aimed at a team whose only visible problem is seats. You pitched the catalog and buried the one thing she actually feels — the rotation — under three things she never asked about, and 'worth a look' invites a no that costs her nothing.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "One thing to flag, just so you're not caught out — seat rotation like that sits outside the free plan's intended use, and accounts doing it can get flagged. Better to get ahead of it with a proper plan.", eval: -0.8, rationale: "You threatened a team for loving the product. Compliance framing on a free-tier workaround turns your warmest upgrade signal into a reason to shop competitors — enforcement is the one message that makes the dance stop and the account leave with it.", atlasTags: ["loss-framing", "authority"]),
                PuzzleCandidate(text: "Totally get it. Quick question, though — how big is the team overall these days, what does the budget picture look like, and who over there would sign off if you ever did decide you wanted more seats?", eval: -0.2, rationale: "BANT questions your own admin panel already answered — you can see the seven people and the rotation from your side. Asking what you already know reads as a script, and none of it moves her; the number that moves her is what the workaround costs.", atlasTags: ["calibrated-question"]),
            ],
            bestIndex: 0,
            themeHint: "A proud workaround is a price the team is already paying — help them count it.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p116", theme: .salesAssist, difficulty: 2000,
            buyerRole: "Head of Product, enterprise; your champion on a healthy 80-seat contract",
            setup: "Quarterly check-in. Workspace data: 14 marketing-domain guest accounts active over the last 60 days, and two marketing-built boards now sit among the most-viewed on the account. Marketing has no contract, no owner, no support entitlement.",
            buyerLine: "Ha, yeah — marketing basically lives in our workspace now. We just add them as guests, it's easier than making them buy anything.",
            candidates: [
                PuzzleCandidate(text: "Easier for now — but fourteen guests deep, marketing's work lives where they can't own it: your permissions, your support line, your renewal. Who runs those boards over there? If it's real, they deserve their own room.", eval: 0.7, rationale: "You built the expansion case out of your champion's interests, not your quota. Guest sprawl costs him — permissions he polices, clutter he owns, a renewal quietly subsidizing another team — and asking for the marketing owner routes you in with his blessing instead of around it. The signal found the deal; the framing decides whether he sponsors it.", atlasTags: ["concrete-construal", "calibrated-question"]),
                PuzzleCandidate(text: "Perfect timing, then — with that much marketing activity we should really talk about the org-wide plan: one contract covering both teams, cleaner admin, and better rates at that volume. I can have pricing over to you by Friday.", eval: -0.3, rationale: "You turned his joke into a bigger invoice. An org-wide repapering makes your champion carry a cross-department procurement he never asked for — and it prices the easy expansion, one marketing pod, inside a big-ticket motion his own budget doesn't even cover.", atlasTags: ["assumptive", "extreme-anchor"]),
                PuzzleCandidate(text: "Good to know! I'll reach out to the marketing folks on those boards directly — I can see who's most active from my side — and find out whether their team wants a proper setup of their own.", eval: -0.9, rationale: "'I can see who's most active' — you just told your champion you'll mine his workspace data to cold-call his colleagues. The expansion might even land; the champion who hears about it from marketing first won't be your champion at the next renewal.", atlasTags: ["multi-threading", "social-proof"]),
                PuzzleCandidate(text: "As long as it's working, that's what matters — guests exist for exactly this. If it ever gets heavy enough that marketing wants their own setup, you know where I am.", eval: 0.4, rationale: "Reads as admirably low-pressure; it's actually a wave at the clearest expansion signal in the account. Fourteen active guests and top-viewed boards is marketing already adopted — waiting for them to volunteer as customers mistakes your job for theirs.", atlasTags: ["liking", "silence"]),
            ],
            bestIndex: 0,
            themeHint: "Guest sprawl is a second team mid-adoption — expand through the champion's problem, never through his data.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p117", theme: .forecastCall, difficulty: 1450,
            buyerRole: "Your VP of Sales, Monday-morning forecast call",
            setup: "Forecast call, week two of the quarter. The dossier: the CFO gave you a verbal yes on Thursday's call. Nothing is in writing. Redlines have not started. Security review has no date. Your champion says 'it's done, just formalities now.' You moved it into Commit last night.",
            buyerLine: "Walk me through why this is Commit.",
            candidates: [
                PuzzleCandidate(text: "It shouldn't be — I got ahead of it. I have a verbal and nothing in pen: no redlines, no security date. It's Best Case until paper moves.", eval: 0.7, rationale: "Commit means bet your job on it, and you can't bet a job on words that aren't in writing. A verbal is a mood with a timestamp — the CFO meant it Thursday; nothing binds him to mean it in week eleven. Moving it yourself, before your VP finds it, is what makes your Commit column worth reading all year.", atlasTags: ["labeling", "concrete-construal"]),
                PuzzleCandidate(text: "The CFO said yes to me directly on Thursday — that's the economic buyer committing. What's left is process. Redlines will be moving this week.", eval: 0.3, rationale: "The right person said yes — that's genuinely worth something, and it's why this is a good Best Case. But a lone verbal is the weakest form of commitment there is: nothing public, nothing written, nothing effortful. You promoted a sentence into a category that's supposed to hold signatures.", atlasTags: ["authority", "commitment-consistency"]),
                PuzzleCandidate(text: "My champion is telling me it's done — formalities left, nothing else. Between his read on the inside and the CFO's yes, I'm comfortable holding it in Commit.", eval: -0.4, rationale: "You just forecast someone else's optimism. 'Just formalities' is what champions say when they've never watched their own legal team work — he isn't lying to you, he's guessing, and now his guess is your number. Commit on a relay is happy ears at one remove.", atlasTags: ["social-proof", "liking"]),
                PuzzleCandidate(text: "Straight answer: it's Commit because my quarter needs it to be. If it drops out my coverage collapses, so I'm going to pull the paper in whatever it takes.", eval: -0.9, rationale: "You forecast your quota gap, not the deal. The moment need sets the category, the forecast stops being information — and a VP who hears 'whatever it takes' now knows both that the deal is soft and that your other calls might be too. Honest and short beats loyal and wrong.", atlasTags: ["scarcity", "loss-framing"]),
            ],
            bestIndex: 0,
            themeHint: "Commit is a bet, not a hope — and a verbal is neither paper nor a date.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p118", theme: .forecastCall, difficulty: 1700,
            buyerRole: "Your VP of Sales, weekly forecast call",
            setup: "Weekly forecast call. The dossier: same deal, third straight week in your Commit. It was 'signing Friday' two weeks ago — slipped. 'This Friday for sure' last week — slipped again. The buyer emails an apology each Monday. Order form is out; no signature. The stated blocker changed each time: first the GC's vacation, then a budget-code question.",
            buyerLine: "It's slipped two Fridays in a row. Is this week real?",
            candidates: [
                PuzzleCandidate(text: "No. A slip whose reason changes weekly means the real reason hasn't surfaced. I'm re-dating it two weeks out and asking him straight what's holding the pen.", eval: 0.65, rationale: "The tell isn't the slipping — it's the rotating explanation. A real blocker stays the same blocker until it clears; a new excuse every Monday means the true obstacle hasn't been said out loud yet, and you can't forecast around a thing that has no name. Re-date it, then go get the name.", atlasTags: ["labeling", "calibrated-question"]),
                PuzzleCandidate(text: "I believe it's real this time — the GC is back from vacation and the budget code got resolved yesterday. Everything I'm seeing points to a signature Friday.", eval: 0.4, rationale: "The facts are true and the sentence is still the problem: 'everything points to Friday' is exactly what you told this call the last two weeks. Clearing the stated blockers only matters if the stated blockers were ever the real one — and the rotation says they weren't.", atlasTags: ["gain-framing", "commitment-consistency"]),
                PuzzleCandidate(text: "I can make it real — I'll put two percent on the table for ink by Friday. That prices the delay off the table and gives his GC a reason to move us up the pile.", eval: -0.6, rationale: "You just offered to pay a mystery. Discounting into an unnamed blocker doesn't remove it — if the real issue is authority, appetite, or a rival, two points changes nothing except your margin, and the Monday apology now arrives with a cheaper deal attached.", atlasTags: ["scarcity", "sharp-angle"]),
                PuzzleCandidate(text: "I'd keep it in Commit but flag it amber on the sheet — the signal's genuinely mixed, and yanking it this late in the week just makes our coverage look worse than it is.", eval: -1.0, rationale: "Forecasting for optics is the Mickey Mouse move — the number stops describing the deal and starts describing your nerves. An amber flag on a Commit is a contradiction your VP will read instantly, and 'coverage looks worse' is an argument about appearances, not revenue.", atlasTags: ["loss-framing"]),
            ],
            bestIndex: 0,
            themeHint: "When the slip's reason changes every week, the reason isn't the reason.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p119", theme: .forecastCall, difficulty: 1500,
            buyerRole: "Your Director of Sales, quarterly pipeline scrub",
            setup: "Quarterly pipeline scrub, deal by deal. The dossier: opportunity is 148 days old, parked at 'Negotiation — 60%' since March. Last live meeting: five weeks ago. He opens every email you send — and answers none. Two 'checking in' notes since. No next step on anyone's calendar.",
            buyerLine: "This one's been sitting at sixty percent since March. Live or dead?",
            candidates: [
                PuzzleCandidate(text: "Dead until it proves otherwise — that's a stall wearing a stage label. It comes out of the forecast today; a close-the-file note will tell us within a week if anyone's home.", eval: 0.7, rationale: "A third of most pipelines is stalled deals masquerading as live, and this is the costume: an old stage percentage doing the breathing the buyer stopped doing five weeks ago. Pulling it costs nothing — the number was fiction — and the takeaway note is the one message a silent buyer reliably answers.", atlasTags: ["takeaway", "labeling"]),
                PuzzleCandidate(text: "He's opening every single email, so the interest is clearly still there — I'd call it live but slow-moving. I'll keep the touches going and catch him when things free up.", eval: 0.2, rationale: "Email opens are a pulse, not a heartbeat — curiosity costs him two seconds and commits him to nothing. Five weeks without a reply or a calendar entry is the actual data, and 'live but slow' is how a dead deal stays on the sheet for another two quarters.", atlasTags: ["gain-framing"]),
                PuzzleCandidate(text: "It's live — that sixty percent reflects terms we'd already negotiated and agreed in principle. Nothing has actually changed on the deal itself since March, so I'd leave it be.", eval: -0.5, rationale: "'Nothing has changed since March' is the case against the deal, not for it. Deals are motion; the stage number recorded a moment that's now a season old. You're defending the label on the jar while the contents evaporate.", atlasTags: ["commitment-consistency"]),
                PuzzleCandidate(text: "Give me one more sequence before we kill anything — a fresh case study this week, an ROI recap next, then a proper breakup note in two weeks if he still hasn't moved at all.", eval: -0.8, rationale: "Half right, three touches too late — the breakup note works because it's scarce and final, and you just buried it under two more sends he'll open and ignore. Meanwhile the deal sits in forecast for two more weeks doing what it's done since March: nothing.", atlasTags: ["social-proof", "gain-framing"]),
            ],
            bestIndex: 0,
            themeHint: "Stage labels don't breathe — a third of any pipeline is stalled deals dressed as live ones.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p120", theme: .forecastCall, difficulty: 1850,
            buyerRole: "Your VP of Sales, forecast one-on-one",
            setup: "Forecast one-on-one. The dossier: $180K expansion in Best Case, dated this quarter. Your champion drove every meeting since January — then went quiet three weeks ago. She declined last week's check-in with no reschedule. Two of her LinkedIn posts mention her company 'restructuring.' The procurement contact still replies, but only about process.",
            buyerLine: "Still comfortable with this one in Best Case?",
            candidates: [
                PuzzleCandidate(text: "No. The engine of this deal went silent three weeks ago and there's a reorg in the air — until I know she still owns it, this is Pipeline, and finding that out is my whole week.", eval: 0.75, rationale: "You read the right instrument. This deal never had momentum — it had a champion, and she's dark during a restructuring, which means her budget, her mandate, or her job may not exist by close date. Downgrading isn't pessimism; it's refusing to forecast a person you can't currently find.", atlasTags: ["labeling", "multi-threading"]),
                PuzzleCandidate(text: "Yes — procurement is still engaged and actively working the process. If their side is processing paperwork, the deal is moving, whether or not she's answering my check-ins.", eval: 0.3, rationale: "Tempting, because paper motion looks like deal motion. But procurement runs on inertia — they process what was queued until someone cancels it, and the someone is exactly the person who went dark. Process signal without sponsor signal is a car rolling with no one at the wheel.", atlasTags: ["commitment-consistency"]),
                PuzzleCandidate(text: "She's just heads-down in the restructuring — champions go quiet when it gets busy, it never means anything. I'll give her the space and keep the close date where it is.", eval: -0.6, rationale: "You wrote her alibi for her. A driver-of-every-meeting doesn't decline the check-in of her own project because she's busy — she declines it because the project's status changed and she can't say so yet. 'Give her space' keeps the date and loses the quarter.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Honestly, my move is to go around her — I'm emailing her VP directly today to keep the momentum up while she's dark. Can't let one quiet contact stall a one-eighty deal.", eval: -0.3, rationale: "Right diagnosis, live grenade. Going over a dark champion mid-reorg — before you know her standing — can execute her politically and you with her. Test the thread first: a no-pressure note she can answer safely tells you whether to multi-thread with her or without her.", atlasTags: ["multi-threading", "authority"]),
            ],
            bestIndex: 0,
            themeHint: "When the champion goes quiet, the deal already changed — your job is finding out how.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p121", theme: .forecastCall, difficulty: 1400,
            buyerRole: "Your new sales manager, her first pipeline review with you",
            setup: "First pipeline review with a new manager. The dossier: $300K net-new in Commit, dated week eleven. One relationship: a Director of Ops who loves the product. Every executive touch has gone through him — he presents your slides internally himself. You have never spoken to the CFO who signs. Legal has the paper. The buying committee is six people; you've met one.",
            buyerLine: "Three hundred K in Commit. Why do I believe it?",
            candidates: [
                PuzzleCandidate(text: "You half shouldn't. Paper's moving, but I've met one of six people and never the signer — it's Best Case until the CFO's in a room with me. That meeting request goes out today.", eval: 0.6, rationale: "Single-threaded is the risk that eats Commits: your entire $300K is one Director's internal salesmanship, unverified. Best Case honors what's real — paper, love, momentum — while pricing what isn't: you've never watched the person who signs react to the number. The honest downgrade plus the fix, in one breath.", atlasTags: ["multi-threading", "concrete-construal"]),
                PuzzleCandidate(text: "Because the Director is the real buyer here — the CFO signs whatever he recommends. He's presented us twice internally on his own, and their legal team already has our paper in hand.", eval: 0.4, rationale: "The best wrong answer on the sheet, because it's coherent — some Directors do carry the room. But 'the CFO signs whatever he recommends' is his claim about his own influence, relayed by him, believed by you. Authority you've never seen exercised is authority you're guessing at.", atlasTags: ["authority", "social-proof"]),
                PuzzleCandidate(text: "Legal has the redlines, and deals don't get to legal unless they're closing — paper in motion is the strongest commit signal there is. That's why I'm confident holding it where it is.", eval: -0.3, rationale: "Paper is necessary, not sufficient — contracts idle in legal queues for quarters, and a redline pass commits nobody to a dollar figure. You promoted the most mechanical signal in the file over the loudest gap in it: five unmet people and an unmet signer.", atlasTags: ["commitment-consistency"]),
                PuzzleCandidate(text: "Fair challenge — so I'll get the Director to stake his own credibility on it this week. If he tells me to commit it, I commit it. He knows that building better than we ever will.", eval: -0.7, rationale: "You just outsourced your forecast to the one person guaranteed to have happy ears — it's his project, his slides, his reputation. He isn't a liar; he's a sponsor grading his own homework. Your manager asked why she should believe you, and you answered 'because he does.'", atlasTags: ["liking", "social-proof"]),
            ],
            bestIndex: 0,
            themeHint: "One thread holds a jacket, not a three-hundred-K Commit.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p122", theme: .forecastCall, difficulty: 1950,
            buyerRole: "Your CRO, quarter-end deal call — four days left",
            setup: "The 26th, four days left in the quarter. The dossier: the deal is genuinely healthy — EB bought in, criteria agreed in writing, order form sitting in the buyer's legal review since Tuesday. Their GC's turnaround averages two weeks; nobody on their side has promised this week. Your gap to quota is exactly this deal.",
            buyerLine: "Four days. What would it take to pull it in?",
            candidates: [
                PuzzleCandidate(text: "Nothing I'd want to pay. Their legal runs two weeks and started Tuesday — a discount doesn't speed a GC up, it reprices a deal that's already won. It signs week two of next quarter, in pen.", eval: 0.7, rationale: "The hardest quarter-end move is declining to buy the calendar. This deal is won; the only open question is a date set by their GC's queue, and no concession you own changes that math. 'In pen, week two' gives your CRO something better than a miracle — a number that will actually come true.", atlasTags: ["concrete-construal", "mutual-close-plan"]),
                PuzzleCandidate(text: "I'll put three percent on the table for signature by the 30th — end-of-quarter pricing is the one lever that reliably moves paper, and honestly the margin costs us less than the slip does.", eval: -0.7, rationale: "The EOQ reflex, fully formed. Three points buys you nothing here — the blocker is a lawyer's queue, not appetite — and it teaches their procurement forever that your price drops on the 26th. You'd pay real margin for a maybe, on a deal that closes anyway.", atlasTags: ["scarcity", "sharp-angle"]),
                PuzzleCandidate(text: "Let me spend the EB — she wants this done, and one email from her to their GC could jump us up the review queue. Costs us nothing and might just save the quarter for us.", eval: 0.1, rationale: "Less destructive than discounting, but 'costs us nothing' isn't true — executive capital is a finite account, and you'd drain it asking a sponsor to lean on her own legal team over four cosmetic days. Save that favor for a moment when the deal itself needs it.", atlasTags: ["authority"]),
                PuzzleCandidate(text: "One option: I ask the champion whether a signed LOI by Friday would let us count it this quarter — the real contract follows two weeks behind, exactly like it's already going to.", eval: -0.5, rationale: "An LOI here is a verbal in a costume. It changes nothing about when money and signatures actually move — it exists so the sheet can say something the deal doesn't. Counting it invents revenue in week thirteen that you'll un-invent, publicly, in week one.", atlasTags: ["commitment-consistency"]),
            ],
            bestIndex: 0,
            themeHint: "Quarter-end discounts try to buy calendar days from people who don't sell calendars.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p123", theme: .forecastCall, difficulty: 1550,
            buyerRole: "Your VP of Sales, deal inspection",
            setup: "Deal inspection. The dossier: mid-market, $95K. Champion (Head of Support) meets you weekly and walked the business case through their internal ops review herself last month. Pain quantified in writing: 31% ticket backlog, costed at $310K a year. Eval scorecard agreed. Procurement confirmed standard MSA, two-week turnaround, no security review under $100K. Champion says budget 'comes out of our ops line — it's fine.' You have never met or emailed the CFO who owns that line.",
            buyerLine: "Run the MEDDPICC on this one for me. What's missing?",
            candidates: [
                PuzzleCandidate(text: "The Economic Buyer. I can't write the EB sentence — I'm taking the champion's word for whose budget this is and how freely she spends it. It's real to everyone but the funder.", eval: 0.7, rationale: "You audited the file instead of your feelings about it. Every other letter has evidence attached; the budget claim has a champion's confidence and nothing else — and 'it's fine, it comes out of our line' is the exact sentence that precedes a CFO surprise in week twelve. If you can't write the EB sentence, you don't forecast the deal.", atlasTags: ["multi-threading", "concrete-construal"]),
                PuzzleCandidate(text: "Metrics would be my worry — the thirty-one percent backlog figure came entirely from their side, and I haven't independently validated it or the three-ten costing behind it yet.", eval: -0.3, rationale: "You audited the strongest slot on the sheet. A buyer-generated, written, costed metric is the best kind — they argued themselves into the pain. Second-guessing filled letters while an empty one sits in plain view is how MEDDPICC becomes theater instead of inspection.", atlasTags: ["concrete-construal"]),
                PuzzleCandidate(text: "Champion, honestly — the weekly meetings are great, but I haven't put her to a genuine test yet, and an untested champion is the classic soft spot in a file that looks this clean.", eval: 0.4, rationale: "Right instinct, already answered: she took the business case through their ops review alone, without you in the room, and won. That is the champion test — passed last month. You quoted the rule where the dossier had already run the experiment.", atlasTags: ["commitment-consistency"]),
                PuzzleCandidate(text: "Paper process — it's the slot we haven't really pressure-tested, and paper is where mid-market deals this size go to die quietly in the last three weeks of a quarter.", eval: -0.6, rationale: "You read the slot's reputation, not this deal's file. Their procurement is on record: standard MSA, two weeks, no security review at this price. That's a mapped, dated, boring paper process — the generic fear beat the specific evidence, which is happy ears' pessimistic twin.", atlasTags: ["loss-framing"]),
            ],
            bestIndex: 0,
            themeHint: "If you can't write the Economic Buyer sentence, you're forecasting somebody else's budget.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p124", theme: .forecastCall, difficulty: 1600,
            buyerRole: "Your VP of Sales, forecast call — five weeks left",
            setup: "Forecast call, five weeks left in the quarter. The dossier: enterprise, $240K, forecast to close in three weeks. The CIO sponsored the eval personally and joined two calls. Champion tested — she killed the incumbent's renewal herself. Metrics agreed in writing: $40K a month in overage fees eliminated. Verbal from the CIO on Friday. Security review, MSA redlines, vendor onboarding: none started — and their procurement's published minimum is six weeks.",
            buyerLine: "Something kills this deal in three weeks. What is it?",
            candidates: [
                PuzzleCandidate(text: "The paper. Their procurement floor is six weeks and we haven't filed a single form — no CIO enthusiasm compresses that. Real close is next quarter; paper should've started with the eval.", eval: 0.75, rationale: "Paper process is the only letter with physics in it — six weeks doesn't fit inside three regardless of how the humans feel. Everything else in this file is genuinely strong, which is exactly why the unstarted paperwork is invisible: nothing feels wrong. The calendar doesn't care. Re-date it and start the forms today.", atlasTags: ["mutual-close-plan", "concrete-construal"]),
                PuzzleCandidate(text: "The verbal is what worries me — the CIO said yes on Friday, but nothing's countersigned yet, and a verbal that isn't converted into something written has a way of quietly evaporating.", eval: 0.3, rationale: "In most files that's the right paranoia — here it's aimed at the wrong slot. This CIO sponsored the eval and sat through two calls; the yes has a track record behind it. Meanwhile the question was what kills it in three weeks, and the answer with a date on it is the six-week paper floor.", atlasTags: ["labeling"]),
                PuzzleCandidate(text: "Competition — the incumbent won't die quietly. A save-desk discount against that renewal could flip this whole thing late, and we've stopped watching them since the eval ended.", eval: -0.2, rationale: "The champion already killed the incumbent's renewal herself — that door is closed and she closed it. You're standing guard at a settled fight while the procurement clock, the one enemy in the file with a confirmed kill window, runs undefended.", atlasTags: ["loss-framing"]),
                PuzzleCandidate(text: "Honestly? Nothing does — every letter on this one is green, and with Friday's verbal from the CIO I'd actually move it up into Commit rather than sit here inventing risks for it.", eval: -0.8, rationale: "The letters are green; the calendar is red. Reading MEDDPICC as a checklist of feelings instead of dates is how a genuinely great deal becomes a forecast miss — this one closes, next quarter, and Commit-on-a-verbal three weeks from an unstarted six-week process is the definition of happy ears.", atlasTags: ["gain-framing", "assumptive"]),
            ],
            bestIndex: 0,
            themeHint: "Paper has physics — no verbal compresses a six-week process into three.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p125", theme: .forecastCall, difficulty: 2000,
            buyerRole: "Your CRO, deep-dive deal review",
            setup: "Deep-dive deal review. The dossier: $150K in Best Case. Your contact, a Senior PM, is wildly enthusiastic — replies in minutes, forwards your decks upward, calls it 'his project.' In four months he has never gotten you a meeting above him, never put a recommendation in writing, never moved anything internally without you drafting it. The budget-owning VP joined one call, asked two cost questions, left early. An eval scorecard exists — the PM wrote it with you. Competition checked: they'd be replacing a homegrown script; no other vendor in the picture.",
            buyerLine: "Strongest slot and weakest slot. Go.",
            candidates: [
                PuzzleCandidate(text: "Weakest is Champion — and it's rotten, not thin. Four months and he's never sold one thing inside without my hands on it. He's a fan. Strongest is Pain: the enthusiasm's real, it just doesn't transfer.", eval: 0.7, rationale: "The brutal read, and the correct one: a champion is defined by what he does when you're not in the room, and in four months that's been nothing. Responsiveness, forwarded decks, 'his project' — those are fandom, and fandom doesn't survive contact with a budget meeting. Every other weak slot in this file is downstream of this one.", atlasTags: ["labeling", "commitment-consistency"]),
                PuzzleCandidate(text: "Weakest is the Economic Buyer — the VP's entire footprint is one cameo and two cost questions. Strongest is Champion, no question; the PM is all-in on this and has been since day one.", eval: 0.4, rationale: "The near-miss that separates good reps from great ones. The EB slot is genuinely thin — but an empty EB slot is fixable in a week if you have a working champion, and that's the rub: you don't. The VP is absent because nobody inside is selling to her. You named the symptom and promoted the disease.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Weakest is Decision Criteria — a scorecard the PM wrote with me isn't the org's criteria, it's ours wearing their font. If a real eval ever starts, that document gets rewritten without us.", eval: 0.1, rationale: "A sharp observation one level short of the diagnosis. The criteria are homemade because the champion can't source real ones — he has no access to where criteria get set. Fix the champion problem and the criteria problem dissolves; fix the scorecard and you've laminated the symptom.", atlasTags: ["concrete-construal"]),
                PuzzleCandidate(text: "Genuinely, the slots mostly look filled here — engaged contact, a scorecard on file, VP's aware, pain's real. Weakest is Competition, if only because it's the one letter with nothing written next to it.", eval: -0.7, rationale: "The dossier answered competition — homegrown script, no vendor in the eval, checked. Calling the one verified-empty threat 'weakest' while a four-month champion failure sits in plain sight means you inspected the acronym, not the deal. Blank and rotten are different failures; only one of them is already in your number.", atlasTags: ["gain-framing"]),
            ],
            bestIndex: 0,
            themeHint: "A champion sells when you're not in the room. Everyone else is an audience.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p126", theme: .forecastCall, difficulty: 1650,
            buyerRole: "Your VP of Sales, one-on-one before the forecast roll-up",
            setup: "One-on-one before the roll-up. The dossier: $120K in Commit, close in five weeks. The COO — the economic buyer — has met you twice and likes it. Champion tested: she ran an internal workshop on the product without you. Paper mapped: their legal quoted ten business days. Decision process written and signed off. Everyone, the COO included, says it will 'save the team a ton of time.' No baseline, no target, no dollar figure appears anywhere in the file. CFO review is the final gate.",
            buyerLine: "It goes to CFO review in two weeks. Where's the exposure?",
            candidates: [
                PuzzleCandidate(text: "Metrics. The whole case is 'a ton of time,' and a CFO doesn't sign adjectives — the first 'how much, against what baseline?' kills it politely. I need the number agreed before the review.", eval: 0.65, rationale: "You found the empty letter behind the good feelings. This deal has sponsors, paper, and process — and no arithmetic, which is the only language the final gate speaks. Finance doesn't kill unquantified deals out of malice; it kills them as policy. A baseline and a dollar figure, co-authored with the champion now, is cheap insurance on $120K.", atlasTags: ["concrete-construal", "precise-anchor"]),
                PuzzleCandidate(text: "The COO drifting is my exposure — two meetings and 'likes it' is thinner executive sponsorship than a Commit rating should be pricing in. I'd want a third touch before the review lands.", eval: 0.3, rationale: "Reasonable paranoia pointed at a filled slot. An EB who took two meetings and voiced support is engaged — more coffee doesn't strengthen the file. What the COO cannot do at CFO review is answer 'how much?' on your behalf, because nobody, including him, knows. The hole isn't warmth; it's arithmetic.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Truthfully, nothing structural — a CFO review is a formality when the COO's the sponsor. My plan is to protect the close date, stay out of their way, and let the internal momentum carry it home.", eval: -0.9, rationale: "'The CFO is a formality' is the epitaph on half of all no-decision losses. Finance gates exist precisely to catch deals that run on sponsorship instead of numbers — and this file, as written, is exactly that deal. Momentum doesn't answer a baseline question; somebody in that room has to.", atlasTags: ["authority", "gain-framing"]),
                PuzzleCandidate(text: "The calendar — ten business days of legal inside a five-week close leaves almost no slack if the redlines bounce even once. I'd start paper this week instead of waiting on the CFO review to clear.", eval: -0.3, rationale: "The math you're worried about actually clears: ten mapped days inside five weeks holds even with a bounce. You stress-tested the slot with a written quote attached and skipped the one where the file contains literally nothing — an empty Metrics line two weeks from a finance gate.", atlasTags: ["loss-framing"]),
            ],
            bestIndex: 0,
            themeHint: "CFOs don't sign adjectives — quantify before the finance gate, or the gate quantifies for you.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p127", theme: .forecastCall, difficulty: 1800,
            buyerRole: "Your Director of Sales, pipeline review",
            setup: "Pipeline review. The dossier: $200K competitive eval, Best Case. Discovery went deep — pain identified and costed at $500K a year. The EB is confirmed, met, and engaged. Your demo 'went great'; the champion texted that you 'clearly led.' You've since learned the buyer scored demo week on an internal rubric nobody on your side has seen. Two other vendors demoed the same week. The champion mentioned they're 'weighting integrations heavily' — once, in passing.",
            buyerLine: "Three vendors in the mix and you're Best Case. What don't you know?",
            candidates: [
                PuzzleCandidate(text: "How they're scoring us — and that's the whole answer. 'We clearly led' is my read of a test I never saw. Getting that rubric, or getting my champion to co-author the weightings, is the entire deal this week.", eval: 0.75, rationale: "Decision Criteria is the letter reps skip because it feels covered by a good demo — and a hidden rubric means you are being graded on axes you're guessing at. One passing mention of 'integrations weighted heavily' is the only glimpse you've had of the actual scoreboard. Get the criteria or shape them; everything else is commentary.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Not much, honestly — the champion says we clearly led demo week, and integrations are our strongest story, which is exactly the thing he told me they're weighting. I like where we're standing.", eval: -0.6, rationale: "Happy ears, three layers deep: a friendly's verdict, on a test scored behind closed doors, matched to a weighting you heard about once in passing. Each layer sounds like evidence and none of it is — you've built a Best Case rating on a rumor agreeing with a compliment.", atlasTags: ["social-proof", "gain-framing"]),
                PuzzleCandidate(text: "Who's actually driving the bake-off — three vendors demoed inside one week, and that cadence smells like a rigged race someone's running for a preferred option. I want intel on who set it up before anything else.", eval: 0.3, rationale: "A real question, sequenced wrong. Column-fodder paranoia is healthy in threes — but you can't out-politick a race whose scoring you haven't read; the rubric would tell you who it favors, which answers your question on the way past. Criteria first; the bake-off org chart second.", atlasTags: ["loss-framing"]),
                PuzzleCandidate(text: "The EB's private lean — she's confirmed and she's met with us, but execs go quiet in the last lap of an eval, and I don't know which way she's actually pointing. I'd get back in front of her first.", eval: -0.4, rationale: "You're courting the judge while ignoring the law. The EB is met, engaged, and — in a scored eval — largely bound to the rubric her team runs. Her lean will follow the scorecard you haven't read, which makes another coffee with her a pleasant way to spend the week not learning it.", atlasTags: ["authority", "liking"]),
            ],
            bestIndex: 0,
            themeHint: "'The demo went great' is your score of a test they graded — go read the rubric.",
            transcriptId: nil
        ),

        Puzzle(
            id: "p128", theme: .forecastCall, difficulty: 2100,
            buyerRole: "Your CRO, inspecting the biggest deal on the board",
            setup: "CRO inspection of the quarter's anchor deal. The dossier: $400K in Commit, week nine of thirteen. Every letter reads green: metrics costed and CFO-validated, EB met three times, champion tested twice and passed, paper started early and on schedule, decision criteria in writing since spring. Buried in the file: six weeks ago the buyer hired a new VP of Engineering — from a company that runs your main competitor globally. Nobody on your side has met him. The criteria doc predates his arrival.",
            buyerLine: "Four hundred K in Commit. Steelman the loss for me.",
            candidates: [
                PuzzleCandidate(text: "The new VP of Engineering — an incumbent competitor walked in wearing a badge six weeks ago, and the criteria doc is older than he is. If he reopens the eval, every letter re-votes. I meet him before I defend Commit.", eval: 0.7, rationale: "Competition isn't a slot you fill in spring and file — it re-opens every time the buyer's org changes, and this org just hired your rival's institutional memory into the exact chair that owns your criteria doc. The steelman with a name, a date, and a fix beats every abstract one. Meet him before he meets your deal.", atlasTags: ["multi-threading", "labeling"]),
                PuzzleCandidate(text: "The honest steelman is a late no-decision — big deals die to the status quo far more often than to rivals, and week thirteen is exactly where CFOs get cold feet and freeze spend that looked certain in week nine.", eval: 0.4, rationale: "Statistically the best prior in sales — no-decision beats all competitors combined — which is what makes this the elite trap. Priors are for when the file is silent, and this file isn't: the CFO already validated the number, while a specific, dated, named threat sits unexamined. The base rate lost to the dossier and you quoted it anyway.", atlasTags: ["loss-framing"]),
                PuzzleCandidate(text: "Paper — early start or not, a four-hundred-K MSA can always find a snag in week twelve, so if I'm steelmanning honestly, I'd steelman a slip into next quarter rather than a true loss of the deal.", eval: -0.3, rationale: "A slip steelman on a loss question is a dodge with a spreadsheet accent — and you aimed it at the single most de-risked line in the file, paper that started early and runs on schedule. When asked to imagine losing, you imagined winning slightly later.", atlasTags: ["concrete-construal"]),
                PuzzleCandidate(text: "I'll be straight: I can't steelman it well — every slot is green and independently validated. If this one gets away from us, it wasn't the kind of loss anyone could have inspected in advance.", eval: -0.9, rationale: "'Not inspectable in advance' — with the tell sitting in the file for six weeks. A rival-trained VP now owns the technical vote and nobody's met him; that's as inspectable as risk gets. This is what a CRO hears the week before a shock loss, and why the inspection exists at all.", atlasTags: ["gain-framing"]),
            ],
            bestIndex: 0,
            themeHint: "A green scorecard ages — re-run the letters every time the buyer's org chart changes.",
            transcriptId: nil
        ),
    ]

    // O(1) lookup — `get` is called per solve row on screens that re-evaluate per
    // keystroke/Store publish; the old linear scan made those O(solves × 100).
    private static let byId: [String: Puzzle] = Dictionary(all.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })

    public static func get(_ id: String) -> Puzzle? {
        byId[id]
    }

    /// Adaptive next-puzzle pick (research 2026-07): serve at the EDGE of ability, not
    /// a coin-flip. Target a difficulty ~100 below the user's rating (~65% success — a
    /// winnable stretch), among unsolved puzzles in a sane band, and INTERLEAVE themes
    /// (a same-theme puzzle must be ~120 ELO closer to the target to win) rather than
    /// blocking one topic. Falls back to a sequential cycle if the band is exhausted.
    public static func adaptiveNext(after currentId: String, rating: Int, solvedIds: Set<String>) -> Puzzle {
        let target = rating - 100
        let currentTheme = get(currentId)?.theme
        let pool = all.filter {
            $0.id != currentId && !solvedIds.contains($0.id) &&
            $0.difficulty >= rating - 300 && $0.difficulty <= rating + 100
        }
        func score(_ p: Puzzle) -> Int { abs(p.difficulty - target) + (p.theme == currentTheme ? 120 : 0) }
        if let best = pool.min(by: { score($0) < score($1) }) { return best }
        if let i = all.firstIndex(where: { $0.id == currentId }) { return all[(i + 1) % all.count] }
        return all[0]
    }

    /// Deterministic daily puzzle. Keyed by the same LOCAL yyyy-MM-dd key as the
    /// attempt lock and streak (`Store.todayKey`) so the puzzle, the lock, and the
    /// streak all roll at the same midnight. (Was ISO8601/UTC — for any user west
    /// of UTC the puzzle swapped mid-afternoon and re-served the next morning.)
    public static func dailyId(for date: Date = Date()) -> String {
        let key = Store.todayKey(date: date)
        var hash: Int = 0
        for scalar in key.unicodeScalars {
            hash = (hash &* 31 &+ Int(scalar.value)) & 0xffffffff
        }
        let idx = abs(hash) % all.count
        return all[idx].id
    }
}
