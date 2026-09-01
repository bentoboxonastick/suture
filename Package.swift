// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Suture",
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
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "SutureCoreTests",
            dependencies: ["SutureCore"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // SutureStorage
        .target(
            name: "SutureStorage",
            dependencies: ["SutureCore"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "SutureStorageTests",
            dependencies: ["SutureStorage"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // PlayerEngineKit
        .target(
            name: "PlayerEngineKit",
            dependencies: ["SutureCore"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "PlayerEngineKitTests",
            dependencies: ["PlayerEngineKit"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // SutureUI
        .target(
            name: "SutureUI",
            dependencies: ["SutureCore", "PlayerEngineKit"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "SutureUITests",
            dependencies: ["SutureUI"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // StremioKit
        .target(
            name: "StremioKit",
            dependencies: ["SutureCore"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "StremioKitTests",
            dependencies: ["StremioKit"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // IPTVKit
        .target(
            name: "IPTVKit",
            dependencies: ["SutureCore"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "IPTVKitTests",
            dependencies: ["IPTVKit"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // MusicKitAPI
        .target(
            name: "MusicKitAPI",
            dependencies: ["SutureCore"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "MusicKitAPITests",
            dependencies: ["MusicKitAPI"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        
        // TrackingKit
        .target(
            name: "TrackingKit",
            dependencies: ["SutureCore"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
        .testTarget(
            name: "TrackingKitTests",
            dependencies: ["TrackingKit"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        ),
    ]
)
