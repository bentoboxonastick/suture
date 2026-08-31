import Testing
import Foundation
import SutureCore
@testable import IPTVKit

@Suite("IPTVKit Channels & EPG Models")
struct IPTVKitTests {
    
    @Test("Channel to MediaItem Transformation")
    func testChannelToMediaItem() {
        let now = Date()
        let program = EPGProgram(
            channelId: "NASA.us",
            title: "Space Station Live",
            description: "Live views of Earth from orbit.",
            category: "Science",
            startTime: now.addingTimeInterval(-600),
            endTime: now.addingTimeInterval(3000)
        )
        
        let channel = M3UChannel(
            id: "nasa_tv",
            name: "NASA TV HD",
            logoURL: URL(string: "https://i.imgur.com/nasa.png"),
            groupTitle: "Science",
            streamURL: URL(string: "https://nasa.example/live.m3u8")!,
            tvgId: "NASA.us"
        )
        
        let mediaItem = channel.toMediaItem(currentProgram: program)
        #expect(mediaItem.id == "nasa_tv")
        #expect(mediaItem.title == "NASA TV HD")
        #expect(mediaItem.currentProgramTitle == "Space Station Live")
        #expect(mediaItem.isLive == true)
        #expect(program.isCurrentlyAiring == true)
    }
}
