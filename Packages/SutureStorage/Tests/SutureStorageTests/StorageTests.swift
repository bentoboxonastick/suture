import Testing
import Foundation
import SwiftData
import SutureCore
@testable import SutureStorage

@Suite("SutureStorage SwiftData Persistence")
struct StorageTests {
    
    @Test("SwiftData Schema In-Memory Container & Insert")
    @MainActor
    func testStoredEntitiesPersistence() throws {
        let schema = Schema([
            StoredAddon.self,
            StoredPlaylist.self,
            WatchHistoryItem.self,
            UserPreference.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = container.mainContext
        
        // 1. Insert StoredAddon
        let addon = StoredAddon(
            id: "org.stremio.cinemeta",
            name: "Cinemeta",
            manifestURL: "https://cinemeta.strem.io/manifest.json",
            isEnabled: true,
            sortOrder: 1
        )
        context.insert(addon)
        
        // 2. Insert WatchHistoryItem
        let watchItem = WatchHistoryItem(
            id: "tt15239678",
            mediaId: "tt15239678",
            mediaType: .movie,
            title: "Dune: Part Two",
            posterURLString: "https://image.tmdb.org/t/p/w500/dune2.jpg",
            progressPercentage: 0.65,
            lastPositionSeconds: 6474.0,
            totalDurationSeconds: 9960.0
        )
        context.insert(watchItem)
        
        try context.save()
        
        // 3. Query items
        let addonDescriptor = FetchDescriptor<StoredAddon>()
        let addons = try context.fetch(addonDescriptor)
        #expect(addons.count == 1)
        #expect(addons.first?.name == "Cinemeta")
        
        let watchDescriptor = FetchDescriptor<WatchHistoryItem>()
        let watchItems = try context.fetch(watchDescriptor)
        #expect(watchItems.count == 1)
        #expect(watchItems.first?.progressPercentage == 0.65)
        #expect(watchItems.first?.mediaType == .movie)
    }
}
