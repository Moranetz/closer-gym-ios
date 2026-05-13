import Foundation

/// Real sourced transcript excerpts. Mirror of web src/lib/transcripts.ts.
/// Brief quotation for educational reference under fair use, source-cited.
public struct Transcript: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let title: String
    public let speaker: String
    public let source: String
    public let sourceUrl: String
    public let scenario: String
    public let turns: [TranscriptTurn]
    public let techniqueNote: String
    public let techniqueIds: [String]
    public let paraphrased: Bool

    public init(id: String, title: String, speaker: String, source: String, sourceUrl: String,
                scenario: String, turns: [TranscriptTurn], techniqueNote: String,
                techniqueIds: [String] = [], paraphrased: Bool = false) {
        self.id = id
        self.title = title
        self.speaker = speaker
        self.source = source
        self.sourceUrl = sourceUrl
        self.scenario = scenario
        self.turns = turns
        self.techniqueNote = techniqueNote
        self.techniqueIds = techniqueIds
        self.paraphrased = paraphrased
    }
}

public struct TranscriptTurn: Hashable, Codable, Sendable {
    public let role: TranscriptRole
    public let text: String

    public init(role: TranscriptRole, text: String) {
        self.role = role
        self.text = text
    }
}

public enum TranscriptRole: String, Codable, Sendable {
    case op = "operator"
    case buyer
    case narrator
}
