// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SutureUI",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "SutureUI",
            targets: ["SutureUI"]
        ),
    ],
    dependencies: [
        .package(path: "../SutureCore"),
        .package(path: "../PlayerEngineKit")
    ],
    targets: [
        .target(
            name: "SutureUI",
            dependencies: [
                "SutureCore",
                "PlayerEngineKit"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "SutureUITests",
            dependencies: [
                "SutureUI"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
    ]
)
