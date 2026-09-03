import Foundation

/// 5 hand-authored annotated master games — verbatim port from web's
/// src/lib/master-games.ts.
///
/// Voice: Persuasion-Max house style. Move dialogue uses character voice
/// (Voss-flavored language inside a Voss game, etc.). Annotations + study
/// takeaways are mechanistic and decompositional — describe what each move
/// does to the buyer's appraisal state and downstream operational
/// consequences. No curriculum references, no name leaks, no moral judgments.
public enum MasterGames {
    public static let all: [MasterGame] = [
        // ─── 1 · Voss ────────────────────────────────────────────────
        MasterGame(
            id: "voss-001",
            speaker: "Chris Voss (style)",
            speakerStyle: "Mirror + label + calibrated-question chain. Tactical empathy. Black Swan curveballs.",
            opponentRole: "Adversarial counterparty in a contract negotiation",
            scenario: "Late-stage deal. Counterparty has just demanded an unreasonable termination clause. The deal is in the room or it dies in the next 10 minutes.",
            outcome: .win,
            outcomeNote: "Surfaced the underlying derisk concern, swapped a 50% refund clause for a usage-tied ramp-down — both sides closer.",
            openingName: "Voss Open (Mirror Variation)",
            openingECO: "VO2",
            moves: [
                MasterMove(role: .buyer, text: "We need a unilateral termination right at 90 days with a 50% refund. Non-negotiable.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Unilateral termination right at 90 days with a 50% refund.", techniqueIds: ["mirroring"], annotation: "You repeat her last clause verbatim. No counter-offer, no pivot. The repetition signals nothing but attention, so she feels the pull to elaborate without you imposing any direction.", delta: 0.32),
                MasterMove(role: .buyer, text: "Right. We've been burned by vendors who oversell and underdeliver. We need a real out.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "It sounds like you're worried about being locked into something that doesn't work.", techniqueIds: ["labeling"], annotation: "You name the underlying concern, vendor-burn risk, instead of the surface artifact, the refund clause. Her appraisal shifts from defending a position to confirming a problem.", delta: 0.55),
                MasterMove(role: .buyer, text: "Yeah. Exactly. We've had two vendors in the last 18 months where we signed long contracts and the product didn't deliver. Procurement got grilled.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "How would you know in 90 days whether this is working?", techniqueIds: ["calibrated-question"], annotation: "You convert a demand into a problem she has to operationalize. Once she states the exit criteria, alternative structures become tractable, and now she has skin in the answer.", delta: 0.72, alternatives: ["What if we cut the refund to 25%? Would that be enough?", "I promise you won't need an out. Our onboarding is best-in-class."]),
                MasterMove(role: .buyer, text: "Honestly? Active usage above 60% across the contracted seats, and at least one named ROI win surfaced by the executive sponsor.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "What if we structured it the other way — instead of a refund clause, a usage-tied ramp-down: if we're not at 60% by day 90, you cut seat count by a third with no penalty. Same protection, but procurement doesn't have to fight a refund battle.", techniqueIds: ["calibrated-question", "concrete-construal"], annotation: "You propose a structural alternative that gives her the same accountability from you without the refund-accounting overhead. The question form preserves her agency — she experiences the structure as her own solution to evaluate, not as your terms.", delta: 0.85, alternatives: ["Okay — we can do the 50% refund at 90 days if that's what closes it.", "Honestly our retention is 94%, you'd never trigger that clause anyway."]),
                MasterMove(role: .buyer, text: "Hmm. That's actually cleaner for us. Let me run it past legal but I think we can work with that.", techniqueIds: nil, annotation: nil, delta: nil),
            ],
            studyHint: "Three moves stacked in a tight sequence: mirror → underlying-concern label → operational-criteria question. The structural reframe at move 7 isn't a concession — it's a question-formed alternative that puts you on the hook for the same accountability without the refund fight. Across the sequence you move her from defending a position to solving a problem."
        ),

        // ─── 2 · Klaff ────────────────────────────────────────────────
        MasterGame(
            id: "klaff-001",
            speaker: "Oren Klaff (style)",
            speakerStyle: "Frame control. Intrigue ping. The prize. Break the chase dynamic.",
            opponentRole: "Senior partner at a $4B AUM family office",
            scenario: "Pitch meeting for a $25M raise. The partner runs a power-frame: drops a stack of pitch decks on the table, says 'You've got 12 minutes.'",
            outcome: .win,
            outcomeNote: "Pulled the partner across the table. Closed on a follow-up at the partner's office two days later.",
            openingName: "Challenger Open (Frame Reversal Variation)",
            openingECO: "CH2",
            moves: [
                MasterMove(role: .buyer, text: "Alright, you've got 12 minutes. Walk me through it.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "I'll do something better — I'll spend the first three minutes telling you the two reasons we'd be wrong for you. If at minute three you want me to keep going, I will. If not, we both save time.", techniqueIds: ["accusation-audit", "takeaway"], annotation: "You redefine who is qualifying whom. The partner just imposed a time constraint to set a power posture; this move re-anchors the dynamic to fit-evaluation without contesting the time constraint itself.", delta: 0.68, alternatives: ["Sure — let me jump straight into the highlights, I'll be quick.", "Twelve minutes is plenty. This is the best deal you'll see all year."]),
                MasterMove(role: .buyer, text: "Okay. That's a new one. Go.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Reason one: we're not the lowest-cost option in this category. If your filter is fee compression, stop me at minute four. Reason two: our holding period is 7-10 years. If you have a fund maturing in 18 months that needs deployable capital fast, I'm wasting your time.", techniqueIds: ["accusation-audit", "concrete-construal"], annotation: "You pre-state the two highest-probability disqualifying objections. His pattern-recognition for 'finding the catch' has nothing to do — you handed it over. His appraisal shifts from detecting concealment to evaluating fit.", delta: 0.52),
                MasterMove(role: .buyer, text: "Fine. Our fees ARE under pressure, and we have a 2027 vehicle. But keep going.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Good — that means the next eight minutes are useful. Here's the prize: we close to new capital end of Q3. We're filling the last $40M with three LPs, two are already committed. The question isn't whether this is a good investment for you. The question is whether you make it into this vehicle or wait two years for the next.", techniqueIds: ["scarcity", "takeaway", "extreme-anchor"], annotation: "Your scarcity claim reads as credible only because moves 2 and 4 established that you're not in chase posture. He absorbs the timeline as procedural fact rather than a pressure tactic. The move re-anchors the decision from yes/no to now/later.", delta: 0.60, alternatives: ["We'd love to have you in — what would it take to get you comfortable?", "You'll need to decide today; this round closes Friday."]),
                MasterMove(role: .buyer, text: "Who are the other two LPs?", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "I can't say on a first meeting. If we go to a second, you'll be in the room with them.", techniqueIds: ["takeaway", "scarcity"], annotation: "Withholding the names preserves the curiosity gap while gating it to the next meeting. He can verify your claim only by progressing the relationship — naming them now would dissolve the asymmetry you just earned.", delta: 0.45),
                MasterMove(role: .buyer, text: "Okay. Send me the deck. I want my associates to look at it before we go further. Can you do a follow-up Thursday at our office?", techniqueIds: nil, annotation: nil, delta: nil),
            ],
            studyHint: "The scarcity move at turn 7 lands only because turns 2-5 established you're not in chase posture. You earn the frame across moves, never assert it in any single one. The 'prize' would be non-credible on minute one — it becomes credible on minute six because of the frame you've accumulated."
        ),

        // ─── 3 · Belfort (CAUTIONARY — right technique, wrong game) ────
        MasterGame(
            id: "belfort-001",
            speaker: "Jordan Belfort (style)",
            speakerStyle: "Straight Line · qualifying open · looping objections. A cautionary study: these moves convert a cold retail mark — and that is the trap. Imported into a B2B evaluation, this is the manipulation a professional buyer is built to catch.",
            opponentRole: "Mid-market investor on a cold call",
            scenario: "Cold call into a qualified retail investor list. You have ~4 minutes before they hang up.",
            outcome: .draw,
            outcomeNote: "Earned a follow-up on a cold call. Studied here as \"right technique, wrong game\" — one transferable idea (close on the next conversation, not the sale) wrapped in a boiler-room method you should learn to recognize, not run.",
            openingName: "Consultative Open (Qualifying Variation)",
            openingECO: "CO2",
            moves: [
                MasterMove(role: .op, text: "Hi, Robert? Jordan from [firm]. How are you today? Good. The reason for my call — I'm reaching out about a name we've been recommending to our top investors for the last few months. Now I know I'm catching you cold, so I want to ask you three quick questions to see if it makes sense to spend a few more minutes. Fair enough?", techniqueIds: ["accusation-audit", "calibrated-question"], annotation: "Three commitments compressed into one turn — slick on a cold mark. But the scripted 'fair enough?' micro-commitment is exactly what a B2B buyer with any deal experience clocks as a technique, and the moment they clock it, trust drops instead of rising. What converts a cold call disqualifies you in an evaluation.", delta: 0.40),
                MasterMove(role: .buyer, text: "Look, what is this? I'm in the middle of something.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "I get it, you're busy. I'll be respectful of your time. Just to ground the conversation — are you currently working with a broker, or do you make your own decisions?", techniqueIds: ["labeling", "calibrated-question"], annotation: "Accepting the busy-signal and re-routing is genuine instinct — that part travels anywhere. What does not: the whole frame is qualifying a mark for a name you are moving on. The mechanic is sound; the game it serves is not one you want to be caught playing.", delta: 0.32),
                MasterMove(role: .buyer, text: "I have a broker but I also pick my own. What are you trying to sell me?", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Nothing today — I'm not asking you to buy anything on this call. What I AM doing is identifying serious investors for a name we'll be moving on in the next two to three weeks. If after our chat you tell me you're interested, I'll send you our research. If it's not for you, no problem. Sound fair?", techniqueIds: ["takeaway", "accusation-audit", "trial-close"], annotation: "\"I am not asking you to buy anything\" — while steering toward a name you will pressure them on later — is the manufactured-no-pressure move. It removes the frame the buyer was defending so you can install your own. It lands on a retail mark; on a B2B evaluator it is the exact manipulation their persuasion-knowledge is built to catch.", delta: 0.55, alternatives: ["It's a biotech with a catalyst next month — I think it could double.", "I'm not trying to sell you anything, I swear — just hear me out."]),
                MasterMove(role: .buyer, text: "Okay. What's the name?", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Before I tell you the name, one more question — when you've made your best calls in the last few years, were those typically growth-stage names or established compounders?", techniqueIds: ["calibrated-question", "commitment-consistency"], annotation: "Gating the reveal to prime their self-image as a winning investor is textbook commitment-consistency — and textbook manipulation when the name is a boiler-room security. The technique is real; the application is why this is a cautionary study, not a model.", delta: 0.48),
                MasterMove(role: .buyer, text: "I've done well in growth names. My broker has me in too many compounders for my taste.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Then this fits you. The name is [company X]. Without making you a recommendation on this call, I'd like to send you our 8-page research note. Read it over the weekend. I'll call you Monday at 10 AM, you tell me yes or no. Does that work?", techniqueIds: ["mutual-close-plan", "alternative-choice"], annotation: "Closing on the next conversation instead of the sale is the best idea in the sequence — and the one move here worth importing. Strip the boiler-room context and \"close on the follow-up, not the sale\" is real craft. That single transferable lesson is the reason this study is in the app at all.", delta: 0.62, alternatives: ["Let's just open a small position today and you can add to it later.", "Take your time — give me a call whenever you've had a look."]),
                MasterMove(role: .buyer, text: "Send it over. Monday's fine.", techniqueIds: nil, annotation: nil, delta: nil),
            ],
            studyHint: "Belfort's Straight Line works on a transactional cold call — and nearly every move that makes it work is a disqualifier in consultative B2B, where the buyer has persuasion-knowledge and a long memory. Read this to recognize the technique when it is used on you, and to extract the one honest lesson buried in it: the real close was the scheduled Monday call, not the security. Do not import the rest."
        ),

        // ─── 4 · Cardone (LOSS) ──────────────────────────────────────
        MasterGame(
            id: "cardone-001",
            speaker: "Grant Cardone (style)",
            speakerStyle: "Assumption + isolation + obligation. Volume tempo. No room to stall.",
            opponentRole: "Couple on the auto floor (persuasion-knowledge high)",
            scenario: "Saturday afternoon on the lot. They've walked the lot twice. You've been with them 35 minutes. They're 'just looking.'",
            outcome: .loss,
            outcomeNote: "Couple walked. Annotated as a deliberate study of move-buyer mismatch.",
            openingName: "Anchored Open (Volume Variation)",
            openingECO: "AN2",
            moves: [
                MasterMove(role: .buyer, text: "We really need to think about it. We'll come back next weekend.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "What's there to think about? The car's right here, the price is fair, and you've test-driven it twice. Let's just write it up.", techniqueIds: ["assumptive"], annotation: "You assume a deal-state the couple hasn't consented to. This works on low-persuasion-knowledge buyers in high-velocity environments. But they've explicitly named their hesitation, so the assumption registers as an override rather than guidance.", delta: -0.45, alternatives: ["Sounds like something's still not sitting right — what is it?", "What would you need to know before you'd feel good about this?"]),
                MasterMove(role: .buyer, text: "We don't need anyone to write anything up. We're going to leave and think about it.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Look, I'll be honest with you — if you walk out today, the same vehicle won't be here Monday. We have three other couples interested. I'm trying to do you a favor.", techniqueIds: ["scarcity", "takeaway"], annotation: "Your scarcity claim is verifiable only by counterfactual — they'd have to return Monday to test it. They pattern-match it to lot-floor scripts and discount it, and your credibility drops a step with each turn.", delta: -0.85),
                MasterMove(role: .buyer, text: "If three other couples want it, sell it to them. We're leaving.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Hold on — what if I could get my manager to drop another $1,500 today only?", techniqueIds: ["sharp-angle", "scarcity"], annotation: "Your same-turn price drop confirms the prior scarcity claim was a bluff. They now have two pieces of evidence that your earlier statements were instrumental rather than informational. Trust is at its terminal value.", delta: -1.10),
                MasterMove(role: .buyer, text: "Now I really don't want it. Have a good weekend.", techniqueIds: nil, annotation: nil, delta: nil),
            ],
            studyHint: "Volume-tempo closing works on a specific buyer: fast-decision, low-persuasion-knowledge, transactional. Run it against a savvy buyer and the same moves stack negative across turns — each one hands them more evidence for the pattern they're already matching you to. Move-buyer fit is what decides whether this exact sequence wins or loses."
        ),

        // ─── 5 · Burg ────────────────────────────────────────────────
        MasterGame(
            id: "burg-001",
            speaker: "Bob Burg (style)",
            speakerStyle: "Five-laws value-first. Reciprocity at scale before any ask. Generous patience.",
            opponentRole: "VP at a target account, intro warm-call after a referral",
            scenario: "Warm intro from a mutual connection. The VP is open but skeptical. You have all the time in the world; the pitch isn't this conversation.",
            outcome: .win,
            outcomeNote: "No ask, no close. Earned a 30-minute follow-up two weeks out.",
            openingName: "Consultative Open (Cialdini Variation)",
            openingECO: "CI1",
            moves: [
                MasterMove(role: .buyer, text: "Sarah said you wanted to chat. What's this about?", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Sarah mentioned you and your team have been thinking about [problem area] — and honestly I'm calling more to share than to sell. We've been studying it for three years and I think there are two specific patterns you'd find useful regardless of whether we ever work together.", techniqueIds: ["liking", "reciprocity"], annotation: "Your 'regardless of whether we ever work together' line removes the immediate-sale frame. Her defensive posture has nothing to engage. The move converts the call from pitch-evaluation to information-evaluation.", delta: 0.50),
                MasterMove(role: .buyer, text: "Okay, sure. What are the patterns?", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "First — the teams that solve this fastest treat it as a sequencing problem, not a tool problem. Most teams skip the sequencing and go straight to tooling. They spend six months and end up worse off. The second pattern is who needs to be in the room when you set the sequence. I can email you a one-pager on both if you want.", techniqueIds: ["authority", "concrete-construal", "reciprocity"], annotation: "You pair a specific falsifiable claim — 'six months and worse off' — with a no-cost artifact offer. She evaluates the claim against her own experience, and the artifact offer is a low-friction path to yes that converts her evaluation into engagement.", delta: 0.65, alternatives: ["There are a lot of best practices here — honestly every company's different.", "This is exactly what our platform fixes — want to see a quick demo?"]),
                MasterMove(role: .buyer, text: "Yeah, send it. The first one is interesting — we just bought a tool and the team is fighting over how to use it.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "That's the most common failure mode. Don't worry, it's recoverable — the sequencing fix takes about two weeks if you do it right. I'll include a checklist with the one-pager. And if it'd be useful, I could spend 30 minutes with whoever owns this internally — no pitch, just helping them think through the sequence.", techniqueIds: ["labeling", "reciprocity", "multi-threading"], annotation: "Three moves compressed: you validate the problem she just stated, add another artifact (the checklist), and offer no-pitch time that introduces a second stakeholder. Each is a small reciprocity event, and the cumulative effect is asymmetric obligation in your favor.", delta: 0.78, alternatives: ["This is exactly what our platform solves — should we set up a demo?", "Want to start a pilot so your team stops fighting over the tool?"]),
                MasterMove(role: .buyer, text: "Honestly, that would be really helpful. Let me get Sandra on the line — she owns the rollout. Can we do 30 minutes next Wednesday?", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Wednesday works. I'll send you both the one-pager and the checklist before the call so we can use the 30 minutes well. Looking forward to it.", techniqueIds: ["mutual-close-plan", "concrete-construal"], annotation: "You lock the next interaction with specific deliverables landing before it. By Wednesday, Sandra has read your material and the conversation starts inside your frame rather than from scratch.", delta: 0.55),
                MasterMove(role: .buyer, text: "Great. Talk Wednesday.", techniqueIds: nil, annotation: nil, delta: nil),
            ],
            studyHint: "You attempt no close in eight turns. Each move is a small no-strings deposit; the cumulative effect is a lopsided sense of obligation that converts into a multi-stakeholder follow-up. The conversation that asks for a commitment happens later — and by then the ask is tiny next to the reciprocity you've already banked."
        ),
// ─── 6 · Keenan / Gap Selling ────────────────────────────────
        MasterGame(
            id: "keenan-001",
            speaker: "Keenan / Gap Selling (style)",
            speakerStyle: "Discovery-as-the-work. Current-state → quantified impact → future-state gap. The buyer states the value; the rep never pitches.",
            opponentRole: "VP of Sales Operations at a mid-market SaaS company, skeptical of another analytics tool",
            scenario: "Discovery call booked off a warm intro. The buyer already has CRM dashboards and opens skeptical. No demo today — the whole call is discovery.",
            outcome: .win,
            outcomeNote: "No pitch, no demo. The buyer quantified the gap themselves and pulled two managers into a tailored working session.",
            openingName: "Consultative Open (Gap Variation)",
            openingECO: "GS2",
            moves: [
                MasterMove(role: .buyer, text: "I've got 25 minutes. Marcus said you do forecasting analytics — we already have dashboards in the CRM, so I'll be honest, I'm not sure what's new here.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "That's fair, and I'm not going to pitch dashboards at someone who already has them. Can I ask how your team builds the forecast today — like, what actually happens the week it's due?", techniqueIds: ["calibrated-question"], annotation: "You open on the current state before you say a word about your product. The question is procedural — 'what actually happens' — so you get the real workflow, not the sanitized version. You can't quantify a gap you haven't mapped first.", delta: 0.35),
                MasterMove(role: .buyer, text: "Each rep updates their deals Friday, my managers roll it up in a spreadsheet over the weekend, and I sanity-check it Monday. It's… fine. It's mostly right.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "When it's not right — when the number you commit to the board slips — where does that show up? What does a missed forecast actually cost your team?", techniqueIds: ["spin-implication"], annotation: "This is the move most reps skip. You had a Problem answer — 'mostly right' — and the instinct is to jump to a demo of your accuracy. Instead you ask what the miss costs. You're not asserting the pain; you're asking the buyer to compute it. The number they say next is theirs, not yours.", delta: 0.85, alternatives: ["Let me show you how our AI forecast hits 95% accuracy out of the box.", "Right — so accuracy is the problem. That's exactly what we fix."]),
                MasterMove(role: .buyer, text: "Honestly? Last quarter we called 4.2 and closed 3.6. I spent two board meetings explaining the gap instead of talking about growth. And my reps lose half of Friday to CRM hygiene that still doesn't catch it.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "So two things: the board conversation you're not having, and roughly half a rep-day a week across the team on manual updates. If I'm doing the math on, what, fifteen reps — that's most of a headcount a year in hygiene alone, before we even get to the forecast miss. Is that the shape of it, or am I over-reading it?", techniqueIds: ["spin-implication", "concrete-construal"], annotation: "You reflect the cost back in concrete units — half a rep-day, most of a headcount — and then you check it: 'am I over-reading?' The check matters. It keeps you honest, and it lets the buyer confirm the number in their own mouth, which is what makes it load-bearing later.", delta: 0.6),
                MasterMove(role: .buyer, text: "No, that's about right. The headcount math is actually worse when you count my managers' weekend rollup.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "If the rollup just… happened — if Monday you opened a forecast you trusted without anyone spending the weekend on it — what would that change for you specifically?", techniqueIds: ["spin-need-payoff"], annotation: "This is the need-payoff question, and it's the whole game. You do not tell the buyer what your product would do for them. You ask what a solved future state would change, and you let them build the case for the purchase out loud. Whatever they say next, you didn't sell it to them — they sold it to themselves.", delta: 0.9, alternatives: ["Our platform automates the rollup completely — no more weekends. Want to see it?", "So if I can give you a trustworthy Monday forecast, is that worth a demo?"]),
                MasterMove(role: .buyer, text: "I'd get my managers' weekends back, I'd walk into the board with a number I'm not apologizing for, and I'd redeploy that hygiene time into actual selling. That's… yeah. That's real money.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Then let's not do a generic demo. Let me build a 30-minute session around exactly what you just said — the weekend rollup, the board number, the redeployed hygiene time — and I'll pull your own funnel shape into it beforehand so we're looking at your gap, not a sandbox. Who else should be in the room when we do?", techniqueIds: ["summary-close", "mutual-close-plan"], annotation: "You close on the next step, not the deal, and you frame the session around the three things the buyer just told you matter — their words, not your feature list. Asking who else should be in the room surfaces the buying committee without pushing for it. The gap did the selling; you're only scheduling the paperwork.", delta: 0.55),
                MasterMove(role: .buyer, text: "Get my two regional managers in there — they own the rollup. Send me a couple of times next week.", techniqueIds: nil, annotation: nil, delta: nil),
            ],
            studyHint: "Discovery is the sale. The move at turn 4 is the whole lesson — the buyer said 'mostly right' and the losing rep jumps to a demo of accuracy; the winning rep asks what the miss costs and lets the buyer compute the number. By turn 8 the need-payoff question has the buyer stating the value out loud, so the close at turn 10 is scheduling, not persuading. The rep never pitches once."
        ),

        // ─── 7 · Dixon / Challenger ──────────────────────────────────
        MasterGame(
            id: "dixon-001",
            speaker: "Dixon / Challenger (style)",
            speakerStyle: "Teach–Tailor–Take Control. A commercial insight reframes the buyer's own problem. Constructive tension, then control the close.",
            opponentRole: "VP of Customer Experience running a competitive RFP with fixed evaluation criteria",
            scenario: "Three weeks into a live RFP. The buyer has shortlisted three vendors and locked the evaluation criteria to first-response time. You are the fourth conversation.",
            outcome: .win,
            outcomeNote: "Reframed the RFP criteria from response-speed to onboarding-ticket volume. Buyer agreed to reopen the scorecard with its owner.",
            openingName: "Challenger Open (Teach-Tailor Variation)",
            openingECO: "CH3",
            moves: [
                MasterMove(role: .buyer, text: "Just so we're efficient — we've shortlisted three chat vendors, and the thing we care about is median first-response time. Where do you land on that?", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "I can give you our number, and it's competitive. But before I do — can I show you something we found looking at forty CX teams that ran this exact eval? The ones who bought on first-response time almost all saw the same thing a year later: faster replies, same churn. The response-time number moved. The retention number didn't. I'd rather not sell you a faster version of a problem you don't actually have.", techniqueIds: ["loss-framing", "authority"], annotation: "This is Teach. You lead with a commercial insight the buyer didn't walk in with — response speed and retention decoupled across teams like theirs — and you name it before you answer their question. Notice you don't hide your own metric, you contextualize it. The insight has to be true and specific, or it reads as a dodge.", delta: 0.75, alternatives: ["Our median first-response is 42 seconds — fastest in the category.", "Great question — speed is everything in support. Let me walk you through our SLAs."]),
                MasterMove(role: .buyer, text: "Our whole team is convinced response time is the lever. That's a hard thing to walk back internally.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Yeah — it's an awkward thing to raise three weeks into an RFP, and I'm not asking you to walk anything back. Response time is a real lever, it's just usually the second one. Can I ask what actually generates most of your ticket volume right now?", techniqueIds: ["labeling"], annotation: "You name the tension instead of steamrolling it — 'it's awkward three weeks into an RFP.' That acknowledgment is what keeps the reframe from turning into a fight. Then you hand the next question back to the buyer. Challenger tension is only constructive when the buyer stays in the driver's seat.", delta: 0.45),
                MasterMove(role: .buyer, text: "A lot of it is setup questions in the first two weeks after a customer signs. The same handful of issues, over and over.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "So here's where it gets specific to you. If most of your volume is repeat onboarding questions, then a faster chat tool just means you answer the same avoidable question faster — you're paying to scale the ticket, not remove it. On your volume, what portion of those first-two-week tickets do you think never needed to exist?", techniqueIds: ["spin-implication", "concrete-construal"], annotation: "This is Tailor: you take the general insight and pin it to the buyer's own just-stated fact — their onboarding-question volume. Then you make them size it. You're not claiming their number, you're asking them to say it. A reframe the buyer quantifies themselves is one they'll defend to their team for you.", delta: 0.7, alternatives: ["Our tool has a great knowledge base that deflects those tickets automatically.", "So really you need deflection, not speed — and we're the best at deflection."]),
                MasterMove(role: .buyer, text: "If I had to guess… half? Maybe more. We've talked about a self-serve onboarding flow for a year and it keeps losing to firefighting.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Then the real decision isn't 'which of these three answers tickets fastest.' It's 'which of these actually shrinks the two-week onboarding queue so your team can firefight less.' Same budget, different question. Two of your three shortlist vendors don't touch that — they're pure speed. I'd genuinely rather compete on the harder question, because that's the one tied to your retention number.", techniqueIds: ["contrast", "summary-close"], annotation: "You reframe the decision criteria itself — from speed to volume-reduction — and you do it inside the buyer's budget, not on top of it. Saying two competitors don't touch the real problem is a claim you can only make if it's true; if the buyer checks and it holds, your credibility jumps. If it doesn't, you've lost the deal. Only reframe on ground you can defend.", delta: 0.6),
                MasterMove(role: .buyer, text: "Okay. That's a more honest version of what we're actually trying to fix. I don't think my team has framed it that way.", techniqueIds: nil, annotation: nil, delta: nil),
                MasterMove(role: .op, text: "Then here's what I'd suggest, and tell me if this is wrong: instead of another vendor demo, let's put one page in front of your team — the onboarding-question volume, the half that never needed to exist, and what shrinking it does to retention. I'll build it from your numbers. You bring whoever owns the RFP scorecard, because if the criteria changes, they're the one who has to change it. Can we get thirty minutes with them this week?", techniqueIds: ["mutual-close-plan", "summary-close"], annotation: "This is Take Control — you assert a specific next step and a specific person, the scorecard owner, because a reframed decision dies if the one who owns the criteria isn't in the room. You still check — 'tell me if this is wrong' — so it's direction, not pressure. Control in Challenger means owning the process, never bullying the person.", delta: 0.65, alternatives: ["So can we get the contract moving this week before the RFP closes?", "Let me just send over my pricing so you can compare us on value too."]),
                MasterMove(role: .buyer, text: "The scorecard owner is my director of CX ops. Let me get her on Thursday — this is worth reopening the criteria for.", techniqueIds: nil, annotation: nil, delta: nil),
            ],
            studyHint: "Teach–Tailor–Take Control across the whole game, not any single move. Turn 2 teaches an insight the buyer didn't own (speed and retention decoupled); turn 6 tailors it to the buyer's own volume number; turn 10 takes control by naming the scorecard owner, because a reframed decision dies if the person who owns the criteria isn't in the room. The tension stays constructive only because turn 4 names the awkwardness instead of steamrolling it."
        ),
    ]

    public static func get(_ id: String) -> MasterGame? {
        all.first { $0.id == id }
    }
}
