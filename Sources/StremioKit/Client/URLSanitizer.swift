import Foundation
import SutureCore

/// Utility for normalizing and sanitizing Stremio v3 addon URLs.
public enum URLSanitizer {
    
    /// Normalizes a raw addon URL (supporting `stremio://` and `https://` schemas) into a valid HTTPS manifest URL.
    public static func sanitizeManifestURL(_ rawString: String) throws -> URL {
        var cleanString = rawString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Convert stremio:// schema to https://
        if cleanString.hasPrefix("stremio://") {
            cleanString = "https://" + cleanString.dropFirst("stremio://".count)
        } else if !cleanString.hasPrefix("http://") && !cleanString.hasPrefix("https://") {
            cleanString = "https://" + cleanString
        }
        
        // Ensure /manifest.json is at the end
        if !cleanString.hasSuffix("/manifest.json") {
            if cleanString.hasSuffix("/") {
                cleanString += "manifest.json"
            } else {
                cleanString += "/manifest.json"
            }
        }
        
        guard let url = URL(string: cleanString), url.host != nil else {
            throw SutureError.addonManifestInvalid(url: rawString)
        }
        
        return url
    }
    
    /// Returns the base endpoint URL of an addon without the `/manifest.json` suffix.
    public static func extractBaseURL(from manifestURL: URL) -> URL {
        let string = manifestURL.absoluteString
        if string.hasSuffix("/manifest.json") {
            let base = string.replacingOccurrences(of: "/manifest.json", with: "")
            return URL(string: base) ?? manifestURL
        }
        return manifestURL
    }
}
