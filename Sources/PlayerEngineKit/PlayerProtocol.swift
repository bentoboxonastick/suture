import Foundation
import SutureCore

/// Universal video & audio playback protocol implemented by AVPlayerEngine and MPVPlayerEngine.
@MainActor
public protocol SuturePlayerProtocol: AnyObject {
    var state: PlaybackState { get }
    var currentMedia: SutureMediaItem? { get }
    var currentStream: StreamSource? { get }
    var currentTime: TimeInterval { get }
    var duration: TimeInterval { get }
    var playbackRate: Float { get set }
    var volume: Float { get set }
    var isMuted: Bool { get set }
    
    var availableAudioTracks: [AudioTrack] { get }
    var selectedAudioTrack: AudioTrack? { get }
    var availableSubtitleTracks: [SubtitleTrack] { get }
    var selectedSubtitleTrack: SubtitleTrack? { get }
    
    func load(media: SutureMediaItem, stream: StreamSource) async throws
    func play()
    func pause()
    func togglePlayPause()
    func seek(to time: TimeInterval)
    func seekBy(offset: TimeInterval)
    func selectAudioTrack(_ track: AudioTrack)
    func selectSubtitleTrack(_ track: SubtitleTrack?)
    func stop()
}

/// External player handoff helper supporting Infuse, VLC, IINA, Outplayer, and VidHub.
public enum ExternalPlayerApp: String, CaseIterable, Identifiable, Sendable {
    case infuse = "Infuse"
    case vlc = "VLC"
    case iina = "IINA"
    case outplayer = "Outplayer"
    case vidhub = "VidHub"
    
    public var id: String { rawValue }
    
    public func generateURL(for streamURL: URL, title: String? = nil) -> URL? {
        let encodedStream = streamURL.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedTitle = title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        switch self {
        case .infuse:
            return URL(string: "infuse://x-callback-url/play?url=\(encodedStream)")
        case .vlc:
            return URL(string: "vlc://\(encodedStream)")
        case .iina:
            return URL(string: "iina://open?url=\(encodedStream)")
        case .outplayer:
            return URL(string: "outplayer://\(encodedStream)")
        case .vidhub:
            return URL(string: "vidhub://play?url=\(encodedStream)&title=\(encodedTitle)")
        }
    }
}
