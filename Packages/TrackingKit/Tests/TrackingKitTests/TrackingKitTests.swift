import Testing
import Foundation
import SutureCore
@testable import TrackingKit

@Suite("TrackingKit Scrobble Models")
struct TrackingKitTests {
    
    @Test("Scrobble Event Construction")
    func testScrobbleEvent() {
        let movie = SutureMediaItem(
            id: "tt2285752",
            type: .movie,
            title: "Tears of Steel"
        )
        
        let event = ScrobbleEvent(
            mediaItem: movie,
            action: .start,
            progressPercentage: 0.01
        )
        
        #expect(event.mediaItem.id == "tt2285752")
        #expect(event.action == .start)
        #expect(event.progressPercentage == 0.01)
    }
}
