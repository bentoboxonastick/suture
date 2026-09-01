import Testing
import Foundation
import SutureCore
@testable import StremioKit

@Suite("StremioKit Manifest, Sanitization & Ranking Tests")
struct StremioKitTests {
    
    @Test("Manifest JSON Decoding")
    func testManifestDecoding() throws {
        let json = """
        {
            "id": "org.stremio.cinemeta",
            "version": "3.0.12",
            "name": "Cinemeta",
            "description": "IMDb metadata for Movies and TV Shows",
            "resources": ["catalog", "meta", "stream", "subtitles"],
            "types": ["movie", "series"],
            "catalogs": [
                {
                    "type": "movie",
                    "id": "top",
                    "name": "Top Movies"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let manifest = try decoder.decode(StremioManifest.self, from: json)
        
        #expect(manifest.id == "org.stremio.cinemeta")
        #expect(manifest.name == "Cinemeta")
        #expect(manifest.catalogs.count == 1)
        #expect(manifest.catalogs.first?.id == "top")
    }
    
    @Test("URL Sanitizer Normalization")
    func testURLSanitizer() throws {
        let stremioURL = "stremio://v3-cinemeta.strem.io"
        let sanitized = try URLSanitizer.sanitizeManifestURL(stremioURL)
        #expect(sanitized.absoluteString == "https://v3-cinemeta.strem.io/manifest.json")
        
        let baseURL = URLSanitizer.extractBaseURL(from: sanitized)
        #expect(baseURL.absoluteString == "https://v3-cinemeta.strem.io")
    }
    
    @Test("Stream Ranking Priority Engine")
    func testStreamRanking() {
        let ranker = StreamRankingEngine()
        
        let stream4KNonCached = StreamSource(
            name: "Direct Stream 4K",
            streamURL: URL(string: "https://example.com/4k.mp4")!,
            quality: .uhd4k,
            isCachedDebrid: false
        )
        
        let stream1080pCachedRD = StreamSource(
            name: "RealDebrid [RD+] 1080p",
            streamURL: URL(string: "https://rd.example.com/1080p.mp4")!,
            quality: .fhd1080p,
            isCachedDebrid: true
        )
        
        let stream720p = StreamSource(
            name: "720p Stream",
            streamURL: URL(string: "https://example.com/720p.mp4")!,
            quality: .hd720p,
            isCachedDebrid: false
        )
        
        let ranked = ranker.rankStreams([stream720p, stream4KNonCached, stream1080pCachedRD])
        
        // Instant Debrid cached stream should rank first
        #expect(ranked.first?.name == "RealDebrid [RD+] 1080p")
        #expect(ranked[1].name == "Direct Stream 4K")
        #expect(ranked.last?.name == "720p Stream")
    }
}
