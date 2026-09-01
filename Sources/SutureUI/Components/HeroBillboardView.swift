import SwiftUI
import SutureCore

public struct HeroBillboardView: View {
    public let item: SutureMediaItem
    public var onPlay: (() -> Void)?
    public var onInfo: (() -> Void)?
    public var onToggleWatchlist: (() -> Void)?
    public var isInWatchlist: Bool
    
    public init(
        item: SutureMediaItem,
        isInWatchlist: Bool = false,
        onPlay: (() -> Void)? = nil,
        onInfo: (() -> Void)? = nil,
        onToggleWatchlist: (() -> Void)? = nil
    ) {
        self.item = item
        self.isInWatchlist = isInWatchlist
        self.onPlay = onPlay
        self.onInfo = onInfo
        self.onToggleWatchlist = onToggleWatchlist
    }
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Backdrop Artwork with Gradient Overlays
            backdropLayer
            
            // Content Layer
            VStack(alignment: .leading, spacing: 14) {
                // Category Pill
                HStack(spacing: 6) {
                    Image(systemName: item.type.iconName)
                        .font(.system(size: 11, weight: .bold))
                    Text(item.type.displayName.uppercased())
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(1.5)
                }
                .foregroundStyle(Color.sutureCrimson)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.sutureCrimson.opacity(0.15))
                .clipShape(Capsule())
                
                // Title
                Text(item.title)
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundStyle(Color.sutureTextPrimary)
                    .shadow(color: .black.opacity(0.8), radius: 8, y: 4)
                
                // Badges & Metadata
                metadataRow
                
                // Overview Synopsis
                if let overview = item.overview {
                    Text(overview)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.sutureTextSecondary)
                        .lineLimit(3)
                        .frame(maxWidth: 580, alignment: .leading)
                        .shadow(color: .black.opacity(0.6), radius: 4)
                }
                
                // Action Cluster
                HStack(spacing: 12) {
                    // Play Button
                    Button {
                        onPlay?()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 15, weight: .bold))
                            Text("Play")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .shadow(color: .white.opacity(0.25), radius: 8)
                    }
                    .buttonStyle(.plain)
                    
                    // More Info Button
                    Button {
                        onInfo?()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 15, weight: .medium))
                            Text("More Info")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundStyle(Color.sutureTextPrimary)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.sutureBorder.opacity(0.6), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // Watchlist Toggle
                    Button {
                        onToggleWatchlist?()
                    } label: {
                        Image(systemName: isInWatchlist ? "checkmark" : "plus")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(isInWatchlist ? Color.sutureEmerald : Color.sutureTextPrimary)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.sutureBorder.opacity(0.6), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 6)
            }
            .padding(32)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 480)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    // MARK: - Backdrop Layer
    private var backdropLayer: some View {
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
        .overlay(
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.suturePitch.opacity(0.4),
                    Color.suturePitch.opacity(0.95),
                    Color.suturePitch
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            LinearGradient(
                colors: [
                    Color.suturePitch.opacity(0.85),
                    Color.suturePitch.opacity(0.3),
                    Color.clear
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
    
    // MARK: - Metadata Row
    private var metadataRow: some View {
        HStack(spacing: 12) {
            if let rating = item.rating {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", rating))
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.sutureTextPrimary)
                }
            }
            
            if let year = item.releaseYear {
                Text(String(year))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.sutureTextSecondary)
            }
            
            if let duration = item.formattedDuration {
                Text(duration)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.sutureTextSecondary)
            }
            
            // Format Badges
            HStack(spacing: 6) {
                badgePill(text: "4K UHD")
                badgePill(text: "HDR10")
                badgePill(text: "5.1 AUDIO")
            }
        }
    }
    
    private func badgePill(text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(Color.sutureTextSecondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.sutureBorder.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }
}

#Preview("Hero Billboard") {
    ZStack {
        Color.suturePitch.ignoresSafeArea()
        HeroBillboardView(item: MockData.tearsOfSteel, isInWatchlist: false)
            .padding()
    }
}
