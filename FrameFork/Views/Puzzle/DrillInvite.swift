import SwiftUI

/// The one thing that brings a player back tomorrow, offered at the only honest moment.
///
/// Round 167 audited this app's engagement and found the return trigger shipped OFF:
/// `DailyNotifications.isEnabled` reads `UserDefaults.bool`, which defaults to false, the only
/// switch lives in Settings, and nothing ever mentions it. The daily drill counts down on the
/// Puzzles tab — dated, named, real anticipation — and none of it reaches a phone that is in a
/// pocket.
///
/// Three rules the invitation follows, and each is a finding from the audit rather than taste:
///   · It comes AFTER the payoff, never before. The player has just been paid in a verdict and a
///     rating; asking there is reciprocity, and asking on launch is a toll gate.
///   · It is offered once, whatever the answer (`hasBeenOffered`). An invitation that returns is
///     a nag, and this app's own rulings put nagging on the never-list.
///   · It says what arrives and what it costs, and it never says what will be lost. Loss framing
///     buys compliance now and churn later.
struct DrillInvite: View {
    let hour: Int
    let minute: Int
    /// Called once the offer is spent, so the host can stop drawing it.
    var onResolved: () -> Void = {}

    @State private var phase: Phase = .offered
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    enum Phase { case offered, granted, refused }

    /// Three lines were written for the offer. `FF_INVITE_STYLE` renders the other two in DEBUG
    /// so they can be read on the card at the size they are used; Release ships 0.
    ///   0  what arrives, and when
    ///   1  what it costs
    ///   2  what the app has already learned about you
    private static var copyStyle: Int {
        #if DEBUG
        return CaptureHooks.value("FF_INVITE_STYLE").flatMap { Int($0) } ?? 0
        #else
        return 0
        #endif
    }

    private var headline: String {
        switch Self.copyStyle {
        case 1:  return "One position a day"
        case 2:  return "Your rating moves on days you play"
        default: return "Tomorrow's drill opens at \(timeText)"
        }
    }

    private var subline: String {
        switch Self.copyStyle {
        case 1:  return "About two minutes, at \(timeText). Nothing else gets sent."
        case 2:  return "A reminder at \(timeText) is the whole feature. Nothing else gets sent."
        default: return "One rated position, about two minutes. Nothing else gets sent."
        }
    }

    private var timeText: String {
        var c = DateComponents(); c.hour = hour; c.minute = minute
        let d = Calendar.current.date(from: c) ?? Date()
        let f = DateFormatter(); f.timeStyle = .short; f.dateStyle = .none
        return f.string(from: d)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch phase {
            case .offered:
                Text(headline)
                    .scaledFont(size: 13, weight: .bold)
                    .foregroundStyle(Color.textPrimary)
                Text(subline)
                    .scaledFont(size: 11)
                    .foregroundStyle(Color.textSecondary)
                HStack(spacing: 10) {
                    Button("Remind me") { enable() }
                        .scaledFont(size: 13, weight: .bold)
                        .foregroundStyle(Color.accentInk)
                        .accessibilityIdentifier("drillInviteAccept")
                    Button("No thanks") { dismissForGood() }
                        .scaledFont(size: 13, weight: .semibold)
                        .foregroundStyle(Color.textMuted)
                        .accessibilityIdentifier("drillInviteDecline")
                }
                .padding(.top, 2)

            case .granted:
                Text("Set for \(timeText)")
                    .scaledFont(size: 13, weight: .bold)
                    .foregroundStyle(Color.accentInk)
                Text("Change the time or turn it off in Settings.")
                    .scaledFont(size: 11).foregroundStyle(Color.textSecondary)

            case .refused:
                // The refusal-path class this fleet closed across seven apps: a permission that
                // is denied must SAY it was denied, or the control reads as never touched.
                Text("Notifications are off for this app")
                    .scaledFont(size: 13, weight: .bold)
                    .foregroundStyle(Color.textPrimary)
                Text("iOS will not ask again. Settings, then Frame & Fork, then Notifications.")
                    .scaledFont(size: 11).foregroundStyle(Color.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.railGround)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Color.border, lineWidth: 1)
        )
        .animation(reduceMotion ? nil : .easeOut(duration: 0.2), value: phase)
    }

    private func enable() {
        DailyNotifications.hasBeenOffered = true
        Task {
            let granted = await DailyNotifications.requestAuthorization()
            await MainActor.run {
                if granted {
                    DailyNotifications.isEnabled = true
                    DailyNotifications.schedule()
                    Haptics.shared.success()
                    phase = .granted
                } else {
                    DailyNotifications.isEnabled = false
                    phase = .refused
                }
            }
        }
    }

    /// Declining schedules nothing and marks the offer spent, so the card goes and never comes
    /// back. The host stops drawing it on `onResolved`.
    private func dismissForGood() {
        DailyNotifications.hasBeenOffered = true
        Haptics.shared.selection()
        onResolved()
    }
}
