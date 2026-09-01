import SwiftUI
import SutureCore
import PlayerEngineKit

public struct PlayerControlsOverlay: View {
    @Bindable public var engine: AVPlayerEngine
    public var onDismiss: () -> Void
    public var onToggleTracks: () -> Void
    
    @State private var isSeeking: Bool = false
    @State private var seekSliderValue: Double = 0
    
    public init(
        engine: AVPlayerEngine,
        onDismiss: @escaping () -> Void,
        onToggleTracks: @escaping () -> Void
    ) {
        self.engine = engine
        self.onDismiss = onDismiss
        self.onToggleTracks = onToggleTracks
    }
    
    public var body: some View {
        ZStack {
            // Background Dark Dimming
            Color.black.opacity(0.45).ignoresSafeArea()
            
            VStack {
                // Top Header Bar
                topHeaderBar
                
                Spacer()
                
                // Center Transport Cluster (Skip -10s, Play/Pause, Skip +10s)
                centerTransportCluster
                
                Spacer()
                
                // Bottom Control Bar (Scrubber, Timestamps, Speed)
                bottomControlBar
            }
            .padding(24)
        }
    }
    
    // MARK: - Top Header Bar
    private var topHeaderBar: some View {
        HStack(alignment: .center) {
            Button {
                onDismiss()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                    Text("Back")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            VStack(spacing: 2) {
                if let title = engine.currentMedia?.title {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                if let subtitle = engine.currentMedia?.subtitle {
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.sutureTextSecondary)
                }
            }
            
            Spacer()
            
            // Audio & Subtitles Button
            Button {
                onToggleTracks()
            } label: {
                Image(systemName: "captions.bubble.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Center Transport Cluster
    private var centerTransportCluster: some View {
        HStack(spacing: 40) {
            // Skip -10s
            Button {
                engine.seekBy(offset: -10)
            } label: {
                Image(systemName: "gobackward.10")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
                    .padding(14)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
            // Play / Pause Big Button
            Button {
                engine.togglePlayPause()
            } label: {
                Image(systemName: engine.state == .playing ? "pause.fill" : "play.fill")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 76, height: 76)
                    .background(Color.sutureCrimson)
                    .clipShape(Circle())
                    .shadow(color: Color.sutureCrimson.opacity(0.5), radius: 16)
            }
            .buttonStyle(.plain)
            
            // Skip +10s
            Button {
                engine.seekBy(offset: 10)
            } label: {
                Image(systemName: "goforward.10")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
                    .padding(14)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Bottom Control Bar
    private var bottomControlBar: some View {
        VStack(spacing: 8) {
            // High-Precision Seek Scrubber
            GeometryReader { geo in
                let currentProgress = engine.duration > 0 ? (engine.currentTime / engine.duration) : 0
                ZStack(alignment: .leading) {
                    // Track Background
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 6)
                    
                    // Active Progress
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.sutureCrimson)
                        .frame(width: geo.size.width * CGFloat(min(max(currentProgress, 0), 1)), height: 6)
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let fraction = max(0, min(1, value.location.x / geo.size.width))
                            let targetTime = fraction * engine.duration
                            engine.seek(to: targetTime)
                        }
                )
            }
            .frame(height: 12)
            
            // Timestamps & Speed Selector
            HStack {
                Text(formatTime(engine.currentTime))
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(Color.sutureTextSecondary)
                
                Spacer()
                
                // Playback Speed Menu
                Menu {
                    Button("0.75x") { engine.playbackRate = 0.75 }
                    Button("1.0x (Normal)") { engine.playbackRate = 1.0 }
                    Button("1.25x") { engine.playbackRate = 1.25 }
                    Button("1.5x") { engine.playbackRate = 1.5 }
                    Button("2.0x") { engine.playbackRate = 2.0 }
                } label: {
                    Text("\(String(format: "%.2fx", engine.playbackRate))")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.sutureTextSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                
                Text("-\(formatTime(max(0, engine.duration - engine.currentTime)))")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(Color.sutureTextSecondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
