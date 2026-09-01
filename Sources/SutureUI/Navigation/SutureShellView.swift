import SwiftUI
import SutureCore
import PlayerEngineKit

public struct SutureShellView: View {
    @State public var navigationState: AppNavigationState
    
    public init(navigationState: AppNavigationState = AppNavigationState()) {
        _navigationState = State(initialValue: navigationState)
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            #if os(macOS) || os(visionOS)
            macOSLayout
            #elseif os(tvOS)
            tvOSLayout
            #else
            iOSLayout
            #endif
            
            // Persistent Bottom MiniPlayer
            MusicPlayerBar(navigationState: navigationState)
            
            // MARK: - In-Canvas & In-Window Modal Overlays
            
            // 1. Media Detail Modal
            if let item = navigationState.selectedMediaItem, navigationState.streamPickerItem == nil, navigationState.activePlaybackStream == nil {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            navigationState.clearDetail()
                        }
                    
                    MediaDetailSheet(
                        item: item,
                        isInWatchlist: false,
                        onPlay: {
                            navigationState.presentStreamPicker(for: item)
                        },
                        onSelectStream: {
                            navigationState.presentStreamPicker(for: item)
                        },
                        onToggleWatchlist: {},
                        onClose: {
                            navigationState.clearDetail()
                        }
                    )
                    .frame(maxWidth: 820, maxHeight: 720)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: .black.opacity(0.8), radius: 32)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
                .zIndex(10)
            }
            
            // 2. Stream Picker Modal
            if let item = navigationState.streamPickerItem, navigationState.activePlaybackStream == nil {
                ZStack {
                    Color.black.opacity(0.75)
                        .ignoresSafeArea()
                        .onTapGesture {
                            navigationState.streamPickerItem = nil
                        }
                    
                    StreamPickerSheet(
                        item: item,
                        onSelectStream: { stream in
                            navigationState.playStream(stream)
                        },
                        onSelectExternal: { stream, app in
                            if let url = app.generateURL(for: stream.streamURL, title: item.title) {
                                #if canImport(AppKit)
                                NSWorkspace.shared.open(url)
                                #elseif canImport(UIKit)
                                UIApplication.shared.open(url)
                                #endif
                            }
                        },
                        onClose: {
                            navigationState.streamPickerItem = nil
                        }
                    )
                    .frame(maxWidth: 680, maxHeight: 620)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: .black.opacity(0.8), radius: 32)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
                .zIndex(20)
            }
            
            // 3. Fullscreen Hardware-Accelerated Video Player
            if let stream = navigationState.activePlaybackStream {
                let engine = AVPlayerEngine()
                VideoPlayerView(engine: engine) {
                    navigationState.activePlaybackStream = nil
                }
                .task {
                    let media = navigationState.selectedMediaItem ?? SutureMediaItem(id: "stream_item", type: .movie, title: stream.name)
                    try? await engine.load(media: media, stream: stream)
                }
                .transition(.opacity)
                .zIndex(30)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: navigationState.selectedMediaItem != nil)
        .animation(.easeInOut(duration: 0.25), value: navigationState.streamPickerItem != nil)
        .animation(.easeInOut(duration: 0.25), value: navigationState.activePlaybackStream != nil)
        .preferredColorScheme(.dark)
    }
    
    // MARK: - macOS / iPadOS Split View Layout
    #if os(macOS) || os(visionOS)
    private var macOSLayout: some View {
        NavigationSplitView {
            List(selection: $navigationState.selectedTab) {
                ForEach(NavigationTab.allCases) { tab in
                    Label(tab.rawValue, systemImage: tab.iconName)
                        .tag(tab)
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Suture")
        } detail: {
            tabContentView(for: navigationState.selectedTab)
        }
    }
    #endif
    
    // MARK: - iOS Tab Bar Layout
    #if os(iOS)
    private var iOSLayout: some View {
        TabView(selection: $navigationState.selectedTab) {
            HomeFeedView(navigationState: navigationState)
                .tabItem {
                    Label(NavigationTab.home.rawValue, systemImage: NavigationTab.home.iconName)
                }
                .tag(NavigationTab.home)
            
            LiveTVGuideView(navigationState: navigationState)
                .tabItem {
                    Label(NavigationTab.liveTV.rawValue, systemImage: NavigationTab.liveTV.iconName)
                }
                .tag(NavigationTab.liveTV)
            
            UnifiedSearchView(navigationState: navigationState)
                .tabItem {
                    Label(NavigationTab.search.rawValue, systemImage: NavigationTab.search.iconName)
                }
                .tag(NavigationTab.search)
            
            settingsPlaceholderView
                .tabItem {
                    Label(NavigationTab.settings.rawValue, systemImage: NavigationTab.settings.iconName)
                }
                .tag(NavigationTab.settings)
        }
        .tint(Color.sutureCrimson)
    }
    #endif
    
    // MARK: - tvOS Living Room Top Tab Layout
    #if os(tvOS)
    private var tvOSLayout: some View {
        TabView(selection: $navigationState.selectedTab) {
            HomeFeedView(navigationState: navigationState)
                .tabItem {
                    Label(NavigationTab.home.rawValue, systemImage: NavigationTab.home.iconName)
                }
                .tag(NavigationTab.home)
            
            LiveTVGuideView(navigationState: navigationState)
                .tabItem {
                    Label(NavigationTab.liveTV.rawValue, systemImage: NavigationTab.liveTV.iconName)
                }
                .tag(NavigationTab.liveTV)
            
            UnifiedSearchView(navigationState: navigationState)
                .tabItem {
                    Label(NavigationTab.search.rawValue, systemImage: NavigationTab.search.iconName)
                }
                .tag(NavigationTab.search)
            
            settingsPlaceholderView
                .tabItem {
                    Label(NavigationTab.settings.rawValue, systemImage: NavigationTab.settings.iconName)
                }
                .tag(NavigationTab.settings)
        }
    }
    #endif
    
    // MARK: - Content Router
    @ViewBuilder
    private func tabContentView(for tab: NavigationTab) -> some View {
        switch tab {
        case .home:
            HomeFeedView(navigationState: navigationState)
        case .movies:
            UnifiedSearchView(navigationState: navigationState)
        case .shows:
            UnifiedSearchView(navigationState: navigationState)
        case .liveTV:
            LiveTVGuideView(navigationState: navigationState)
        case .music:
            UnifiedSearchView(navigationState: navigationState)
        case .search:
            UnifiedSearchView(navigationState: navigationState)
        case .watchlist:
            HomeFeedView(navigationState: navigationState)
        case .settings:
            settingsPlaceholderView
        }
    }
    
    private var settingsPlaceholderView: some View {
        VStack(spacing: 20) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.sutureCrimson)
            
            Text("Settings & Addon Manager")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.sutureTextPrimary)
            
            Text("Configure Stremio v3 Addons, M3U Playlists, Tidal/Qobuz accounts, and iCloud Sync.")
                .font(.system(size: 14))
                .foregroundStyle(Color.sutureTextSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.suturePitch)
    }
}

#Preview("Suture Shell") {
    SutureShellView()
}
