import ProjectDescription

let project = Project(
    name: "HotSpot",
    targets: [
        .target(
            name: "HotSpot",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.HotSpot",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["HotSpot/Sources/**"],
            resources: ["HotSpot/Resources/**"], 
            dependencies: []
        ),
        .target(
            name: "HotSpotTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.HotSpotTests",
            infoPlist: .default,
            sources: ["HotSpot/Tests/**"],
            resources: [],
            dependencies: [.target(name: "HotSpot")]
        ),
    ]
)
