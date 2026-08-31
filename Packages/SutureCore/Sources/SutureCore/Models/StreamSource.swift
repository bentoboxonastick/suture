import Foundation

/// Represents video or audio quality indicators.
public enum VideoQuality: String, Codable, Sendable, Comparable {
    case uhd4k = "4K"
    case fhd1080p = "1080p"
    case hd720p = "720p"
    case sd480p = "480p"
    case unknown = "SD"
    
    private var sortOrder: Int {
        switch self {
        case .uhd4k: return 4
        case .fhd1080p: return 3
        case .hd720p: return 2
        case .sd480p: return 1
        case .unknown: return 0
        }
    }
    
    public static func < (lhs: VideoQuality, rhs: VideoQuality) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}

/// Dynamic range capabilities.
public enum DynamicRange: String, Codable, Sendable {
    case dolbyVision = "Dolby Vision"
    case hdr10Plus = "HDR10+"
    case hdr10 = "HDR"
    case sdr = "SDR"
}

/// Audio profile indicators.
public enum AudioProfile: String, Codable, Sendable {
    case dolbyAtmos = "Dolby Atmos"
    case trueHD = "TrueHD 7.1"
    case dtsHD = "DTS-HD MA"
    case surround51 = "5.1 Surround"
    case stereo = "Stereo"
    case hiResFLAC = "24-bit Hi-Res"
    case losslessFLAC = "Lossless FLAC"
}

/// A playable media stream descriptor resolved from an addon, IPTV list, or music provider.
public struct StreamSource: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let title: String?
    public let streamURL: URL
    public let quality: VideoQuality
    public let dynamicRange: DynamicRange
    public let audioProfile: AudioProfile
    public let fileSizeInBytes: Int64?
    public let seeders: Int?
    public let providerName: String?
    public let isCachedDebrid: Bool
    public let customHeaders: [String: String]?
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        title: String? = nil,
        streamURL: URL,
        quality: VideoQuality = .fhd1080p,
        dynamicRange: DynamicRange = .sdr,
        audioProfile: AudioProfile = .stereo,
        fileSizeInBytes: Int64? = nil,
        seeders: Int? = nil,
        providerName: String? = nil,
        isCachedDebrid: Bool = false,
        customHeaders: [String: String]? = nil
    ) {
        self.id = id
        self.name = name
        self.title = title
        self.streamURL = streamURL
        self.quality = quality
        self.dynamicRange = dynamicRange
        self.audioProfile = audioProfile
        self.fileSizeInBytes = fileSizeInBytes
        self.seeders = seeders
        self.providerName = providerName
        self.isCachedDebrid = isCachedDebrid
        self.customHeaders = customHeaders
    }
    
    public var formattedSize: String? {
        guard let bytes = fileSizeInBytes, bytes > 0 else { return nil }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}
