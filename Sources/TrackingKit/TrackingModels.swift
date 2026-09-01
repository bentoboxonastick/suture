import Foundation
import SutureCore

public enum ScrobbleAction: String, Codable, Sendable {
    case start = "start"
    case pause = "pause"
    case stop = "stop"
}

public struct ScrobbleEvent: Sendable, Identifiable {
    public let id: UUID
    public let mediaItem: SutureMediaItem
    public let action: ScrobbleAction
    public let progressPercentage: Double
    public let timestamp: Date
    
    public init(
        id: UUID = UUID(),
        mediaItem: SutureMediaItem,
        action: ScrobbleAction,
        progressPercentage: Double,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.mediaItem = mediaItem
        self.action = action
        self.progressPercentage = progressPercentage
        self.timestamp = timestamp
    }
}

public protocol ScrobbleProvider: Sendable {
    var providerName: String { get }
    var isConnected: Bool { get }
    func scrobble(event: ScrobbleEvent) async throws
    func syncWatchlist() async throws -> [SutureMediaItem]
    func syncPlaybackHistory() async throws -> [SutureMediaItem]
}
