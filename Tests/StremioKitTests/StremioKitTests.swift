import Testing
import Foundation
import SutureCore
@testable import StremioKit

@Suite("StremioKit Manifest & Stream Schemas")
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
}
