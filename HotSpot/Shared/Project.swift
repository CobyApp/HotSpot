import ProjectDescription

let project = Project(
    name: "Shared",
    organizationName: "Coby",
    targets: [
        .target(
            name: "Shared",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.coby.HotSpot.Shared",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "ComposableArchitecture")
            ]
        ),
        .target(
            name: "SharedTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.coby.HotSpot.SharedTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: "Shared")]
        )
    ]
) 