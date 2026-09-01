import Testing
import Foundation
import SutureCore
@testable import MusicKitAPI

@Suite("MusicKitAPI Track Models")
struct MusicKitAPITests {
    
    @Test("MusicTrack to MediaItem Transformation")
    func testMusicTrackTransformation() {
        let track = MusicTrack(
            id: "tidal_12345",
            title: "Solar Flare",
            artistName: "Quantum Resonance",
            albumTitle: "Starlight Odyssey",
            duration: 248,
            coverArtURL: URL(string: "https://example.com/art.jpg"),
            provider: .tidal,
            quality: .hiRes24Bit192k
        )
        
        let mediaItem = track.toMediaItem()
        #expect(mediaItem.id == "tidal_12345")
        #expect(mediaItem.title == "Solar Flare")
        #expect(mediaItem.artistName == "Quantum Resonance")
        #expect(mediaItem.type == .musicTrack)
    }
}
