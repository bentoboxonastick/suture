import Testing
import Foundation
import SutureCore
@testable import PlayerEngineKit

@Suite("PlayerEngineKit External Player Schemes")
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
}
