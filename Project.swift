import ProjectDescription

let projectName = "HotSpot"
let organizationName = "Coby"
let bundleID = "com.coby.HotSpot"
let bundleTestID = "com.coby.HotSpotTests"
let targetVersion = "15.0"
let version = "1.0.0"
let bundleVersion = "0"
let baseURL = "http://webservice.recruit.co.jp/hotpepper"
let apiKey = "8011379945b3b751"

let project = Project(
    name: projectName,
    organizationName: organizationName,
    settings: .settings(
        base: [
            "BASE_URL": SettingValue(stringLiteral: baseURL),
            "API_KEY": SettingValue(stringLiteral: apiKey),
            "SWIFT_VERSION": SettingValue(stringLiteral: "5.9"),
            "DEVELOPMENT_TEAM": SettingValue(stringLiteral: "3Y8YH8GWMM")
        ],
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
                    "CFBundleShortVersionString": .string(version),
                    "CFBundleVersion": .string(bundleVersion),
                    "CFBundleDisplayName": .string(projectName),
                    "BASE_URL": .string(baseURL),
                    "API_KEY": .string(apiKey),
                    "UILaunchScreen": .dictionary([
                        "UIColorName": .string(""),
                        "UIImageName": .string("")
                    ]),
                    "NSAppTransportSecurity": .dictionary([
                        "NSExceptionDomains": .dictionary([
                            "webservice.recruit.co.jp": .dictionary([
                                "NSExceptionAllowsInsecureHTTPLoads": .boolean(true)
                            ])
                        ])
                    ]),
                    "NSLocationWhenInUseUsageDescription": .string("周辺の店舗を表示するために位置情報が必要です。"),
                    "NSLocationAlwaysAndWhenInUseUsageDescription": .string("周辺の店舗を表示するために位置情報が必要です。")
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
