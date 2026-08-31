// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PlayerEngineKit",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "PlayerEngineKit",
            targets: ["PlayerEngineKit"]
        ),
    ],
    dependencies: [
        .package(path: "../SutureCore")
    ],
    targets: [
        .target(
            name: "PlayerEngineKit",
            dependencies: ["SutureCore"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "PlayerEngineKitTests",
            dependencies: ["PlayerEngineKit"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
    ]
)
