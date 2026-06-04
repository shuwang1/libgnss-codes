// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "libgnss-codes-swift",
    products: [
        .library(
            name: "GNSSCodes",
            targets: ["GNSSCodes"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "GNSSCodes",
            resources: [.process("Resources")]
        ),
        .executableTarget(
            name: "Generator",
            dependencies: ["GNSSCodes"]
        ),
        .testTarget(
            name: "GNSSCodesTests",
            dependencies: ["GNSSCodes"]),
    ]
)
