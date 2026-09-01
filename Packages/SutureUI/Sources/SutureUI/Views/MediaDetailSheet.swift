import SwiftUI
import SutureCore

public struct MediaDetailSheet: View {
    public let item: SutureMediaItem
    public var onPlay: () -> Void
    public var onSelectStream: () -> Void
    public var onToggleWatchlist: () -> Void
    public var isInWatchlist: Bool
    public var onClose: () -> Void
    
    public init(
        item: SutureMediaItem,
        isInWatchlist: Bool = false,
        onPlay: @escaping () -> Void,
        onSelectStream: @escaping () -> Void,
        onToggleWatchlist: @escaping () -> Void,
        onClose: @escaping () -> Void
    ) {
        self.item = item
        self.isInWatchlist = isInWatchlist
        self.onPlay = onPlay
        self.onSelectStream = onSelectStream
        self.onToggleWatchlist = onToggleWatchlist
        self.onClose = onClose
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Header Banner
                heroHeader
                
                // Content Body
                VStack(alignment: .leading, spacing: 24) {
                    // Synopsis
                    if let overview = item.overview {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.sutureTextPrimary)
                            
                            Text(overview)
                                .font(.system(size: 14, weight: .regular))
                                .lineSpacing(4)
                                .foregroundStyle(Color.sutureTextSecondary)
                        }
                    }
                    
                    // Series Episodes (if applicable)
                    if item.type == .series {
                        Divider().background(Color.sutureBorder)
                        SeasonEpisodePicker { _ in
                            onPlay()
                        }
                    }
                    
                    Divider().background(Color.sutureBorder)
                    
                    // Recommendations Rail
                    MediaCarouselRail(title: "More Like This", items: MockData.trendingItems) { _ in }
                }
                .padding(24)
            }
        }
        .background(Color.suturePitch)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    // MARK: - Hero Header
    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            // Backdrop Artwork
            AsyncImage(url: item.backdropURL ?? item.posterURL) { phase in
                switch phase {
                case .empty:
                    Color.sutureSurface
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Color.sutureSurface
                @unknown default:
                    Color.sutureSurface
                }
            }
            .frame(height: 380)
            .clipped()
            .overlay(
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.suturePitch.opacity(0.4),
                        Color.suturePitch
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Close Button Top Right
            VStack {
                HStack {
                    Spacer()
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white.opacity(0.8))
                            .shadow(color: .black.opacity(0.6), radius: 6)
                    }
                    .buttonStyle(.plain)
                    .padding(20)
                }
                Spacer()
            }
            
            // Header Content
            VStack(alignment: .leading, spacing: 12) {
                Text(item.title)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(Color.sutureTextPrimary)
                    .shadow(color: .black.opacity(0.8), radius: 8)
                
                // Metadata Pills
                HStack(spacing: 12) {
                    if let rating = item.rating {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundStyle(.yellow)
                            Text(String(format: "%.1f", rating))
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    if let year = item.releaseYear {
                        Text(String(year))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.sutureTextSecondary)
                    }
                    
                    if let duration = item.formattedDuration {
                        Text(duration)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.sutureTextSecondary)
                    }
                    
                    // Quality Badges
                    badgePill("4K HDR")
                    badgePill("DOLBY ATMOS")
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    // Play Primary Button
                    Button {
                        onPlay()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 15, weight: .bold))
                            Text("Play")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    
                    // Stream Sources Selector
                    Button {
                        onSelectStream()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "server.rack")
                                .font(.system(size: 14))
                            Text("Sources")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundStyle(Color.sutureTextPrimary)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.sutureBorder.opacity(0.8), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // Watchlist Button
                    Button {
                        onToggleWatchlist()
                    } label: {
                        Image(systemName: isInWatchlist ? "checkmark" : "plus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(isInWatchlist ? Color.sutureEmerald : Color.sutureTextPrimary)
                            .frame(width: 38, height: 38)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.sutureBorder.opacity(0.8), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 4)
            }
            .padding(24)
        }
    }
    
    private func badgePill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(Color.sutureTextSecondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.sutureBorder.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }
}

#Preview("Media Detail Sheet") {
    ZStack {
        Color.suturePitch.ignoresSafeArea()
        MediaDetailSheet(item: MockData.tearsOfSteel, onPlay: {}, onSelectStream: {}, onToggleWatchlist: {}, onClose: {})
    }
}
