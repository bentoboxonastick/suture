import SwiftUI
import SutureCore

public struct LiveTVGuideView: View {
    @Bindable public var navigationState: AppNavigationState
    public let channels: [SutureMediaItem]
    
    public init(navigationState: AppNavigationState, channels: [SutureMediaItem] = MockData.liveChannels) {
        self.navigationState = navigationState
        self.channels = channels
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Live TV & Electronic Program Guide")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.sutureTextPrimary)
                        
                        Text("\(channels.count) Active Channels Available")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.sutureTextSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Channel Rows
                VStack(spacing: 12) {
                    ForEach(channels) { channel in
                        channelRow(channel: channel)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 16)
        }
        .background(Color.suturePitch)
    }
    
    private func channelRow(channel: SutureMediaItem) -> some View {
        Button {
            navigationState.presentStreamPicker(for: channel)
        } label: {
            HStack(spacing: 16) {
                // Channel Logo / Number
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.sutureElevated)
                        .frame(width: 64, height: 64)
                    
                    if let number = channel.channelNumber {
                        Text(number)
                            .font(.system(size: 14, weight: .black, design: .rounded))
                            .foregroundStyle(Color.sutureCrimson)
                    } else {
                        Image(systemName: "tv")
                            .font(.system(size: 22))
                            .foregroundStyle(Color.sutureTextTertiary)
                    }
                }
                
                // Channel Info & Currently Airing
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(channel.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.sutureTextPrimary)
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.sutureEmerald)
                                .frame(width: 6, height: 6)
                            Text("LIVE")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Capsule())
                    }
                    
                    if let program = channel.currentProgramTitle {
                        Text(program)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.sutureTextSecondary)
                            .lineLimit(1)
                    }
                    
                    // Live Progress
                    if let progress = channel.liveProgress {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.sutureBorder)
                                    .frame(height: 3)
                                
                                Rectangle()
                                    .fill(Color.sutureEmerald)
                                    .frame(width: geo.size.width * CGFloat(progress), height: 3)
                            }
                        }
                        .frame(height: 3)
                    }
                }
                
                Spacer()
                
                // Play Button
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Color.sutureCrimson)
            }
            .padding(16)
            .background(Color.sutureSurface)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.sutureBorder.opacity(0.4), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview("Live TV Guide") {
    LiveTVGuideView(navigationState: AppNavigationState())
}
