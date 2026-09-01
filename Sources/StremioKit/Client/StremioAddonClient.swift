import Foundation
import SutureCore

/// Actor-isolated client for communicating with any Stremio v3 Addon protocol endpoint.
public actor StremioAddonClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    public init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }
    
    // MARK: - Manifest Retrieval
    public func fetchManifest(from rawURL: String) async throws -> StremioManifest {
        let manifestURL = try URLSanitizer.sanitizeManifestURL(rawURL)
        
        var request = URLRequest(url: manifestURL)
        request.timeoutInterval = 10
        request.setValue("Suture-Media-Hub/1.0", forHTTPHeaderField: "User-Agent")
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw SutureError.addonManifestInvalid(url: rawURL)
            }
            
            return try decoder.decode(StremioManifest.self, from: data)
        } catch let error as SutureError {
            throw error
        } catch {
            throw SutureError.addonResponseMalformed(reason: error.localizedDescription)
        }
    }
    
    // MARK: - Catalog Fetch
    public func fetchCatalog(
        addonBaseURL: URL,
        type: String,
        id: String,
        extra: [String: String]? = nil
    ) async throws -> [SutureMediaItem] {
        var endpoint = "\(addonBaseURL.absoluteString)/catalog/\(type)/\(id)"
        if let extra = extra, !extra.isEmpty {
            let extraString = extra.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            endpoint += "/\(extraString)"
        }
        endpoint += ".json"
        
        guard let url = URL(string: endpoint) else {
            throw SutureError.addonResponseMalformed(reason: "Invalid catalog endpoint: \(endpoint)")
        }
        
        struct CatalogResponse: Codable {
            let metas: [StremioMetaItem]
        }
        
        let (data, _) = try await session.data(from: url)
        let response = try decoder.decode(CatalogResponse.self, from: data)
        
        return response.metas.map { meta in
            SutureMediaItem(
                id: meta.id,
                type: meta.type == "series" ? .series : .movie,
                title: meta.name,
                subtitle: meta.releaseInfo,
                overview: meta.description,
                releaseYear: Int(meta.releaseInfo ?? ""),
                rating: Double(meta.imdbRating ?? ""),
                posterURL: meta.poster.flatMap { URL(string: $0) },
                backdropURL: meta.background.flatMap { URL(string: $0) },
                genres: meta.genres ?? []
            )
        }
    }
    
    // MARK: - Meta Fetch
    public func fetchMeta(
        addonBaseURL: URL,
        type: String,
        id: String
    ) async throws -> SutureMediaItem {
        let endpoint = "\(addonBaseURL.absoluteString)/meta/\(type)/\(id).json"
        guard let url = URL(string: endpoint) else {
            throw SutureError.addonResponseMalformed(reason: "Invalid meta endpoint: \(endpoint)")
        }
        
        let (data, _) = try await session.data(from: url)
        let response = try decoder.decode(StremioMetaResponse.self, from: data)
        let meta = response.meta
        
        return SutureMediaItem(
            id: meta.id,
            type: meta.type == "series" ? .series : .movie,
            title: meta.name,
            subtitle: meta.releaseInfo,
            overview: meta.description,
            releaseYear: Int(meta.releaseInfo ?? ""),
            rating: Double(meta.imdbRating ?? ""),
            posterURL: meta.poster.flatMap { URL(string: $0) },
            backdropURL: meta.background.flatMap { URL(string: $0) },
            genres: meta.genres ?? []
        )
    }
    
    // MARK: - Streams Fetch
    public func fetchStreams(
        addonBaseURL: URL,
        type: String,
        id: String
    ) async throws -> [StreamSource] {
        let endpoint = "\(addonBaseURL.absoluteString)/stream/\(type)/\(id).json"
        guard let url = URL(string: endpoint) else {
            throw SutureError.addonResponseMalformed(reason: "Invalid stream endpoint: \(endpoint)")
        }
        
        let (data, _) = try await session.data(from: url)
        let response = try decoder.decode(StremioStreamResponse.self, from: data)
        
        return response.streams.compactMap { stream in
            guard let streamURLString = stream.url, let streamURL = URL(string: streamURLString) else {
                return nil
            }
            
            let name = stream.name ?? "Direct Stream"
            let title = stream.title ?? ""
            let quality = inferQuality(from: "\(name) \(title)")
            let dynamicRange = inferDynamicRange(from: "\(name) \(title)")
            let isDebrid = name.contains("RD") || name.contains("RealDebrid") || name.contains("Debrid")
            
            return StreamSource(
                name: name,
                title: title.isEmpty ? nil : title,
                streamURL: streamURL,
                quality: quality,
                dynamicRange: dynamicRange,
                isCachedDebrid: isDebrid
            )
        }
    }
    
    // MARK: - Helpers
    private func inferQuality(from text: String) -> VideoQuality {
        let lower = text.lowercased()
        if lower.contains("4k") || lower.contains("2160p") || lower.contains("uhd") {
            return .uhd4k
        } else if lower.contains("1080p") || lower.contains("fhd") {
            return .fhd1080p
        } else if lower.contains("720p") || lower.contains("hd") {
            return .hd720p
        }
        return .sd480p
    }
    
    private func inferDynamicRange(from text: String) -> DynamicRange {
        let lower = text.lowercased()
        if lower.contains("dolby vision") || lower.contains("dovi") || lower.contains(" dv ") {
            return .dolbyVision
        } else if lower.contains("hdr10+") {
            return .hdr10Plus
        } else if lower.contains("hdr") {
            return .hdr10
        }
        return .sdr
    }
}
