import SwiftUI
import SutureCore

public struct MediaCardView: View {
    public let item: SutureMediaItem
    public var watchProgress: Double?
    public var onSelect: (() -> Void)?
    
    @State private var isHovered: Bool = false
    @FocusState private var isFocused: Bool
    
    public init(
        item: SutureMediaItem,
        watchProgress: Double? = nil,
        onSelect: (() -> Void)? = nil
    ) {
        self.item = item
        self.watchProgress = watchProgress
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button {
            onSelect?()
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                // Card Artwork Container
                ZStack(alignment: .bottomLeading) {
                    artworkView
                    
                    // Live TV Badge / Progress
                    if item.isLive {
                        liveOverlay
                    }
                    
                    // Continue Watching Progress Bar
                    if let progress = watchProgress, progress > 0 {
                        progressBar(progress: progress)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(
                            (isHovered || isFocused) ? Color.sutureCrimson : Color.sutureBorder.opacity(0.4),
                            lineWidth: (isHovered || isFocused) ? 2 : 1
                        )
                )
                .shadow(
                    color: (isHovered || isFocused) ? Color.sutureCrimson.opacity(0.35) : Color.black.opacity(0.4),
                    radius: (isHovered || isFocused) ? 14 : 4,
                    y: (isHovered || isFocused) ? 6 : 2
                )
                .scaleEffect((isHovered || isFocused) ? 1.06 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
                
                // Metadata Labels
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.sutureTextPrimary)
                        .lineLimit(1)
                    
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(Color.sutureTextSecondary)
                            .lineLimit(1)
                    }
                }
                .frame(width: cardWidth)
            }
        }
        .buttonStyle(.plain)
        .focused($isFocused)
        #if os(macOS)
        .onHover { hovering in
            isHovered = hovering
        }
        #endif
    }
    
    // MARK: - Artwork View
    private var artworkView: some View {
        AsyncImage(url: item.type == .liveTV ? (item.backdropURL ?? item.posterURL) : (item.posterURL ?? item.backdropURL)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.sutureSurface
                    ProgressView()
                        .tint(.sutureCrimson)
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                ZStack {
                    Color.sutureElevated
                    Image(systemName: item.type.iconName)
                        .font(.system(size: 28))
                        .foregroundStyle(Color.sutureTextTertiary)
                }
            @unknown default:
                Color.sutureSurface
            }
        }
        .frame(width: cardWidth, height: cardHeight)
    }
    
    // MARK: - Overlays
    private var liveOverlay: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color.sutureEmerald)
                .frame(width: 6, height: 6)
            Text("LIVE")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color.black.opacity(0.75))
        .clipShape(Capsule())
        .padding(8)
    }
    
    private func progressBar(progress: Double) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.black.opacity(0.6))
                    .frame(height: 4)
                
                Rectangle()
                    .fill(Color.sutureCrimson)
                    .frame(width: geo.size.width * CGFloat(min(max(progress, 0.0), 1.0)), height: 4)
            }
        }
        .frame(height: 4)
    }
    
    private var cardWidth: CGFloat {
        switch item.type {
        case .movie, .series: return 140
        case .liveTV: return 220
        case .musicTrack, .musicAlbum, .musicArtist: return 140
        case .episode: return 200
        }
    }
    
    private var cardHeight: CGFloat {
        switch item.type {
        case .movie, .series: return 210 // 2:3 ratio
        case .liveTV: return 124 // 16:9 ratio
        case .musicTrack, .musicAlbum, .musicArtist: return 140 // 1:1 ratio
        case .episode: return 112 // 16:9 ratio
        }
    }
}

#Preview("Standard Media Card") {
    ZStack {
        Color.suturePitch.ignoresSafeArea()
        HStack(spacing: 20) {
            MediaCardView(item: MockData.tearsOfSteel)
            MediaCardView(item: MockData.bigBuckBunny, watchProgress: 0.45)
            MediaCardView(item: MockData.nasaTV)
            MediaCardView(item: MockData.solarFlareTrack)
        }
        .padding()
    }
}
