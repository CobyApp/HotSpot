// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        )
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Shared"),
        .package(url: "https://github.com/Moya/Moya", from: "15.0.0")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                "Domain",
                "Shared",
                .product(name: "Moya", package: "Moya")
            ]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data"]
        )
    ]
) 