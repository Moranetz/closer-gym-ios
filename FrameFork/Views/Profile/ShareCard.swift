import SwiftUI

/// 1080x1080 share card. Rendered to PNG via ImageRenderer and exposed
/// through the iOS share sheet for LinkedIn / Twitter / Messages.
struct ShareCard: View {
    let rating: Double
    let streak: Int
    let longestStreak: Int
    let solveCount: Int

    var body: some View {
        let title = titleForRating(rating)
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.106, green: 0.102, blue: 0.098), Color(red: 0.149, green: 0.141, blue: 0.129)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Soft brand-green radial glow upper-left
            RadialGradient(
                colors: [Color.brandGreen.opacity(0.20), Color.clear],
                center: .topLeading,
                startRadius: 0,
                endRadius: 600
            )

            VStack(alignment: .leading, spacing: 0) {
                // Header band
                HStack {
                    Text("♞")
                        .font(.system(size: 56, weight: .heavy))
                        .foregroundStyle(Color.brandGreen)
                    Spacer()
                    Text("FRAME & FORK")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .kerning(2)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.horizontal, 60)
                .padding(.top, 56)

                Spacer()

                // Rating block
                VStack(alignment: .leading, spacing: 14) {
                    Text("PUZZLE RATING")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .kerning(3)
                        .foregroundStyle(Color.brandGreen)

                    HStack(alignment: .firstTextBaseline, spacing: 24) {
                        Text("\(Int(rating))")
                            .font(.system(size: 240, weight: .heavy, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(Color.textPrimary)
                            .kerning(-4)
                        Text(title.label.replacingOccurrences(of: " Closer", with: ""))
                            .font(.system(size: 36, weight: .heavy, design: .rounded))
                            .foregroundStyle(title.tier.textColor)
                            .padding(.horizontal, 18).padding(.vertical, 8)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(title.tier.color))
                            .offset(y: -36)
                    }
                }
                .padding(.horizontal, 60)

                Spacer().frame(height: 60)

                // Stats row
                HStack(spacing: 40) {
                    statBlock(label: "STREAK", value: "\(streak)d", color: streak > 0 ? Color.brandGreen : Color.textMuted)
                    Divider().frame(width: 1, height: 60).background(Color.borderStrong)
                    statBlock(label: "LONGEST", value: "\(longestStreak)d", color: Color.textSecondary)
                    Divider().frame(width: 1, height: 60).background(Color.borderStrong)
                    statBlock(label: "SOLVED", value: "\(solveCount)", color: Color.textSecondary)
                }
                .padding(.horizontal, 60)

                Spacer()

                // Footer
                VStack(alignment: .leading, spacing: 8) {
                    Text("There's no cheat code for a live buyer. We built the gym.")
                        .font(.system(size: 28, weight: .semibold))
                        .italic()
                        .foregroundStyle(Color.textSecondary)
                    Text("Frame & Fork")
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .kerning(2)
                        .foregroundStyle(Color.brandGreen)
                }
                .padding(.horizontal, 60)
                .padding(.bottom, 56)
            }
        }
        .frame(width: 1080, height: 1080)
    }

    private func statBlock(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .kerning(2)
                .foregroundStyle(Color.textMuted)
            Text(value)
                .font(.system(size: 56, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(color)
        }
    }
}

/// Renders a ShareCard to a PNG at 1080x1080 and returns the URL of the
/// temporary file. Designed for use with ShareLink or UIActivityViewController.
@MainActor
public enum ShareCardRenderer {
    // Cache keyed on the stats: ProfileTab evaluates its body on every Store change
    // and calls render from TWO ShareLinks — without the cache that was two full
    // 1080×1080 offscreen renders + synchronous main-thread disk writes per pass.
    private static var cachedKey: String?
    private static var cachedURL: URL?

    public static func render(rating: Double, streak: Int, longestStreak: Int, solveCount: Int) -> URL? {
        let rating = rating.isFinite ? rating : 1200   // Int(NaN) is a runtime trap
        let key = "\(Int(rating))-\(streak)-\(longestStreak)-\(solveCount)"
        if key == cachedKey, let cachedURL, FileManager.default.fileExists(atPath: cachedURL.path) {
            return cachedURL
        }
        let card = ShareCard(rating: rating, streak: streak, longestStreak: longestStreak, solveCount: solveCount)
        let renderer = ImageRenderer(content: card)
        renderer.scale = 1.0  // 1080x1080 native
        guard let image = renderer.uiImage,
              let data = image.pngData() else { return nil }

        // Stable filename — the old per-rating name accumulated stale PNGs in tmp.
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("framefork-rating-card.png")
        do {
            try data.write(to: url)
            cachedKey = key
            cachedURL = url
            return url
        } catch {
            return nil
        }
    }
}
