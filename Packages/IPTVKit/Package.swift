// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "IPTVKit",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "IPTVKit",
            targets: ["IPTVKit"]
        ),
    ],
    dependencies: [
        .package(path: "../SutureCore")
    ],
    targets: [
        .target(
            name: "IPTVKit",
            dependencies: ["SutureCore"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "IPTVKitTests",
            dependencies: ["IPTVKit"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
    ]
)
