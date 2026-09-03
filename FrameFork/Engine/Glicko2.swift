import Foundation

/// Glicko-2 rating system. Reference: glicko.net/glicko/glicko2.pdf
/// (Mark Glickman, 2013). Direct port of web src/lib/elo.ts.
///
/// Used for the rating buckets: Game and Puzzle.
public struct GlickoState: Codable, Hashable, Sendable {
    public var rating: Double
    public var rd: Double           // rating deviation
    public var volatility: Double

    public init(rating: Double = initialRating, rd: Double = initialRD, volatility: Double = initialVolatility) {
        self.rating = rating
        self.rd = rd
        self.volatility = volatility
    }

    /// True while RD hasn't come down from the cold start — the rating is still a
    /// guess, not an earned class. See `provisionalRD` (EloBand.swift).
    public var isProvisional: Bool { rd > provisionalRD }
}

public struct MatchResult {
    public let opponentRating: Double
    public let opponentRD: Double
    public let score: Double        // 1 = win, 0.5 = draw, 0 = loss

    public init(opponentRating: Double, opponentRD: Double, score: Double) {
        self.opponentRating = opponentRating
        self.opponentRD = opponentRD
        self.score = score
    }
}

public enum Glicko2 {
    static let tau: Double = 0.5

    static func toG2(_ rating: Double, _ rd: Double) -> (mu: Double, phi: Double) {
        ((rating - 1500) / 173.7178, rd / 173.7178)
    }

    static func fromG2(_ mu: Double, _ phi: Double) -> (rating: Double, rd: Double) {
        (mu * 173.7178 + 1500, phi * 173.7178)
    }

    static func g(_ phi: Double) -> Double {
        1.0 / sqrt(1 + (3 * phi * phi) / (Double.pi * Double.pi))
    }

    static func E(_ mu: Double, _ muJ: Double, _ phiJ: Double) -> Double {
        // Clamp away from {0,1}. At the extremes E·(1−E) is 0, which would make
        // vInverse 0 and v = +Inf, poisoning the whole update with NaN. Reachable
        // only with pathological ratings, but cheap to make impossible.
        let e = 1.0 / (1 + exp(-g(phiJ) * (mu - muJ)))
        return min(max(e, 1e-12), 1 - 1e-12)
    }

    // Iterative volatility solver per Glickman 2013 §3.1.
    static func newVolatility(sigma: Double, phi: Double, v: Double, delta: Double) -> Double {
        let a = log(sigma * sigma)
        let epsilon = 1e-6
        let f: (Double) -> Double = { x in
            let ex = exp(x)
            let num = ex * (delta * delta - phi * phi - v - ex)
            let den = 2 * pow(phi * phi + v + ex, 2)
            return num / den - (x - a) / (tau * tau)
        }

        var A = a
        var B: Double
        if delta * delta > phi * phi + v {
            B = log(delta * delta - phi * phi - v)
        } else {
            var k = 1
            while f(a - Double(k) * tau) < 0 && k < 100 { k += 1 }
            B = a - Double(k) * tau
        }
        var fA = f(A)
        var fB = f(B)
        var iter = 0
        while abs(B - A) > epsilon && iter < 100 {
            let C = A + ((A - B) * fA) / (fB - fA)
            let fC = f(C)
            if fC * fB <= 0 {
                A = B
                fA = fB
            } else {
                fA = fA / 2
            }
            B = C
            fB = fC
            iter += 1
        }
        return exp(A / 2)
    }

    /// Update state given one or more match results in the same rating period.
    public static func update(_ state: GlickoState, results: [MatchResult]) -> GlickoState {
        guard !results.isEmpty else {
            // No games — only inflate RD by volatility.
            let (_, phi) = toG2(state.rating, state.rd)
            let newPhi = sqrt(phi * phi + state.volatility * state.volatility)
            let (_, rd) = fromG2(0, newPhi)
            return GlickoState(rating: state.rating, rd: rd, volatility: state.volatility)
        }

        let (mu, phi) = toG2(state.rating, state.rd)
        let opp = results.map { r -> (muJ: Double, phiJ: Double, score: Double) in
            let t = toG2(r.opponentRating, r.opponentRD)
            return (t.mu, t.phi, r.score)
        }

        var vInverse: Double = 0
        for o in opp {
            let gPhi = g(o.phiJ)
            let eMu = E(mu, o.muJ, o.phiJ)
            vInverse += gPhi * gPhi * eMu * (1 - eMu)
        }
        let v = vInverse > 0 ? 1.0 / vInverse : 1e9   // guard; E-clamp keeps vInverse > 0

        var deltaSum: Double = 0
        for o in opp {
            let gPhi = g(o.phiJ)
            let eMu = E(mu, o.muJ, o.phiJ)
            deltaSum += gPhi * (o.score - eMu)
        }
        let delta = v * deltaSum

        let newSigma = newVolatility(sigma: state.volatility, phi: phi, v: v, delta: delta)
        let phiStar = sqrt(phi * phi + newSigma * newSigma)
        let newPhi = 1.0 / sqrt(1 / (phiStar * phiStar) + 1 / v)
        let newMu = mu + newPhi * newPhi * deltaSum
        let (rating, rd) = fromG2(newMu, newPhi)
        return GlickoState(rating: rating, rd: rd, volatility: newSigma)
    }

    /// Convenience — single-match update returning (newState, delta).
    public static func applyMatch(_ state: GlickoState, opponent: GlickoState, score: Double) -> (state: GlickoState, delta: Double) {
        let next = update(state, results: [
            MatchResult(opponentRating: opponent.rating, opponentRD: opponent.rd, score: score)
        ])
        return (next, next.rating - state.rating)
    }
}
