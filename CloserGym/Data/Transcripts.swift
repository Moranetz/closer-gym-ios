import Foundation

/// 13 real sourced transcript excerpts. Verbatim port of web src/lib/transcripts.ts.
/// Each one is a brief quotation from published material with explicit source URL.
public enum Transcripts {
    public static let all: [Transcript] = [
        Transcript(
            id: "voss-two-copies",
            title: "Mirror Chain (Two Copies)",
            speaker: "Chris Voss",
            source: "Never Split the Difference (HarperBusiness, 2016), recounted on Rise With Drew",
            sourceUrl: "https://risewithdrew.com/negotiating-lesson-4-be-a-mirror/",
            scenario: "A boss directs the student to make duplicate paperwork. Using nothing but mirrors (repeating the last 1 to 3 words) the student exposes that the request was never validated against the actual customer.",
            turns: [
                TranscriptTurn(role: .buyer, text: "Let's make two copies of all the paperwork."),
                TranscriptTurn(role: .op, text: "I'm sorry, two copies?"),
                TranscriptTurn(role: .buyer, text: "Yes, one for us and one for the customer."),
                TranscriptTurn(role: .op, text: "I'm sorry, so the client is asking for a copy and we need one for internal use?"),
                TranscriptTurn(role: .buyer, text: "Actually, I'll check with the client. They haven't asked for anything. But I want a copy. That's how I do business."),
                TranscriptTurn(role: .op, text: "Absolutely. Thanks for checking with the customer. Where would you like to store the in-house copy?"),
                TranscriptTurn(role: .buyer, text: "It's fine. You can store it anywhere."),
                TranscriptTurn(role: .op, text: "Anywhere?"),
            ],
            techniqueNote: "Mirror followed by mirror forces a re-examination of the original premise. The operator never argues. The mirror does the work."
        ),

        Transcript(
            id: "voss-haiti-how",
            title: "How Am I Supposed to Do That? (Haiti Kidnapping)",
            speaker: "Chris Voss",
            source: "Never Split the Difference, Port-au-Prince case (2004), recounted on Rise With Drew",
            sourceUrl: "https://risewithdrew.com/negotiation-101-ask-open-ended-questions/",
            scenario: "A nephew's aunt is taken in Port-au-Prince. Initial ransom demand is $150,000. Voss coaches the nephew through calibrated open-ended questions instead of counter-offers. Final settlement: $4,751, aunt released within hours.",
            turns: [
                TranscriptTurn(role: .buyer, text: "Give us the money, or your aunt is going to die."),
                TranscriptTurn(role: .op, text: "How am I supposed to do that?"),
                TranscriptTurn(role: .buyer, text: "[restates demand, no specifics]"),
                TranscriptTurn(role: .op, text: "I'm sorry. How are we supposed to pay if you're going to hurt her?"),
                TranscriptTurn(role: .buyer, text: "[shifts toward terms]"),
                TranscriptTurn(role: .op, text: "How can I come up with that kind of money?"),
            ],
            techniqueNote: "Calibrated 'how' questions function as a soft no. They hand the problem back without confrontation. The counterparty starts solving the asker's problem instead of defending the demand."
        ),

        Transcript(
            id: "voss-live-label",
            title: "The Live Label (Interview Demo)",
            speaker: "Chris Voss",
            source: "Interview reproduced at Mindtools",
            sourceUrl: "https://www.mindtools.com/arg0sjv/never-split-the-difference/",
            scenario: "Mid-interview, Voss demonstrates labeling by catching the interviewer doing it to him in real time.",
            turns: [
                TranscriptTurn(role: .buyer, text: "It sounds like you think that labeling is an appropriate business tactic."),
                TranscriptTurn(role: .op, text: "You just labeled it. Is that right?"),
                TranscriptTurn(role: .buyer, text: "[acknowledges, laughs]"),
                TranscriptTurn(role: .op, text: "That's exactly what a label is. 'It sounds like,' 'it seems like,' 'it looks like.' You name the emotion or position out loud, then shut up."),
            ],
            techniqueNote: "Label followed by calibrated confirmation followed by silence. Labels work because they invite correction, which gives you the counterparty's real position for free."
        ),

        Transcript(
            id: "voss-accusation-audit",
            title: "Accusation Audit (Pre-emptive Negative Inventory)",
            speaker: "Chris Voss",
            source: "Black Swan Group blog",
            sourceUrl: "https://www.blackswanltd.com/the-edge/the-1-negotiation-strategy-for-everyone-backed-by-science",
            scenario: "Voss describes opening a hard conversation by listing, out loud and before the counterparty does, every negative they could plausibly be thinking about you. In one cited case, an executive used it to land a two-level promotion.",
            turns: [
                TranscriptTurn(role: .op, text: "Before we start, I want to get something out of the way."),
                TranscriptTurn(role: .op, text: "It probably seems like we don't care about you."),
                TranscriptTurn(role: .op, text: "It probably seems like we're selfish."),
                TranscriptTurn(role: .op, text: "It probably seems like I'm a loose cannon on this team."),
                TranscriptTurn(role: .buyer, text: "[posture softens; often denies one or more of the accusations]"),
                TranscriptTurn(role: .op, text: "Good. So here's what I'd actually like to propose..."),
            ],
            techniqueNote: "Stack three to five 'it probably seems like' statements followed by deliberate silence. The counterparty involuntarily de-escalates because the worst-case interpretations have been named and survived."
        ),

        Transcript(
            id: "klaff-time-reversal",
            title: "Time Frame Reversal (10-Minute Meeting)",
            speaker: "Oren Klaff",
            source: "Pitch Anything (McGraw-Hill, 2011), excerpted by Sheldon Nesdale",
            sourceUrl: "https://www.marketingfirst.co.nz/2013/10/pitch-anything-an-innovative-method-for-presenting-persuading-and-winning-the-deal-by-oren-klaff/",
            scenario: "Buyer opens by compressing your time. Klaff's prescription: refuse the compressed frame, defy it openly, and watch the buyer hand the time back.",
            turns: [
                TranscriptTurn(role: .buyer, text: "Hi, yes, um, well, I only have about 10 minutes to meet with you, but come on in."),
                TranscriptTurn(role: .op, text: "No. I don't work like that. There's no sense in rescheduling unless we like each other and trust each other."),
                TranscriptTurn(role: .op, text: "I need to know. Are you good to work with? Can you keep appointments and stick to a schedule?"),
                TranscriptTurn(role: .buyer, text: "Okay, you're right about that. Yeah, sure I can. Let's do this now. I have 30 minutes. That's no problem. Come on in."),
            ],
            techniqueNote: "Time-frame collision met with refusal and qualification. The buyer self-corrects upward from 10 to 30 minutes. The frame that reacts is the frame that loses."
        ),

        Transcript(
            id: "klaff-prize-frame",
            title: "Prize Frame Under Investor Drill-Down",
            speaker: "Oren Klaff",
            source: "Pitch Anything, excerpted by Sheldon Nesdale",
            sourceUrl: "https://www.marketingfirst.co.nz/2013/10/pitch-anything-an-innovative-method-for-presenting-persuading-and-winning-the-deal-by-oren-klaff/",
            scenario: "A VC tries to bury the pitch in line-by-line diligence. Klaff redirects with an intrigue frame, then collapses neediness with a prize frame at close.",
            turns: [
                TranscriptTurn(role: .buyer, text: "Walk me through the revenue model line by line. What's gross margin on segment two?"),
                TranscriptTurn(role: .op, text: "Revenue is $80 million, expenses are $62 million, net is $18 million. These you can verify later."),
                TranscriptTurn(role: .op, text: "Right now what we need to focus on is this. Are we a good fit? Should we be doing business together?"),
                TranscriptTurn(role: .buyer, text: "[tries to pull back to numbers]"),
                TranscriptTurn(role: .op, text: "There's a real possibility we're not right for each other. But if this did work out, our forces could combine into something great."),
                TranscriptTurn(role: .op, text: "This deal will be fully subscribed in the next 14 days. We don't need VC money. We want a big name on our cap sheet."),
                TranscriptTurn(role: .op, text: "I think you're interesting, but are you really the right investor for us?"),
            ],
            techniqueNote: "Intrigue frame (give headline numbers, defer the audit) plus push and pull tension plus prize frame at close. Buyer qualifies to operator, not the reverse."
        ),

        Transcript(
            id: "cardone-trial-close",
            title: "Trial-Close Stack (Transactional Close)",
            speaker: "Grant Cardone",
            source: "How To Close A Sale: The Ultimate Guide, grantcardone.com",
            sourceUrl: "https://grantcardone.com/close-sale/",
            scenario: "Showroom or product demo. Buyer has handled the product. Salesperson stacks low-friction trial closes to confirm fit before naming price.",
            turns: [
                TranscriptTurn(role: .op, text: "Hey, it looks like you really like this, is that true?"),
                TranscriptTurn(role: .buyer, text: "[affirms interest]"),
                TranscriptTurn(role: .op, text: "If you took this home would you be proud to own this?"),
                TranscriptTurn(role: .buyer, text: "[affirms]"),
                TranscriptTurn(role: .op, text: "Do you prefer the larger or smaller version?"),
                TranscriptTurn(role: .buyer, text: "[picks one]"),
                TranscriptTurn(role: .op, text: "How would this look in your home?"),
            ],
            techniqueNote: "Three-question affective ladder: interest, ownership, preference. Each is binary or preference-based, designed to extract micro-yeses. The 'larger or smaller' is an alternative-choice close disguised as a preference question."
        ),

        Transcript(
            id: "cardone-yay-or-nay",
            title: "Yay or Nay (Endgame Verbal Lock)",
            speaker: "Grant Cardone",
            source: "How To Close A Sale: The Ultimate Guide, grantcardone.com",
            sourceUrl: "https://grantcardone.com/close-sale/",
            scenario: "Late-stage negotiation. Buyer hesitates over a small price gap on a large deal. Cardone reframes the gap as trivial relative to the total, then forces a binary commit.",
            turns: [
                TranscriptTurn(role: .op, text: "You're talking about $100 in a $30,000 deal. $100 doesn't change it. Yay or nay?"),
                TranscriptTurn(role: .buyer, text: "That is true."),
                TranscriptTurn(role: .op, text: "Yay or nay?"),
                TranscriptTurn(role: .buyer, text: "Let's do it."),
            ],
            techniqueNote: "Magnitude-anchoring (reduce price gap to its share of total) followed by forced-binary close. The repeat of 'Yay or nay?' after a qualifying acknowledgment is the lock. Refuses any third option."
        ),

        Transcript(
            id: "cardone-snapbacks",
            title: "Four Objection Snap-Backs (Stall)",
            speaker: "Grant Cardone",
            source: "How To Close A Sale: The Ultimate Guide, grantcardone.com",
            sourceUrl: "https://grantcardone.com/close-sale/",
            scenario: "Standard objection volley. Each snap-back is a single-turn response to a common stall.",
            turns: [
                TranscriptTurn(role: .buyer, text: "I'm not buying today."),
                TranscriptTurn(role: .op, text: "Sir, that would be my fault, not yours."),
                TranscriptTurn(role: .buyer, text: "We're not buying until..."),
                TranscriptTurn(role: .op, text: "No problem, let me give you some idea of cost when you are ready."),
                TranscriptTurn(role: .buyer, text: "I need my wife or husband or CEO involved."),
                TranscriptTurn(role: .op, text: "I appreciate that, and I would want that as well. I want that person involved. Follow me."),
                TranscriptTurn(role: .buyer, text: "I don't have time."),
                TranscriptTurn(role: .op, text: "Sir, I understand you don't have time, and time is valuable to you. Let's get you figures you can live with."),
            ],
            techniqueNote: "Each response refuses the implied dismissal and converts the objection into a continuation. 'My fault not yours' is a credibility-reversal. 'Follow me' is a physical and verbal commit."
        ),

        Transcript(
            id: "tracy-money-reframe",
            title: "Money-Objection Hypothetical Removal",
            speaker: "Brian Tracy",
            source: "Effortlessly Diffuse The 'I Don't Have The Money' Objection, briantracy.com",
            sourceUrl: "https://www.briantracy.com/blog/sales-success/effortlessly-diffuse-the-i-dont-have-the-money-objection/",
            scenario: "Prospect raises the affordability objection. Tracy's move bypasses the logic war and tests for product-fit underneath the money concern.",
            turns: [
                TranscriptTurn(role: .buyer, text: "I don't have the money."),
                TranscriptTurn(role: .op, text: "That's not a problem. Tell me, if you did have the money, would this be something that would work for you?"),
                TranscriptTurn(role: .buyer, text: "[If yes, fit is confirmed. If no, the real objection surfaces.]"),
            ],
            techniqueNote: "Hypothetical removal. Strip the money variable so the prospect has to answer whether the product itself is right. A yes means solve a financing problem. A no means money was a polite refusal masking something else."
        ),

        Transcript(
            id: "tracy-feel-felt-found",
            title: "Feel-Felt-Found on Price",
            speaker: "Brian Tracy",
            source: "Sales Process: Handle Objections and Use Closing Techniques, briantracy.com",
            sourceUrl: "https://www.briantracy.com/blog/sales-success/sales-process-handle-objections-and-use-closing-techniques-sales-funnel/",
            scenario: "Prospect resists on price after presentation. The classic three-beat reframe.",
            turns: [
                TranscriptTurn(role: .buyer, text: "It costs too much."),
                TranscriptTurn(role: .op, text: "I understand exactly how you feel."),
                TranscriptTurn(role: .op, text: "Others felt the same way when they first heard the price."),
                TranscriptTurn(role: .op, text: "But this is what they found when they began using our product or service..."),
                TranscriptTurn(role: .op, text: "[Transition to a specific outcome story matched to the prospect's stated use case.]"),
            ],
            techniqueNote: "Acknowledge the emotion (feel), socially normalize it (felt), resolve it with concrete outcome data (found). Tracy delivers the three beats as a single uninterrupted turn."
        ),

        Transcript(
            id: "tracy-think-it-over",
            title: "Let Me Think About It (Stall Disarm)",
            speaker: "Brian Tracy",
            source: "Brian Tracy's published guidance on stall objections",
            sourceUrl: "https://www.briantracy.com/blog/sales-success/sales-process-handle-objections-and-use-closing-techniques-sales-funnel/",
            scenario: "End of presentation. Prospect deflects with the most common stall in sales. Tracy's move converts the stall back into a continuation by lowering the perceived commitment.",
            turns: [
                TranscriptTurn(role: .buyer, text: "Let me think about it."),
                TranscriptTurn(role: .op, text: "Relax, I'm not trying to sell you anything right now. That's not the purpose of my visit."),
                TranscriptTurn(role: .op, text: "All I ask is that you look at what I have to show you with an open mind, determine if it applies to your situation, and tell me at the end of our conversation if this product makes sense."),
                TranscriptTurn(role: .buyer, text: "[typically continues the conversation; the disarm has worked]"),
            ],
            techniqueNote: "Pressure-removal opener collapses the prospect's defensive frame. The conditional re-engagement ('tell me at the end if this makes sense') gives the prospect a graceful out, which paradoxically makes them more willing to stay engaged."
        ),

        Transcript(
            id: "belfort-aerotyne",
            title: "Cold-Open Qualifying Hook (Aerotyne)",
            speaker: "Jordan Belfort",
            source: "Reconstructed from Belfort's Straight Line teaching plus the 2013 film script (Wolf of Wall Street)",
            sourceUrl: "https://www.buzzlead.io/blogs/jordan-belfort-script-what-it-actually-says-and-how-to-use-it-in-cold-outreach",
            scenario: "Outbound cold call. Broker reaches a previously-interested prospect and opens with the Straight Line three-beat.",
            turns: [
                TranscriptTurn(role: .op, text: "Hi, is this [Name]? My name is Jordan Belfort. I'm calling from Stratton Oakmont. How are you today?"),
                TranscriptTurn(role: .buyer, text: "Good."),
                TranscriptTurn(role: .op, text: "The reason for my call is that a company just came across my desk. Aerotyne International. It's a cutting-edge tech firm out of the Midwest."),
                TranscriptTurn(role: .op, text: "They're awaiting imminent patent approval on a new generation of radar detectors. Huge military and civilian applications."),
                TranscriptTurn(role: .op, text: "The stock is trading at 10 cents a share. By the time the patent's approved, it's going to be trading at a dollar."),
                TranscriptTurn(role: .op, text: "I'm not asking you to mortgage your house. I'm just asking you to make a small investment, three to four thousand, and let me prove myself to you."),
            ],
            techniqueNote: "Three-beat opener: enthusiasm (name plus firm), peer-equality ('how are you today' delivered as friend-tone), then urgency-with-scarcity. The small ask anchors a smaller commitment, making the eventual upsell feel low-risk.",
            paraphrased: true
        ),
    ]

    private static let byId: [String: Transcript] = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })

    public static func get(_ id: String) -> Transcript? {
        byId[id]
    }
}
