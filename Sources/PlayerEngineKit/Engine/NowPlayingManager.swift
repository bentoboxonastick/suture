import Foundation
import SutureCore
#if canImport(MediaPlayer)
import MediaPlayer
#endif

/// Synchronizes playback metadata with Apple's Now Playing Center & Lock Screen controls.
@MainActor
public final class NowPlayingManager {
    public static let shared = NowPlayingManager()
    
    private init() {}
    
    public func updateNowPlaying(
        media: SutureMediaItem,
        currentTime: TimeInterval,
        duration: TimeInterval,
        playbackRate: Float
    ) {
        #if canImport(MediaPlayer)
        var info: [String: Any] = [
            MPMediaItemPropertyTitle: media.title,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyPlaybackRate: Double(playbackRate)
        ]
        
        if let subtitle = media.subtitle {
            info[MPMediaItemPropertyArtist] = subtitle
        } else if let artist = media.artistName {
            info[MPMediaItemPropertyArtist] = artist
        }
        
        if let album = media.albumTitle {
            info[MPMediaItemPropertyAlbumTitle] = album
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        #endif
    }
    
    public func clearNowPlaying() {
        #if canImport(MediaPlayer)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        #endif
    }
}
