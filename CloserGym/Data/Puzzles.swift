import Foundation

/// 20 hand-authored puzzle positions — verbatim port from web's
/// src/lib/puzzle-library.ts. Each position is a real common moment from
/// the closer-curriculum + Atlas literature. Evals tuned against the same
/// heuristic engine.
///
/// Convention:
///   - bestIndex 0 is the canonical "best move"
///   - 1 is plausible-but-suboptimal
///   - 2 is contraindicated / scripted-cliché
///   - 3 is a blunder
/// PuzzleSolveView shuffles display order deterministically by puzzle.id.
public enum Puzzles {
    public static let all: [Puzzle] = [
        // ─── Budget (4) ─────────────────────────────────────────────────
        Puzzle(
            id: "p001", theme: .budget, difficulty: 1300,
            buyerRole: "VP Operations, mid-market SaaS",
            setup: "You're 18 minutes into a discovery call. You've established the problem — three reps quit last quarter because the manual onboarding process is brutal. The buyer just heard your pricing.",
            buyerLine: "Honestly, we don't have budget for this in FY26.",
            candidates: [
                PuzzleCandidate(text: "Help me understand — when you say no budget, do you mean the line item doesn't exist yet, or it exists and it's allocated elsewhere?", eval: 0.7, rationale: "Calibrated question that surfaces whether 'no budget' means 'no awareness of cost' (solvable) or 'budget is locked' (real). Voss-textbook.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "I hear you — budget season is tough. Could we revisit this in Q1 when planning opens up?", eval: -0.4, rationale: "Accepts the objection without testing it. Buyer learns they can end any conversation by saying 'no budget.'", atlasTags: []),
                PuzzleCandidate(text: "Most companies your size find the budget when they realize what onboarding churn is costing them — usually about 3x our license fee.", eval: -0.6, rationale: "Social-proof + implied-loss without earning permission. Reads as pressure.", atlasTags: ["social-proof", "loss-framing"]),
                PuzzleCandidate(text: "I'll let you in on something — if you sign by Friday, we can offer 20% off.", eval: -1.4, rationale: "Manufactured scarcity + price drop in response to a budget objection. Trains the buyer that discounts come from pushing back.", atlasTags: ["scarcity", "lowball"]),
            ],
            bestIndex: 0,
            themeHint: "Classic 'no budget' position. The right move is to test whether the objection is real before negotiating against it."
        ),
        Puzzle(
            id: "p002", theme: .budget, difficulty: 1600,
            buyerRole: "CFO, $200M revenue SaaS",
            setup: "Late-stage call, fourth meeting. Champion VP-Eng is on the line. You've already mapped value at $1.2M. Now the CFO has just joined.",
            buyerLine: "Walk me through ROI. Specifically, how do I tell my board this paid back in under 12 months?",
            candidates: [
                PuzzleCandidate(text: "The fastest pay-back I've seen in your peer set is 7 months — Acme cut their onboarding churn from 18% to 6% in two quarters. Want me to walk through their math, or yours?", eval: 0.9, rationale: "Named peer (specific social proof) + concrete number + calibrated branch back to the CFO's specific board narrative.", atlasTags: ["social-proof", "calibrated-question"]),
                PuzzleCandidate(text: "Industry average is around 15 months, but we usually beat that.", eval: -0.3, rationale: "Vague stat + 'usually' undercuts itself. Doesn't give the CFO a defensible number.", atlasTags: []),
                PuzzleCandidate(text: "Honestly, the ROI math depends on your assumptions. Let me send you our calculator after this call.", eval: -0.5, rationale: "Punts the question to a tool. The CFO asked YOU.", atlasTags: []),
                PuzzleCandidate(text: "I can't promise 12 months, but we'll do everything we can.", eval: -1.1, rationale: "Pre-emptive hedge with no specifics. CFOs hear this as 'I don't know.'", atlasTags: []),
            ],
            bestIndex: 0,
            themeHint: "Specific named peer beats generic social proof every time on a prestige-driven CFO."
        ),
        Puzzle(
            id: "p003", theme: .budget, difficulty: 1800,
            buyerRole: "Procurement specialist, F500",
            setup: "First procurement call after the business team agreed in principle. The procurement specialist has very high persuasion-knowledge.",
            buyerLine: "Your list price is 15% above the next vendor we're considering. What can you do on price?",
            candidates: [
                PuzzleCandidate(text: "What does the next vendor's package include? I want to make sure we're comparing apples-to-apples before talking discount.", eval: 0.6, rationale: "Calibrated question that re-frames the conversation away from list price and toward scope. Procurement specialists respect this — it's their move.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "We can match — what would it take to close this today?", eval: -0.2, rationale: "Concession with conditional close. Signals price is flexible from move 1.", atlasTags: ["sharp-angle"]),
                PuzzleCandidate(text: "Honestly, we're already at floor pricing for your tier.", eval: -0.9, rationale: "Bluff that procurement will test.", atlasTags: []),
                PuzzleCandidate(text: "I'll come back with our best and final by EOD.", eval: -1.2, rationale: "Pre-emptively conceding before they've made an offer. You just gave up your anchor.", atlasTags: []),
            ],
            bestIndex: 0, themeHint: nil
        ),
        Puzzle(
            id: "p004", theme: .budget, difficulty: 1500,
            buyerRole: "Founder, Series A startup",
            setup: "Cash-conscious founder, real budget pressure, but also genuinely interested. You're at 28 minutes.",
            buyerLine: "I love the product but realistically we can only spend $30k this year. Your price is $80k.",
            candidates: [
                PuzzleCandidate(text: "What if we structured a starter package at $30k that scales as you grow? I'd want to design it so you don't pay for capacity you can't use yet.", eval: 0.7, rationale: "Reframes from discount to scope. Founder gets a yes-to-something + signals you understand their stage.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Let me see what we can do — I'll talk to my VP and come back with a number.", eval: 0.1, rationale: "Buys time but doesn't progress. Acceptable; not great.", atlasTags: []),
                PuzzleCandidate(text: "We can do $30k for year one if you commit to a three-year ramp.", eval: -0.3, rationale: "Multi-year lock-in early-stage founders hate.", atlasTags: []),
                PuzzleCandidate(text: "Most early-stage companies who try to do this on the cheap end up paying more when they have to switch later. Our $80k actually saves you money.", eval: -1.0, rationale: "Lectures the founder. The 'you'll pay more later' frame is reactance bait.", atlasTags: ["loss-framing", "authority"]),
            ],
            bestIndex: 0, themeHint: nil
        ),

        // ─── Procurement (3) ──────────────────────────────────────────────
        Puzzle(
            id: "p005", theme: .procurement, difficulty: 1900,
            buyerRole: "Senior procurement specialist",
            setup: "Late stage. Champion has already verbally committed. Procurement is doing 'standard process.'",
            buyerLine: "We need a 90-day pilot before any commitment.",
            candidates: [
                PuzzleCandidate(text: "I want to honor your process. Help me understand — what would the pilot need to prove for you to recommend we move forward, and what's the timeline implication for the team that wants this live?", eval: 0.8, rationale: "Honors procurement's authority + extracts exit criteria + surfaces the cost of delay to the business sponsor.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "We can do a 30-day pilot — 90 is too long.", eval: -0.2, rationale: "Negotiates against the timeline without establishing why.", atlasTags: []),
                PuzzleCandidate(text: "Other customers your size skip the pilot — we have references that can speak to outcomes.", eval: -0.5, rationale: "Tries to social-proof procurement. Their job is to verify, not take peer's word.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "If we agree to a pilot, can we lock the contract today?", eval: -1.0, rationale: "Sharp-angle close + assumptive. Procurement specialists are explicitly trained against these.", atlasTags: ["sharp-angle", "assumptive"]),
            ],
            bestIndex: 0, themeHint: nil
        ),
        Puzzle(
            id: "p006", theme: .procurement, difficulty: 2100,
            buyerRole: "Procurement counterparty in adversarial negotiation",
            setup: "You've named your number. They've named theirs. Gap is $40k.",
            buyerLine: "We're $40k apart. Where can you flex?",
            candidates: [
                PuzzleCandidate(text: "Before I answer that — what's the deadline pressure on your end? Knowing your timeline helps me figure out what's actually workable.", eval: 0.5, rationale: "Voss-textbook: surface their constraints before revealing yours.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Split the difference — $20k each side and we close this week?", eval: 0.2, rationale: "Standard 'meet in the middle.' You just told them you can move $20k.", atlasTags: ["alternative-choice"]),
                PuzzleCandidate(text: "We can do $40k off if you agree to be a reference and a case study.", eval: 0.0, rationale: "Trades concession for non-cash value. Defensible but hard to enforce.", atlasTags: []),
                PuzzleCandidate(text: "I can do it. $40k off, but I need a signed PO by Friday.", eval: -1.1, rationale: "Total capitulation with manufactured urgency.", atlasTags: ["scarcity"]),
            ],
            bestIndex: 0, themeHint: nil
        ),
        Puzzle(
            id: "p007", theme: .procurement, difficulty: 1700,
            buyerRole: "IT security architect (technical evaluator)",
            setup: "Security review meeting. Architect has just finished walking you through their concerns.",
            buyerLine: "Honestly, your SOC2 is fine but you don't have FedRAMP. That's a hard requirement for us.",
            candidates: [
                PuzzleCandidate(text: "That's a fair call-out. Where is FedRAMP on your timeline — are you actively pursuing now, or is it a longer-term posture? I want to see if we can sequence around it.", eval: 0.6, rationale: "Accepts the constraint, then surfaces whether it's actually blocking THIS deal or a future one.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "We're in the early stages of FedRAMP — happy to commit to a date if it unblocks this.", eval: 0.3, rationale: "Honest answer + conditional offer. Risky if you can't actually commit.", atlasTags: []),
                PuzzleCandidate(text: "Most of our enterprise customers don't require FedRAMP — your SOC2 + ISO27001 covers the same controls.", eval: -0.5, rationale: "Argues with a security architect about their requirement.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "We can get a letter of intent from a FedRAMP sponsor — that's effectively the same thing.", eval: -0.9, rationale: "Technical hand-waving that won't survive a five-minute search.", atlasTags: []),
            ],
            bestIndex: 0, themeHint: nil
        ),

        // ─── Stall (3) ───────────────────────────────────────────────────
        Puzzle(
            id: "p008", theme: .stall, difficulty: 1400,
            buyerRole: "VP Sales, mid-market",
            setup: "Second meeting. You sent a proposal three weeks ago. Followups go unanswered. You finally got them back on a call.",
            buyerLine: "Sorry — yeah, I've been swamped. We're still thinking about it.",
            candidates: [
                PuzzleCandidate(text: "Totally get it. When you say 'still thinking' — what's the specific thing you're working through? Curious whether it's something I can help with or whether it's truly internal.", eval: 0.6, rationale: "Calibrated question without pressure. Surfaces real objection vs. polite stall.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "No worries. Should I check back in two weeks?", eval: -0.3, rationale: "Accepts the stall and schedules another stall.", atlasTags: []),
                PuzzleCandidate(text: "Honestly, at this point I'm wondering if this is no longer a priority for you. If so, totally fine to tell me.", eval: 0.4, rationale: "Takeaway / accusation audit. Works to surface a real objection.", atlasTags: ["takeaway", "accusation-audit"]),
                PuzzleCandidate(text: "We have a Q-end deadline approaching that might make this much harder if you wait. Can we get on the calendar this week?", eval: -0.8, rationale: "Manufactured urgency on a stalled deal. Reads as desperation.", atlasTags: ["scarcity"]),
            ],
            bestIndex: 0, themeHint: nil
        ),
        Puzzle(
            id: "p009", theme: .stall, difficulty: 1700,
            buyerRole: "Founder, post-Series B",
            setup: "Founder said yes 30 days ago to a $200k contract. Legal review has been 'in progress' for three weeks.",
            buyerLine: "Legal is still reviewing. I'll ping them tomorrow.",
            candidates: [
                PuzzleCandidate(text: "What's actually holding things up on your end? Sometimes 'legal review' is a holding pattern when something else has changed — would rather know now than chase the wrong thing.", eval: 0.7, rationale: "Direct + non-judgmental. Founders respect this.", atlasTags: ["calibrated-question", "labeling"]),
                PuzzleCandidate(text: "Can you introduce me to your legal counsel? I'd love to address their concerns directly.", eval: 0.3, rationale: "Useful if legal IS the holdup. Often the founder hasn't actually sent it.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "I'm going to be transparent — if we don't close by quarter end my pricing model resets. I'd rather not see you pay more.", eval: -0.7, rationale: "Manufactured price-change urgency. Founder hears 'you have a quota.'", atlasTags: ["scarcity", "loss-framing"]),
                PuzzleCandidate(text: "Just checking in. Let me know if you need anything.", eval: -0.4, rationale: "Pure deferential check-in. Doesn't surface the real issue.", atlasTags: []),
            ],
            bestIndex: 0, themeHint: nil
        ),
        Puzzle(
            id: "p010", theme: .stall, difficulty: 2000,
            buyerRole: "Champion VP-Eng",
            setup: "Champion has gone unusually quiet after being highly engaged for a month.",
            buyerLine: "Hey — I think we need to push this to Q3. Things changed internally.",
            candidates: [
                PuzzleCandidate(text: "Got it. What changed? Don't want to push if it's the wrong moment, but if there's something I can help you carry internally I'd rather know than not.", eval: 0.8, rationale: "Releases pressure + opens the door for them to share the real internal reason.", atlasTags: ["calibrated-question", "labeling"]),
                PuzzleCandidate(text: "Understood. Should I follow up in Q3 then?", eval: -0.2, rationale: "Polite but doesn't earn information.", atlasTags: []),
                PuzzleCandidate(text: "I get it, but our pricing locks at Q2 end. Want me to send you a memo for your CFO?", eval: -0.9, rationale: "Tries to use scarcity + authority on a champion. Trust drops sharply.", atlasTags: ["scarcity", "authority"]),
                PuzzleCandidate(text: "Is there someone else internally I should be talking to?", eval: 0.3, rationale: "Multi-threading move but going around your champion when they've just pushed you off is risky.", atlasTags: ["multi-threading"]),
            ],
            bestIndex: 0, themeHint: nil
        ),

        // ─── Renewal (3) ──────────────────────────────────────────────────
        Puzzle(
            id: "p011", theme: .renewal, difficulty: 1500,
            buyerRole: "VP Operations (new renewal contact)",
            setup: "30 days before renewal. Usage data shows the team is using your product heavily. But the new VP doesn't know you.",
            buyerLine: "I inherited this contract. I want to understand the value before signing again.",
            candidates: [
                PuzzleCandidate(text: "Fair — I'd want the same in your seat. Want to start with what the team's been using it for, or with what business outcome you're being measured on? I'll back-fill the value story around that.", eval: 0.7, rationale: "Reframes from defending past spend to mapping value to NEW VP's actual KPIs.", atlasTags: ["calibrated-question", "alternative-choice"]),
                PuzzleCandidate(text: "Let me send you the usage report — you've had 47 active users averaging 23 hours/week. The team is clearly getting value.", eval: 0.2, rationale: "Data without context. Numbers don't speak to the VP's specific concerns.", atlasTags: []),
                PuzzleCandidate(text: "Other VPs in your spot have all renewed once they saw the impact data.", eval: -0.4, rationale: "Generic social proof on a person trying to evaluate independently.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "If you don't renew, your team loses access in 30 days — that's going to be a brutal switch.", eval: -1.2, rationale: "Loss-framing on a new stakeholder you haven't earned trust with.", atlasTags: ["loss-framing"]),
            ],
            bestIndex: 0, themeHint: nil
        ),
        Puzzle(
            id: "p012", theme: .renewal, difficulty: 1900,
            buyerRole: "CFO at renewal time, considering downgrade",
            setup: "Quarterly business review just ended. CFO is questioning the seat count.",
            buyerLine: "We're paying for 200 seats. Usage shows 130 active. Why shouldn't I cut to 130 at renewal?",
            candidates: [
                PuzzleCandidate(text: "That's a fair number to start from. The complication is the cyclical 70 seats — they're the new-hire and PIP-recovery cohort. Cutting them puts onboarding behind on day 1 of the new term. Want to walk through the cycle data before we set the floor?", eval: 0.7, rationale: "Acknowledges the math, then introduces information the CFO didn't have.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "We can do 150 seats with a small price increase per seat — keeps your buffer.", eval: 0.1, rationale: "Reasonable counter but doesn't address the WHY.", atlasTags: ["anchor-with-range"]),
                PuzzleCandidate(text: "Most of our customers your size buy 25% above active usage as a buffer — peer benchmark suggests 165.", eval: -0.2, rationale: "Generic stat that a CFO will discount immediately.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "If we go to 130 we'd need to renegotiate the volume discount — your effective price per seat goes up 22%.", eval: -0.6, rationale: "Pricing threat in response to a usage question.", atlasTags: []),
            ],
            bestIndex: 0, themeHint: nil
        ),
        Puzzle(
            id: "p013", theme: .renewal, difficulty: 1700,
            buyerRole: "Champion at risk — being recruited elsewhere",
            setup: "Champion has hinted they may not be at the company at renewal time. Renewal is in 60 days.",
            buyerLine: "I'm going to be honest — I might not be here for the renewal. The new person may want to evaluate fresh.",
            candidates: [
                PuzzleCandidate(text: "I appreciate you flagging that. Two questions: who'd be your successor, and would it help if we drafted something now that survives the transition — like a usage-tied renewal that the new person can extend or pause?", eval: 0.7, rationale: "Labels the situation + multi-threads to the successor + offers a structure that reduces successor risk.", atlasTags: ["multi-threading", "calibrated-question"]),
                PuzzleCandidate(text: "Can we lock the renewal now, before you leave?", eval: -0.3, rationale: "Reads as 'I want to secure you against the new person.'", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Who will the new person be? Can you introduce me?", eval: 0.4, rationale: "Reasonable multi-threading but skips relationship-building.", atlasTags: ["multi-threading"]),
                PuzzleCandidate(text: "Most renewals survive transitions when the usage data is strong — yours is.", eval: 0.0, rationale: "Reassurance without action.", atlasTags: ["social-proof"]),
            ],
            bestIndex: 0, themeHint: nil
        ),

        // ─── Multi-stakeholder (2) ──────────────────────────────────────
        Puzzle(
            id: "p014", theme: .multistakeholder, difficulty: 1700,
            buyerRole: "Champion VP-Eng, with quiet CFO on the call",
            setup: "Joint call with champion + CFO. Champion has been enthusiastic. CFO has said almost nothing for 35 minutes.",
            buyerLine: "[CFO finally speaks] What's the deployment risk profile here? Specifically operational, not technical.",
            candidates: [
                PuzzleCandidate(text: "Great question. The two operational risks we've seen in similar deployments are change-management velocity and integration with the data-warehouse refresh cycle. Of those, which is the higher concern for you given how your team operates?", eval: 0.7, rationale: "Concrete answer + flips back to the CFO with a calibrated branch.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Risk is minimal — we've deployed this 47 times in your peer set with no significant operational issues.", eval: -0.4, rationale: "Dismisses the CFO's question. CFO marks you as glossing over real concerns.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "[to champion] Tom, you've been through the technical review — want to take this one?", eval: -0.2, rationale: "Hands the answer back to the champion in front of the CFO.", atlasTags: []),
                PuzzleCandidate(text: "Honestly, risk is going to depend a lot on your team's existing process maturity.", eval: -0.5, rationale: "Vague answer that implies the CFO's question can't be answered without more from them.", atlasTags: []),
            ],
            bestIndex: 0, themeHint: nil
        ),
        Puzzle(
            id: "p015", theme: .multistakeholder, difficulty: 2000,
            buyerRole: "Board director joining the eval call",
            setup: "Board director with audit-committee role has joined a deal call. Very high persuasion-knowledge.",
            buyerLine: "How does this decision read in the proxy if it goes wrong?",
            candidates: [
                PuzzleCandidate(text: "That's the right question to ask. Two ways it could read poorly: dependency on a single vendor without a credible exit, or a contractual term that surfaces in audit as off-market. Want to walk through how we structure both so the proxy story is clean?", eval: 0.8, rationale: "Validates the director's question + names the SPECIFIC governance failure modes + offers to walk through mitigations.", atlasTags: ["calibrated-question", "authority", "labeling"]),
                PuzzleCandidate(text: "We have many board-level customers — they've all been comfortable with our governance posture.", eval: -0.5, rationale: "Generic social proof on a board director.", atlasTags: ["social-proof"]),
                PuzzleCandidate(text: "I'd want to make sure your audit committee has full transparency — happy to send our SOC2, ISO, and contractual templates.", eval: 0.3, rationale: "Helpful but doesn't address the political/narrative concern.", atlasTags: []),
                PuzzleCandidate(text: "Honestly, the risk profile is low and the upside justifies the investment.", eval: -1.0, rationale: "Generic 'risk low' answer.", atlasTags: []),
            ],
            bestIndex: 0, themeHint: nil
        ),

        // ─── Endgame (2) ─────────────────────────────────────────────────
        Puzzle(
            id: "p016", theme: .endgame, difficulty: 1800,
            buyerRole: "Champion who has just verbally committed",
            setup: "Champion just said yes. You have 30 seconds to lock the next step before they pivot to another meeting.",
            buyerLine: "Yeah, this is making sense. I want to move forward.",
            candidates: [
                PuzzleCandidate(text: "Great — quick: who should I send the MSA to, and what's your standard procurement turnaround? I'll mirror your process. Want to put a signing call on the calendar 7-10 days out so we both have a target?", eval: 0.8, rationale: "Immediate mutual-action-plan move. Lock the next step + name the stakeholder + put a date on calendar.", atlasTags: ["mutual-close-plan", "alternative-choice"]),
                PuzzleCandidate(text: "Perfect. I'll send you the contract tomorrow.", eval: 0.1, rationale: "Polite acknowledgment but doesn't lock anything.", atlasTags: []),
                PuzzleCandidate(text: "Awesome — can we sign today?", eval: -0.4, rationale: "Assumptive close before procurement is on the radar.", atlasTags: ["assumptive"]),
                PuzzleCandidate(text: "Excellent! Let me share a few more reference customers before we move to paper.", eval: -0.9, rationale: "Adds more selling AFTER a verbal commit.", atlasTags: []),
            ],
            bestIndex: 0,
            themeHint: "Mate-in-1 position. The verbal yes is move 1; you have one move to lock the procedural path."
        ),
        Puzzle(
            id: "p017", theme: .endgame, difficulty: 2200,
            buyerRole: "Procurement, last call before signature",
            setup: "Final call. They've sent redlines. You're walking through.",
            buyerLine: "Last thing — we want a unilateral termination right at 90 days with 50% refund. Non-negotiable.",
            candidates: [
                PuzzleCandidate(text: "Help me understand the concern this is solving — is it about implementation risk, or vendor performance over time? If implementation, we have a structure that addresses it differently and we'd prefer that path.", eval: 0.7, rationale: "Calibrated question to surface the underlying concern.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "We can do 30 days termination with no refund — that's our standard.", eval: -0.3, rationale: "Counter-offer without diagnosing why.", atlasTags: ["anchor-with-range"]),
                PuzzleCandidate(text: "If that's truly non-negotiable, we may not be a fit.", eval: -0.2, rationale: "Takeaway that works only if you have credible BATNA.", atlasTags: ["takeaway"]),
                PuzzleCandidate(text: "Agreed. Let me update the redlines and send them back.", eval: -1.2, rationale: "Total capitulation on a major commercial term in the last call.", atlasTags: []),
            ],
            bestIndex: 0, themeHint: nil
        ),

        // ─── Cold open (3) ───────────────────────────────────────────────
        Puzzle(
            id: "p018", theme: .coldOpen, difficulty: 1300,
            buyerRole: "VP at a target account, just answered the cold call",
            setup: "You've cold-called a senior VP who actually picked up. You have 8 seconds before they say 'not interested.'",
            buyerLine: "Hello?",
            candidates: [
                PuzzleCandidate(text: "Hi — this is a cold call. You have 22 seconds to decide if it's worth your time. Want them?", eval: 0.7, rationale: "Pattern-interrupt cold open. Names that it's a cold call + invites them in + gives them control.", atlasTags: ["accusation-audit"]),
                PuzzleCandidate(text: "Hi there, hope I'm not catching you at a bad time! Is now a good moment to chat about a tool that might help your team?", eval: -0.6, rationale: "Classic scripted cold-call opener. Triggers 'not a good time' reflex within 4 seconds.", atlasTags: []),
                PuzzleCandidate(text: "Hi! I noticed you recently posted about [topic] on LinkedIn — wanted to share something relevant.", eval: 0.1, rationale: "Personalization helps but still reads as a pitch wind-up.", atlasTags: ["liking"]),
                PuzzleCandidate(text: "Hi — quick question: are you the person who handles [thing]?", eval: -0.4, rationale: "Yes/no qualifier dressed up as a question.", atlasTags: []),
            ],
            bestIndex: 0, themeHint: nil
        ),
        Puzzle(
            id: "p019", theme: .coldOpen, difficulty: 1700,
            buyerRole: "Senior procurement lead, intro email reply",
            setup: "You sent a referral-led cold email. They replied: 'What do you do?'",
            buyerLine: "What do you do?",
            candidates: [
                PuzzleCandidate(text: "We help [peer-company] cut procurement cycle time by ~40% on mid-market software deals — specifically the security-review and vendor-onboarding stages. Worth a 15-minute look, or not relevant?", eval: 0.7, rationale: "Named peer + specific outcome + concrete mechanism + low-friction CTA.", atlasTags: ["social-proof", "concrete-construal"]),
                PuzzleCandidate(text: "We're the leading platform for procurement workflow automation, used by 200+ enterprises including 4 of the Fortune 50.", eval: -0.5, rationale: "Generic 'leading platform' + vague enterprise count.", atlasTags: ["social-proof", "authority"]),
                PuzzleCandidate(text: "Happy to send you a 1-pager. What's the best email?", eval: -0.3, rationale: "Defers the value question to a document they may never read.", atlasTags: []),
                PuzzleCandidate(text: "[Referrer] thought you might be interested in what we're doing. Want to grab 30 minutes?", eval: 0.0, rationale: "Pure referral hand-off without substance.", atlasTags: ["liking"]),
            ],
            bestIndex: 0, themeHint: nil
        ),
        Puzzle(
            id: "p020", theme: .coldOpen, difficulty: 1500,
            buyerRole: "Founder, intro Zoom — first 60 seconds",
            setup: "First Zoom. Founder asks the open before you can.",
            buyerLine: "So — tell me what you do.",
            candidates: [
                PuzzleCandidate(text: "I'd rather start the other way: I read your latest [post / earnings note] and I think there are two specific places we can move the needle. Mind if I ask three questions first to make sure I'm right about which one matters more?", eval: 0.6, rationale: "Flips the discovery frame + earns the right to ask questions.", atlasTags: ["calibrated-question", "concrete-construal"]),
                PuzzleCandidate(text: "Sure — we're a platform that helps founders like you scale go-to-market faster. Let me walk you through the deck.", eval: -0.8, rationale: "Generic 'we help founders' + deck-walkthrough open.", atlasTags: []),
                PuzzleCandidate(text: "Two-minute version: we do X for companies like Y. Worth more than two minutes only if it lands. Want me to keep going?", eval: 0.4, rationale: "Disciplined and respectful but still leads with what you do.", atlasTags: ["calibrated-question"]),
                PuzzleCandidate(text: "Happy to — but first, on a scale of 1 to 10 how painful is your current [problem]?", eval: -0.4, rationale: "Scripted trial-close in the first minute.", atlasTags: ["trial-close"]),
            ],
            bestIndex: 0, themeHint: nil
        ),
    ]

    public static func get(_ id: String) -> Puzzle? {
        all.first { $0.id == id }
    }

    /// Deterministic daily puzzle — keyed by YYYY-MM-DD.
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
