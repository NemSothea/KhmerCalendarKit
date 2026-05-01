// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "KhmerCalendarKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        .library(
            name: "KhmerCalendarKit",
            targets: ["KhmerCalendarKit"]
        ),
    ],
    targets: [
        .target(
            name: "KhmerCalendarKit",
            path: "Sources/KhmerCalendarKit"
        ),
        .testTarget(
            name: "KhmerCalendarKitTests",
            dependencies: ["KhmerCalendarKit"],
            path: "Tests/KhmerCalendarKitTests"
        ),
    ]
)
