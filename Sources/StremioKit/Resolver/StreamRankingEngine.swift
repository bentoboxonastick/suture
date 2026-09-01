import Foundation
import SutureCore

/// Concurrent multi-source stream aggregator and quality ranking engine.
public struct StreamRankingEngine: Sendable {
    private let client: StremioAddonClient
    
    public init(client: StremioAddonClient = StremioAddonClient()) {
        self.client = client
    }
    
    /// Resolves and aggregates streams across multiple addon base URLs concurrently.
    public func resolveStreams(
        addonBaseURLs: [URL],
        type: String,
        id: String
    ) async -> [StreamSource] {
        await withTaskGroup(of: [StreamSource].self) { group in
            for url in addonBaseURLs {
                group.addTask {
                    do {
                        return try await self.client.fetchStreams(addonBaseURL: url, type: type, id: id)
                    } catch {
                        return []
                    }
                }
            }
            
            var allStreams: [StreamSource] = []
            for await streams in group {
                allStreams.append(contentsOf: streams)
            }
            
            return rankStreams(allStreams)
        }
    }
    
    /// Ranks streams in priority order: Cached Debrid -> Video Quality -> Dynamic Range -> File Size.
    public func rankStreams(_ streams: [StreamSource]) -> [StreamSource] {
        streams.sorted { (lhs: StreamSource, rhs: StreamSource) -> Bool in
            // 1. Debrid cache priority
            if lhs.isCachedDebrid != rhs.isCachedDebrid {
                return lhs.isCachedDebrid && !rhs.isCachedDebrid
            }
            
            // 2. Video quality priority
            if lhs.quality != rhs.quality {
                return lhs.quality > rhs.quality
            }
            
            // 3. Dynamic range priority
            if lhs.dynamicRange != rhs.dynamicRange {
                return lhs.dynamicRange > rhs.dynamicRange
            }
            
            // 4. File size priority (larger usually equals higher bitrate)
            if let lSize = lhs.fileSizeInBytes, let rSize = rhs.fileSizeInBytes {
                return lSize > rSize
            }
            
            // 5. Seeders priority
            return (lhs.seeders ?? 0) > (rhs.seeders ?? 0)
        }
    }
}
