import Foundation

/// Local Atlas detector. Pure regex/keyword pattern matching, no API call.
/// Mirrors web src/lib/detector-local.ts. Used to drive the eval bar during
/// live games (per-turn, instant, zero cost) and post-game review.
///
/// Accuracy target: ~70% agreement with the LLM detector on representative
/// input. Lower than the LLM (~85%) but free, instant, runs offline.
public enum DetectorLocal {
    public struct Result: Sendable {
        public let techniqueIds: [String]
        public let confidence: Confidence
    }

    public enum Confidence: String, Sendable {
        case high, medium, low
    }

    private struct Rule {
        let id: String
        let patterns: [NSRegularExpression]
        let weight: Int
        let needsContext: Bool
    }

    private static func re(_ pattern: String) -> NSRegularExpression {
        try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
    }

    // Stored once.
    private static let rules: [Rule] = [
        Rule(id: "calibrated-question", patterns: [
            re(#"^\s*(how|what|where|when|why|tell me|walk me through|help me understand|talk me through)\b[^?]+\?"#),
            re(#"\b(how|what)\s+(does|do|did|might|would|could|are|is)\b[^?]*\?"#),
        ], weight: 2, needsContext: false),

        Rule(id: "labeling", patterns: [
            re(#"\b(it (?:seems|sounds|looks|feels) like|you'?re (?:feeling|worried|concerned|frustrated|excited|hesitant|cautious|under pressure)|sounds like you)\b"#),
            re(#"\b(i (?:imagine|sense|hear|gather|notice) (?:that|you)|that (?:must (?:be|feel)|sounds (?:like|tough)))\b"#),
        ], weight: 2, needsContext: false),

        Rule(id: "mirroring", patterns: [], weight: 1, needsContext: true),

        Rule(id: "accusation-audit", patterns: [
            re(#"\b(i (?:know|imagine|expect) you'?re (?:probably )?(?:thinking|worried|wondering)|you (?:might|may|probably) (?:be )?(?:think|wonder)|i'?m sure you'?re (?:concerned|wondering|thinking))\b"#),
            re(#"\b(before you (?:say|push back|object)|you'?re probably going to say)\b"#),
        ], weight: 2, needsContext: false),

        Rule(id: "spin-implication", patterns: [
            re(#"\b(what (?:does that (?:cost|mean)|happens if|are the implications|is the impact|is the downside))\b"#),
            re(#"\b(how much (?:does|would|is|are) that (?:cost|costing|costing you|impacting))\b"#),
            re(#"\b(if (?:that|this) (?:keeps|continues|doesn'?t change))\b"#),
        ], weight: 1, needsContext: false),

        Rule(id: "spin-need-payoff", patterns: [
            re(#"\b(how would (?:that|it) help|what would (?:that|fixing this) mean|what'?s the value)\b"#),
            re(#"\b(if you (?:solved|fixed|had) that\b[^?]*\?)"#),
        ], weight: 1, needsContext: false),

        Rule(id: "summary-close", patterns: [
            re(#"\b(so (?:to summarize|let me make sure|what i'?m hearing)|let me play that back|to recap|here'?s what i'?m hearing)\b"#),
            re(#"\b(based on (?:everything|what) you'?ve (?:said|told me))\b"#),
        ], weight: 2, needsContext: false),

        Rule(id: "trial-close", patterns: [
            re(#"\b(does that (?:make sense|sound right|sound like|feel like)|how (?:does|would) that sit|on a scale of)\b"#),
            re(#"\b(if (?:we|i) (?:could|were to)\b[^?]*would you\b)"#),
        ], weight: 1, needsContext: false),

        Rule(id: "assumptive", patterns: [
            re(#"\b(when (?:we|you) (?:get started|kick off|onboard|sign|go live)|once (?:we|you) (?:start|begin|sign))\b"#),
            re(#"\b(let'?s (?:get you|book the|set up)\b)"#),
        ], weight: 1, needsContext: false),

        Rule(id: "alternative-choice", patterns: [
            re(#"\b(would you (?:prefer|rather) (?:to )?[a-z\s,]+ or [a-z\s,]+\?)"#),
            re(#"\b(option (?:a|1).*or option (?:b|2))"#),
        ], weight: 2, needsContext: false),

        Rule(id: "takeaway", patterns: [
            re(#"\b(maybe this isn'?t (?:the right|a fit)|i'?m not sure (?:this|we'?re) (?:is|are) (?:the right|a fit))\b"#),
            re(#"\b(we (?:may not be|might not be) the right|honestly i don'?t think)\b"#),
        ], weight: 2, needsContext: false),

        Rule(id: "loss-framing", patterns: [
            re(#"\b(cost of (?:doing nothing|inaction|not (?:moving|deciding))|what (?:you'?re|you'?d be) losing|status quo (?:costs|is costing))\b"#),
            re(#"\b(without (?:this|us)|if you don'?t|if nothing changes)\b"#),
            re(#"\b(every (?:week|month|quarter) (?:you (?:wait|delay)|of (?:delay|inaction)))\b"#),
        ], weight: 2, needsContext: false),

        Rule(id: "concrete-construal", patterns: [
            re(#"\b(in (?:concrete|specific|practical) terms|to (?:make (?:it )?concrete|put numbers on))\b"#),
            re(#"\b(here'?s exactly what|the specific number is|on day 1)\b"#),
        ], weight: 1, needsContext: false),

        Rule(id: "social-proof", patterns: [
            re(#"\b((?:other|other companies|teams|peers|customers) (?:at|in|like) (?:your|that|the))\b"#),
            re(#"\b(\d+ (?:of (?:your|the|our) peers|companies (?:like|in)|customers))\b"#),
            re(#"\b(case stud(?:y|ies)|peer (?:reference|data))\b"#),
        ], weight: 1, needsContext: false),

        Rule(id: "authority", patterns: [
            re(#"\b(our (?:research|study|paper|peer-reviewed|published))\b"#),
            re(#"\b(harvard|stanford|mit|the (?:wsj|economist|atlantic))\b"#),
        ], weight: 1, needsContext: false),

        Rule(id: "scarcity", patterns: [
            re(#"\b(only (?:\d+|a few) (?:left|spots|slots|seats)|limited (?:to|number)|this quarter only|deadline (?:is|on))\b"#),
            re(#"\b(if you don'?t (?:act|sign|commit) (?:by|before))\b"#),
        ], weight: 2, needsContext: false),

        Rule(id: "extreme-anchor", patterns: [
            re(#"\$\s?\d{1,3}(?:[,.]\d{3})+"#),
            re(#"\b\d{1,3}(?:[.,]\d{3})+\s?(?:dollars|usd)"#),
        ], weight: 1, needsContext: false),

        Rule(id: "anchor-with-range", patterns: [
            re(#"\$\s?\d[\d,.]*\s*[-–to]+\s*\$?\s?\d[\d,.]*"#),
            re(#"\bbetween (?:\$|\d)"#),
        ], weight: 1, needsContext: false),

        Rule(id: "mutual-close-plan", patterns: [
            re(#"\b(next steps|mutual (?:close|action) plan|MAP|let'?s (?:agree on|sketch) (?:a|the) (?:timeline|plan))\b"#),
            re(#"\b(by (?:next|this) (?:week|monday|tuesday|wednesday|thursday|friday|month|quarter))\b"#),
            re(#"\b(i'?ll (?:send|share|put together) (?:you|the)\b)"#),
        ], weight: 1, needsContext: false),

        Rule(id: "multi-threading", patterns: [
            re(#"\b(loop in|bring (?:in|on) (?:your|the) (?:cfo|cto|cro|vp|head of))\b"#),
            re(#"\b(who else (?:needs|should be|is) (?:involved|in the room|on the call))\b"#),
        ], weight: 1, needsContext: false),
    ]

    public static func detect(_ operatorText: String, recentBuyerTurn: String? = nil) -> Result {
        // Greeting / pleasantry fast-path
        let greetingPattern = try! NSRegularExpression(pattern: #"^\s*(hi|hello|hey|thanks for|appreciate|good (?:morning|afternoon|evening))[\s,!.]*$"#, options: [.caseInsensitive])
        let textRange = NSRange(operatorText.startIndex..., in: operatorText)
        if greetingPattern.firstMatch(in: operatorText, options: [], range: textRange) != nil {
            return Result(techniqueIds: [], confidence: .high)
        }

        var matched: [(id: String, weight: Int)] = []

        for rule in rules {
            var hits = 0
            for pattern in rule.patterns {
                if pattern.firstMatch(in: operatorText, options: [], range: textRange) != nil {
                    hits += 1
                }
            }
            // Mirror context-check (id = "mirroring"): operator turn starts with a verbatim echo
            // of the buyer's last 2-3 words. Cheap and conservative.
            if rule.needsContext, rule.id == "mirroring", let buyerTurn = recentBuyerTurn {
                let buyerWords = buyerTurn.split(separator: " ").suffix(3).map { String($0).lowercased().filter { !$0.isPunctuation } }
                if buyerWords.count >= 2 {
                    let opLower = operatorText.lowercased()
                    let openingChars = String(opLower.prefix(60))
                    if buyerWords.allSatisfy({ $0.count > 1 && openingChars.contains($0) }) {
                        hits += 1
                    }
                }
            }
            if hits > 0 {
                matched.append((rule.id, rule.weight))
            }
        }

        let totalWeight = matched.reduce(0) { $0 + $1.weight }
        let confidence: Confidence = totalWeight >= 3 ? .high : totalWeight >= 1 ? .medium : .low
        return Result(techniqueIds: matched.map { $0.id }, confidence: confidence)
    }
}
