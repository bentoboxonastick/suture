import Foundation
import SutureCore

public enum MusicProvider: String, Codable, Sendable {
    case tidal = "Tidal"
    case qobuz = "Qobuz"
}

public enum AudioSampleQuality: String, Codable, Sendable {
    case hiRes24Bit192k = "24-bit / 192kHz FLAC"
    case hiRes24Bit96k = "24-bit / 96kHz FLAC"
    case lossless16Bit44k = "16-bit / 44.1kHz FLAC"
    case standardAAC = "320kbps AAC"
}

/// Domain model representing a music track from Tidal or Qobuz.
public struct MusicTrack: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let artistName: String
    public let albumTitle: String
    public let duration: TimeInterval
    public let trackNumber: Int
    public let coverArtURL: URL?
    public let provider: MusicProvider
    public let quality: AudioSampleQuality
    
    public init(
        id: String,
        title: String,
        artistName: String,
        albumTitle: String,
        duration: TimeInterval,
        trackNumber: Int = 1,
        coverArtURL: URL? = nil,
        provider: MusicProvider,
        quality: AudioSampleQuality = .lossless16Bit44k
    ) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.albumTitle = albumTitle
        self.duration = duration
        self.trackNumber = trackNumber
        self.coverArtURL = coverArtURL
        self.provider = provider
        self.quality = quality
    }
    
    public func toMediaItem() -> SutureMediaItem {
        SutureMediaItem(
            id: id,
            type: .musicTrack,
            title: title,
            subtitle: artistName,
            overview: "\(albumTitle) • \(quality.rawValue)",
            duration: duration,
            posterURL: coverArtURL,
            artistName: artistName,
            albumTitle: albumTitle,
            trackNumber: trackNumber,
            genres: [provider.rawValue]
        )
    }
}
