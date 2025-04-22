import ProjectDescription

let project = Project(
    name: "Presentation",
    organizationName: "Coby",
    targets: [
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.coby.HotSpot.Presentation",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Shared", path: "../Shared"),
                .external(name: "CobyDS"),
                .external(name: "Kingfisher")
            ]
        ),
        .target(
            name: "PresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.coby.HotSpot.PresentationTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: "Presentation")]
        )
    ]
) 