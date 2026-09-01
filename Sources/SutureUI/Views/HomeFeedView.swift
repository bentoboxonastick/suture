import SwiftUI
import SutureCore

public struct HomeFeedView: View {
    @Bindable public var navigationState: AppNavigationState
    @State private var selectedCategory: String = "All"
    
    public init(navigationState: AppNavigationState) {
        self.navigationState = navigationState
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Top Category Filter Pills
                categoryFilterRow
                
                // Hero Billboard
                HeroBillboardView(
                    item: MockData.tearsOfSteel,
                    isInWatchlist: false,
                    onPlay: {
                        navigationState.presentStreamPicker(for: MockData.tearsOfSteel)
                    },
                    onInfo: {
                        navigationState.presentDetail(for: MockData.tearsOfSteel)
                    },
                    onToggleWatchlist: {
                        // Toggle watchlist
                    }
                )
                .padding(.horizontal, 24)
                
                // Continue Watching Rail
                MediaCarouselRail(
                    title: "Continue Watching",
                    items: [MockData.bigBuckBunny, MockData.sintel]
                ) { item in
                    navigationState.presentDetail(for: item)
                }
                
                // Trending Movies & Shows Rail
                MediaCarouselRail(
                    title: "Trending Movies & Shows",
                    items: MockData.trendingItems
                ) { item in
                    navigationState.presentDetail(for: item)
                }
                
                // Live TV Now Playing Rail
                MediaCarouselRail(
                    title: "Live TV (Now Airing)",
                    items: MockData.liveChannels
                ) { channel in
                    navigationState.presentStreamPicker(for: channel)
                }
                
                // Featured Hi-Res Music Rail
                MediaCarouselRail(
                    title: "Featured Hi-Res Music",
                    items: MockData.musicTracks
                ) { track in
                    navigationState.playTrack(track)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Color.suturePitch)
    }
    
    // MARK: - Category Filter Row
    private var categoryFilterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                categoryPill(title: "All")
                categoryPill(title: "Movies")
                categoryPill(title: "TV Shows")
                categoryPill(title: "Live TV")
                categoryPill(title: "Music")
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
        }
    }
    
    private func categoryPill(title: String) -> some View {
        let isSelected = selectedCategory == title
        return Button {
            selectedCategory = title
        } label: {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .bold : .medium, design: .rounded))
                .foregroundStyle(isSelected ? .white : Color.sutureTextSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(isSelected ? Color.sutureCrimson : Color.sutureSurface)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(isSelected ? Color.sutureCrimson : Color.sutureBorder.opacity(0.6), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview("Home Feed View") {
    HomeFeedView(navigationState: AppNavigationState())
}
