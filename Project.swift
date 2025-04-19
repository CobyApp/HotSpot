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
            .swiftVersion("5.9"),
        configurations: [
            .debug(name: .debug, xcconfig: "\(projectName)/Configuration/Config.xcconfig"),
            .release(name: .release, xcconfig: "\(projectName)/Configuration/Config.xcconfig")
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
                    "NSAppTransportSecurity": [
                        "NSExceptionDomains": [
                            "webservice.recruit.co.jp": [
                                "NSExceptionAllowsInsecureHTTPLoads": true
                            ]
                        ]
                    ],
                    "NSLocationWhenInUseUsageDescription": "周辺の店舗を表示するために位置情報が必要です。",
                    "NSLocationAlwaysAndWhenInUseUsageDescription": "周辺の店舗を表示するために位置情報が必要です。"
                ]
            ),
            sources: ["\(projectName)/Sources/**"],
            resources: ["\(projectName)/Resources/**"],
            dependencies: [
                .external(name: "CobyDS"),
                .external(name: "Moya"),
                .external(name: "ComposableArchitecture"),
                .external(name: "Kingfisher")
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
