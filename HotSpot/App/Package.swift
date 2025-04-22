// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "App",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "App",
            targets: ["App"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.19.1"),
        .package(path: "../Shared"),
        .package(path: "../Domain"),
        .package(path: "../Presentation")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Shared",
                "Domain",
                "Presentation"
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"]
        )
    ]
) 