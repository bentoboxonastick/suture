import SwiftUI
import SutureCore
import PlayerEngineKit

public struct TrackSelectorMenu: View {
    @Bindable public var engine: AVPlayerEngine
    public var onClose: () -> Void
    
    public init(engine: AVPlayerEngine, onClose: @escaping () -> Void) {
        self.engine = engine
        self.onClose = onClose
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Text("Audio & Subtitles")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.sutureTextPrimary)
                
                Spacer()
                
                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.sutureTextTertiary)
                }
                .buttonStyle(.plain)
            }
            
            Divider().background(Color.sutureBorder)
            
            HStack(alignment: .top, spacing: 32) {
                // Audio Tracks Column
                VStack(alignment: .leading, spacing: 10) {
                    Text("AUDIO")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.sutureCrimson)
                    
                    if engine.availableAudioTracks.isEmpty {
                        Text("Default Audio (Stereo)")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.sutureTextSecondary)
                    } else {
                        ForEach(engine.availableAudioTracks) { track in
                            Button {
                                engine.selectAudioTrack(track)
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: engine.selectedAudioTrack?.id == track.id ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(engine.selectedAudioTrack?.id == track.id ? Color.sutureCrimson : Color.sutureTextTertiary)
                                    Text(track.title)
                                        .font(.system(size: 13, weight: engine.selectedAudioTrack?.id == track.id ? .bold : .regular))
                                        .foregroundStyle(Color.sutureTextPrimary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Subtitles Column
                VStack(alignment: .leading, spacing: 10) {
                    Text("SUBTITLES")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.sutureCrimson)
                    
                    // Off Option
                    Button {
                        engine.selectSubtitleTrack(nil)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: engine.selectedSubtitleTrack == nil ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(engine.selectedSubtitleTrack == nil ? Color.sutureCrimson : Color.sutureTextTertiary)
                            Text("Off")
                                .font(.system(size: 13, weight: engine.selectedSubtitleTrack == nil ? .bold : .regular))
                                .foregroundStyle(Color.sutureTextPrimary)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    ForEach(engine.availableSubtitleTracks) { track in
                        Button {
                            engine.selectSubtitleTrack(track)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: engine.selectedSubtitleTrack?.id == track.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(engine.selectedSubtitleTrack?.id == track.id ? Color.sutureCrimson : Color.sutureTextTertiary)
                                Text(track.title)
                                    .font(.system(size: 13, weight: engine.selectedSubtitleTrack?.id == track.id ? .bold : .regular))
                                    .foregroundStyle(Color.sutureTextPrimary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(24)
        .frame(width: 440)
        .background(Color.sutureSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.sutureBorder, lineWidth: 1)
        )
    }
}
