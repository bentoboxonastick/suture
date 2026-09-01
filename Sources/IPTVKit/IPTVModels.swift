import Foundation
import SutureCore

/// Represents an individual live channel parsed from an M3U/M3U8 playlist.
public struct M3UChannel: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let logoURL: URL?
    public let groupTitle: String
    public let streamURL: URL
    public let tvgId: String?
    public let tvgName: String?
    public let catchupSource: String?
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        logoURL: URL? = nil,
        groupTitle: String = "General",
        streamURL: URL,
        tvgId: String? = nil,
        tvgName: String? = nil,
        catchupSource: String? = nil
    ) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
        self.groupTitle = groupTitle
        self.streamURL = streamURL
        self.tvgId = tvgId
        self.tvgName = tvgName
        self.catchupSource = catchupSource
    }
    
    public func toMediaItem(currentProgram: EPGProgram? = nil) -> SutureMediaItem {
        SutureMediaItem(
            id: id,
            type: .liveTV,
            title: name,
            subtitle: groupTitle,
            overview: currentProgram?.description,
            posterURL: logoURL,
            currentProgramTitle: currentProgram?.title,
            programStartTime: currentProgram?.startTime,
            programEndTime: currentProgram?.endTime,
            genres: [groupTitle],
            isLive: true
        )
    }
}

/// Represents an individual TV show / broadcast program parsed from an XMLTV EPG feed.
public struct EPGProgram: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let channelId: String
    public let title: String
    public let description: String?
    public let category: String?
    public let startTime: Date
    public let endTime: Date
    public let iconURL: URL?
    
    public init(
        id: String = UUID().uuidString,
        channelId: String,
        title: String,
        description: String? = nil,
        category: String? = nil,
        startTime: Date,
        endTime: Date,
        iconURL: URL? = nil
    ) {
        self.id = id
        self.channelId = channelId
        self.title = title
        self.description = description
        self.category = category
        self.startTime = startTime
        self.endTime = endTime
        self.iconURL = iconURL
    }
    
    public var isCurrentlyAiring: Bool {
        let now = Date()
        return now >= startTime && now <= endTime
    }
}
