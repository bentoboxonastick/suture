import Foundation
import SwiftData
import SutureCore

/// Represents a user-installed Stremio v3 addon configuration.
@Model
public final class StoredAddon {
    @Attribute(.unique) public var id: String
    public var name: String
    public var manifestURL: String
    public var isEnabled: Bool
    public var sortOrder: Int
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        manifestURL: String,
        isEnabled: Bool = true,
        sortOrder: Int = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.manifestURL = manifestURL
        self.isEnabled = isEnabled
        self.sortOrder = sortOrder
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

/// Represents a user-added M3U playlist and its associated XMLTV EPG feed.
@Model
public final class StoredPlaylist {
    @Attribute(.unique) public var id: String
    public var name: String
    public var sourceURL: String
    public var epgURL: String?
    public var isEnabled: Bool
    public var lastRefreshed: Date?
    public var customGroups: [String]
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        sourceURL: String,
        epgURL: String? = nil,
        isEnabled: Bool = true,
        lastRefreshed: Date? = nil,
        customGroups: [String] = []
    ) {
        self.id = id
        self.name = name
        self.sourceURL = sourceURL
        self.epgURL = epgURL
        self.isEnabled = isEnabled
        self.lastRefreshed = lastRefreshed
        self.customGroups = customGroups
    }
}

/// Tracks playback state and watch progress for "Continue Watching" rails.
@Model
public final class WatchHistoryItem {
    @Attribute(.unique) public var id: String // e.g. "tt15239678" or "seriesId_s1_e1"
    public var mediaId: String
    public var mediaTypeRaw: String
    public var title: String
    public var subtitle: String?
    public var posterURLString: String?
    public var backdropURLString: String?
    public var progressPercentage: Double
    public var lastPositionSeconds: Double
    public var totalDurationSeconds: Double
    public var lastWatchedAt: Date
    public var isCompleted: Bool
    
    public init(
        id: String,
        mediaId: String,
        mediaType: MediaType,
        title: String,
        subtitle: String? = nil,
        posterURLString: String? = nil,
        backdropURLString: String? = nil,
        progressPercentage: Double = 0.0,
        lastPositionSeconds: Double = 0.0,
        totalDurationSeconds: Double = 0.0,
        lastWatchedAt: Date = Date(),
        isCompleted: Bool = false
    ) {
        self.id = id
        self.mediaId = mediaId
        self.mediaTypeRaw = mediaType.rawValue
        self.title = title
        self.subtitle = subtitle
        self.posterURLString = posterURLString
        self.backdropURLString = backdropURLString
        self.progressPercentage = progressPercentage
        self.lastPositionSeconds = lastPositionSeconds
        self.totalDurationSeconds = totalDurationSeconds
        self.lastWatchedAt = lastWatchedAt
        self.isCompleted = isCompleted
    }
    
    public var mediaType: MediaType {
        MediaType(rawValue: mediaTypeRaw) ?? .movie
    }
}

/// Generic key-value store for app settings.
@Model
public final class UserPreference {
    @Attribute(.unique) public var key: String
    public var valueData: Data
    public var updatedAt: Date
    
    public init(key: String, valueData: Data, updatedAt: Date = Date()) {
        self.key = key
        self.valueData = valueData
        self.updatedAt = updatedAt
    }
}
