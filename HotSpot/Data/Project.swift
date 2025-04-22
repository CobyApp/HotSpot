import ProjectDescription

let project = Project(
    name: "Data",
    organizationName: "Coby",
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.coby.HotSpot.Data",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .external(name: "Moya")
            ]
        ),
        .target(
            name: "DataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.coby.HotSpot.DataTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: "Data")]
        )
    ]
) 