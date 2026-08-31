// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SutureStorage",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "SutureStorage",
            targets: ["SutureStorage"]
        ),
    ],
    dependencies: [
        .package(path: "../SutureCore")
    ],
    targets: [
        .target(
            name: "SutureStorage",
            dependencies: [
                "SutureCore"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "SutureStorageTests",
            dependencies: [
                "SutureStorage"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
    ]
)
