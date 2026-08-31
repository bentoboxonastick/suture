import Testing
import Foundation
@testable import SutureCore

@Suite("SutureCore Domain Models & Errors")
struct SutureCoreTests {
    
    @Test("SutureMediaItem Encoding & Decoding")
    func testMediaItemCodable() throws {
        let original = SutureMediaItem(
            id: "tt15239678",
            type: .movie,
            title: "Dune: Part Two",
            subtitle: "Sci-Fi / Adventure",
            overview: "Paul Atreides unites with Chani and the Fremen.",
            releaseYear: 2024,
            rating: 8.6,
            duration: 9960,
            posterURL: URL(string: "https://image.tmdb.org/t/p/w500/dune2.jpg"),
            imdbId: "tt15239678",
            tmdbId: 693134,
            genres: ["Action", "Adventure", "Sci-Fi"]
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(SutureMediaItem.self, from: data)
        
        #expect(decoded.id == original.id)
        #expect(decoded.title == "Dune: Part Two")
        #expect(decoded.formattedDuration == "2h 46m")
        #expect(decoded.type == .movie)
    }
    
    @Test("StreamSource Quality Comparison")
    func testStreamQualityComparison() {
        #expect(VideoQuality.uhd4k > VideoQuality.fhd1080p)
        #expect(VideoQuality.fhd1080p > VideoQuality.hd720p)
        #expect(VideoQuality.hd720p > VideoQuality.sd480p)
    }
    
    @Test("SutureError Code Mapping")
    func testErrorCodeMapping() {
        let err = SutureError.debridExpired(provider: "Real-Debrid")
        #expect(err.errorCode == "ERR_DEBRID_EXPIRED")
        #expect(err.troubleshootingDocAnchor.contains("err_debrid_expired"))
    }
}
