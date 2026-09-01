import Foundation
import SutureCore

/// Real-Debrid API Client implementation conforming to DebridProvider.
public actor RealDebridClient: DebridProvider {
    public let providerName: String = "Real-Debrid"
    private let apiToken: String
    private let session: URLSession
    private let baseURL = URL(string: "https://api.real-debrid.com/rest/1.0")!
    
    public init(apiToken: String, session: URLSession = .shared) {
        self.apiToken = apiToken
        self.session = session
    }
    
    // MARK: - Validation
    public func validateCredentials() async throws -> Bool {
        let url = baseURL.appendingPathComponent("user")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    return true
                } else if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                    throw SutureError.debridExpired(provider: providerName)
                }
            }
            return false
        } catch let error as SutureError {
            throw error
        } catch {
            throw SutureError.debridExpired(provider: providerName)
        }
    }
    
    // MARK: - Instant Cache Check
    public func checkInstantAvailability(infohashes: [String]) async throws -> [String: Bool] {
        guard !infohashes.isEmpty else { return [:] }
        let hashesPath = infohashes.joined(separator: "/")
        let url = baseURL.appendingPathComponent("torrents/instantAvailability/\(hashesPath)")
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return [:]
        }
        
        // JSON format: { "<hash>": { "rd": [ { ... } ] } }
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: [String: Any]] {
            var result: [String: Bool] = [:]
            for (hash, dict) in json {
                let isCached = (dict["rd"] as? [[String: Any]])?.isEmpty == false
                result[hash.lowercased()] = isCached
            }
            return result
        }
        
        return [:]
    }
    
    // MARK: - Unrestrict Link
    public func unrestrictDownloadLink(_ link: String) async throws -> URL {
        let url = baseURL.appendingPathComponent("unrestrict/link")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postData = "link=\(link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? link)"
        request.httpBody = postData.data(using: .utf8)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SutureError.streamPlaybackFailed(reason: "Invalid server response from Debrid service.")
        }
        
        if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
            throw SutureError.debridExpired(provider: providerName)
        }
        
        struct UnrestrictResponse: Codable {
            let download: String?
            let streamable: Int?
        }
        
        let unrestrictResponse = try JSONDecoder().decode(UnrestrictResponse.self, from: data)
        guard let download = unrestrictResponse.download, let streamURL = URL(string: download) else {
            throw SutureError.streamPlaybackFailed(reason: "Debrid service could not generate direct stream link.")
        }
        
        return streamURL
    }
}
