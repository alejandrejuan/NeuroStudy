// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NeuroStudy",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "NeuroStudy",
            targets: ["NeuroStudy"]
        )
    ],
    targets: [
        .target(
            name: "NeuroStudy",
            path: "Shared",
            resources: [
                .process("Resources")
            ],
            linkerSettings: [
                .linkedFramework("SceneKit")
            ]
        )
    ]
)
