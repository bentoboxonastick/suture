import Foundation

/// Defines active playback state across both video and audio players.
public enum PlaybackState: String, Codable, Sendable, Equatable {
    case idle = "idle"
    case buffering = "buffering"
    case playing = "playing"
    case paused = "paused"
    case stopped = "stopped"
    case failed = "failed"
    
    public var isPlaying: Bool {
        self == .playing
    }
}

/// Represents an audio track in a stream.
public struct AudioTrack: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let language: String?
    public let title: String
    public let channelCount: Int
    public let isDefault: Bool
    
    public init(id: String, language: String? = nil, title: String, channelCount: Int = 2, isDefault: Bool = false) {
        self.id = id
        self.language = language
        self.title = title
        self.channelCount = channelCount
        self.isDefault = isDefault
    }
}

/// Represents a subtitle track in a stream.
public struct SubtitleTrack: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let language: String?
    public let title: String
    public let format: SubtitleFormat
    public let remoteURL: URL?
    public let isEmbedded: Bool
    public let isDefault: Bool
    
    public init(
        id: String,
        language: String? = nil,
        title: String,
        format: SubtitleFormat = .srt,
        remoteURL: URL? = nil,
        isEmbedded: Bool = false,
        isDefault: Bool = false
    ) {
        self.id = id
        self.language = language
        self.title = title
        self.format = format
        self.remoteURL = remoteURL
        self.isEmbedded = isEmbedded
        self.isDefault = isDefault
    }
}

public enum SubtitleFormat: String, Codable, Sendable {
    case srt = "srt"
    case vtt = "vtt"
    case ass = "ass"
    case ssa = "ssa"
}
