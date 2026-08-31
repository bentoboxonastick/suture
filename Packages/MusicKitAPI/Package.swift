// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MusicKitAPI",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "MusicKitAPI",
            targets: ["MusicKitAPI"]
        ),
    ],
    dependencies: [
        .package(path: "../SutureCore")
    ],
    targets: [
        .target(
            name: "MusicKitAPI",
            dependencies: ["SutureCore"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "MusicKitAPITests",
            dependencies: ["MusicKitAPI"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
    ]
)
