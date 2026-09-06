import SwiftUI

/// Fleet round 92 (2026-09-03). Her ruling: Frame & Fork's world is chess-adjacent, "not like my
/// ascent app". Three worlds render on the Puzzles tab behind a DEBUG switch, for her gallery:
///   board — maple and walnut squares seen from above, lit from a window top-left; cards are ivory.
///   sheet — a club table: green baize under a brass lamp top-right; cards are cream scoresheet paper.
///   chart — a tournament hall's wall: index cards pinned to cork under a skylight.
/// `FF_WORLD=board|sheet|chart` (DEBUG only). Release renders `.shipped` until she picks.
enum World: String {
    case shipped, board, sheet, chart

    static let current: World = {
        #if DEBUG
        if let raw = ProcessInfo.processInfo.environment["FF_WORLD"], let w = World(rawValue: raw) { return w }
        #endif
        return .shipped
    }()

    var isWorld: Bool { self != .shipped }

    // Card material
    var panel: Color {
        switch self {
        case .shipped: return .bgPanel
        case .board: return hex(0xF6F0E0)
        case .sheet: return hex(0xF2E8CF)
        case .chart: return hex(0xFBF7EE)
        }
    }
    var rail: Color {
        switch self {
        case .shipped: return .bgRail
        case .board: return hex(0xE8DEC4)
        case .sheet: return hex(0xE6D9B8)
        case .chart: return hex(0xECE4D2)
        }
    }
    var border: Color {
        switch self {
        case .shipped: return .border
        case .board: return hex(0xD9CBAA)
        case .sheet: return hex(0xD6C7A1)
        case .chart: return hex(0xD6CBB4)
        }
    }
    /// The hero card's own material: the lit square, the index card dropped on the sheet, the
    /// whitest card on the wall.
    var heroFill: AnyShapeStyle {
        switch self {
        case .shipped: return AnyShapeStyle(LinearGradient(colors: [.bgPanel, .bgRail], startPoint: .topLeading, endPoint: .bottomTrailing))
        case .board: return AnyShapeStyle(hex(0xFBF6E8))
        case .sheet: return AnyShapeStyle(hex(0xFBF4E2))
        case .chart: return AnyShapeStyle(hex(0xFFFDF7))
        }
    }

    // Ink
    var ink: Color { self == .shipped ? .textPrimary : (self == .sheet ? hex(0x241D12) : hex(0x1F1A12)) }
    var inkSecondary: Color { self == .shipped ? .textSecondary : hex(0x3F3424) }
    var inkMuted: Color { self == .shipped ? .textMuted : hex(0x6A5B3F) }
    /// The ink for a small-caps section label. Fleet round 119: on the shipped page these read
    /// Lc 44.0 against body text at 70.5, and changing `microLabel`'s default did not reach them,
    /// because every label here passes its colour explicitly since the world work of round 92.
    var inkLabel: Color { self == .shipped ? .textLabel : hex(0x6A5B3F) }
    var inkFaint: Color { self == .shipped ? .textFaint : hex(0x8E7F62) }
    /// Green as ink on paper has to be deep to read; as a fill it stays the brand green on the dark
    /// shipped page and goes deep on paper so cream key text reads on it.
    var accent: Color { self == .shipped ? .brandGreen : hex(0x2B5D3A) }
    var keyInk: Color { self == .shipped ? .bgPage : hex(0xF6F0E0) }
}

private func hex(_ v: UInt32) -> Color {
    Color(red: Double((v >> 16) & 0xFF) / 255, green: Double((v >> 8) & 0xFF) / 255, blue: Double(v & 0xFF) / 255)
}

/// The ground behind the Puzzles tab. Drawn, never a stock gradient: wood squares with grain, felt
/// with its nap, cork with its speckle; light from somewhere in each.
struct WorldGround: View {
    var body: some View {
        switch World.current {
        case .shipped: Color.bgPage
        case .board: Canvas { ctx, size in drawBoard(ctx, size) }
        case .sheet: Canvas { ctx, size in drawSheet(ctx, size) }
        case .chart: Canvas { ctx, size in drawChart(ctx, size) }
        }
    }

    /// A small deterministic generator so the grain and speckle never shimmer between frames.
    private struct LCG {
        var s: UInt32
        mutating func next() -> Double { s = s &* 1664525 &+ 1013904223; return Double(s >> 8) / Double(1 << 24) }
    }

