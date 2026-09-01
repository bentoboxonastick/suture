import SwiftUI
import SutureCore
import PlayerEngineKit

public struct StreamPickerSheet: View {
    public let item: SutureMediaItem
    public let availableStreams: [StreamSource]
    public var onSelectStream: (StreamSource) -> Void
    public var onSelectExternal: ((StreamSource, ExternalPlayerApp) -> Void)?
    public var onClose: () -> Void
    
    @State private var selectedQualityFilter: String = "All"
    
    public init(
        item: SutureMediaItem,
        availableStreams: [StreamSource] = MockData.sampleStreams,
        onSelectStream: @escaping (StreamSource) -> Void,
        onSelectExternal: ((StreamSource, ExternalPlayerApp) -> Void)? = nil,
        onClose: @escaping () -> Void
    ) {
        self.item = item
        self.availableStreams = availableStreams
        self.onSelectStream = onSelectStream
        self.onSelectExternal = onSelectExternal
        self.onClose = onClose
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Select Stream Source")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.sutureCrimson)
                        .textCase(.uppercase)
                    
                    Text(item.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.sutureTextPrimary)
                    
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.sutureTextSecondary)
                    }
                }
                
                Spacer()
                
                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.sutureTextTertiary)
                }
                .buttonStyle(.plain)
            }
            .padding(24)
            .background(Color.sutureSurface)
            
            Divider()
                .background(Color.sutureBorder)
            
            // Filter Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    filterPill(title: "All Streams", count: availableStreams.count)
                    filterPill(title: "4K UHD", count: availableStreams.filter { $0.quality == .uhd4k }.count)
                    filterPill(title: "1080p", count: availableStreams.filter { $0.quality == .fhd1080p }.count)
                    filterPill(title: "Debrid [RD+]", count: availableStreams.filter { $0.isCachedDebrid }.count)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
            
            // Stream List
            ScrollView {
                LazyVStack(spacing: 12) {
                    let streams = filteredStreams
                    if streams.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 32))
                                .foregroundStyle(Color.sutureTextTertiary)
                            Text("No streams match the selected filter.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.sutureTextSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        ForEach(streams) { stream in
                            StreamSourceRow(stream: stream) {
                                onSelectStream(stream)
                            } onSelectExternal: { app in
                                onSelectExternal?(stream, app)
                            }
                        }
                    }
                }
                .padding(24)
            }
        }
        .frame(maxWidth: 680)
        .background(Color.suturePitch)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.sutureBorder, lineWidth: 1)
        )
    }
    
    private var filteredStreams: [StreamSource] {
        switch selectedQualityFilter {
        case "4K UHD":
            return availableStreams.filter { $0.quality == .uhd4k }
        case "1080p":
            return availableStreams.filter { $0.quality == .fhd1080p }
        case "Debrid [RD+]":
            return availableStreams.filter { $0.isCachedDebrid }
        default:
            return availableStreams
        }
    }
    
    private func filterPill(title: String, count: Int) -> some View {
        let isSelected = selectedQualityFilter == title
        return Button {
            selectedQualityFilter = title
        } label: {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                
                Text("\(count)")
                    .font(.system(size: 11, weight: .bold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(isSelected ? Color.white.opacity(0.25) : Color.sutureElevated)
                    .clipShape(Capsule())
            }
            .foregroundStyle(isSelected ? .white : Color.sutureTextSecondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(isSelected ? Color.sutureCrimson : Color.sutureSurface)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(isSelected ? Color.sutureCrimson : Color.sutureBorder.opacity(0.6), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview("Stream Picker Sheet") {
    ZStack {
        Color.black.opacity(0.85).ignoresSafeArea()
        StreamPickerSheet(item: MockData.tearsOfSteel) { _ in } onClose: {}
            .padding()
    }
}
