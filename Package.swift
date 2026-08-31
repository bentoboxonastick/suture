// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SutureWorkspace",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(name: "SutureCore", targets: ["SutureCore"]),
        .library(name: "SutureStorage", targets: ["SutureStorage"]),
        .library(name: "SutureUI", targets: ["SutureUI"]),
        .library(name: "StremioKit", targets: ["StremioKit"]),
        .library(name: "IPTVKit", targets: ["IPTVKit"]),
        .library(name: "MusicKitAPI", targets: ["MusicKitAPI"]),
        .library(name: "TrackingKit", targets: ["TrackingKit"]),
        .library(name: "PlayerEngineKit", targets: ["PlayerEngineKit"]),
    ],
    dependencies: [],
    targets: [
        // SutureCore
        .target(
            name: "SutureCore",
            path: "Packages/SutureCore/Sources/SutureCore",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "SutureCoreTests",
            dependencies: ["SutureCore"],
            path: "Packages/SutureCore/Tests/SutureCoreTests",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // SutureStorage
        .target(
            name: "SutureStorage",
            dependencies: ["SutureCore"],
            path: "Packages/SutureStorage/Sources/SutureStorage",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "SutureStorageTests",
            dependencies: ["SutureStorage"],
            path: "Packages/SutureStorage/Tests/SutureStorageTests",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // SutureUI
        .target(
            name: "SutureUI",
            dependencies: ["SutureCore"],
            path: "Packages/SutureUI/Sources/SutureUI",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "SutureUITests",
            dependencies: ["SutureUI"],
            path: "Packages/SutureUI/Tests/SutureUITests",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // StremioKit
        .target(
            name: "StremioKit",
            dependencies: ["SutureCore"],
            path: "Packages/StremioKit/Sources/StremioKit",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "StremioKitTests",
            dependencies: ["StremioKit"],
            path: "Packages/StremioKit/Tests/StremioKitTests",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // IPTVKit
        .target(
            name: "IPTVKit",
            dependencies: ["SutureCore"],
            path: "Packages/IPTVKit/Sources/IPTVKit",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "IPTVKitTests",
            dependencies: ["IPTVKit"],
            path: "Packages/IPTVKit/Tests/IPTVKitTests",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // MusicKitAPI
        .target(
            name: "MusicKitAPI",
            dependencies: ["SutureCore"],
            path: "Packages/MusicKitAPI/Sources/MusicKitAPI",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "MusicKitAPITests",
            dependencies: ["MusicKitAPI"],
            path: "Packages/MusicKitAPI/Tests/MusicKitAPITests",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // TrackingKit
        .target(
            name: "TrackingKit",
            dependencies: ["SutureCore"],
            path: "Packages/TrackingKit/Sources/TrackingKit",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "TrackingKitTests",
            dependencies: ["TrackingKit"],
            path: "Packages/TrackingKit/Tests/TrackingKitTests",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // PlayerEngineKit
        .target(
            name: "PlayerEngineKit",
            dependencies: ["SutureCore"],
            path: "Packages/PlayerEngineKit/Sources/PlayerEngineKit",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "PlayerEngineKitTests",
            dependencies: ["PlayerEngineKit"],
            path: "Packages/PlayerEngineKit/Tests/PlayerEngineKitTests",
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
    ]
)