    private func drawBoard(_ ctx: GraphicsContext, _ size: CGSize) {
        let w = size.width, h = size.height
        let side = w / 8
        let maple = hex(0xF0D9B5), walnut = hex(0xB58863)
        var rng = LCG(s: 7)
        let rows = Int((h / side).rounded(.up)) + 1
        for r in 0..<rows {
            for c in 0..<8 {
                let rect = CGRect(x: CGFloat(c) * side, y: CGFloat(r) * side, width: side + 0.5, height: side + 0.5)
                let light = (r + c) % 2 == 0
                ctx.fill(Path(rect), with: .color(light ? maple : walnut))
                // three grain strokes per square, running with the board's length
                for _ in 0..<3 {
                    let y = rect.minY + rect.height * rng.next()
                    var p = Path(); p.move(to: CGPoint(x: rect.minX, y: y))
                    p.addCurve(to: CGPoint(x: rect.maxX, y: y + (rng.next() - 0.5) * 6),
                               control1: CGPoint(x: rect.minX + side * 0.35, y: y + (rng.next() - 0.5) * 4),
                               control2: CGPoint(x: rect.minX + side * 0.65, y: y + (rng.next() - 0.5) * 4))
                    ctx.stroke(p, with: .color(.black.opacity(light ? 0.05 : 0.09)), lineWidth: 0.8)
                }
            }
        }
        // a window top-left, and the far corner falling off
        ctx.fill(Path(CGRect(origin: .zero, size: size)),
                 with: .radialGradient(Gradient(colors: [.white.opacity(0.22), .clear]),
                                       center: CGPoint(x: w * 0.1, y: h * 0.05), startRadius: 0, endRadius: w * 0.95))
        ctx.fill(Path(CGRect(origin: .zero, size: size)),
                 with: .radialGradient(Gradient(colors: [.clear, .black.opacity(0.22)]),
                                       center: CGPoint(x: w * 0.15, y: h * 0.1), startRadius: w * 0.5, endRadius: w * 1.6))
    }

    private func drawSheet(_ ctx: GraphicsContext, _ size: CGSize) {
        let w = size.width, h = size.height
        ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(hex(0x2F6B45)))
        // the nap of the baize
        var rng = LCG(s: 11)
        for _ in 0..<1400 {
            let x = w * rng.next(), y = h * rng.next()
            let dark = rng.next() < 0.5
            ctx.fill(Path(ellipseIn: CGRect(x: x, y: y, width: 1.4, height: 1.4)),
                     with: .color(dark ? .black.opacity(0.10) : .white.opacity(0.07)))
        }
        // the lamp, top right
        ctx.fill(Path(CGRect(origin: .zero, size: size)),
                 with: .radialGradient(Gradient(stops: [.init(color: hex(0xFFD678).opacity(0.50), location: 0),
                                                        .init(color: hex(0xFFC85A).opacity(0.16), location: 0.45),
                                                        .init(color: .clear, location: 1)]),
                                       center: CGPoint(x: w * 0.86, y: h * 0.02), startRadius: 0, endRadius: w * 0.8))
        ctx.fill(Path(CGRect(origin: .zero, size: size)),
                 with: .radialGradient(Gradient(colors: [.clear, .black.opacity(0.28)]),
                                       center: CGPoint(x: w * 0.86, y: h * 0.02), startRadius: w * 0.7, endRadius: w * 1.9))
    }

    private func drawChart(_ ctx: GraphicsContext, _ size: CGSize) {
        let w = size.width, h = size.height
        ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(hex(0xC98F5B)))
        var rng = LCG(s: 23)
        for _ in 0..<2600 {
            let x = w * rng.next(), y = h * rng.next(), d = 1 + 2.4 * rng.next()
            let dark = rng.next() < 0.55
            ctx.fill(Path(ellipseIn: CGRect(x: x, y: y, width: d, height: d)),
                     with: .color(dark ? hex(0x9A6234).opacity(0.45) : hex(0xE8BE86).opacity(0.5)))
        }
        // skylight from above
        ctx.fill(Path(CGRect(x: 0, y: 0, width: w, height: h * 0.4)),
                 with: .linearGradient(Gradient(colors: [.white.opacity(0.16), .clear]),
                                       startPoint: .zero, endPoint: CGPoint(x: 0, y: h * 0.4)))
        // the walnut frame
        let f: CGFloat = 12
        var frame = Path(CGRect(origin: .zero, size: size))
        frame.addRect(CGRect(x: f, y: f, width: w - 2 * f, height: h - 2 * f))
        ctx.fill(frame, with: .color(hex(0x5A3A1E)), style: FillStyle(eoFill: true))
        ctx.stroke(Path(CGRect(x: f, y: f, width: w - 2 * f, height: h - 2 * f)), with: .color(.black.opacity(0.35)), lineWidth: 2)
    }
}

/// A drawing pin: red head, a highlight, the shadow it throws on the card.
struct WorldPin: View {
    var body: some View {
        ZStack {
            Ellipse().fill(.black.opacity(0.28)).frame(width: 16, height: 8).offset(x: 3, y: 8)
            Circle().fill(hex(0xC1440E)).frame(width: 14, height: 14)
            Circle().fill(.white.opacity(0.55)).frame(width: 5, height: 5).offset(x: -3, y: -3)
        }
    }
}

extension View {
    /// Every card on a world sits on it: a shadow on the table, a pin on the wall. The shipped
    /// page is untouched.
    @ViewBuilder func worldCard() -> some View {
        switch World.current {
        case .shipped: self
        case .board: self.shadow(color: .black.opacity(0.22), radius: 8, x: 4, y: 6)
        case .sheet: self.shadow(color: .black.opacity(0.30), radius: 10, x: -3, y: 7)
        case .chart: self.shadow(color: .black.opacity(0.28), radius: 6, x: 0, y: 5)
                .overlay(alignment: .top) { WorldPin().offset(y: -9) }
        }
    }
    /// The hero card on the sheet is an index card dropped on it, so it lies a little crooked.
    @ViewBuilder func worldHero() -> some View {
        if World.current == .sheet { self.rotationEffect(.degrees(-1.2)) } else { self }
    }
}
