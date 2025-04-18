import ProjectDescription

let projectName = "HotSpot"
let organizationName = "Coby"
let bundleID = "com.coby.HotSpot"
let bundleTestID = "com.coby.HotSpotTests"
let targetVersion = "15.0"
let version = "1.0.0"
let bundleVersion = "0"

let project = Project(
    name: projectName,
    organizationName: organizationName,
    settings: .settings(
        base: SettingsDictionary()
            .automaticCodeSigning(devTeam: "3Y8YH8GWMM")
            .swiftVersion("6.0"),
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ]
    ),
    targets: [
        .target(
            name: projectName,
            destinations: [.iPhone],
            product: .app,
            bundleId: bundleID,
            deploymentTargets: .iOS(targetVersion),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": "\(version)",
                    "CFBundleVersion": "\(bundleVersion)",
                    "CFBundleDisplayName": "\(projectName)",
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["\(projectName)/Sources/**"],
            resources: ["\(projectName)/Resources/**"],
            dependencies: [
                .external(name: "Moya"),
                .external(name: "ComposableArchitecture")
            ]
        ),
        .target(
            name: "\(projectName)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: bundleTestID,
            infoPlist: .default,
            sources: ["\(projectName)/Tests/**"],
            resources: [],
            dependencies: [.target(name: projectName)]
        ),
    ],
    schemes: [
        .scheme(
            name: "\(projectName) Debug",
            buildAction: .buildAction(targets: ["\(projectName)"]),
            runAction: .runAction(configuration: .debug)
        ),
        .scheme(
            name: "\(projectName) Release",
            buildAction: .buildAction(targets: ["\(projectName)"]),
            runAction: .runAction(configuration: .release)
        )
    ]
)
