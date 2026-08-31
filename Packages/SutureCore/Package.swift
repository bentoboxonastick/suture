// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SutureCore",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "SutureCore",
            targets: ["SutureCore"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SutureCore",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "SutureCoreTests",
            dependencies: ["SutureCore"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
    ]
)
