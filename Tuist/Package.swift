// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "Moya": .framework,
            "CombineMoya": .framework,
            "ComposableArchitecture": .framework
        ],
        baseSettings: .settings(
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ]
        )
    )
#endif

let package = Package(
    name: "HotSpot",
    platforms: [
        .iOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.19.1")
    ]
)
