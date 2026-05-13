import Foundation

/// 20 hand-authored puzzle positions. Verbatim port from web src/lib/puzzle-library.ts.
///
/// Candidates are compressed tactical descriptions (notation, not dialogue). The
/// puzzle question is "which move type fits this position", not "which exact
/// English sentence sounds best."
///
/// Each puzzle points to a real sourced transcript (Transcripts.swift) via
/// transcriptId. Post-solve, the user can tap "Read Full Transcript" to see how
/// the move type plays out in a recognized practitioner's actual conversation.
public enum Puzzles {
    public static let all: [Puzzle] = [
        // ─── Budget (4) ─────────────────────────────────────────────────
        Puzzle(
            id: "p001", theme: .budget, difficulty: 1300,
            buyerRole: "VP Operations, mid-market SaaS",
            setup: "Eighteen minutes into discovery. You've established the onboarding-churn problem. Buyer just heard pricing.",
            buyerLine: "It's just not in the FY26 envelope. We'd have to pull from training or shift the hire freeze around, and neither one's going to fly with the board.",
            candidates: [
                PuzzleCandidate(text: "Test the underlying constraint. Branch budget-as-policy from budget-as-priority based on which lever the recipient names.", eval: 0.7, rationale: "Operator routes the objection into two operational paths the recipient just surfaced. Recipient appraisal shifts from defending a position to identifying which lever is the real ceiling.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Accept the defer. Schedule a Q1 placeholder.", eval: -0.5, rationale: "Accepts the recipient-supplied frame as-is. No new information surfaced. Probability of repeat hold-pattern compounds across each accepted defer.", atlasTags: []),
                PuzzleCandidate(text: "Offer an asymmetric-work artifact (cost-of-current-state doc). Embed implicit re-engagement frame.", eval: -0.7, rationale: "Pairs reciprocity gift with embedded re-engagement. Operator absorbs work; recipient absorbs artifact. Lateral move, not vertical.", atlasTags: ["reciprocity", "loss-framing"]),
                PuzzleCandidate(text: "Pre-position price elasticity. Hand the recipient the framing pen on the number.", eval: -1.1, rationale: "Operator surfaces price flexibility before recipient asks. Downstream: future budget conversations lengthen; procurement absorbs as calibration point.", atlasTags: ["scarcity", "sharp-angle"]),
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
                PuzzleCandidate(text: "Anchor a named-peer payback number at high specificity. Branch buyer's math vs peer's math.", eval: 0.9, rationale: "Named-peer specificity pre-empts generic-stat dismissal. Branch offer routes toward the higher-effort path while making the lower-effort path available. Recipient shifts from evaluating cost to evaluating method.", atlasTags: ["social-proof", "calibrated-question"]),
                PuzzleCandidate(text: "Defer to a generic stat plus an artifact promise after the call.", eval: -0.3, rationale: "No defensible board number surfaced in the live moment. CFO appraisal stays in uncertainty range.", atlasTags: []),
                PuzzleCandidate(text: "Absorb custom-model authoring work. Promise return by end of week.", eval: -0.5, rationale: "Asymmetric work transferred to operator. Recipient deferred to artifact-pending state. Live-moment energy dissipates; champion has to re-mobilize urgency.", atlasTags: []),
                PuzzleCandidate(text: "Ask the recipient to name the payback ceiling. Work backward from it.", eval: -1.1, rationale: "Operator hands the framing pen to the recipient. Whatever number the CFO names becomes the ceiling. Pre-positions a downstream concession unasked.", atlasTags: []),
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
                PuzzleCandidate(text: "Re-frame the contest to scope match. Question SOW alignment before discussing the delta.", eval: 0.6, rationale: "Re-frames from list price to scope match. Procurement professionals respect comparison-rigor framing because it's their daily operating mode.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Match the price. Conditional close on signing today.", eval: -0.2, rationale: "Concession with conditional close. Signals price is flexible from move 1. Recipient stores the move as a calibration point.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Absorb the re-pricing work internally. Return with a revised package tomorrow.", eval: -0.6, rationale: "Operator absorbs asymmetric work without surfacing the scope question. Returns to the same 12% benchmark with less leverage.", atlasTags: []),
                PuzzleCandidate(text: "Pre-emptive best-and-final. Burn own anchor in the first turn.", eval: -1.2, rationale: "Procurement specialists are trained to push when this pattern fires. Operator has surrendered the negotiation's starting position.", atlasTags: []),
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
                PuzzleCandidate(text: "Re-frame discount to scope. Offer a starter-package design with an explicit 24-hour no-fit path.", eval: 0.7, rationale: "Recipient gets a yes-to-something path plus an explicit no-fit path. 24-hour commitment shifts operator from chase-posture to fit-evaluation-posture.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Defer to an internal check. Promise a return with a number that works.", eval: 0.1, rationale: "Buys time but introduces no new information. Recipient holds in same appraisal state. Operator returns later to a colder conversation.", atlasTags: []),
                PuzzleCandidate(text: "Trade multi-year lock-in for the lower year-one number.", eval: -0.3, rationale: "Multi-year lock-in proposed to a founder explicitly stating burn-rate uncertainty. Recipient absorbs the offer as evidence operator hasn't been listening.", atlasTags: []),
                PuzzleCandidate(text: "Defensive frame. Argue against the recipient's stated runway constraint.", eval: -1.0, rationale: "'You'll pay more later' is structurally implausible to a founder who knows their own runway math. Reactance fires.", atlasTags: ["loss-framing", "authority"]),
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
                PuzzleCandidate(text: "Comply with policy. Surface exit criteria + business-sponsor cost-of-delay in the same turn.", eval: 0.8, rationale: "Operator absorbs the policy without contest, then surfaces two operational paths: procurement's exit criteria and business-sponsor cost-of-delay. Multi-thread embedded in compliance.", atlasTags: ["calibrated-question", "multi-threading"]),
                PuzzleCandidate(text: "Negotiate the timeline. Compress to 30 days.", eval: -0.2, rationale: "Negotiates against the timeline without addressing the policy frame. Procurement reads operator as needing the deal more than they need the eval.", atlasTags: []),
                PuzzleCandidate(text: "Substitute compliance documentation (SOC2 + ISO27001) for the policy step.", eval: -0.5, rationale: "Generic peer-skipping claim to a procurement specialist. The doc offer reads as substitution for a policy the recipient framed as non-negotiable.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Propose a contractual workaround. Route around procurement's authority.", eval: -1.0, rationale: "Reads as either ignorance of procurement's authority or attempt to route around it. Both degrade trust.", atlasTags: ["sharp-angle"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-two-copies"
        ),

        Puzzle(
            id: "p006", theme: .procurement, difficulty: 2100,
            buyerRole: "Procurement counterparty in adversarial negotiation",
            setup: "You've named your number. They've named theirs. Gap is $40K.",
            buyerLine: "We're $40K apart. Before either of us makes a move, what's your last quarter's win-loss ratio at our deal size? I want to know what the next vendor in line costs us.",
            candidates: [
                PuzzleCandidate(text: "Decline to fabricate the requested data. Redirect to deployment-time dimension recipient has previously surfaced.", eval: 0.7, rationale: "Operator does not invent the win-loss number. Redirects to an operational dimension the recipient has surfaced. Anchors the conversation to a number operator can credibly defend.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Answer honestly with appropriate caveat. No position advance.", eval: 0.1, rationale: "Recipient absorbs the data point without obligation; operator has revealed information without extracting any.", atlasTags: []),
                PuzzleCandidate(text: "Split the difference at the midpoint. Standard meet-in-the-middle.", eval: 0.2, rationale: "Workable, but signals operator can move $20K. Procurement will return for a second pass at half that.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "Total capitulation paired with manufactured urgency and an enforceable-style deliverable.", eval: -1.1, rationale: "Procurement registers the move as the operator hitting a quarter-end target, not as a real concession.", atlasTags: ["scarcity"]),
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
                PuzzleCandidate(text: "Name the constraint without inflating the commitment. Surface the timing-mismatch between roadmap and audit cycle.", eval: 0.6, rationale: "Operator names the constraint accurately. Surfaces a timing question the architect can confirm or deny. Recipient experiences operator as audit-literate.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Conditional commitment to a future ATO date.", eval: 0.3, rationale: "Works if operator can credibly hold the date. Carries reputation risk if internal roadmap shifts.", atlasTags: []),
                PuzzleCandidate(text: "Argue against the recipient's stated regulatory requirement.", eval: -0.5, rationale: "Argues with a security architect about the architect's stated requirement. Even if technically defensible, depletes credibility downstream.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Propose a substitution claim that won't survive a five-minute check.", eval: -0.9, rationale: "Architect is positioned to verify. Misrepresentation surfaces immediately.", atlasTags: []),
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
                PuzzleCandidate(text: "Offer a park-or-shrink choice. The choice itself reveals real priority.", eval: 0.6, rationale: "Both options respect the recipient's stated constraint. The choice reveals priority: accept-park signals real deprioritization, accept-shrink signals lingering interest.", atlasTags: ["calibrated-question", "alternative-choice"]),
                PuzzleCandidate(text: "Accept the deprioritization. Schedule a future check-in.", eval: -0.3, rationale: "Schedules a future check-in that will likely produce the same response.", atlasTags: []),
                PuzzleCandidate(text: "Volunteer significant asymmetric work in exchange for the recipient's attention.", eval: -0.4, rationale: "The artifact arrives; the attention does not. Pattern repeats.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Manufactured time-pressure paired with the recipient's stated capacity constraint.", eval: -0.8, rationale: "Recipient registers operator as quota-driven, not customer-driven. Stall extends.", atlasTags: ["scarcity", "loss-framing"]),
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
                PuzzleCandidate(text: "Convert wait-state into actionable signal. Surface spillover risk + remaining recipient-side blockers.", eval: 0.7, rationale: "Operator does not press the legal-team availability. Instead surfaces operational questions inside recipient's control. Converts wait-state into actionable information.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Offer to absorb legal coordination work directly.", eval: 0.3, rationale: "Useful if legal IS the blocker. If legal is a proxy for cold-feet, the request will be deflected and the deprioritization will surface.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Accept the recipient's frame. Wait until Monday.", eval: -0.2, rationale: "Recipient resumes the lower-attention state.", atlasTags: []),
                PuzzleCandidate(text: "Manufactured pricing pressure on an event outside the recipient's control.", eval: -0.7, rationale: "Recipient absorbs the move as operator-side quota anxiety. Trust degrades.", atlasTags: ["scarcity"]),
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
                PuzzleCandidate(text: "Release schedule pressure entirely. Surface calendar-vs-content distinction.", eval: 0.8, rationale: "Champion's answer reveals whether the deal is procedurally deferred or has lost internal air cover. Either way, operator gets actionable information.", atlasTags: ["calibrated-question", "labeling"]),
                PuzzleCandidate(text: "Polite acceptance. Re-engage in Q3.", eval: -0.2, rationale: "No information gained. Operator misses the chance to distinguish calendar-deferral from priority-deferral.", atlasTags: []),
                PuzzleCandidate(text: "Multi-thread around the champion during their stated capacity constraint.", eval: 0.3, rationale: "Works if champion welcomes coverage, backfires if it reads as bypass. High-variance during capacity-limited window.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Manufactured pricing pressure plus a routing-around move to an unavailable stakeholder.", eval: -0.9, rationale: "Champion absorbs the move as operator self-interest overriding listening.", atlasTags: ["scarcity", "authority"]),
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
                PuzzleCandidate(text: "Pivot from defending past spend to mapping value into the recipient's evaluation framework.", eval: 0.7, rationale: "Branch offer signals operator understands the recipient's review is systematic, not personal. Value story re-orients to the new VP's actual KPIs.", atlasTags: ["calibrated-question", "alternative-choice"]),
                PuzzleCandidate(text: "Surface raw usage data. Defer the value report to after the call.", eval: 0.2, rationale: "Data without context. Numbers don't connect to the recipient's stated evaluation framework.", atlasTags: []),
                PuzzleCandidate(text: "Volunteer to do the recipient's evaluation work for them.", eval: -0.3, rationale: "The comparison will arrive but will not displace the recipient's own evaluation process. Lateral move with significant asymmetric cost.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Threat-framed consequence on a new stakeholder with no relationship equity.", eval: -1.2, rationale: "Recipient registers operator as escalating to consequence-pressure on first call.", atlasTags: ["loss-framing"]),
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
                PuzzleCandidate(text: "Supply information recipient lacked. Surface cyclical pattern + cost of re-buying at no-discount pricing.", eval: 0.7, rationale: "Operator accepts the framing and supplies information the CFO did not have. Cycle-data offer is concrete and audit-defensible.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Mid-range counter-offer (150 seats with a small per-seat adjustment).", eval: 0.1, rationale: "Reasonable counter; doesn't address the board narrative. CFO may accept and re-open the question next quarter.", atlasTags: ["anchor-with-range"]),
                PuzzleCandidate(text: "Generic peer benchmark. Recipient discounts aggregate stats.", eval: -0.2, rationale: "Generic benchmark to a CFO holding a specific board-asked question. Peer data cannot answer the actual constraint.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Pricing threat in response to a usage question.", eval: -0.6, rationale: "CFO marks operator as adversarial in a renewal where the relationship is otherwise positive. Risk of competitive exit increases.", atlasTags: []),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-two-copies"
        ),

        Puzzle(
            id: "p013", theme: .renewal, difficulty: 1700,
            buyerRole: "Champion being recruited elsewhere",
            setup: "Champion has hinted they may not be at the company at renewal time. Renewal in 60 days.",
            buyerLine: "Heads up. I've got an offer I'm probably taking. Renewal's in 60 days and the new person will want to look at things from scratch. Just so you can plan.",
            candidates: [
                PuzzleCandidate(text: "Multi-thread to the successor. Offer a structural concession that reduces switch cost.", eval: 0.7, rationale: "Operator absorbs the courtesy signal without pressuring the champion. Successor-friendly structure is a real concession reducing the new person's switching cost.", atlasTags: ["multi-threading", "calibrated-question"]),
                PuzzleCandidate(text: "Lock the renewal before the champion exits. Read as self-interest.", eval: -0.3, rationale: "Champion absorbs the move as self-interest. Successor may rip up the locked contract on first review anyway.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Multi-thread question only. No structural offer.", eval: 0.4, rationale: "Useful but transactional. Champion may share the name; the introduction is a separate step.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Reassurance without action.", eval: 0.0, rationale: "Champion absorbs the move as operator not registering the actual risk signal just provided.", atlasTags: ["social-proof"]),
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
                PuzzleCandidate(text: "Name two concrete process-owner failure modes matching the recipient's framing. Branch back to recipient.", eval: 0.7, rationale: "Concrete failure modes matching the operational (not technical) framing. Branch question reroutes the CFO into specifying which failure pattern applies.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Generic dismissal of recipient-specific concern (aggregate deployment stat).", eval: -0.4, rationale: "Aggregate statistic does not address the three prior incidents the CFO has named.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Route the question back to the champion in front of the CFO.", eval: -0.2, rationale: "Champion may not have process-owner-failure framing. Risk of deepening the CFO's hesitation.", atlasTags: []),
                PuzzleCandidate(text: "Vague answer implying recipient needs to do more discovery work.", eval: -0.5, rationale: "CFO absorbs the move as operator deflection.", atlasTags: []),
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
                PuzzleCandidate(text: "Name the specific governance failure modes the recipient is signaling for. Offer structural mitigation.", eval: 0.8, rationale: "Recipient experiences operator as audit-committee-literate. Structural offer routes the conversation into recipient's domain expertise.", atlasTags: ["calibrated-question", "authority", "labeling"]),
                PuzzleCandidate(text: "Generic peer-claim (many board-level customers, comfortable governance).", eval: -0.5, rationale: "Board directors have heard this from every vendor; absorb it as content-free.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Documentation offer (SOC2 + ISO + contractual templates).", eval: 0.3, rationale: "Necessary but insufficient. Recipient is asking about narrative risk, not documentation risk.", atlasTags: []),
                PuzzleCandidate(text: "Generic risk-low framing to a catastrophic-failure question.", eval: -1.0, rationale: "Operator signals lack of comprehension of the board director's actual job.", atlasTags: []),
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
                PuzzleCandidate(text: "Stack three procedural commitments in the current turn (MSA recipient, turnaround, calendar-locked signing call).", eval: 0.8, rationale: "Three simultaneous escalations reduce drift probability. 'While we're still on this call' converts champion-momentum into calendar-state.", atlasTags: ["mutual-close-plan", "alternative-choice"]),
                PuzzleCandidate(text: "Polite acknowledgment with a follow-up tomorrow.", eval: 0.1, rationale: "By tomorrow the champion is in three other meetings and the verbal yes has cooled.", atlasTags: []),
                PuzzleCandidate(text: "Skip the procurement frame. Push for signature today.", eval: -0.4, rationale: "Champion absorbs the move as operator not understanding the recipient's organization.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Continue selling after the verbal commit (more references, more case studies).", eval: -0.9, rationale: "Recipient registers operator as hedging. Creates retroactive uncertainty about the just-stated yes.", atlasTags: []),
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
                PuzzleCandidate(text: "Accept the policy context. Offer a structural alternative producing equivalent accountability without refund-accounting.", eval: 0.7, rationale: "Equivalent operator-side accountability without the refund-accounting overhead. Recipient experiences operator as policy-aware.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Counter-offer without acknowledging the policy framing (30 days, no refund).", eval: -0.3, rationale: "Procurement registers operator as not having listened to the policy framing.", atlasTags: ["anchor-with-range"]),
                PuzzleCandidate(text: "Calibrated question on a stated-policy clause late in the cycle.", eval: 0.4, rationale: "Structurally valid but introduces friction late in the cycle. Recipient may absorb it as last-minute renegotiation.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Takeaway frame on the final clause without credible BATNA.", eval: -0.5, rationale: "Works only if operator BATNA is credible. In final-call context with sunk pipeline cost, the threat reads as bluff.", atlasTags: ["takeaway"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "cardone-trial-close"
        ),

        // ─── Cold open (3) ──────────────────────────────────────────────
        Puzzle(
            id: "p018", theme: .coldOpen, difficulty: 1300,
            buyerRole: "VP at a target account who just answered the cold call",
            setup: "Cold call to a senior VP who actually picked up. You have eight seconds before they say 'not interested.'",
            buyerLine: "Hello?",
            candidates: [
                PuzzleCandidate(text: "Pattern-interrupt. Name the call type, hand time-control to the recipient.", eval: 0.7, rationale: "Names the call type explicitly, hands time-control to the recipient, removes scripted opener cues.", atlasTags: ["accusation-audit"]),
                PuzzleCandidate(text: "Scripted softening opener ('hope I'm not catching you at a bad time').", eval: -0.6, rationale: "Triggers the 'not a good time' reflex within four seconds.", atlasTags: []),
                PuzzleCandidate(text: "Personalization signal (LinkedIn post reference).", eval: 0.1, rationale: "Earns three additional seconds. Still reads as a sales-context wind-up; pattern recognition fires shortly after.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Yes/no qualifier giving the recipient an exit.", eval: -0.4, rationale: "If yes, operator hasn't earned the next sentence. If no, recipient hangs up.", atlasTags: []),
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
                PuzzleCandidate(text: "Named peer + specific outcome + concrete mechanism + explicit permission-to-disengage.", eval: 0.7, rationale: "Procurement lead absorbs the move as time-respectful. Specific outcome under the implicit time constraint.", atlasTags: ["social-proof", "concrete-construal"]),
                PuzzleCandidate(text: "Generic 'leading platform' claim with vague enterprise count.", eval: -0.5, rationale: "Procurement specialists discount aggregate enterprise claims by default.", atlasTags: ["social-proof", "authority"]),
                PuzzleCandidate(text: "Defer the value question to a one-pager artifact.", eval: -0.3, rationale: "Document handoff fails the implicit time constraint the recipient surfaced.", atlasTags: []),
                PuzzleCandidate(text: "Referral hand-off without substance.", eval: 0.0, rationale: "Recipient may grant a call out of courtesy; conversion to opportunity rate is low.", atlasTags: ["liking"]),
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
                PuzzleCandidate(text: "Invert demonstration to qualification. Compress remaining time if discovery confirms a specific path.", eval: 0.6, rationale: "Founder absorbs the move as time-respecting and homework-done. Demonstration frame flips into qualification frame.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Generic 'we help founders' opener plus deck walkthrough.", eval: -0.8, rationale: "Founder checks their phone before slide three.", atlasTags: []),
                PuzzleCandidate(text: "Disciplined two-minute version. Operator-led demonstration.", eval: 0.4, rationale: "Better than deck-walkthrough; worse than discovery-first because operator still owns the demonstration frame.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Scripted trial-close in the opening minute (1 to 10 scale).", eval: -0.4, rationale: "Founder pattern-matches to sales-coach training; pitch credibility degrades before content lands.", atlasTags: ["trial-close"]),
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
                PuzzleCandidate(text: "Decompose the $58k into the per-seat and per-event vectors the cap was written against. Test whether the cap is the binding constraint.", eval: 0.7, rationale: "Decomposition unbundles a flat number into operational vectors. The cap may be one vector, not the total. Recipient appraisal shifts from line-item rejection to constraint clarification.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Offer a 30% discount conditional on signing this week.", eval: -0.5, rationale: "Concession plus time pressure. Operator surrenders the anchor in the first turn and tags the move as scarcity-driven.", atlasTags: ["scarcity", "sharp-angle"]),
                PuzzleCandidate(text: "Match the cap. Move on.", eval: -0.8, rationale: "Cap absorbed as the price. Future negotiations recalibrate around it. ROI conversation lost without ever surfacing.", atlasTags: []),
                PuzzleCandidate(text: "Defer to a written proposal after the call.", eval: -0.4, rationale: "Live-moment friction transferred to a document review cycle. Champion has to re-mobilize the conversation.", atlasTags: []),
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
                PuzzleCandidate(text: "Surface the two assumptions doing the most leverage in the 22-month number. Test whether the holdco mandate counts soft-savings or only hard-savings.", eval: 0.8, rationale: "Routes the conversation toward methodology rather than discount. Finance VPs respect assumption-level interrogation because it's their daily mode.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Re-do the math, dropping soft-savings to compress to 18.", eval: -0.4, rationale: "Operator absorbs the recalc work without surfacing the soft-vs-hard distinction. Future ROI gets evaluated under the stricter rule unasked.", atlasTags: []),
                PuzzleCandidate(text: "Authority-anchor on a sister portfolio company that closed at 22 months.", eval: 0.2, rationale: "Reference may land if specific. More likely treated as anecdotal without the methodology branch.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Offer a one-quarter pilot to defer the payback question.", eval: -0.6, rationale: "Pilot defers the mandate without addressing it. Finance VP routes to procurement for pilot terms; cycle lengthens.", atlasTags: []),
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
                PuzzleCandidate(text: "Structure a flat fee for May-June at the per-month equivalent of a paid pilot, full rate starting July with credit applied. Surface the half-period split as already-budgeted.", eval: 0.8, rationale: "Re-routes net-new approval into within-period pilot spending which has different sign-off thresholds. Champion gets a path his finance partner can absorb.", atlasTags: ["concrete-construal", "alternative-choice"]),
                PuzzleCandidate(text: "Park the deal until July. Schedule re-engagement.", eval: -0.4, rationale: "Two-month gap is high-risk for momentum loss. Champion has to re-mobilize internal stakeholders.", atlasTags: []),
                PuzzleCandidate(text: "Offer a free trial through July with full pricing locked.", eval: -0.7, rationale: "Free trial trains the recipient on consumption without spending. Conversion drops when the meter starts.", atlasTags: []),
                PuzzleCandidate(text: "Push back on the OpEx framing. Cite the cost of delay.", eval: -0.5, rationale: "Pressure against a constraint the recipient surfaced. Champion gets caught between operator and finance.", atlasTags: ["loss-framing"]),
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
                PuzzleCandidate(text: "Ask what the $25k number is anchored to and whether the comparison set is delivering the outcome they're after.", eval: 0.6, rationale: "Surfaces the anchor's provenance. Often $25k is a competitor's published list price for a different scope.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Split the difference at $36k.", eval: -0.7, rationale: "Splits the anchor without testing it. Operator validates the $25k as the recipient's true expectation.", atlasTags: []),
                PuzzleCandidate(text: "Defend the $48k with feature parity to competitors.", eval: -0.3, rationale: "Feature-list reply commoditizes the conversation. Director routes to procurement for spec comparison.", atlasTags: []),
                PuzzleCandidate(text: "Drop to $25k. Commit on terms.", eval: -1.2, rationale: "Operator absorbs the recipient's first number as the price. Sets the precedent for every future expansion.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Re-frame the median number. Ask which two of the three are on the shortlist and what they scoped for.", eval: 0.8, rationale: "Median across a comparison set is statistically meaningless if the scope differs. Surfacing scope routes the comparison from price-per-seat to value-per-outcome.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Anchor to a $1.2M cost-of-failed-implementation paid by a peer who chose the cheaper vendor.", eval: 0.6, rationale: "Specific peer-failure anchor counters the median frame. Less effective than the scope-re-frame because CFO may discount as cherry-picked.", atlasTags: ["social-proof", "loss-framing"]),
                PuzzleCandidate(text: "Match the median. Conditional on signing this quarter.", eval: -0.6, rationale: "Surrenders the anchor and tags the move as quarter-end scarcity. CFO stores both as calibration points.", atlasTags: ["scarcity", "sharp-angle"]),
                PuzzleCandidate(text: "Defer to a custom ROI doc after the call.", eval: -0.4, rationale: "Live-moment leverage transferred to a doc review. Champion absorbs the work to re-engage.", atlasTags: []),
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
                PuzzleCandidate(text: "Re-frame from cost-of-software to cost-of-the-hire-this-replaces. Hand the recipient a defensible one-line for the owner.", eval: 0.7, rationale: "Owner's frame is already comparing to a hire. Operator gives the messenger ammunition that fits the owner's existing mental model.", atlasTags: ["contrast", "concrete-construal"]),
                PuzzleCandidate(text: "Suggest a face-to-face with the owner.", eval: 0.0, rationale: "Possible upside if owner is responsive, but bypasses the champion. Risk of damaging the messenger's standing.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Offer monthly billing to soften the annual number.", eval: -0.3, rationale: "Cash-flow gymnastic without re-framing the mental model. Owner sees the annualized number eventually.", atlasTags: []),
                PuzzleCandidate(text: "Discount to half. Sign today.", eval: -1.1, rationale: "Massive concession trains the recipient on operator's flexibility and tags the brand as discount-driven.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Map the three displaceable line items already in their stack. Hand the messenger a one-pager their finance partner can absorb without rework.", eval: 0.8, rationale: "Removes asymmetric work from the champion's plate. Displacement framing fits the finance constraint as stated. Champion routes upward with low friction.", atlasTags: ["concrete-construal", "reciprocity"]),
                PuzzleCandidate(text: "Push back. Argue the displacement frame undersells the value.", eval: -0.4, rationale: "Operator argues with a constraint the recipient surfaced. Champion gets caught in the cross-fire.", atlasTags: []),
                PuzzleCandidate(text: "Discount until the displacement gap closes.", eval: -0.6, rationale: "Operator absorbs the finance partner's frame as the price ceiling. Future expansion gets evaluated under the same rule.", atlasTags: []),
                PuzzleCandidate(text: "Suggest a procurement intro.", eval: -0.3, rationale: "Procurement intro before champion has the displacement story risks operator and procurement re-debating value.", atlasTags: []),
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
                PuzzleCandidate(text: "Decline the five-minute pitch. Ask which of the three categories of revenue-leak the CRO views as the single biggest 2026 risk. Map the response to specific outcome data.", eval: 0.8, rationale: "Re-frames a pitch contest into a diagnosis contest. CROs respond to diagnosis-first because it signals operator did the homework on their specific revenue equation.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Five-minute structured pitch with three customer outcomes.", eval: 0.3, rationale: "Acceptable but loses the diagnostic frame. Operator competes on demonstrated-outcome rather than fit-to-this-specific-CRO.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Five-minute structured pitch ending in trial-close.", eval: -0.4, rationale: "Trial close at five minutes signals operator wants the close more than the diagnosis. CRO routes to procurement for spec comparison.", atlasTags: ["trial-close"]),
                PuzzleCandidate(text: "Suggest the CRO take the meeting separately from the CFO.", eval: -0.3, rationale: "Bypasses the CFO who has joint sign-off. CFO routes to procurement to block.", atlasTags: []),
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
                PuzzleCandidate(text: "Compress to a 90-day deployment plan keyed to a specific Q3 metric the founder names. Tie payment terms to delivery milestones.", eval: 0.8, rationale: "Founder's frame is cash-out / cash-in across two quarters. Milestone-tied payments map the operator's risk to her risk.", atlasTags: ["concrete-construal", "commitment-consistency"]),
                PuzzleCandidate(text: "Defer the cash-flow question. Cite the lifetime ROI.", eval: -0.5, rationale: "Lifetime ROI doesn't survive a $480k burn-rate conversation. Founder mentally archives the operator as not-getting-it.", atlasTags: []),
                PuzzleCandidate(text: "Offer a quarter free.", eval: -0.3, rationale: "Free quarter delays the question but does not answer it. Founder still has to make the pay-for-itself math work in Q3.", atlasTags: []),
                PuzzleCandidate(text: "Pivot to a smaller-scope starter tier at $1.5k/month.", eval: 0.2, rationale: "Reduces the absolute number but may also reduce the outcome the founder needs to see by Q3. Conditional on the smaller tier still hitting the Q3 metric.", atlasTags: []),
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
                PuzzleCandidate(text: "Accept the cadence. Counter on contract length and net-15 invoice terms after each quarter ends.", eval: 0.6, rationale: "Accepts the binding constraint Treasury surfaced. Counter on adjacent levers (term length, net-payment) where Treasury has less policy.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "Push back on quarterly in arrears. Cite policy at our company.", eval: -0.4, rationale: "Policy-vs-policy contests rarely move treasuries; they have more authority than line vendors on cash policy.", atlasTags: []),
                PuzzleCandidate(text: "Accept quarterly in arrears at the same price.", eval: -0.5, rationale: "Cash-flow lever absorbed without compensating counter. Operator's NPV degrades silently.", atlasTags: []),
                PuzzleCandidate(text: "Walk. Re-tier means lost deal.", eval: -1.0, rationale: "Walking on cadence costs a multi-year deal when the underlying value math survives a 90-day NPV adjustment.", atlasTags: ["takeaway"]),
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
                PuzzleCandidate(text: "Provide the named-peer comparable and a one-line exit-impact statement tied to the multiple the sponsor pays for in this sector. Pre-package for memo insertion.", eval: 0.9, rationale: "Hands the Chief of Staff exactly the two artifacts the sponsor will ask for. Operator routes upward through the messenger's existing memo flow.", atlasTags: ["social-proof", "concrete-construal", "reciprocity"]),
                PuzzleCandidate(text: "Push the meeting to the sponsor directly.", eval: -0.2, rationale: "PE sponsors rarely take vendor meetings. Move costs the operator the messenger's goodwill.", atlasTags: []),
                PuzzleCandidate(text: "Defer to a generic ROI deck.", eval: -0.5, rationale: "Generic decks fail the memo format. Chief of Staff has to rewrite.", atlasTags: []),
                PuzzleCandidate(text: "Offer to write the memo yourself.", eval: 0.1, rationale: "Possible reciprocity gain; risk of memo voice mismatch. Defaults to providing structured inputs the messenger composes.", atlasTags: ["reciprocity"]),
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
                PuzzleCandidate(text: "Deliver MSA red-lines and security questionnaire on time. Defer BAFO until the SOW is final. Surface that BAFO before scope-final loses procurement signal.", eval: 0.7, rationale: "Sequence-routing acknowledges procurement's request while preserving the BAFO anchor. Strategic sourcing professionals respect operators who understand BAFO ordering.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Deliver all three on time with a 10% BAFO discount.", eval: -0.3, rationale: "Pre-emptive BAFO concession trains the procurement counterpart on operator's flexibility. Next round, they push for more.", atlasTags: []),
                PuzzleCandidate(text: "Deliver BAFO at list. MSA at standard. Questionnaire late.", eval: -0.5, rationale: "Late on a standard ask signals operator can't operate at procurement's tempo. Adds friction without compensating leverage.", atlasTags: []),
                PuzzleCandidate(text: "Push back. Argue BAFO is premature before SOW.", eval: 0.1, rationale: "Substance is correct but presentation as pushback rather than sequence-routing risks escalation.", atlasTags: []),
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
                PuzzleCandidate(text: "Confirm which two of the three operator has. Surface the third's actual scope (the program-specific subset) before committing to a timeline.", eval: 0.7, rationale: "Defense procurement compliance asks often overstate the scope. Surfacing the program-specific subset routes the conversation from full-compliance to in-scope-compliance.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Commit to full L3 in 90 days.", eval: -0.6, rationale: "Compliance timelines are unreliable to commit on the procurement call. Miss damages credibility more than the original gap.", atlasTags: []),
                PuzzleCandidate(text: "Offer a workaround using a partner who holds CMMC L3.", eval: 0.2, rationale: "Partner-mediated compliance is a legitimate path but requires procurement signoff on the assignment-of-rights structure. Conditional on procurement accepting.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Push back on the L3 requirement. Cite L2 sufficiency.", eval: -0.4, rationale: "Arguing with a compliance requirement signals operator does not understand the threat model. Procurement disengages.", atlasTags: []),
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
                PuzzleCandidate(text: "Acknowledge the template. Propose a hybrid where the $9 covers the operator-managed base and a separate platform-services line covers the delta. Reference the pilot data the analyst already has.", eval: 0.7, rationale: "Procurement templates are rigid on the line they cover. Re-organizing into compliant lines is a routine procurement move when the operator presents the structure.", atlasTags: ["alternative-choice", "concrete-construal"]),
                PuzzleCandidate(text: "Drop to $9. Eat the margin given the pilot success.", eval: -0.5, rationale: "Concedes the template as the price. Future renewals re-anchor downward.", atlasTags: []),
                PuzzleCandidate(text: "Defer to procurement leadership for an exception.", eval: -0.2, rationale: "Possible if a pre-existing exception path is known. Cold ask to procurement leadership without supporting structure underwhelms.", atlasTags: []),
                PuzzleCandidate(text: "Walk the pilot back as conditional. Threaten renewal.", eval: -1.0, rationale: "Threat after a year-long pilot reads as bad-faith. Procurement archives the relationship.", atlasTags: ["takeaway"]),
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
                PuzzleCandidate(text: "Accept uncapped indemnity scoped to IP and confidentiality only. Cap consequential damages at the deal value. Counter termination for convenience with 60-day notice and pro-rata refund. Surface each as the symmetric market position.", eval: 0.8, rationale: "Senior counsel respects operators who counter on legal-defensible market positions. Each counter is the recognized vendor counter for that ask.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "Accept all three.", eval: -1.0, rationale: "Uncapped consequential damages on a SaaS contract is an existence-level risk. Senior counsel stores compliance as a calibration point.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Reject all three. Stand on standard MSA.", eval: -0.4, rationale: "Stand-on-standard rarely survives senior counsel review. Negotiation collapses into MSA contests.", atlasTags: []),
                PuzzleCandidate(text: "Refer to internal counsel without operator response.", eval: -0.2, rationale: "Operator absent from the legal conversation cedes the operator-counter framing. Internal counsel concedes more than necessary.", atlasTags: []),
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
                PuzzleCandidate(text: "Ask which two of the four made the shortlist and what specific outcome the chain is solving for. Offer final-and-final scoped to that outcome, not to a feature parity sheet.", eval: 0.7, rationale: "Final-and-final on aggregate is a price contest. Final-and-final on outcome is a fit contest. Procurement specialists accept outcome-scoping because it produces defensible comparisons.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Deliver final-and-final at 15% below list.", eval: -0.5, rationale: "Pre-emptive concession; operator competes on price against four others without surfacing the scope.", atlasTags: []),
                PuzzleCandidate(text: "Walk. Cite that final-and-final on Thursday is unrealistic.", eval: -0.7, rationale: "Walking on tempo when the underlying business team is unenthused exits a winnable deal. Tempo can be negotiated; walk forecloses.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "Defer to legal review to slow the cycle.", eval: -0.3, rationale: "Process-delay tactics with procurement specialists get tagged immediately. Operator absorbs the credibility cost.", atlasTags: []),
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
                PuzzleCandidate(text: "Request the new scoring rubric. Tie any reduction to a specific weighting change. Surface the operator's higher score on the weights that didn't change.", eval: 0.7, rationale: "Procurement scoring shifts are usually procedural and defensible. Tying response to specific weight changes routes the conversation back to the rubric the procurement director defends.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Match the 7% reduction.", eval: -0.4, rationale: "Operator validates the new rubric without testing it. Future bids re-anchor to the lower number.", atlasTags: []),
                PuzzleCandidate(text: "Push back. Argue the original scoring was correct.", eval: -0.3, rationale: "Argues with a process the procurement director owns. Director routes the bid lower.", atlasTags: []),
                PuzzleCandidate(text: "Withdraw the bid. Position for the next RFP.", eval: -1.0, rationale: "Withdrawal forfeits the current opportunity and the relationship leverage. The next RFP rarely materializes on the predicted timeline.", atlasTags: ["takeaway"]),
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
                PuzzleCandidate(text: "Acknowledge the pattern recognition. Surface the one lever the CPO has not signaled (multi-year with price-lock and joint marketing offset) and ask what would make it worth their time to evaluate.", eval: 0.8, rationale: "CPO has signaled they've seen the standard discount tree. Operator surfaces a non-standard lever and asks for the CPO's value frame on it. Pattern-break.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Offer 22%. Sign-today plus three-year.", eval: -0.6, rationale: "Escalates the discount tree the CPO already named. Operator pattern-matched as predictable.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Push back. Argue the value justifies list.", eval: -0.4, rationale: "Value-justifies-list to a CPO who has signaled procurement readiness disengages.", atlasTags: []),
                PuzzleCandidate(text: "Walk. Cite that the deal isn't ready.", eval: -1.1, rationale: "Walking on a final call after business alignment forfeits sunk-cost. CPO archives the operator as unstable.", atlasTags: ["takeaway"]),
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
                PuzzleCandidate(text: "Provide two warm references in 24 hours. Surface that the third named peer is under NDA and offer a substitute peer in the same revenue band.", eval: 0.7, rationale: "Delivers on tempo and substance. Substitute peer with disclosed reason is a routine procurement substitution; named-NDA explanation is credible.", atlasTags: ["concrete-construal", "social-proof"]),
                PuzzleCandidate(text: "Promise all three in 48 hours.", eval: 0.1, rationale: "Possible upside if all three are accessible. Risk of one peer ghosting damages credibility.", atlasTags: []),
                PuzzleCandidate(text: "Defer. Cite reference fatigue.", eval: -0.6, rationale: "Reference fatigue is a real constraint but raised cold reads as evasion. Procurement coordinator escalates.", atlasTags: []),
                PuzzleCandidate(text: "Offer case studies in lieu.", eval: -0.4, rationale: "Case studies are publicly available and don't satisfy a named-peer ask. Procurement absorbs as non-responsive.", atlasTags: []),
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
                PuzzleCandidate(text: "Accept flat for one year; year two and three indexed to inflation with a 4% cap. Surface that flat-flat-flat over three years is below the carrier's own procurement inflation policy.", eval: 0.8, rationale: "Carrier procurement policies usually have inflation indexing on every multi-year contract. Surfacing the policy mismatch makes the counter the procurement manager's defensible position.", atlasTags: ["calibrated-question", "alternative-choice"]),
                PuzzleCandidate(text: "Accept flat across three years.", eval: -0.6, rationale: "Three-year flat absorbs inflation risk entirely on operator. NPV degrades silently.", atlasTags: []),
                PuzzleCandidate(text: "Decline. Force the RFP.", eval: -0.3, rationale: "RFP may be winnable but costs cycle time and incumbency credit. Conditional on confidence in re-winning.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "Counter with a 10% increase year one.", eval: -0.4, rationale: "10% bump on renewal triggers the RFP. Counter overshoots the procurement manager's tolerance.", atlasTags: []),
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
                PuzzleCandidate(text: "Re-frame the ask. Surface the next-month timeline against a specific milestone the VP named in the demo (campaign post-mortem, Q-end planning). Offer two 25-minute slots inside the campaign window.", eval: 0.7, rationale: "Push-to-next-month signals deprioritization. Tying the conversation to a milestone the VP herself owns re-anchors urgency without pressure.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Agree to push. Send calendar invite four weeks out.", eval: -0.4, rationale: "Accepts the push without testing the underlying signal. Probability of further push compounds.", atlasTags: []),
                PuzzleCandidate(text: "Send a takeaway email. Withdraw the proposal.", eval: -0.6, rationale: "Takeaway after one push reads as theatrical. VP rolls the move into her pattern-recognition file.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "Forward a case study to keep top of mind.", eval: -0.2, rationale: "Asymmetric work added with no live-moment leverage. Buyer absorbs as noise.", atlasTags: []),
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
                PuzzleCandidate(text: "Accusation audit: assume the worst and surface it. \"I imagine the pricing landed differently than you expected and you're probably thinking we're overpriced.\" Make space for the real signal.", eval: 0.7, rationale: "Accusation audit on a silence pattern surfaces the suppressed appraisal. Directors of Sales Ops respect operators who name what's likely true.", atlasTags: ["accusation-audit"]),
                PuzzleCandidate(text: "Send a follow-up with a 15% discount offer.", eval: -0.8, rationale: "Unilateral discount with no surfaced objection trains the recipient to silence as a price lever.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Send a check-in email asking when works.", eval: -0.4, rationale: "Generic check-in has near-zero re-engagement rate after two prior follow-ups.", atlasTags: []),
                PuzzleCandidate(text: "Forward a competitor comparison sheet.", eval: -0.5, rationale: "Adds work the recipient did not ask for. Reinforces silence as the path of least resistance.", atlasTags: []),
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
                PuzzleCandidate(text: "Offer a 20-minute joint call directly with the CFO this week. Frame as removing the calendar-friction the champion is absorbing.", eval: 0.7, rationale: "Champion is bottlenecked on CFO calendar access. Operator-mediated calendar request shifts the constraint to a path the champion cannot solve alone.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Send a CFO-targeted ROI doc for the champion to forward.", eval: 0.3, rationale: "Useful artifact but the champion is signaling calendar, not content, is the constraint.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Accept the next-week timeline. Schedule a follow-up.", eval: -0.4, rationale: "Three-week pattern continues. Each week the deal momentum decays.", atlasTags: []),
                PuzzleCandidate(text: "Push back on the delay. Ask whether this is still real.", eval: -0.5, rationale: "Champion is real; the calendar is the constraint. Push damages the champion relationship.", atlasTags: []),
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
                PuzzleCandidate(text: "Offer a 30-minute three-way call with both legal teams to walk through the open red-lines synchronously. Surface that round-three usually clears in a single sync session.", eval: 0.7, rationale: "Async legal cycles compound delay. Sync session is a routine path; surfacing the cycle-time data routes the conversation toward acceptance.", atlasTags: ["concrete-construal", "multi-threading"]),
                PuzzleCandidate(text: "Accept all open red-lines to clear legal immediately.", eval: -0.7, rationale: "Material legal concessions to clear a stall train the recipient on operator's flexibility. NPV degrades.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Escalate to the VP CS to pressure legal internally.", eval: 0.1, rationale: "Possible if the VP CS has the authority and appetite. Many do not; risk of damaging the relationship.", atlasTags: []),
                PuzzleCandidate(text: "Wait. Trust the process.", eval: -0.5, rationale: "Eight weeks of waiting with no surfaced friction signals operator does not understand legal cycle-mechanics.", atlasTags: []),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-haiti-how"
        ),

        Puzzle(
            id: "p045", theme: .stall, difficulty: 1300,
            buyerRole: "Director, mid-funnel, vague timeline",
            setup: "Director engaged in demo. Timeline cited as Q2 with no specifics.",
            buyerLine: "We're targeting Q2. Hard to be more specific until the planning cycle closes.",
            candidates: [
                PuzzleCandidate(text: "Ask one calibrated question about the planning cycle: what is the trigger that moves Q2 from intent to scheduled. Use the answer to map a pre-cycle artifact.", eval: 0.7, rationale: "Surfaces the trigger event. Planning cycles have specific trigger criteria; tying operator's next action to the trigger gets the operator into the cycle before procurement enters.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Accept Q2. Schedule a check-in in 30 days.", eval: -0.3, rationale: "Generic accept-and-defer with no information surfaced. Q2 stays vague.", atlasTags: []),
                PuzzleCandidate(text: "Pressure for a specific Q2 week.", eval: -0.5, rationale: "Pressure on a timeline the recipient surfaced as inherently vague signals operator does not respect the planning cycle.", atlasTags: []),
                PuzzleCandidate(text: "Send a generic Q2-readiness checklist.", eval: -0.2, rationale: "Asymmetric work; checklist arrives before the buyer is ready to act on it.", atlasTags: []),
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
                PuzzleCandidate(text: "Send a one-line takeaway message. \"It sounds like the timing didn't line up — I'll archive on our side unless you'd like to revisit.\" No further follow-ups for 30 days.", eval: 0.7, rationale: "Takeaway after four ignored follow-ups is the highest-information move available. C-suite recipients respond to permission-to-disengage at higher rates than to additional pressure.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "Send a fifth follow-up with new content.", eval: -0.5, rationale: "Fifth follow-up after four ignores reinforces the silence pattern. Recipient archives the operator.", atlasTags: []),
                PuzzleCandidate(text: "Escalate to the executive's chief of staff.", eval: -0.4, rationale: "Going around the executive damages the relationship and rarely produces re-engagement.", atlasTags: []),
                PuzzleCandidate(text: "Forward a peer reference to keep top of mind.", eval: -0.6, rationale: "Adds noise to a recipient who has signaled disengagement four times. Reduces re-engagement probability further.", atlasTags: []),
            ],
            bestIndex: 0,
            themeHint: "Takeaway after multiple ignored follow-ups is the highest-information move.",
            transcriptId: "cardone-yay-or-nay"
        ),

        Puzzle(
            id: "p047", theme: .stall, difficulty: 1600,
            buyerRole: "Procurement coordinator, delayed on security review",
            setup: "Security questionnaire submitted three weeks ago. No response.",
            buyerLine: "Security team is backed up. Probably another two weeks.",
            candidates: [
                PuzzleCandidate(text: "Offer to run a 30-minute walk-through of the questionnaire directly with the security reviewer. Frame as removing the document-review friction.", eval: 0.7, rationale: "Async security reviews compound delay. Live walk-throughs accelerate by replacing async document review with a synchronous-clarification cycle. Routine path that procurement coordinators accept.", atlasTags: ["multi-threading", "reciprocity"]),
                PuzzleCandidate(text: "Wait the two weeks. Schedule a follow-up.", eval: -0.3, rationale: "Acceptance without surfacing the cycle-time friction. Two-week estimate has high probability of slipping further.", atlasTags: []),
                PuzzleCandidate(text: "Send a competitor security comparison.", eval: -0.4, rationale: "Inappropriate vector; security review is internal and won't accept vendor-supplied competitor comparisons.", atlasTags: []),
                PuzzleCandidate(text: "Escalate to the procurement director.", eval: -0.2, rationale: "Escalation around the security team often slows the cycle further by introducing process arguments.", atlasTags: []),
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
                PuzzleCandidate(text: "Surface that headcount freezes typically don't cover existing operational tools and re-classify the deal as a productivity offset to the freeze. Provide a three-line CFO note framing the spend as freeze-mitigation.", eval: 0.7, rationale: "Headcount freezes are written against new hires, not against tooling that reduces hiring pressure. Re-classification is a routine procurement path that gives the champion ammunition.", atlasTags: ["contrast", "reciprocity"]),
                PuzzleCandidate(text: "Wait for the freeze to lift.", eval: -0.4, rationale: "Freezes commonly extend; waiting forfeits the verbal commit momentum.", atlasTags: []),
                PuzzleCandidate(text: "Offer a 50% discount to clear the freeze.", eval: -0.7, rationale: "Discount against a freeze that's not a price objection. Operator concedes margin without addressing the underlying classification.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Push back on the freeze framing.", eval: -0.5, rationale: "Pushing back on an internal policy the VP is operating under damages the champion relationship.", atlasTags: []),
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
                PuzzleCandidate(text: "Offer a 30-minute structured Q&A directly with the two skeptics. Surface that director-led internal selling rarely converts the skeptics without operator-mediated technical answers.", eval: 0.7, rationale: "Director's internal selling task carries asymmetric difficulty when the skeptics' objections are technical or specific. Direct Q&A converts at higher rates and frees the director from the asymmetric work.", atlasTags: ["multi-threading", "reciprocity"]),
                PuzzleCandidate(text: "Send a skeptic-targeted FAQ doc for the director to forward.", eval: 0.2, rationale: "Useful artifact but transfers the conversion work back to the director. Conditional on the director's appetite for that lift.", atlasTags: ["reciprocity"]),
                PuzzleCandidate(text: "Wait the week. Schedule a follow-up.", eval: -0.3, rationale: "Skeptic conversion attempts without operator support frequently fail. Week becomes two weeks.", atlasTags: []),
                PuzzleCandidate(text: "Push for the director to override the skeptics.", eval: -0.6, rationale: "Override damages the director's standing with their team. Damages the post-purchase rollout.", atlasTags: []),
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
                PuzzleCandidate(text: "Pre-package the board narrative for the CFO. Two-page memo, named-peer comparable, exit-impact line. Position so the CFO can present the spend as decision-ready when the cycle opens.", eval: 0.8, rationale: "Six-week board cycles compound risk. Pre-packaging means the CFO arrives at the cycle with a decision-ready memo, not a starting position. Routes operator into the board cycle through the messenger's existing workflow.", atlasTags: ["reciprocity", "concrete-construal", "social-proof"]),
                PuzzleCandidate(text: "Wait for the board cycle.", eval: -0.4, rationale: "Six weeks of passive waiting frequently sees deals deprioritized when the cycle opens. Other priorities surface.", atlasTags: []),
                PuzzleCandidate(text: "Push the CFO to approve outside the cycle.", eval: -0.6, rationale: "Pushing a CFO to bypass their own board process damages the relationship. CFO routes the deal lower.", atlasTags: []),
                PuzzleCandidate(text: "Offer a smaller pilot to clear pre-board approval.", eval: 0.1, rationale: "Pilots may clear smaller approval thresholds; risk of pilot becoming the perpetual state. Conditional on pilot-to-full path being structurally defined.", atlasTags: []),
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
                PuzzleCandidate(text: "Schedule a 45-minute joint technical session between the infra team and the operator's solutions engineer. Surface that auth-model questions resolve in one session 90% of the time when both teams have shared docs.", eval: 0.7, rationale: "Technical due-diligence stalls usually resolve in one sync session. Specifying the session shape and the 90% resolution rate routes the conversation toward acceptance.", atlasTags: ["concrete-construal", "multi-threading"]),
                PuzzleCandidate(text: "Send the auth-model documentation for async review.", eval: 0.1, rationale: "Async review extends cycle time. Possible if doc is exceptionally clear; default to sync.", atlasTags: []),
                PuzzleCandidate(text: "Push for verbal commit while the auth question is open.", eval: -0.6, rationale: "Verbal commit before technical resolution gets rescinded once the team flags the issue. VP Operations relationship degrades.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Offer a workaround that bypasses the auth question.", eval: -0.4, rationale: "Workaround without engaging the infra team's specific concern signals operator doesn't take the team's technical input seriously.", atlasTags: []),
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
                PuzzleCandidate(text: "Surface the three teams that haven't onboarded yet. Map a 60-day activation plan with weekly check-ins. Tie the seat-count conversation to the activation outcome.", eval: 0.7, rationale: "Usage flatness is usually an onboarding-gap problem, not a seat-count problem. Re-routing to activation reframes the renewal conversation from contraction to growth-recovery.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Offer a 30% seat-count reduction for the renewal.", eval: -0.6, rationale: "Pre-emptive contraction concession before surfacing the activation gap. NPV degrades and the customer learns silence as a price lever.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Push back. Cite contractual seat minimums.", eval: -0.5, rationale: "Contract-first pushback during a usage conversation damages the relationship. VP signals churn intent.", atlasTags: []),
                PuzzleCandidate(text: "Wait. Discuss at the renewal call in four months.", eval: -0.4, rationale: "Four months of unaddressed flat usage compounds the contraction signal. By renewal the conversation is harder.", atlasTags: []),
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
                PuzzleCandidate(text: "Acknowledge the renewal intent. Surface the year-one outcome data and propose a 12% price increase tied to year-two value-add modules. Frame as standard outcome-indexed pricing.", eval: 0.7, rationale: "Strong year-one outcomes are the renewal lever. Same-terms renewal leaves NPV on the table; outcome-indexed re-anchoring is the standard renewal move when the data supports it.", atlasTags: ["anchor-with-range", "concrete-construal"]),
                PuzzleCandidate(text: "Renew at same terms.", eval: -0.5, rationale: "Strong-year renewal at same terms gives away upside and trains the customer on flat pricing.", atlasTags: []),
                PuzzleCandidate(text: "Renew with a 20% discount as customer-loyalty thank-you.", eval: -1.0, rationale: "Unilateral discount on a strong-renewal call is anti-leveraged. Customer files the move under sales not understanding their own value.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Renew at same terms with a multi-year lock.", eval: 0.2, rationale: "Multi-year lock has some value but caps the upside captured. Conditional on the customer's stated multi-year intent.", atlasTags: []),
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
                PuzzleCandidate(text: "Surface the three switching costs (data migration, retraining, integration). Map them to specific dollars and weeks. Counter with a 4% increase against the multi-year value indexed to those costs.", eval: 0.7, rationale: "Renewal benchmarking ignores switching cost by default. Surfacing the specific dollars and weeks routes the procurement conversation toward total cost of switch, not new-vendor sticker.", atlasTags: ["loss-framing", "concrete-construal"]),
                PuzzleCandidate(text: "Match the 12% reduction.", eval: -0.6, rationale: "Concedes on the procurement benchmark without surfacing switching cost. Year four anchors lower.", atlasTags: []),
                PuzzleCandidate(text: "Pre-emptive 6% reduction to compromise.", eval: -0.4, rationale: "Splitting the procurement number trains the procurement counterpart on year-over-year erosion. Compounds across renewals.", atlasTags: []),
                PuzzleCandidate(text: "Engage business team to override procurement.", eval: -0.3, rationale: "Override damages procurement relationship and the underlying renewal-process integrity. Risk of business team being unable to deliver the override.", atlasTags: []),
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
                PuzzleCandidate(text: "Confirm the 40-seat target. Propose a co-term to the existing contract with a 30-day onboarding plan keyed to the VP's revenue target. Surface co-term as the lowest-friction path.", eval: 0.7, rationale: "Co-term consolidates billing on the existing renewal date and locks the expansion in. Lowest-friction path for an expanding customer.", atlasTags: ["concrete-construal", "commitment-consistency"]),
                PuzzleCandidate(text: "Wait for renewal. Bundle the expansion then.", eval: -0.4, rationale: "Eight-month wait during fast growth risks the customer adopting a competitor in parallel or right-sizing down later.", atlasTags: []),
                PuzzleCandidate(text: "Offer the 40 seats at a per-seat list rate.", eval: 0.0, rationale: "List rate is acceptable for expansion but misses the co-term opportunity. Functional but suboptimal.", atlasTags: []),
                PuzzleCandidate(text: "Discount the 40 seats to win the expansion fast.", eval: -0.5, rationale: "Customer is expanding because they need the product. Discount before requested erodes expansion margin.", atlasTags: []),
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
                PuzzleCandidate(text: "Re-discovery. Treat the new sponsor as a net-new prospect. 30-minute session to surface what they're trying to do, then map the tool's existing usage against their priorities. Frame as fresh-eyes review.", eval: 0.7, rationale: "Inherited sponsors are net-new buyers. Treating the renewal as a re-sale and earning the buy explicitly converts at higher rates than relying on history.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Send a year-one ROI summary.", eval: 0.2, rationale: "Useful but assumes the new sponsor cares about year-one numbers from a predecessor. Often they don't.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Offer a renewal discount to retain.", eval: -0.6, rationale: "Discount before re-discovery trains the new sponsor on the operator's flexibility. Cap shifts down structurally.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Escalate to a more senior executive.", eval: -0.5, rationale: "Going around the new sponsor poisons the working relationship. Renewal is the new sponsor's call.", atlasTags: []),
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
                PuzzleCandidate(text: "Acknowledge the specific three escalations with their resolution paths. Offer a 90-day named-support arrangement with weekly check-ins through the renewal window. Frame as a corrective sprint.", eval: 0.7, rationale: "Specific acknowledgement converts the abstract complaint into a discussable diagnosis. Named-support arrangement is a recognized recovery path that customer success directors accept.", atlasTags: ["labeling", "concrete-construal", "reciprocity"]),
                PuzzleCandidate(text: "Offer a 10% renewal discount to compensate.", eval: -0.3, rationale: "Discount-as-compensation buys time but does not address the underlying support quality. Year-two renewal recurs.", atlasTags: []),
                PuzzleCandidate(text: "Push back. Cite resolution times that met SLA.", eval: -0.6, rationale: "SLA-correct dismissals to a customer's perception complaint damage the relationship. Customer signals churn intent.", atlasTags: []),
                PuzzleCandidate(text: "Escalate to the operator's VP Support to apologize.", eval: 0.2, rationale: "Useful for serious cases; for three escalations, the named-support arrangement is more operational.", atlasTags: []),
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
                PuzzleCandidate(text: "Counter with consolidation. Surface two vendors in the operator's adjacent capability stack that could be replaced under a consolidated renewal. Frame as net-savings to the SaaS line.", eval: 0.7, rationale: "Cross-vendor consolidation converts a margin-compression conversation into an expansion conversation. Recognized CFO-friendly pattern when the operator's product map supports it.", atlasTags: ["alternative-choice", "contrast"]),
                PuzzleCandidate(text: "Match the 18% cut.", eval: -0.7, rationale: "Across-the-board cuts are board-mandated; meeting them line-for-line trains the CFO on operator's pure flexibility and re-anchors years three and four.", atlasTags: []),
                PuzzleCandidate(text: "Push back. Cite the year-one ROI.", eval: -0.4, rationale: "Year-one ROI doesn't survive a board-level cost-discipline directive. CFO archives as operator-doesn't-get-it.", atlasTags: []),
                PuzzleCandidate(text: "Offer the cut conditional on a three-year lock.", eval: 0.0, rationale: "Acceptable if the lock substantially exceeds the cut. Conditional structure depends on the math.", atlasTags: []),
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
                PuzzleCandidate(text: "Propose a 6% increase tied to the 40% usage growth and the operator's market-rate adjustment. Surface the usage data as the anchor.", eval: 0.6, rationale: "Usage-growth-tied price increase is a recognized renewal mechanism. Director already knows the usage growth; the operator's job is to map it to defensible pricing.", atlasTags: ["concrete-construal"]),
                PuzzleCandidate(text: "Renew at flat pricing.", eval: -0.3, rationale: "Flat renewal forfeits the value-growth increment. Customer is not signaling price sensitivity; operator's hesitation is self-imposed.", atlasTags: []),
                PuzzleCandidate(text: "Propose a 15% increase to capture the full usage growth.", eval: 0.0, rationale: "Aggressive but defensible. Risk of overshooting on a low-friction renewal that the director would have signed at 6%.", atlasTags: []),
                PuzzleCandidate(text: "Offer a multi-year lock at current pricing.", eval: -0.4, rationale: "Multi-year at current rates absorbs the value-growth opportunity into a static price. Customer takes the deal.", atlasTags: []),
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
                PuzzleCandidate(text: "Confirm the finding. Provide the specific remediation timeline (compensating control already deployed, full remediation by date). Offer a direct CISO-to-CISO call to walk the closure path.", eval: 0.8, rationale: "Security findings are remediation-path questions. Specificity (compensating control + date) and CISO-to-CISO routing convert security pressure into procedural confidence.", atlasTags: ["concrete-construal", "multi-threading"]),
                PuzzleCandidate(text: "Dispute the finding's materiality.", eval: -0.7, rationale: "Disputing a CISO-flagged finding signals operator does not respect the security process. Renewal goes to RFP.", atlasTags: []),
                PuzzleCandidate(text: "Defer the renewal until the finding closes.", eval: -0.3, rationale: "Defer-without-closure-plan extends the cycle and gives competitors entry. Conditional path; not the highest-information move.", atlasTags: []),
                PuzzleCandidate(text: "Offer a discount conditional on renewal before remediation.", eval: -0.5, rationale: "Discount tied to security risk is offensive to a CISO. Damages the security trust relationship.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Counter with bundled-feature uplift at flat pricing in year four, full market rate in year five. Use the year-four value-add as the upgrade ramp.", eval: 0.7, rationale: "Customer signals price-sensitivity at neutral usage. Bundled-feature uplift converts the renewal from a flat-price negotiation into a value-expansion conversation that justifies a year-five increase.", atlasTags: ["alternative-choice", "commitment-consistency"]),
                PuzzleCandidate(text: "Renew at same terms.", eval: -0.2, rationale: "Acceptable on a neutral-usage account but forfeits the upsell vector. Conditional on account priority.", atlasTags: []),
                PuzzleCandidate(text: "Push for a 10% increase, citing market.", eval: -0.5, rationale: "Market-based push against a customer who has signaled they cannot defend the increase damages the renewal probability.", atlasTags: []),
                PuzzleCandidate(text: "Offer a 5% discount as a year-three thank-you.", eval: -0.6, rationale: "Unilateral discount on a satisfied account is anti-leveraged. Customer files the operator under flexibility-by-default.", atlasTags: []),
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
                PuzzleCandidate(text: "Request a 30-minute meeting with the parent's procurement and IT to scope the consolidation specifically. Surface that the customer's deployment depth often makes them the surviving vendor in 60% of M&A consolidations when surfaced specifically.", eval: 0.7, rationale: "M&A consolidations are not predetermined; the surviving vendor often depends on deployment depth and integration cost. Surfacing the data and the meeting routes the conversation toward the operator's strongest ground.", atlasTags: ["concrete-construal", "social-proof", "multi-threading"]),
                PuzzleCandidate(text: "Accept the consolidation. Negotiate exit terms.", eval: -0.5, rationale: "Premature acceptance forfeits the consolidation negotiation entirely. Operator may be the surviving vendor if surfaced.", atlasTags: []),
                PuzzleCandidate(text: "Offer a 25% discount to retain.", eval: -0.6, rationale: "Discount-to-retain in an M&A consolidation rarely changes the outcome and trains the customer on discount-at-renewal.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Wait. Re-engage post-integration.", eval: -0.4, rationale: "M&A integration timelines compound risk. Waiting frequently sees the consolidation default to the parent's vendor.", atlasTags: []),
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
                PuzzleCandidate(text: "Defer to the champion to summarize the problem first. Position operator to fill in the cost-of-current-state and outcome-data once the champion has anchored on the problem.", eval: 0.7, rationale: "CFO trusts the champion more than the operator on problem-statement. Champion-first ordering uses the operator's credibility on outcome-data once the problem is established.", atlasTags: ["multi-threading", "calibrated-question"]),
                PuzzleCandidate(text: "Operator-led structured pitch with full ROI walk-through.", eval: -0.2, rationale: "Skips the champion's social credibility with the CFO. Operator competes on raw pitch in front of a hostile decision-maker.", atlasTags: []),
                PuzzleCandidate(text: "Push the meeting to a 1:1 with the CFO offline.", eval: -0.3, rationale: "Bypasses the champion who has invested in the process. Damages the multi-thread.", atlasTags: []),
                PuzzleCandidate(text: "Ask the CFO what would justify the spend.", eval: 0.2, rationale: "Possible if CFO is responsive; can flip into a fishing-expedition appearance if asked cold without champion anchoring.", atlasTags: ["calibrated-question"]),
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
                PuzzleCandidate(text: "Send a structured side-by-side scoped to the three outcomes the champion has internally agreed are the decision criteria. Lead with the criteria the champion's preferred solution wins on; concede where competitor wins, with brief notes on materiality.", eval: 0.7, rationale: "Side-by-side neutrality earns CFO trust. Champion-coordinated criteria framing earns the win on the dimensions that matter. Concession-where-honest signals operator credibility.", atlasTags: ["concrete-construal", "contrast"]),
                PuzzleCandidate(text: "Send a side-by-side that frames operator as winning every category.", eval: -0.5, rationale: "Unanimous-win comparisons get discounted by CFOs as marketing. Damages the champion's standing.", atlasTags: []),
                PuzzleCandidate(text: "Decline the side-by-side. Argue the champion's preference should stand.", eval: -0.7, rationale: "CFOs respond to structured comparisons; refusing one signals operator's data won't hold up. CFO defaults to the competitor.", atlasTags: []),
                PuzzleCandidate(text: "Send the side-by-side directly to the CFO without coordinating with the champion.", eval: -0.6, rationale: "Bypasses the champion. Champion loses standing and may reverse the recommendation.", atlasTags: []),
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
                PuzzleCandidate(text: "Re-discovery, scoped to the CRO. 30-minute session anchored to the CRO's revenue equation. Do not assume the champion's framing transfers.", eval: 0.7, rationale: "Late-stage stakeholders are net-new buyers. Operator that re-discovers with the CRO and earns the buy explicitly converts at higher rates than relying on champion handoff.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Push the champion to defend the operator's case to the CRO.", eval: -0.3, rationale: "Asymmetric work on the champion in front of their boss. Champion's standing degrades.", atlasTags: []),
                PuzzleCandidate(text: "Forward a CRO-targeted case study.", eval: -0.2, rationale: "Generic case study sent without re-discovery underwhelms a CRO. Operator absorbed as not-doing-the-homework.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Offer a 25% discount to clear the late-stakeholder friction.", eval: -0.6, rationale: "Discount to a new stakeholder before re-discovery trains them on operator's discount-by-default. Cap shifts down.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Surface the specific integration risk the blocker is naming. Map it to two specific resolutions (architectural change + integration-services scope). Offer a follow-up technical session with their infra lead.", eval: 0.7, rationale: "Blockers' objections are specific. Generic reassurance reinforces the block; specific resolution paths convert.", atlasTags: ["calibrated-question", "concrete-construal", "multi-threading"]),
                PuzzleCandidate(text: "Push the two-vote majority through the decision.", eval: -0.7, rationale: "Forcing a 2-1 decision against a stated blocker poisons the post-purchase rollout. The blocker has the operator on their list.", atlasTags: []),
                PuzzleCandidate(text: "Wait. Let the champion convert the blocker.", eval: -0.3, rationale: "Champion-to-blocker conversion attempts on technical objections without operator support frequently fail. Conditional on the blocker's specific concern.", atlasTags: []),
                PuzzleCandidate(text: "Send the blocker a technical FAQ.", eval: -0.2, rationale: "FAQ assumes the blocker's question is on the FAQ. Specific risks require specific resolutions.", atlasTags: []),
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
                PuzzleCandidate(text: "Confirm the specific region and the data-residency architecture. Surface the SOC2 control reference for the residency claim. Offer a 30-minute joint architectural review with their security team.", eval: 0.8, rationale: "CISOs convert on specificity (region + control reference + architectural review). Vague residency claims to a skeptical CISO are immediately filed under operator-doesn't-know.", atlasTags: ["concrete-construal", "multi-threading"]),
                PuzzleCandidate(text: "Defer the residency question to a follow-up doc.", eval: -0.5, rationale: "Deferred specificity to a security audience signals operator does not have the answer ready. CISO routes to procurement to block.", atlasTags: []),
                PuzzleCandidate(text: "Offer an enclaved-deployment option.", eval: 0.2, rationale: "Possible architectural path; risk of overpromising a deployment model that doesn't exist. Conditional on actual product capability.", atlasTags: []),
                PuzzleCandidate(text: "Push the executive to overrule the CISO's concern.", eval: -1.0, rationale: "Executives do not overrule CISOs on data-residency questions. Damages both relationships.", atlasTags: []),
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
                PuzzleCandidate(text: "Surface the specific path the committee will follow. Ask who needs what data when. Offer to provide each committee member with a tailored one-page brief 24 hours before the committee meets.", eval: 0.7, rationale: "Process-driven committee chairs respect operators who understand committee mechanics. Pre-meeting tailored briefs reduce committee friction and give the operator a per-member articulation surface.", atlasTags: ["calibrated-question", "multi-threading", "reciprocity"]),
                PuzzleCandidate(text: "Accept the two-week timeline.", eval: -0.3, rationale: "Generic accept-and-wait forfeits the committee-cycle insertion opportunity. Two weeks frequently slip.", atlasTags: []),
                PuzzleCandidate(text: "Push the chair for a faster decision.", eval: -0.5, rationale: "Pressuring a process-driven chair on tempo damages the chair relationship. Chair routes the deal lower.", atlasTags: []),
                PuzzleCandidate(text: "Forward a generic committee deck.", eval: -0.2, rationale: "Generic deck assumes the committee is one audience. Per-member briefs convert at higher rates.", atlasTags: []),
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
                PuzzleCandidate(text: "Re-route. Surface that the political cost is a face-saving constraint and propose a structured POV where both vendors run in parallel against a published rubric. Champion's boss saves face by following the data.", eval: 0.7, rationale: "Political constraints are face-saving constraints. POV-with-rubric creates a face-saving exit for the champion's boss. Routes the conversation from public-reversal to data-following.", atlasTags: ["concrete-construal", "alternative-choice"]),
                PuzzleCandidate(text: "Push the champion to escalate.", eval: -0.7, rationale: "Forcing a champion to challenge their boss on a public position destroys the champion.", atlasTags: []),
                PuzzleCandidate(text: "Wait for the political constraint to fade.", eval: -0.5, rationale: "Political positions calcify with time, not fade. Waiting forfeits the deal.", atlasTags: []),
                PuzzleCandidate(text: "Match the competitor's price.", eval: -0.4, rationale: "Price is not the issue; face-saving is. Discount does not address the structural objection.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Propose a 60/40 split aligned to the use-case weight, with named budget owners on each side. Surface that joint-budget deals close 30% faster when the split is operator-recommended in writing.", eval: 0.7, rationale: "Joint-budget deals frequently stall on which budget. Operator-recommended split with named owners gives champions a shared decision they can absorb upward in their respective lines.", atlasTags: ["concrete-construal", "alternative-choice"]),
                PuzzleCandidate(text: "Let the champions sort the budget split themselves.", eval: -0.4, rationale: "Champions delegating to each other on budget questions frequently produces internal friction. Operator's silence is a missed coordination opportunity.", atlasTags: []),
                PuzzleCandidate(text: "Push for one champion to own the full budget.", eval: -0.3, rationale: "Single-owner deals close faster but require one champion to absorb the political cost. Damages the under-funded champion's role.", atlasTags: []),
                PuzzleCandidate(text: "Discount to soften the joint-budget concern.", eval: -0.5, rationale: "Joint-budget isn't a price objection. Discount misreads the constraint.", atlasTags: []),
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
                PuzzleCandidate(text: "Request the procurement's TCO model. Surface the two assumptions doing the most leverage (typically year-three implementation cost and switching premium). Offer revised inputs sourced from named-peer data.", eval: 0.7, rationale: "Procurement TCO models have assumptions. Surfacing the assumptions with named-peer data routes the procurement conversation from advocacy to methodology refinement. Procurement professionals respect this.", atlasTags: ["calibrated-question", "social-proof", "concrete-construal"]),
                PuzzleCandidate(text: "Push the business team to overrule procurement.", eval: -0.5, rationale: "Business team override damages the procurement relationship and the underlying decision-process integrity.", atlasTags: []),
                PuzzleCandidate(text: "Match the competitor's price to neutralize procurement's recommendation.", eval: -0.4, rationale: "Match-to-clear trains procurement on operator's full flexibility. Future deals re-anchor.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Escalate to a senior business executive.", eval: -0.2, rationale: "Possible if executive sponsorship is real; risk of poisoning procurement. Conditional path.", atlasTags: []),
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
                PuzzleCandidate(text: "Schedule a 45-minute working session with the Director scoped to their daily workflow specifically. Map the operator's product to the Director's workflow step-by-step. Surface that adoption-success correlates with end-user-champion conversion above C-suite mandate.", eval: 0.7, rationale: "C-suite mandates without end-user buy-in produce shelfware. Earning the Director's buy through workflow-specific mapping is the high-leverage move; convertshelfware risk and creates the daily advocate.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Push the CEO to mandate the Director's adoption.", eval: -0.7, rationale: "Mandated adoption is the standard path to shelfware. Director becomes an internal opponent.", atlasTags: []),
                PuzzleCandidate(text: "Send a workflow comparison doc.", eval: 0.1, rationale: "Document assumes the Director will read it sympathetically. Working session converts at higher rates.", atlasTags: []),
                PuzzleCandidate(text: "Discount to neutralize the Director's concerns.", eval: -0.6, rationale: "Director's concerns are workflow-shaped, not price-shaped. Discount misreads the constraint.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Surface the build-vs-buy economics in three dimensions: time-to-deploy, total cost of internal engineering, and opportunity cost of redirected engineering talent. Provide the champion with a one-page brief and named-peer references where internal builds were abandoned.", eval: 0.7, rationale: "Build-vs-buy contests turn on engineering opportunity cost more than direct cost. Specific named-peer abandonment data provides the champion with a brief their CEO will absorb.", atlasTags: ["loss-framing", "social-proof", "concrete-construal"]),
                PuzzleCandidate(text: "Match the build's implied cost with a deep discount.", eval: -0.4, rationale: "Build advocacy is rarely price-driven; matching the implied build cost rewards the wrong path.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Push the CEO to overrule the build pitch.", eval: -0.6, rationale: "Direct executive override damages the champion and the VP-peer relationship. Conditional path that rarely lands cleanly.", atlasTags: []),
                PuzzleCandidate(text: "Wait. See if the build initiative collapses on its own.", eval: -0.5, rationale: "Internal builds with executive support survive scrutiny longer than expected. Passive waiting forfeits the deal.", atlasTags: []),
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
                PuzzleCandidate(text: "Surface the rubric. Offer to schedule 30-minute working sessions with each function leader to walk through how the operator maps to their function's specific metric. Frame as committee-process-acceleration.", eval: 0.7, rationale: "Cross-functional committees converge faster when each function leader sees the operator-to-their-metric mapping. Operator routes through the committee process by reducing each leader's evaluation lift.", atlasTags: ["multi-threading", "reciprocity", "concrete-construal"]),
                PuzzleCandidate(text: "Send a single deck targeted at the joint committee.", eval: 0.0, rationale: "Joint deck assumes the committee evaluates jointly. Independent scoring requires per-function content.", atlasTags: []),
                PuzzleCandidate(text: "Push for an accelerated decision before next month.", eval: -0.4, rationale: "Pressuring a committee on tempo damages the process credibility. Committee chair routes the deal lower.", atlasTags: []),
                PuzzleCandidate(text: "Wait for the convening. Trust the process.", eval: -0.3, rationale: "Passive waiting forfeits the per-function articulation opportunity. Committee may converge on a competitor.", atlasTags: []),
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
                PuzzleCandidate(text: "Mutual close plan with named owners and dates. Sign-off, kick-off, named onboarding lead. Surface that mutual close plans reduce post-verbal-commit slippage by 50%+ in operator's data.", eval: 0.7, rationale: "Verbal commit to signature has 20-30% slippage without a mutual close plan. Named-owners-and-dates structure removes ambiguity and creates joint accountability.", atlasTags: ["mutual-close-plan", "commitment-consistency"]),
                PuzzleCandidate(text: "Send the paperwork. Wait for signature.", eval: -0.3, rationale: "Passive waiting accepts the slippage rate as given. No leverage on tempo or scope.", atlasTags: []),
                PuzzleCandidate(text: "Pressure the champion for an earlier signature.", eval: -0.4, rationale: "Pressure post-verbal-commit damages the champion relationship. Champion has signaled the path.", atlasTags: []),
                PuzzleCandidate(text: "Offer a kickoff bonus contingent on signing this week.", eval: -0.5, rationale: "Bonus signaling at endgame trains the champion on operator's flexibility just before close. Damages the post-purchase dynamic.", atlasTags: ["sharp-angle", "scarcity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-two-copies"
        ),

        Puzzle(
            id: "p076", theme: .endgame, difficulty: 1700,
            buyerRole: "Late-stage redline on indemnity scope",
            setup: "Final legal review. One open issue.",
            buyerLine: "[legal] We need IP indemnity uncapped. Everything else looks good.",
            candidates: [
                PuzzleCandidate(text: "Accept uncapped IP indemnity scoped to the specific named IP (the operator's underlying patents and copyrights). Counter requires symmetric obligations on customer-supplied content. Surface this as the symmetric market position.", eval: 0.7, rationale: "Uncapped IP indemnity is a recognized vendor concession when scoped to operator-owned IP. Symmetric customer-obligation is the standard counter that survives legal review.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "Accept uncapped IP indemnity without scope.", eval: -0.8, rationale: "Unscoped uncapped IP indemnity exposes operator to indirect-IP claims via customer-supplied content. Existence-level risk.", atlasTags: []),
                PuzzleCandidate(text: "Reject uncapped IP indemnity. Stand on capped.", eval: -0.3, rationale: "Final-redline pure rejection often blocks signature. Conditional on the customer's legal posture.", atlasTags: []),
                PuzzleCandidate(text: "Defer the IP indemnity question to a side letter.", eval: -0.4, rationale: "Side-letter on a final redline extends the cycle. Legal teams resist side-letter scopes.", atlasTags: []),
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
                PuzzleCandidate(text: "Counter with a 3% concession contingent on extending term length by 12 months and a published case study clause. Surface that the 5% number is round-number procurement-theater.", eval: 0.7, rationale: "5% asks at endgame are procurement-theater (round-number negotiation closures). Counter with structurally-different concession produces a defensible compromise without surrendering the anchor as theater.", atlasTags: ["alternative-choice", "anchor-with-range"]),
                PuzzleCandidate(text: "Match the 5%.", eval: -0.4, rationale: "Round-number concession at endgame trains procurement on operator's flexibility. Future renewals re-anchor.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Refuse. Walk back to committee.", eval: -0.6, rationale: "Walking back at endgame on 5% forfeits sunk-cost. Committee re-opens decision and may default to a competitor.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "Match the 5% conditional on signing today.", eval: -0.2, rationale: "Time-pressure plus full concession is the procurement-trained discount tree. Procurement absorbs the move as predictable.", atlasTags: ["sharp-angle", "scarcity"]),
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
                PuzzleCandidate(text: "Offer to pre-stage signature on the operator side. Provide a one-click DocuSign envelope and a single named owner on the customer side who can sign on return. Reduce friction to zero.", eval: 0.7, rationale: "Holiday-delayed signatures slip 40%+ in operator's data when no friction reduction is staged. Pre-staged signature with a named owner is a routine endgame insurance move.", atlasTags: ["concrete-construal", "commitment-consistency"]),
                PuzzleCandidate(text: "Accept the two-week delay.", eval: -0.3, rationale: "Generic accept-and-wait accepts the slippage rate. Possible deals collapse over a holiday-extended deferral.", atlasTags: []),
                PuzzleCandidate(text: "Pressure the champion to sign before holiday.", eval: -0.4, rationale: "Pressure on a personal-time constraint damages the champion relationship.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "Offer a discount conditional on pre-holiday signature.", eval: -0.5, rationale: "Time-pressure discount at endgame trains the champion on operator's flexibility. Sets a year-two re-anchor.", atlasTags: ["sharp-angle", "scarcity"]),
            ],
            bestIndex: 0, themeHint: nil,
            transcriptId: "voss-two-copies"
        ),

        Puzzle(
            id: "p079", theme: .endgame, difficulty: 2000,
            buyerRole: "Endgame politics: customer's general counsel inserting new clauses",
            setup: "Last week of cycle. GC opens new clauses not raised in red-lines.",
            buyerLine: "[GC] We need a most-favored-nation clause, a unilateral price-cap, and a competitor non-compete.",
            candidates: [
                PuzzleCandidate(text: "Accept the unilateral price-cap scoped to year-over-year increases above a 6% threshold (operator-standard tolerance). Reject the MFN and competitor non-compete as market-non-standard. Position each rejection with the named-peer enterprise norm.", eval: 0.7, rationale: "MFN and competitor non-compete are non-standard customer asks that vendors universally reject. Scoped price-cap acceptance is a normal market concession. Differentiating signals operator's market knowledge.", atlasTags: ["alternative-choice", "concrete-construal"]),
                PuzzleCandidate(text: "Accept all three.", eval: -1.2, rationale: "MFN, non-compete, and unilateral price-cap together hand the customer asymmetric leverage forever. Existence-level NPV degradation.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Reject all three.", eval: -0.5, rationale: "Blanket rejection at endgame stalls the deal. Customer's GC asks include legitimate price-cap territory.", atlasTags: []),
                PuzzleCandidate(text: "Defer the clauses to a side letter.", eval: -0.4, rationale: "Side-letter on three clauses delays the close and may collapse. Legal teams resist side-letter complexity.", atlasTags: []),
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
                PuzzleCandidate(text: "Offer to draft the internal-routing email and the legal-handoff doc on the champion's behalf. Frame as removing the asymmetric work the champion is absorbing.", eval: 0.7, rationale: "Verbal-commit-to-paperwork stalls are usually internal-routing friction. Removing the work from the champion's plate is a standard endgame intervention.", atlasTags: ["reciprocity", "concrete-construal"]),
                PuzzleCandidate(text: "Wait. Accept the this-week timeline.", eval: -0.4, rationale: "Generic accept-and-wait accepts the stall pattern. Each week the deal momentum decays.", atlasTags: []),
                PuzzleCandidate(text: "Pressure the champion to escalate internally.", eval: -0.5, rationale: "Escalation pressure on a champion who has lost momentum damages the relationship. Champion's standing may be already compromised.", atlasTags: []),
                PuzzleCandidate(text: "Offer a deal-incentive contingent on this-week signature.", eval: -0.5, rationale: "Endgame discount on operator-initiated pressure trains the champion on operator's flexibility. Damages post-purchase dynamic.", atlasTags: ["sharp-angle", "scarcity"]),
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
                PuzzleCandidate(text: "Acknowledge the requirement. Offer to provide the named VP-level signer with a 15-minute briefing on the deal at their convenience. Frame as reducing their review load.", eval: 0.7, rationale: "Procurement-inserted additional signers are standard endgame friction. Offering a briefing reduces the VP's review time and gives the operator a pre-decision articulation surface.", atlasTags: ["multi-threading", "reciprocity"]),
                PuzzleCandidate(text: "Push the procurement counterpart to waive the additional signer.", eval: -0.4, rationale: "Procurement rarely waives process requirements; pushing creates an adversarial relationship for the post-purchase phase.", atlasTags: []),
                PuzzleCandidate(text: "Accept the two-week delay passively.", eval: -0.3, rationale: "Passive acceptance forfeits the briefing-opportunity to shape the VP's decision frame.", atlasTags: []),
                PuzzleCandidate(text: "Offer a discount contingent on bypassing the additional signer.", eval: -0.7, rationale: "Suggesting a process bypass to procurement is offensive to procurement professionalism. Damages the relationship.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Accusation audit. Surface the suppressed appraisal directly: budget pulled, competitor entered, executive intervention. Make space for the real signal in one outreach. Then takeaway-if-no-response.", eval: 0.7, rationale: "Late-stage silence after verbal commit signals one of three specific events. Naming them invites the champion to respond with the truth and re-opens the conversation.", atlasTags: ["accusation-audit", "takeaway"]),
                PuzzleCandidate(text: "Continue follow-ups at 3-day intervals.", eval: -0.5, rationale: "Continued follow-ups without surfacing the suppressed signal reinforce the silence pattern. Champion archives the operator.", atlasTags: []),
                PuzzleCandidate(text: "Escalate to a senior executive on the customer side.", eval: -0.4, rationale: "Going around a silent champion damages the relationship and rarely produces re-engagement. Conditional on relationship depth.", atlasTags: []),
                PuzzleCandidate(text: "Offer a deal-saving discount unilaterally.", eval: -0.8, rationale: "Discount offered into silence with no surfaced objection trains every future champion that silence is the lever.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Accept net-60 as the midpoint. Counter with a price-adjustment indexing the difference to operator's working-capital cost. Frame as the symmetric NPV-neutral position.", eval: 0.7, rationale: "Payment term concession is an NPV transfer. Mid-point counter with cost-indexed price adjustment is the standard operator response.", atlasTags: ["anchor-with-range", "concrete-construal"]),
                PuzzleCandidate(text: "Accept net-90 at the same price.", eval: -0.5, rationale: "Payment term extension is silent NPV degradation. Operator absorbs the working-capital cost without compensating counter.", atlasTags: []),
                PuzzleCandidate(text: "Refuse net-90. Stand on net-30.", eval: -0.3, rationale: "Pure refusal at endgame on a standard customer ask stalls the deal. Counter with concession-with-counter is higher-leverage.", atlasTags: []),
                PuzzleCandidate(text: "Match net-90 conditional on autopay.", eval: 0.3, rationale: "Autopay reduces collection cost but doesn't address the working-capital cost. Useful adjunct, not the primary counter.", atlasTags: []),
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
                PuzzleCandidate(text: "Counter with 4% conditional on Friday signature, term length extended by 6 months, and a published case-study clause. Surface that each concession includes a structurally-different lever, not just a number.", eval: 0.7, rationale: "Endgame final-asks are procurement's last-shot tactics. Multi-lever counter preserves the price anchor while giving procurement a face-saving win.", atlasTags: ["alternative-choice", "scarcity"]),
                PuzzleCandidate(text: "Accept 7% conditional on Friday signature.", eval: -0.4, rationale: "Single-lever concession at the procurement's number trains them on operator's flexibility. Year-two anchors lower.", atlasTags: ["sharp-angle", "scarcity"]),
                PuzzleCandidate(text: "Refuse all concession. Call procurement's bluff.", eval: -0.6, rationale: "Calling procurement's bluff at endgame on a winnable ask risks the deal. Conditional on confidence in procurement's posture.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "Offer 7% with no conditions.", eval: -0.7, rationale: "Unconditional concession is the worst variant. Procurement records both the concession and the lack of counter.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Provide a one-page CFO memo with: outcome data tied to the operator's value claim, a named peer comparable in the same revenue band, and a one-line risk-mitigation statement. Pre-format for memo insertion.", eval: 0.8, rationale: "Champion explicitly asks for asymmetric work absorption. Pre-packaged CFO memo gives them the artifact and reduces the cognitive load between commit and signature.", atlasTags: ["reciprocity", "social-proof", "concrete-construal"]),
                PuzzleCandidate(text: "Offer a direct CFO meeting.", eval: 0.4, rationale: "Useful if CFO is responsive; risk of bypassing the champion's internal positioning. Conditional on champion's preference.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Send a generic ROI deck.", eval: -0.2, rationale: "Generic deck assumes the champion will repackage. Misses the explicit-request opportunity.", atlasTags: []),
                PuzzleCandidate(text: "Defer to the champion's judgment without offering material.", eval: -0.5, rationale: "Champion asked for help; non-response is non-responsive. Champion absorbs the cognitive load alone.", atlasTags: []),
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
                PuzzleCandidate(text: "Accept the right-to-evaluate as a stated business right. Counter with a 30-day notice obligation before any active competitor evaluation begins. Frame as symmetric process clarity.", eval: 0.7, rationale: "Right-to-evaluate is a routine customer ask that costs operator little if scoped with notice. Symmetric notice obligation provides the operator with reaction-time during the term.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "Reject the clause. Stand on standard MSA.", eval: -0.4, rationale: "Customers' right-to-evaluate is implicit; refusing the clause signals operator insecurity. Damages credibility.", atlasTags: []),
                PuzzleCandidate(text: "Accept the clause without scope.", eval: -0.3, rationale: "Unscoped right-to-evaluate gives the customer permission to run parallel pilots without notice. Operator loses reaction time.", atlasTags: []),
                PuzzleCandidate(text: "Offer a price discount in exchange for clause removal.", eval: -0.6, rationale: "Discount-for-clause-removal signals operator believes the clause is high-cost. Customer routes the clause back in at renewal.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Re-position. Treat the new CFO as a net-new buyer; pre-package the decision memo with named-peer references and the existing approval rationale. Frame as decision-ready, not decision-pending.", eval: 0.7, rationale: "Inherited executives are net-new buyers at endgame. Pre-packaged decision-ready memo with the approval-rationale carry-forward reduces the new CFO's review lift and the slippage probability.", atlasTags: ["reciprocity", "social-proof"]),
                PuzzleCandidate(text: "Push to close before the new CFO can review.", eval: -0.8, rationale: "Rush-to-close ahead of inherited executive review reads as bad-faith. Damages the deal and the post-purchase relationship.", atlasTags: ["scarcity"]),
                PuzzleCandidate(text: "Wait the two weeks passively.", eval: -0.5, rationale: "Passive waiting accepts slippage rate as given. Inherited-CFO transitions reverse 40%+ of pre-approved deals without re-positioning.", atlasTags: []),
                PuzzleCandidate(text: "Offer a discount to clear new-CFO friction.", eval: -0.6, rationale: "Discount to a new buyer before re-discovery trains them on operator's structural flexibility. Cap shifts down.", atlasTags: ["sharp-angle"]),
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
                PuzzleCandidate(text: "Invert the open. Ask which of two specific operational problems is the more painful one in their company right now. Map the answer to the operator's product.", eval: 0.7, rationale: "Founders absorb diagnosis-first openings as time-respecting and homework-done. Inverts the pitch frame into a fit-discovery frame.", atlasTags: ["calibrated-question", "alternative-choice"]),
                PuzzleCandidate(text: "Generic two-minute pitch.", eval: -0.4, rationale: "Pitch-into-skepticism reinforces the founder's initial skepticism. Conversion to follow-up degrades.", atlasTags: []),
                PuzzleCandidate(text: "Customer-quote opener: \"Customer X said we saved them N hours.\"", eval: 0.0, rationale: "Possible if the named customer is specifically relevant to the founder's business. More likely treated as marketing.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Trial-close in the opening minute.", eval: -0.7, rationale: "Trial-close before discovery reads as sales-coach training. Founder archives the operator as low-credibility.", atlasTags: ["trial-close"]),
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
                PuzzleCandidate(text: "Specify one non-obvious technical differentiator (architectural, deployment-model, or integration-specific) and ask whether that's the dimension that matters most to the VP's current stack. Calibrate from response.", eval: 0.7, rationale: "VPs of Engineering respond to specific technical differentiators that signal operator understands their stack. Calibration question turns the reply into a discovery start.", atlasTags: ["concrete-construal", "calibrated-question"]),
                PuzzleCandidate(text: "Generic differentiator list (three claims).", eval: -0.3, rationale: "Three-claim differentiator list reads as marketing. VP discounts.", atlasTags: []),
                PuzzleCandidate(text: "Defer to a demo without specifying.", eval: -0.4, rationale: "Demo-deferral on a specific question signals operator does not have a crisp answer ready.", atlasTags: []),
                PuzzleCandidate(text: "Send a case study from the referrer.", eval: 0.2, rationale: "Useful as adjunct; alone may underwhelm a specific question.", atlasTags: ["social-proof"]),
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
                PuzzleCandidate(text: "Ask which two of three named adjacent vendors they're using, and what one outcome the existing vendor isn't delivering yet. Calibrate the differentiator answer from the response.", eval: 0.7, rationale: "Director's existing-vendor framing is the discovery surface. Surfacing which adjacent vendor and what gap routes the conversation toward a fit-discovery moment.", atlasTags: ["calibrated-question", "contrast"]),
                PuzzleCandidate(text: "Generic competitive differentiator list.", eval: -0.4, rationale: "Director already has a vendor; competitive list without surfaced gap reinforces switching cost in the director's mind.", atlasTags: []),
                PuzzleCandidate(text: "Propose a parallel evaluation.", eval: -0.3, rationale: "Parallel evaluation before fit-discovery asks for asymmetric work without earning it.", atlasTags: []),
                PuzzleCandidate(text: "Disparage the named competitor.", eval: -1.0, rationale: "Disparaging an existing vendor the director chose damages the director's standing implicitly. Director archives the operator.", atlasTags: []),
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
                PuzzleCandidate(text: "Send a one-page CFO-targeted math sheet: three assumptions specified, named-peer comparable, single payback number. Include the operator's calendar link for follow-up if math holds.", eval: 0.8, rationale: "CFOs respond to specificity. One-page format respects time; named-peer + payback frame the conversation around defensible inputs.", atlasTags: ["concrete-construal", "social-proof"]),
                PuzzleCandidate(text: "Send a 12-slide pitch deck.", eval: -0.6, rationale: "12-slide deck fails the 15-minute frame. CFO archives without reading.", atlasTags: []),
                PuzzleCandidate(text: "Propose a 15-minute live call instead of math.", eval: -0.3, rationale: "Pivot off the CFO's specific ask signals operator is uncomfortable with the math. Conversion drops.", atlasTags: []),
                PuzzleCandidate(text: "Send generic ROI calculator.", eval: -0.4, rationale: "Generic calculator without named-peer or specific assumptions fails CFO-level scrutiny.", atlasTags: []),
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
                PuzzleCandidate(text: "Acknowledge the gatekeeper's role. Provide a specific one-sentence reason tied to the executive's named priority (referenced from public sources). Ask the assistant whether they prefer an email-with-context they can route or a 30-second context-call they can vet.", eval: 0.7, rationale: "Gatekeepers respond to operators who respect their role and provide them with a routing decision. Two-choice route lets them choose which path serves the executive best.", atlasTags: ["alternative-choice", "liking"]),
                PuzzleCandidate(text: "Press to speak to the executive.", eval: -0.7, rationale: "Pressuring a gatekeeper damages the long-term access. Gatekeeper archives the operator.", atlasTags: []),
                PuzzleCandidate(text: "Provide vague \"I'm following up\" answer.", eval: -0.5, rationale: "Vague answers to gatekeepers route to voicemail. Conversion drops.", atlasTags: []),
                PuzzleCandidate(text: "Use a fabricated existing-relationship cover.", eval: -1.1, rationale: "Lying to a gatekeeper damages the operator's reputation when surfaced. High-risk path for low expected gain.", atlasTags: []),
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
                PuzzleCandidate(text: "Surface one non-pitch differentiator (operating model, deployment depth, customer-success staffing ratio) the CRO would not have heard from the standard pitch. Tie to a single named peer's specific outcome.", eval: 0.7, rationale: "CROs have heard category pitches dozens of times. Non-pitch operational differentiator (the things that don't fit on a slide) earns a second conversation.", atlasTags: ["concrete-construal", "social-proof"]),
                PuzzleCandidate(text: "Stand on the standard pitch with more enthusiasm.", eval: -0.6, rationale: "Repeating the pitch reinforces the CRO's complaint. Conversion to follow-up drops.", atlasTags: []),
                PuzzleCandidate(text: "Pivot to demoing the product.", eval: -0.2, rationale: "Demo without surfacing the differentiator the CRO is asking about wastes the opening. Possible recovery.", atlasTags: []),
                PuzzleCandidate(text: "Trial-close on a discovery meeting.", eval: -0.3, rationale: "Trial-close before answering the CRO's question signals operator wants the meeting more than the diagnosis.", atlasTags: ["trial-close"]),
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
                PuzzleCandidate(text: "Send a one-page tailored to the Director's stated function with three named-peer outcomes in the same function. Include two calibrated questions about their specific stack. Avoid attaching a calendar link.", eval: 0.7, rationale: "Send-me-more-info is a low-effort request. Operator's job is to make the artifact tailored enough to convert. Calibrated questions invite the next message instead of demanding the call.", atlasTags: ["calibrated-question", "social-proof"]),
                PuzzleCandidate(text: "Send the full pitch deck.", eval: -0.3, rationale: "Pitch-deck volume is not tailoring. Director scans and archives.", atlasTags: []),
                PuzzleCandidate(text: "Pivot to demanding a call.", eval: -0.5, rationale: "Pivoting to a call before earning the second-message conversion misreads the Director's signal.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Send a generic one-pager with calendar link.", eval: -0.2, rationale: "Generic format underwhelms a Director who explicitly asked for relevance. Conversion drops.", atlasTags: []),
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
                PuzzleCandidate(text: "One sentence: named-peer plus specific outcome plus question whether the executive's company has a similar problem. Time pressure built in.", eval: 0.7, rationale: "Hallway conversations have a 5-second decision window. Operator's job is to fit named-peer + specific outcome + invitation-question into the window. Earns the next conversation or doesn't.", atlasTags: ["social-proof", "concrete-construal", "calibrated-question"]),
                PuzzleCandidate(text: "Two-minute pitch.", eval: -1.0, rationale: "Two-minute pitch fails the hallway-window. Executive exits regardless.", atlasTags: []),
                PuzzleCandidate(text: "Compliment the executive's recent talk.", eval: -0.3, rationale: "Compliment without substance burns the window without surfacing the operator's value.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Hand a business card.", eval: -0.4, rationale: "Card without context goes in a pocket. Conversion to follow-up is near zero.", atlasTags: []),
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
                PuzzleCandidate(text: "Complete the RFI promptly. In parallel, surface a named-business-side stakeholder the operator believes is the actual user. Politely ask procurement which business stakeholder owns the use case for context. Respect the gatekeeper-then-find-user pattern.", eval: 0.7, rationale: "Procurement specialists respect operators who follow the RFI process. Operator's parallel question identifies the business stakeholder without bypassing procurement.", atlasTags: ["calibrated-question", "liking"]),
                PuzzleCandidate(text: "Skip the RFI. Outreach directly to a guessed business stakeholder.", eval: -0.7, rationale: "Bypassing procurement gets the operator flagged in the vendor portal and damages future access.", atlasTags: []),
                PuzzleCandidate(text: "Complete the RFI without surfacing the business stakeholder.", eval: 0.0, rationale: "Compliant but slow. Procurement holds the RFI in queue indefinitely without business pull.", atlasTags: []),
                PuzzleCandidate(text: "Push procurement for an immediate business intro.", eval: -0.4, rationale: "Pushing procurement on intro speed signals operator does not respect their role. Damages the relationship.", atlasTags: []),
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
                PuzzleCandidate(text: "Decline the convince-frame. Ask the peer what their function's largest operational drag is right now and whether the operator's product would map to that. Map carefully or honestly decline-the-fit.", eval: 0.7, rationale: "Convince-me framing is an invitation to overreach. Diagnosis-first preserves credibility; honest decline-the-fit when applicable earns the relationship.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Lean into the convince-frame. Make the case.", eval: -0.5, rationale: "Convince-me framing puts operator in the defensive position. Conversion to follow-up degrades.", atlasTags: []),
                PuzzleCandidate(text: "Cite the champion's enthusiasm as social proof.", eval: -0.3, rationale: "Champion's enthusiasm is already known to the peer; re-citing it adds no information. Damages the operator's standing.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Defer to a structured discovery later.", eval: 0.2, rationale: "Acceptable but loses the in-conversation opportunity to surface the function-specific drag.", atlasTags: []),
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
                PuzzleCandidate(text: "Acknowledge the skepticism. Surface the one specific objection their public writings raise and provide the operator's mechanistic response to that specific objection. Do not defend the category as a whole.", eval: 0.7, rationale: "Category-skeptics respect operators who engage their specific objection rather than the category abstraction. Mechanistic response on the named objection earns the second conversation.", atlasTags: ["labeling", "concrete-construal"]),
                PuzzleCandidate(text: "Defend the category broadly.", eval: -0.5, rationale: "Broad category defense reinforces the skeptic's complaint. Operator absorbed as snake-oil vendor.", atlasTags: []),
                PuzzleCandidate(text: "Cite peer-vendor adoption as social proof.", eval: -0.3, rationale: "Aggregate adoption is the standard category claim the skeptic has already discounted.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "Withdraw. Cite poor fit.", eval: -0.4, rationale: "Withdrawal forfeits a winnable conversation. Category-skeptics frequently convert when their specific objection is engaged.", atlasTags: ["takeaway"]),
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
                PuzzleCandidate(text: "30-second framed open: named referral or named-peer + specific outcome + permission to either keep talking or schedule. Time-respect the rushed posture.", eval: 0.7, rationale: "Rushed-tone signals time constraint. 30-second framed open with explicit two-path permission preserves operator credibility regardless of which path the prospect chooses.", atlasTags: ["social-proof", "alternative-choice"]),
                PuzzleCandidate(text: "Launch into a two-minute pitch.", eval: -0.7, rationale: "Two-minute pitch into rushed-tone fails. Prospect hangs up.", atlasTags: []),
                PuzzleCandidate(text: "Ask permission for a future meeting first.", eval: 0.1, rationale: "Acceptable but skips the opportunity to deliver one specific outcome that earns the meeting.", atlasTags: []),
                PuzzleCandidate(text: "Apologize and offer to call back tomorrow.", eval: -0.3, rationale: "Apology-and-defer wastes the live-moment access. Tomorrow's call rarely happens.", atlasTags: []),
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
                PuzzleCandidate(text: "Acknowledge the data gap. Surface that the outcome citation reflects a specific function (e.g., post-implementation Year-1 in a single business unit) and offer the granular reference. Concede if the public framing was misleading.", eval: 0.8, rationale: "High-PK senior executive tested the operator's data integrity. Specific scoping plus honest concession-where-applicable earns enormous credibility. Defending the misleading framing destroys the relationship.", atlasTags: ["labeling", "concrete-construal"]),
                PuzzleCandidate(text: "Defend the original citation as accurate.", eval: -1.0, rationale: "Defending a citation a high-PK executive flagged as inaccurate destroys credibility permanently.", atlasTags: []),
                PuzzleCandidate(text: "Pivot to a different peer reference.", eval: -0.5, rationale: "Pivot without addressing the flagged citation signals operator is choosing convenient over honest.", atlasTags: []),
                PuzzleCandidate(text: "Withdraw the citation entirely without explanation.", eval: -0.4, rationale: "Silent withdrawal without scoping reads as evasion. Possible recovery if the executive responds.", atlasTags: []),
            ],
            bestIndex: 0,
            themeHint: "High-PK executives test data integrity. Specific scoping + honest concession converts; defense destroys.",
            transcriptId: "voss-accusation-audit"
        ),
    ]

    public static func get(_ id: String) -> Puzzle? {
        all.first { $0.id == id }
    }

    /// Deterministic daily puzzle. Keyed by YYYY-MM-DD.
    public static func dailyId(for date: Date = Date()) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let key = formatter.string(from: date)
        var hash: Int = 0
        for scalar in key.unicodeScalars {
            hash = (hash &* 31 &+ Int(scalar.value)) & 0xffffffff
        }
        let idx = abs(hash) % all.count
        return all[idx].id
    }
}
