import Foundation
import SutureCore

/// Universal protocol for HTTPS Debrid unrestrictors (Real-Debrid, AllDebrid, Premiumize).
public protocol DebridProvider: Sendable {
    var providerName: String { get }
    func validateCredentials() async throws -> Bool
    func checkInstantAvailability(infohashes: [String]) async throws -> [String: Bool]
    func unrestrictDownloadLink(_ link: String) async throws -> URL
}
