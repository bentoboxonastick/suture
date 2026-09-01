import SwiftUI
import SutureCore

public struct MediaCarouselRail: View {
    public let title: String
    public let items: [SutureMediaItem]
    public var onSelectItem: ((SutureMediaItem) -> Void)?
    
    public init(
        title: String,
        items: [SutureMediaItem],
        onSelectItem: ((SutureMediaItem) -> Void)? = nil
    ) {
        self.title = title
        self.items = items
        self.onSelectItem = onSelectItem
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Rail Header
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.sutureTextPrimary)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.sutureTextTertiary)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // Horizontal Virtualized Rail
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(items) { item in
                        MediaCardView(item: item) {
                            onSelectItem?(item)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8) // Accommodates hover/focus scaling without clipping
            }
        }
    }
}

#Preview("Multiple Media Rails") {
    ZStack {
        Color.suturePitch.ignoresSafeArea()
        ScrollView {
            VStack(spacing: 32) {
                MediaCarouselRail(title: "Trending Movies & Shows", items: MockData.trendingItems)
                MediaCarouselRail(title: "Live TV Channels (Now Airing)", items: MockData.liveChannels)
                MediaCarouselRail(title: "Featured Hi-Res Music", items: MockData.musicTracks)
            }
            .padding(.vertical)
        }
    }
}
