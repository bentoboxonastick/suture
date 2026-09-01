import Foundation

/// Unified error catalog for Suture with standardized error codes and documentation mapping.
public enum SutureError: LocalizedError, Identifiable, Sendable {
    case debridExpired(provider: String)
    case debridRateLimit(retryAfterSeconds: Int)
    case addonManifestInvalid(url: String)
    case addonResponseMalformed(reason: String)
    case streamUnreachable(url: URL, underlying: String?)
    case streamPlaybackFailed(reason: String)
    case epgParseFailed(url: URL, reason: String)
    case epgOutOfSync(channel: String)
    case m3uUnreachable(url: URL)
    case codecUnsupported(codec: String)
    case tidalSessionExpired
    case traktSyncFailed(reason: String)
    case cloudKitQuotaExceeded
    case unknown(message: String)
    
    public var id: String { errorCode }
    
    public var errorCode: String {
        switch self {
        case .debridExpired: return "ERR_DEBRID_EXPIRED"
        case .debridRateLimit: return "ERR_DEBRID_RATE_LIMIT"
        case .addonManifestInvalid: return "ERR_ADDON_MANIFEST_INVALID"
        case .addonResponseMalformed: return "ERR_ADDON_MALFORMED"
        case .streamUnreachable: return "ERR_STREAM_UNREACHABLE"
        case .streamPlaybackFailed: return "ERR_STREAM_PLAYBACK_FAILED"
        case .epgParseFailed: return "ERR_EPG_PARSE_FAILED"
        case .epgOutOfSync: return "ERR_EPG_OUT_OF_SYNC"
        case .m3uUnreachable: return "ERR_M3U_UNREACHABLE"
        case .codecUnsupported: return "ERR_CODEC_UNSUPPORTED"
        case .tidalSessionExpired: return "ERR_TIDAL_SESSION_EXPIRED"
        case .traktSyncFailed: return "ERR_TRAKT_SYNC_FAILED"
        case .cloudKitQuotaExceeded: return "ERR_CLOUDKIT_QUOTA"
        case .unknown: return "ERR_UNKNOWN"
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .debridExpired(let provider):
            return "Your \(provider) account has expired or credentials are invalid."
        case .debridRateLimit(let seconds):
            return "Rate limit exceeded. Please wait \(seconds) seconds before retrying."
        case .addonManifestInvalid(let url):
            return "The addon manifest at \(url) is invalid or unreachable."
        case .addonResponseMalformed(let reason):
            return "Malformed addon response: \(reason)"
        case .streamUnreachable(let url, let underlying):
            return "Unable to connect to stream at \(url.host ?? "server"). \(underlying ?? "")"
        case .streamPlaybackFailed(let reason):
            return "Stream playback error: \(reason)"
        case .epgParseFailed(_, let reason):
            return "Failed to parse TV guide: \(reason)"
        case .epgOutOfSync(let channel):
            return "The guide schedule for \(channel) is out of sync with your local clock."
        case .m3uUnreachable(let url):
            return "Could not download playlist from \(url.host ?? "server")."
        case .codecUnsupported(let codec):
            return "Video or audio codec '\(codec)' cannot be played natively."
        case .tidalSessionExpired:
            return "Your Tidal session has expired. Please re-authenticate."
        case .traktSyncFailed(let reason):
            return "Trakt sync error: \(reason)"
        case .cloudKitQuotaExceeded:
            return "iCloud storage is full. Settings cannot be synced."
        case .unknown(let message):
            return message
        }
    }
    
    public var troubleshootingDocAnchor: String {
        "https://docs.suture.app/troubleshooting/error-code-directory#\(errorCode.lowercased())"
    }
}
