import SwiftUI
import SutureCore
import PlayerEngineKit

public struct StreamSourceRow: View {
    public let stream: StreamSource
    public var onSelect: () -> Void
    public var onSelectExternal: ((ExternalPlayerApp) -> Void)?
    
    @State private var isHovered: Bool = false
    
    public init(
        stream: StreamSource,
        onSelect: @escaping () -> Void,
        onSelectExternal: ((ExternalPlayerApp) -> Void)? = nil
    ) {
        self.stream = stream
        self.onSelect = onSelect
        self.onSelectExternal = onSelectExternal
    }
    
    public var body: some View {
        Button {
            onSelect()
        } label: {
            HStack(spacing: 14) {
                // Provider / Quality Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(stream.isCachedDebrid ? Color.sutureEmerald.opacity(0.15) : Color.sutureElevated)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: stream.isCachedDebrid ? "bolt.fill" : "play.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(stream.isCachedDebrid ? Color.sutureEmerald : Color.sutureTextSecondary)
                }
                
                // Stream Info & Title
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(stream.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.sutureTextPrimary)
                            .lineLimit(1)
                        
                        if stream.isCachedDebrid {
                            Text("CACHED")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Color.sutureEmerald)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.sutureEmerald.opacity(0.2))
                                .clipShape(Capsule())
                        }
                    }
                    
                    if let title = stream.title {
                        Text(title)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(Color.sutureTextTertiary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Badges: Quality, Dynamic Range, Size
                HStack(spacing: 6) {
                    badge(text: stream.quality.rawValue, color: qualityColor)
                    badge(text: stream.dynamicRange.rawValue, color: .sutureBorder)
                    
                    if let size = stream.formattedSize {
                        badge(text: size, color: .sutureBorder)
                    }
                }
                
                // External Player Options Menu
                Menu {
                    ForEach(ExternalPlayerApp.allCases) { app in
                        Button {
                            onSelectExternal?(app)
                        } label: {
                            Label("Open in \(app.rawValue)", systemImage: "arrow.up.forward.app")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.sutureTextTertiary)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isHovered ? Color.sutureElevated : Color.sutureSurface)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(isHovered ? Color.sutureCrimson.opacity(0.6) : Color.sutureBorder.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        #if os(macOS)
        .onHover { hovering in
            isHovered = hovering
        }
        #endif
    }
    
    private func badge(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(Color.sutureTextSecondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    }
    
    private var qualityColor: Color {
        switch stream.quality {
        case .uhd4k: return Color.sutureCrimson.opacity(0.3)
        case .fhd1080p: return Color.suturePurple.opacity(0.3)
        default: return Color.sutureBorder
        }
    }
}

#Preview("Stream Source Row") {
    ZStack {
        Color.suturePitch.ignoresSafeArea()
        VStack(spacing: 12) {
            ForEach(MockData.sampleStreams) { stream in
                StreamSourceRow(stream: stream) {}
            }
        }
        .padding()
    }
}
