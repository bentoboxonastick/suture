import Foundation
import SutureCore

/// Stremio Addon Protocol v3 Manifest Schema.
public struct StremioManifest: Codable, Sendable, Identifiable {
    public let id: String
    public let name: String
    public let version: String
    public let description: String?
    public let resources: [String]
    public let types: [String]
    public let catalogs: [StremioCatalogDescriptor]
    public let idPrefixes: [String]?
    
    public init(
        id: String,
        name: String,
        version: String,
        description: String? = nil,
        resources: [String] = [],
        types: [String] = [],
        catalogs: [StremioCatalogDescriptor] = [],
        idPrefixes: [String]? = nil
    ) {
        self.id = id
        self.name = name
        self.version = version
        self.description = description
        self.resources = resources
        self.types = types
        self.catalogs = catalogs
        self.idPrefixes = idPrefixes
    }
}

public struct StremioCatalogDescriptor: Codable, Sendable, Identifiable {
    public let type: String
    public let id: String
    public let name: String
    public let extra: [StremioExtraItem]?
    
    public init(type: String, id: String, name: String, extra: [StremioExtraItem]? = nil) {
        self.type = type
        self.id = id
        self.name = name
        self.extra = extra
    }
}

public struct StremioExtraItem: Codable, Sendable {
    public let name: String
    public let isRequired: Bool?
    public let options: [String]?
}

public struct StremioMetaResponse: Codable, Sendable {
    public let meta: StremioMetaItem
}

public struct StremioMetaItem: Codable, Sendable, Identifiable {
    public let id: String
    public let type: String
    public let name: String
    public let poster: String?
    public let background: String?
    public let logo: String?
    public let description: String?
    public let releaseInfo: String?
    public let imdbRating: String?
    public let genres: [String]?
    public let videos: [StremioVideoItem]?
}

public struct StremioVideoItem: Codable, Sendable, Identifiable {
    public let id: String
    public let title: String?
    public let season: Int?
    public let episode: Int?
    public let overview: String?
    public let thumbnail: String?
}

public struct StremioStreamResponse: Codable, Sendable {
    public let streams: [StremioStreamItem]
}

public struct StremioStreamItem: Codable, Sendable {
    public let name: String?
    public let title: String?
    public let url: String?
    public let infoHash: String?
    public let fileIdx: Int?
    public let behaviorHints: StremioBehaviorHints?
}

public struct StremioBehaviorHints: Codable, Sendable {
    public let notWebReady: Bool?
    public let proxyHeaders: [String: [String: String]]?
}
