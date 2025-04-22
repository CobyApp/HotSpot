import ProjectDescription

let project = Project(
    name: "Domain",
    organizationName: "Coby",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.coby.HotSpot.Domain",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Data", path: "../Data"),
                .project(target: "Shared", path: "../Shared")
            ]
        ),
        .target(
            name: "DomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.coby.HotSpot.DomainTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: "Domain")]
        )
    ]
) 