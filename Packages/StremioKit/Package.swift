// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "StremioKit",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "StremioKit",
            targets: ["StremioKit"]
        ),
    ],
    dependencies: [
        .package(path: "../SutureCore")
    ],
    targets: [
        .target(
            name: "StremioKit",
            dependencies: ["SutureCore"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "StremioKitTests",
            dependencies: ["StremioKit"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
    ]
)
