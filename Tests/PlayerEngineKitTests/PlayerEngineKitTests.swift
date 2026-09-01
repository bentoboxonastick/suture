import Testing
import Foundation
import SutureCore
@testable import PlayerEngineKit

@Suite("PlayerEngineKit External Players & Subtitle Tests")
struct PlayerEngineKitTests {
    
    @Test("External Player URL Generation")
    func testExternalPlayerURLSchemes() {
        let streamURL = URL(string: "https://example.com/stream.mkv")!
        
        let infuseURL = ExternalPlayerApp.infuse.generateURL(for: streamURL)
        #expect(infuseURL?.scheme == "infuse")
        
        let vlcURL = ExternalPlayerApp.vlc.generateURL(for: streamURL)
        #expect(vlcURL?.scheme == "vlc")
        
        let iinaURL = ExternalPlayerApp.iina.generateURL(for: streamURL)
        #expect(iinaURL?.scheme == "iina")
        
        let vidhubURL = ExternalPlayerApp.vidhub.generateURL(for: streamURL, title: "Test Movie")
        #expect(vidhubURL?.scheme == "vidhub")
    }
    
    @Test("SRT Subtitle Parsing")
    func testSRTSubtitleParsing() {
        let srtData = """
        1
        00:00:01,000 --> 00:00:04,500
        Welcome to Suture Media Hub.

        2
        00:00:05,200 --> 00:00:08,800
        Stitching all your sources together.
        """
        
        let cues = SubtitleParser.parse(content: srtData, format: .srt)
        #expect(cues.count == 2)
        #expect(cues[0].startTime == 1.0)
        #expect(cues[0].endTime == 4.5)
        #expect(cues[0].text == "Welcome to Suture Media Hub.")
        #expect(cues[1].startTime == 5.2)
    }
    
    @Test("WebVTT Subtitle Parsing")
    func testVTTSubtitleParsing() {
        let vttData = """
        WEBVTT

        00:01.000 --> 00:05.000
        High-Res Lossless Audio streaming.
        """
        
        let cues = SubtitleParser.parse(content: vttData, format: .vtt)
        #expect(cues.count == 1)
        #expect(cues[0].startTime == 1.0)
        #expect(cues[0].endTime == 5.0)
        #expect(cues[0].text == "High-Res Lossless Audio streaming.")
    }
}
