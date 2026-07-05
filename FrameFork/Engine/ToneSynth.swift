import Foundation
import AVFoundation

/// Tiny asset-free tone synthesizer for the verdict reveal (see JUICE-DOCTRINE.md §4).
/// Pure sine partials with percussive envelopes — warm, not arcade. Rendered to PCM and
/// played through an AVAudioPlayerNode on the `.ambient` session, so it respects the mute
/// switch and mixes with other audio. Every path is fail-safe: any error → silence, never a
/// crash. Sound is opt-out via UserDefaults (default on). No bundled audio = no IP exposure.
@MainActor
public final class ToneSynth {
    public static let shared = ToneSynth()

    private static let enabledKey = "framefork:sound:enabled:v1"
    public static var isEnabled: Bool {
        get { UserDefaults.standard.object(forKey: enabledKey) as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: enabledKey) }
    }

    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let sampleRate: Double = 44_100
    private var started = false

    private struct Note { let freq: Double; let start: Double; let dur: Double; let gain: Double; let decay: Double }

    private init() {}

    private func startIfNeeded() {
        guard !started else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient, options: [.mixWithOthers])
            try session.setActive(true)
            engine.attach(player)
            engine.connect(player, to: engine.mainMixerNode,
                           format: AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1))
            try engine.start()
            player.play()
            started = true
        } catch {
            started = false   // stay silent; never crash
        }
    }

    // MARK: - Verdict → notes (the sound spec)

    private func notes(for v: Verdict) -> [Note] {
        switch v {
        case .fork:   // full major triad (G–B–D) + low octave, longer tail — the only "fuller" sound
            return [Note(freq: 392.00, start: 0, dur: 0.42, gain: 0.13, decay: 5),
                    Note(freq: 493.88, start: 0, dur: 0.42, gain: 0.12, decay: 5),
                    Note(freq: 587.33, start: 0, dur: 0.42, gain: 0.11, decay: 5),
                    Note(freq: 196.00, start: 0, dur: 0.46, gain: 0.12, decay: 4)]
        case .sharp:  // ascending perfect fifth
            return [Note(freq: 440.00, start: 0,    dur: 0.16, gain: 0.15, decay: 9),
                    Note(freq: 659.25, start: 0.05, dur: 0.13, gain: 0.15, decay: 9)]
        case .best:   // ascending major third — barely more than routine
            return [Note(freq: 440.00, start: 0,    dur: 0.15, gain: 0.14, decay: 10),
                    Note(freq: 554.37, start: 0.055, dur: 0.12, gain: 0.14, decay: 10)]
        case .solid:  // single soft tone — the protected noise floor
            return [Note(freq: 466.16, start: 0, dur: 0.11, gain: 0.11, decay: 13)]
        case .fine:
            return [Note(freq: 415.30, start: 0, dur: 0.10, gain: 0.10, decay: 14)]
        case .loose, .slip, .missed:  // descending interval, dry, short — "off," never a buzzer
            return [Note(freq: 392.00, start: 0,    dur: 0.13, gain: 0.12, decay: 12),
                    Note(freq: 329.63, start: 0.06, dur: 0.12, gain: 0.12, decay: 12)]
        case .tell:   // low descending settle + low-octave body — heavy, not loud
            return [Note(freq: 233.08, start: 0,    dur: 0.24, gain: 0.15, decay: 7),
                    Note(freq: 174.61, start: 0.10, dur: 0.22, gain: 0.15, decay: 7),
                    Note(freq: 116.54, start: 0,    dur: 0.26, gain: 0.13, decay: 6)]
        }
    }

    public func play(_ v: Verdict) {
        guard ToneSynth.isEnabled else { return }
        startIfNeeded()
        // An audio interruption (phone call, Siri, route change) stops AVAudioEngine
        // behind our back; `started` alone would then schedule buffers into a dead
        // engine and every verdict after the call would be silent until relaunch.
        if started && !engine.isRunning {
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                try engine.start()
                player.play()
            } catch {
                return   // stay silent this reveal; retry on the next one
            }
        }
        guard started, engine.isRunning, let buf = render(notes(for: v)) else { return }
        player.scheduleBuffer(buf, at: nil, options: .interrupts, completionHandler: nil)
    }

    private func render(_ notes: [Note]) -> AVAudioPCMBuffer? {
        let tail = notes.map { $0.start + $0.dur }.max() ?? 0.4
        let frameCount = AVAudioFrameCount((tail + 0.08) * sampleRate)
        guard frameCount > 0,
              let fmt = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buf = AVAudioPCMBuffer(pcmFormat: fmt, frameCapacity: frameCount),
              let ch = buf.floatChannelData?[0] else { return nil }
        buf.frameLength = frameCount
        let n = Int(frameCount)
        for i in 0..<n { ch[i] = 0 }
        for note in notes {
            let startF = Int(note.start * sampleRate)
            let lenF = Int(note.dur * sampleRate)
            var k = 0
            while k < lenF {
                let idx = startF + k
                if idx >= n { break }
                let t = Double(k) / sampleRate
                let attack = min(1.0, t / 0.006)        // 6ms fade-in (no click)
                let env = exp(-t * note.decay) * attack
                ch[idx] += Float(sin(2.0 * .pi * note.freq * t) * note.gain * env)
                k += 1
            }
        }
        for i in 0..<n { ch[i] = tanhf(ch[i]) * 0.9 }   // soft-clip, headroom
        return buf
    }
}
