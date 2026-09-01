import Testing
import SwiftUI
import SutureCore
@testable import SutureUI

@Suite("SutureUI Design Tokens & Mock Data")
struct SutureUITests {
    
    @Test("Mock Data Integrity")
    func testMockDataIntegrity() {
        #expect(MockData.trendingItems.count >= 3)
        #expect(MockData.liveChannels.count >= 2)
        #expect(MockData.musicTracks.count >= 2)
        #expect(MockData.sampleStreams.count >= 3)
        
        let movie = MockData.tearsOfSteel
        #expect(movie.type == .movie)
        #expect(movie.imdbId != nil)
        #expect(movie.posterURL != nil)
    }
    
    @Test("Color Tokens Presence")
    func testColorTokens() {
        _ = Color.suturePitch
        _ = Color.sutureCrimson
        _ = Color.sutureEmerald
        _ = Color.sutureCyan
    }
}
