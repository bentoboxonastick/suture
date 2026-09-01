import SwiftUI
import SutureCore

public struct MusicPlayerBar: View {
    @Bindable public var navigationState: AppNavigationState
    
    public init(navigationState: AppNavigationState) {
        self.navigationState = navigationState
    }
    
    public var body: some View {
        if let track = navigationState.currentlyPlayingTrack {
            VStack(spacing: 0) {
                // MiniPlayer Bar
                HStack(spacing: 16) {
                    // Artwork
                    AsyncImage(url: track.posterURL) { phase in
                        switch phase {
                        case .empty:
                            Color.sutureElevated
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Color.sutureElevated
                        @unknown default:
                            Color.sutureElevated
                        }
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    
                    // Track Info & Animated Waveform
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 8) {
                            Text(track.title)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color.sutureTextPrimary)
                                .lineLimit(1)
                            
                            // 24-bit Hi-Res Pill
                            Text("24-BIT HI-RES")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Color.sutureCyan)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.sutureCyan.opacity(0.15))
                                .clipShape(Capsule())
                        }
                        
                        Text(track.artistName ?? "Unknown Artist")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color.sutureTextSecondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Soundwave Animation
                    if navigationState.isMusicPlaying {
                        SoundwaveVisualizerView()
                            .frame(width: 32, height: 18)
                    }
                    
                    // Controls: Previous, Play/Pause, Next
                    HStack(spacing: 14) {
                        Button {
                            // Previous
                        } label: {
                            Image(systemName: "backward.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.sutureTextSecondary)
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            navigationState.toggleMusicPlayPause()
                        } label: {
                            Image(systemName: navigationState.isMusicPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color.sutureTextPrimary)
                                .frame(width: 32, height: 32)
                                .background(Color.sutureElevated)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            // Next
                        } label: {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.sutureTextSecondary)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // Expand Button
                    Button {
                        navigationState.isFullscreenMusicExpanded.toggle()
                    } label: {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color.sutureTextTertiary)
                            .padding(6)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.sutureBorder.opacity(0.8), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.5), radius: 12, y: 6)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
        }
    }
}

public struct SoundwaveVisualizerView: View {
    @State private var isAnimating = false
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 3) {
            bar(delay: 0.1, minHeight: 4, maxHeight: 16)
            bar(delay: 0.3, minHeight: 6, maxHeight: 18)
            bar(delay: 0.2, minHeight: 4, maxHeight: 12)
            bar(delay: 0.4, minHeight: 6, maxHeight: 16)
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private func bar(delay: Double, minHeight: CGFloat, maxHeight: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.sutureCyan)
            .frame(width: 3, height: isAnimating ? maxHeight : minHeight)
            .animation(
                Animation.easeInOut(duration: 0.5)
                    .repeatForever(autoreverses: true)
                    .delay(delay),
                value: isAnimating
            )
    }
}

#Preview("Music Player Bar") {
    ZStack {
        Color.suturePitch.ignoresSafeArea()
        VStack {
            Spacer()
            MusicPlayerBar(
                navigationState: AppNavigationState(
                    currentlyPlayingTrack: MockData.solarFlareTrack,
                    isMusicPlaying: true
                )
            )
        }
    }
}
