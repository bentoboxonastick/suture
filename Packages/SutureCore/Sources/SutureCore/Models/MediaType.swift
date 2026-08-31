import Foundation

/// Defines the primary media category handled across Suture.
public enum MediaType: String, Codable, Sendable, CaseIterable, Identifiable {
    case movie = "movie"
    case series = "series"
    case episode = "episode"
    case liveTV = "live_tv"
    case musicTrack = "music_track"
    case musicAlbum = "music_album"
    case musicArtist = "music_artist"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .movie: return "Movies"
        case .series: return "TV Shows"
        case .episode: return "Episodes"
        case .liveTV: return "Live TV"
        case .musicTrack: return "Tracks"
        case .musicAlbum: return "Albums"
        case .musicArtist: return "Artists"
        }
    }
    
    public var iconName: String {
        switch self {
        case .movie: return "film"
        case .series: return "tv"
        case .episode: return "play.rectangle"
        case .liveTV: return "antenna.radiowaves.left.and.right"
        case .musicTrack: return "music.note"
        case .musicAlbum: return "square.stack"
        case .musicArtist: return "person.crop.circle"
        }
    }
}
