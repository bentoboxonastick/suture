import Foundation

/// Universal domain model representing any media item within Suture.
public struct SutureMediaItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let type: MediaType
    public let title: String
    public let subtitle: String?
    public let overview: String?
    public let releaseYear: Int?
    public let rating: Double?
    public let duration: TimeInterval?
    
    // Artwork URLs
    public let posterURL: URL?
    public let backdropURL: URL?
    public let logoURL: URL?
    public let previewVideoURL: URL?
    
    // Series / Episode Hierarchy
    public let seasonNumber: Int?
    public let episodeNumber: Int?
    public let seriesId: String?
    
    // Live TV EPG / Channel info
    public let channelNumber: String?
    public let currentProgramTitle: String?
    public let programStartTime: Date?
    public let programEndTime: Date?
    
    // Music Metadata
    public let artistName: String?
    public let albumTitle: String?
    public let trackNumber: Int?
    
    // Third-party IDs
    public let imdbId: String?
    public let tmdbId: Int?
    public let traktId: Int?
    public let simklId: Int?
    
    // Badges / Tags
    public let genres: [String]
    public let isLive: Bool
    
    public init(
        id: String,
        type: MediaType,
        title: String,
        subtitle: String? = nil,
        overview: String? = nil,
        releaseYear: Int? = nil,
        rating: Double? = nil,
        duration: TimeInterval? = nil,
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        logoURL: URL? = nil,
        previewVideoURL: URL? = nil,
        seasonNumber: Int? = nil,
        episodeNumber: Int? = nil,
        seriesId: String? = nil,
        channelNumber: String? = nil,
        currentProgramTitle: String? = nil,
        programStartTime: Date? = nil,
        programEndTime: Date? = nil,
        artistName: String? = nil,
        albumTitle: String? = nil,
        trackNumber: Int? = nil,
        imdbId: String? = nil,
        tmdbId: Int? = nil,
        traktId: Int? = nil,
        simklId: Int? = nil,
        genres: [String] = [],
        isLive: Bool = false
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.overview = overview
        self.releaseYear = releaseYear
        self.rating = rating
        self.duration = duration
        self.posterURL = posterURL
        self.backdropURL = backdropURL
        self.logoURL = logoURL
        self.previewVideoURL = previewVideoURL
        self.seasonNumber = seasonNumber
        self.episodeNumber = episodeNumber
        self.seriesId = seriesId
        self.channelNumber = channelNumber
        self.currentProgramTitle = currentProgramTitle
        self.programStartTime = programStartTime
        self.programEndTime = programEndTime
        self.artistName = artistName
        self.albumTitle = albumTitle
        self.trackNumber = trackNumber
        self.imdbId = imdbId
        self.tmdbId = tmdbId
        self.traktId = traktId
        self.simklId = simklId
        self.genres = genres
        self.isLive = isLive
    }
    
    public var formattedDuration: String? {
        guard let duration = duration, duration > 0 else { return nil }
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    public var liveProgress: Double? {
        guard isLive, let start = programStartTime, let end = programEndTime else { return nil }
        let now = Date()
        let total = end.timeIntervalSince(start)
        guard total > 0 else { return nil }
        let elapsed = now.timeIntervalSince(start)
        return min(max(elapsed / total, 0.0), 1.0)
    }
}
