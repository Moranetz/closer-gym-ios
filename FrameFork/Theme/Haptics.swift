import UIKit
import CoreHaptics

/// Centralized haptic service. Pre-prepares feedback generators so the
/// first tap doesn't lag (a common iOS gotcha).
///
/// Usage (anywhere):
///     Haptics.shared.selection()    // light tick — tab switch, candidate hover
///     Haptics.shared.light()         // before-reveal candidate confirmation
///     Haptics.shared.success()       // correct answer
///     Haptics.shared.error()         // wrong answer
///     Haptics.shared.medium()        // primary button press
///     Haptics.shared.streakMilestone()  // 3 escalating taps via AHAP
@MainActor
final class Haptics {
    static let shared = Haptics()

    private let selectionGen = UISelectionFeedbackGenerator()
    private let lightImpact  = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact  = UIImpactFeedbackGenerator(style: .heavy)
    private let notifGen     = UINotificationFeedbackGenerator()
    private var engine: CHHapticEngine?

    private init() {
        // Warm them up.
        selectionGen.prepare()
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
        notifGen.prepare()
        bootCoreHapticsEngine()
    }

    func selection() {
        selectionGen.selectionChanged()
        selectionGen.prepare()
    }

    func light() {
        lightImpact.impactOccurred(intensity: 0.7)
        lightImpact.prepare()
    }

    func medium() {
        mediumImpact.impactOccurred()
        mediumImpact.prepare()
    }

    func heavy() {
        heavyImpact.impactOccurred()
        heavyImpact.prepare()
    }

    func success() {
        notifGen.notificationOccurred(.success)
        notifGen.prepare()
    }

    func error() {
        notifGen.notificationOccurred(.error)
        notifGen.prepare()
    }

    func warning() {
        notifGen.notificationOccurred(.warning)
        notifGen.prepare()
    }

    // ─── AHAP custom — streak milestone (3 escalating taps) ──────────────
    private func bootCoreHapticsEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            // Auto-restart on stop (interruption from phone calls, etc.)
            engine?.resetHandler = { [weak self] in
                try? self?.engine?.start()
            }
            engine?.stoppedHandler = { _ in /* will auto-restart on next play */ }
        } catch {
            engine = nil
        }
    }

    func streakMilestone() {
        guard let engine else {
            // Fallback: three medium taps
            mediumImpact.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [self] in
                mediumImpact.impactOccurred()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { [self] in
                heavyImpact.impactOccurred()
            }
            return
        }
        do {
            let events: [CHHapticEvent] = [
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    .init(parameterID: .hapticIntensity, value: 0.5),
                    .init(parameterID: .hapticSharpness, value: 0.5),
                ], relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    .init(parameterID: .hapticIntensity, value: 0.75),
                    .init(parameterID: .hapticSharpness, value: 0.7),
                ], relativeTime: 0.12),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    .init(parameterID: .hapticIntensity, value: 1.0),
                    .init(parameterID: .hapticSharpness, value: 0.9),
                ], relativeTime: 0.30),
            ]
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            // Silent failure — never crash on a missing haptic.
        }
    }
}
