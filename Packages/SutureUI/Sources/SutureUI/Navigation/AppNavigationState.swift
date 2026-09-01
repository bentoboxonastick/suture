import SwiftUI
import SutureCore

/// Primary navigation tabs across macOS, iPadOS, iOS, and tvOS.
public enum NavigationTab: String, CaseIterable, Identifiable, Sendable {
    case home = "Home"
    case movies = "Movies"
    case shows = "Shows"
    case liveTV = "Live TV"
    case music = "Music"
    case search = "Search"
    case watchlist = "Watchlist"
    case settings = "Settings"
    
    public var id: String { rawValue }
    
    public var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .movies: return "film.fill"
        case .shows: return "tv.fill"
        case .liveTV: return "antenna.radiowaves.left.and.right"
        case .music: return "music.note"
        case .search: return "magnifyingglass"
        case .watchlist: return "bookmark.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

/// Central navigation coordinator managing tabs, modals, search, and active playback sheets.
@MainActor
@Observable
public final class AppNavigationState {
    public var selectedTab: NavigationTab
    public var selectedMediaItem: SutureMediaItem?
    public var streamPickerItem: SutureMediaItem?
    public var activePlaybackStream: StreamSource?
    
    // Search State
    public var searchQuery: String
    public var searchMediaTypeFilter: MediaType?
    
    // Music Playback State
    public var currentlyPlayingTrack: SutureMediaItem?
    public var isMusicPlaying: Bool
    public var isFullscreenMusicExpanded: Bool
    
    public init(
        selectedTab: NavigationTab = .home,
        selectedMediaItem: SutureMediaItem? = nil,
        streamPickerItem: SutureMediaItem? = nil,
        activePlaybackStream: StreamSource? = nil,
        searchQuery: String = "",
        searchMediaTypeFilter: MediaType? = nil,
        currentlyPlayingTrack: SutureMediaItem? = nil,
        isMusicPlaying: Bool = false,
        isFullscreenMusicExpanded: Bool = false
    ) {
        self.selectedTab = selectedTab
        self.selectedMediaItem = selectedMediaItem
        self.streamPickerItem = streamPickerItem
        self.activePlaybackStream = activePlaybackStream
        self.searchQuery = searchQuery
        self.searchMediaTypeFilter = searchMediaTypeFilter
        self.currentlyPlayingTrack = currentlyPlayingTrack
        self.isMusicPlaying = isMusicPlaying
        self.isFullscreenMusicExpanded = isFullscreenMusicExpanded
    }
    
    // MARK: - Navigation Actions
    public func presentDetail(for item: SutureMediaItem) {
        selectedMediaItem = item
    }
    
    public func presentStreamPicker(for item: SutureMediaItem) {
        streamPickerItem = item
    }
    
    public func playStream(_ stream: StreamSource) {
        activePlaybackStream = stream
        streamPickerItem = nil
    }
    
    public func playTrack(_ track: SutureMediaItem) {
        currentlyPlayingTrack = track
        isMusicPlaying = true
    }
    
    public func toggleMusicPlayPause() {
        isMusicPlaying.toggle()
    }
    
    public func clearDetail() {
        selectedMediaItem = nil
    }
}
