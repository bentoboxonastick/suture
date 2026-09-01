import SwiftUI
import SutureCore

public struct UnifiedSearchView: View {
    @Bindable public var navigationState: AppNavigationState
    @State private var allItems: [SutureMediaItem] = MockData.trendingItems + MockData.liveChannels + MockData.musicTracks
    
    private let columns = [
        GridItem(.adaptive(minimum: 140, maximum: 180), spacing: 18)
    ]
    
    public init(navigationState: AppNavigationState) {
        self.navigationState = navigationState
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Search Input Header
            searchHeader
            
            Divider().background(Color.sutureBorder)
            
            // Search Results or Empty Discovery Grid
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    let results = filteredItems
                    
                    if results.isEmpty {
                        emptyStateView
                    } else {
                        Text(navigationState.searchQuery.isEmpty ? "Explore & Discover" : "Search Results (\(results.count))")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.sutureTextPrimary)
                            .padding(.top, 16)
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(results) { item in
                                MediaCardView(item: item) {
                                    if item.type == .musicTrack {
                                        navigationState.playTrack(item)
                                    } else {
                                        navigationState.presentDetail(for: item)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(24)
            }
        }
        .background(Color.suturePitch)
    }
    
    // MARK: - Search Header
    private var searchHeader: some View {
        VStack(spacing: 14) {
            // Text Input Box
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.sutureTextTertiary)
                
                TextField("Search Movies, Shows, Live Channels, Artists...", text: $navigationState.searchQuery)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.sutureTextPrimary)
                    .textFieldStyle(.plain)
                
                if !navigationState.searchQuery.isEmpty {
                    Button {
                        navigationState.searchQuery = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.sutureTextTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.sutureElevated)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.sutureBorder.opacity(0.8), lineWidth: 1)
            )
            
            // Category Filter Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    typeFilterPill(title: "All", type: nil)
                    typeFilterPill(title: "Movies", type: .movie)
                    typeFilterPill(title: "TV Shows", type: .series)
                    typeFilterPill(title: "Live TV", type: .liveTV)
                    typeFilterPill(title: "Music", type: .musicTrack)
                }
            }
        }
        .padding(20)
        .background(Color.sutureSurface)
    }
    
    private func typeFilterPill(title: String, type: MediaType?) -> some View {
        let isSelected = navigationState.searchMediaTypeFilter == type
        return Button {
            navigationState.searchMediaTypeFilter = type
        } label: {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                .foregroundStyle(isSelected ? .white : Color.sutureTextSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(isSelected ? Color.sutureCrimson : Color.sutureElevated)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(isSelected ? Color.sutureCrimson : Color.sutureBorder.opacity(0.6), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
    
    private var filteredItems: [SutureMediaItem] {
        allItems.filter { item in
            let matchesType = navigationState.searchMediaTypeFilter == nil || item.type == navigationState.searchMediaTypeFilter
            let matchesQuery = navigationState.searchQuery.isEmpty ||
                item.title.localizedCaseInsensitiveContains(navigationState.searchQuery) ||
                (item.subtitle?.localizedCaseInsensitiveContains(navigationState.searchQuery) ?? false) ||
                (item.artistName?.localizedCaseInsensitiveContains(navigationState.searchQuery) ?? false)
            return matchesType && matchesQuery
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "film.stack")
                .font(.system(size: 44))
                .foregroundStyle(Color.sutureTextTertiary)
            
            Text("No results found for \"\(navigationState.searchQuery)\"")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.sutureTextPrimary)
            
            Text("Try checking your spelling or adjusting your category filter.")
                .font(.system(size: 13))
                .foregroundStyle(Color.sutureTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview("Unified Search View") {
    UnifiedSearchView(navigationState: AppNavigationState())
}
