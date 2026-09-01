import SwiftUI
import AVKit
import SutureCore
import PlayerEngineKit

public struct VideoPlayerView: View {
    @State public var engine: AVPlayerEngine
    public var onDismiss: () -> Void
    
    @State private var areControlsVisible: Bool = true
    @State private var isShowingTrackSelector: Bool = false
    @State private var hideTimer: Task<Void, Never>?
    
    public init(engine: AVPlayerEngine = AVPlayerEngine(), onDismiss: @escaping () -> Void) {
        _engine = State(initialValue: engine)
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Clean Hardware Accelerated Video Surface (No OS UI Controls)
            VideoSurfaceView(player: engine.player)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    toggleControls()
                }
            
            // Buffering Spinner
            if engine.state == .buffering {
                ProgressView()
                    .scaleEffect(1.8)
                    .tint(.sutureCrimson)
            }
            
            // Error State
            if engine.state == .failed {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.sutureCrimson)
                    Text("Playback Failed")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Unable to stream this media. Please check your connection or try another source.")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.sutureTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Button("Dismiss") {
                        onDismiss()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.sutureElevated)
                    .clipShape(Capsule())
                }
                .padding(32)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            // Custom Controls Overlay
            if areControlsVisible && engine.state != .idle {
                PlayerControlsOverlay(
                    engine: engine,
                    onDismiss: {
                        engine.stop()
                        onDismiss()
                    },
                    onToggleTracks: {
                        isShowingTrackSelector.toggle()
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
            
            // Audio & Subtitle Popover
            if isShowingTrackSelector {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture {
                        isShowingTrackSelector = false
                    }
                
                TrackSelectorMenu(engine: engine) {
                    isShowingTrackSelector = false
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            resetHideTimer()
        }
        #if os(macOS)
        .onHover { _ in
            showControlsTemporarily()
        }
        #endif
    }
    
    private func toggleControls() {
        withAnimation(.easeInOut(duration: 0.25)) {
            areControlsVisible.toggle()
        }
        if areControlsVisible {
            resetHideTimer()
        }
    }
    
    private func showControlsTemporarily() {
        if !areControlsVisible {
            withAnimation(.easeInOut(duration: 0.25)) {
                areControlsVisible = true
            }
        }
        resetHideTimer()
    }
    
    private func resetHideTimer() {
        hideTimer?.cancel()
        hideTimer = Task {
            try? await Task.sleep(nanoseconds: 3_500_000_000)
            if !Task.isCancelled && !isShowingTrackSelector && engine.state == .playing {
                withAnimation(.easeInOut(duration: 0.3)) {
                    areControlsVisible = false
                }
            }
        }
    }
}

#Preview("Video Player View") {
    let engine = AVPlayerEngine()
    VideoPlayerView(engine: engine, onDismiss: {})
        .task {
            let sampleMedia = SutureMediaItem(
                id: "sample_tos",
                type: .movie,
                title: "Tears of Steel",
                subtitle: "Blender Open Sci-Fi Movie",
                overview: "A group of warriors and scientists gather at the Oude Kerk in Amsterdam to stage a crucial event from the past.",
                releaseYear: 2012,
                posterURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/TearsOfSteel.jpg")
            )
            let sampleStream = StreamSource(
                name: "Tears of Steel (Open Source)",
                streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")!,
                quality: .fhd1080p,
                dynamicRange: .sdr
            )
            try? await engine.load(media: sampleMedia, stream: sampleStream)
        }
}
