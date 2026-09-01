import Testing
import SwiftUI
import SutureCore
@testable import SutureUI

@Suite("AppNavigationState Coordinator Tests")
struct NavigationStateTests {
    
    @Test("Tab Navigation Transitions")
    @MainActor
    func testTabTransitions() {
        let nav = AppNavigationState()
        #expect(nav.selectedTab == .home)
        
        nav.selectedTab = .liveTV
        #expect(nav.selectedTab == .liveTV)
        
        nav.selectedTab = .search
        #expect(nav.selectedTab == .search)
    }
    
    @Test("Detail & Stream Picker Modals Presentation")
    @MainActor
    func testModalPresentations() {
        let nav = AppNavigationState()
        let movie = MockData.tearsOfSteel
        
        nav.presentDetail(for: movie)
        #expect(nav.selectedMediaItem?.id == movie.id)
        
        nav.presentStreamPicker(for: movie)
        #expect(nav.streamPickerItem?.id == movie.id)
        
        let stream = MockData.sampleStreams[0]
        nav.playStream(stream)
        #expect(nav.activePlaybackStream?.id == stream.id)
        #expect(nav.streamPickerItem == nil)
        
        nav.clearDetail()
        #expect(nav.selectedMediaItem == nil)
    }
    
    @Test("Music Playback State Transitions")
    @MainActor
    func testMusicPlayback() {
        let nav = AppNavigationState()
        let track = MockData.solarFlareTrack
        
        nav.playTrack(track)
        #expect(nav.currentlyPlayingTrack?.id == track.id)
        #expect(nav.isMusicPlaying == true)
        
        nav.toggleMusicPlayPause()
        #expect(nav.isMusicPlaying == false)
    }
}
