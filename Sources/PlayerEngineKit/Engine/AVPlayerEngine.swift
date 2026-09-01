import Foundation
import AVFoundation
import SutureCore

/// Native hardware-accelerated Apple AVPlayer engine.
@MainActor
@Observable
public final class AVPlayerEngine: SuturePlayerProtocol {
    public private(set) var state: PlaybackState = .idle
    public private(set) var currentMedia: SutureMediaItem?
    public private(set) var currentStream: StreamSource?
    public private(set) var currentTime: TimeInterval = 0
    public private(set) var duration: TimeInterval = 0
    
    public var playbackRate: Float = 1.0 {
        didSet {
            player.rate = (state == .playing) ? playbackRate : 0.0
        }
    }
    
    public var volume: Float = 1.0 {
        didSet {
            player.volume = volume
        }
    }
    
    public var isMuted: Bool = false {
        didSet {
            player.isMuted = isMuted
        }
    }
    
    public private(set) var availableAudioTracks: [AudioTrack] = []
    public private(set) var selectedAudioTrack: AudioTrack?
    public private(set) var availableSubtitleTracks: [SubtitleTrack] = []
    public private(set) var selectedSubtitleTrack: SubtitleTrack?
    
    public let player: AVPlayer
    private var timeObserverToken: Any?
    private var playerItemObserver: NSKeyValueObservation?
    
    public init(player: AVPlayer = AVPlayer()) {
        self.player = player
        setupTimeObserver()
    }
    
    deinit {
        // Observers cleaned up
    }
    
    // MARK: - Load & Playback
    public func load(media: SutureMediaItem, stream: StreamSource) async throws {
        self.currentMedia = media
        self.currentStream = stream
        self.state = .buffering
        
        let playerItem = AVPlayerItem(url: stream.streamURL)
        player.replaceCurrentItem(with: playerItem)
        
        // Observe duration & tracks
        observePlayerItem(playerItem)
        
        play()
    }
    
    public func play() {
        state = .playing
        player.play()
        player.rate = playbackRate
        
        if let media = currentMedia {
            NowPlayingManager.shared.updateNowPlaying(
                media: media,
                currentTime: currentTime,
                duration: duration,
                playbackRate: playbackRate
            )
        }
    }
    
    public func pause() {
        state = .paused
        player.pause()
        
        if let media = currentMedia {
            NowPlayingManager.shared.updateNowPlaying(
                media: media,
                currentTime: currentTime,
                duration: duration,
                playbackRate: 0.0
            )
        }
    }
    
    public func togglePlayPause() {
        if state == .playing {
            pause()
        } else {
            play()
        }
    }
    
    public func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
        currentTime = time
    }
    
    public func seekBy(offset: TimeInterval) {
        let target = max(0, min(duration, currentTime + offset))
        seek(to: target)
    }
    
    public func selectAudioTrack(_ track: AudioTrack) {
        self.selectedAudioTrack = track
        guard let currentItem = player.currentItem else { return }
        
        Task {
            if let group = try? await currentItem.asset.loadMediaSelectionGroup(for: .audible) {
                let option = group.options.first { $0.displayName == track.title }
                if let option = option {
                    currentItem.select(option, in: group)
                }
            }
        }
    }
    
    public func selectSubtitleTrack(_ track: SubtitleTrack?) {
        self.selectedSubtitleTrack = track
        guard let currentItem = player.currentItem else { return }
        
        Task {
            if let group = try? await currentItem.asset.loadMediaSelectionGroup(for: .legible) {
                if let track = track {
                    let option = group.options.first { $0.displayName == track.title }
                    if let option = option {
                        currentItem.select(option, in: group)
                    }
                } else {
                    currentItem.select(nil, in: group)
                }
            }
        }
    }
    
    public func stop() {
        player.pause()
        player.replaceCurrentItem(with: nil)
        state = .idle
        currentTime = 0
        duration = 0
        currentMedia = nil
        currentStream = nil
        NowPlayingManager.shared.clearNowPlaying()
    }
    
    // MARK: - Internal Observers
    private func setupTimeObserver() {
        let interval = CMTime(seconds: 0.25, preferredTimescale: 600)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.currentTime = time.seconds
            }
        }
    }
    
    private func observePlayerItem(_ item: AVPlayerItem) {
        playerItemObserver = item.observe(\.status, options: [.new]) { [weak self] playerItem, _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                if playerItem.status == .readyToPlay {
                    self.duration = playerItem.duration.seconds.isFinite ? playerItem.duration.seconds : 0
                    await self.discoverTracks(from: playerItem)
                    self.state = .playing
                } else if playerItem.status == .failed {
                    self.state = .failed
                }
            }
        }
    }
    
    private func discoverTracks(from item: AVPlayerItem) async {
        // Audible tracks
        if let audioGroup = try? await item.asset.loadMediaSelectionGroup(for: .audible) {
            self.availableAudioTracks = audioGroup.options.enumerated().map { idx, opt in
                AudioTrack(id: "\(idx)", language: opt.extendedLanguageTag, title: opt.displayName)
            }
        }
        
        // Legible tracks (Subtitles)
        if let subGroup = try? await item.asset.loadMediaSelectionGroup(for: .legible) {
            self.availableSubtitleTracks = subGroup.options.enumerated().map { idx, opt in
                SubtitleTrack(id: "\(idx)", language: opt.extendedLanguageTag, title: opt.displayName, format: .vtt)
            }
        }
    }
}
