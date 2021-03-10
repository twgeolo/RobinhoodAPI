// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "RobinhoodAPI",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "RobinhoodAPI",
            targets: ["RobinhoodAPI"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RobinhoodAPI",
            dependencies: []),
        .testTarget(
            name: "RobinhoodAPITests",
            dependencies: ["RobinhoodAPI"])
    ]
)
