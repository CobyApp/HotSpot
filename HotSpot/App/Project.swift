import ProjectDescription

let project = Project(
    name: "HotSpot",
    organizationName: "Coby",
    settings: .settings(
        base: [
            "BASE_URL": SettingValue(stringLiteral: "http://webservice.recruit.co.jp/hotpepper"),
            "API_KEY": SettingValue(stringLiteral: "8011379945b3b751"),
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
            name: "HotSpot",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.coby.HotSpot",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": .string("1.0.0"),
                    "CFBundleVersion": .string("0"),
                    "CFBundleDisplayName": .string("HotSpot"),
                    "BASE_URL": .string("http://webservice.recruit.co.jp/hotpepper"),
                    "API_KEY": .string("8011379945b3b751"),
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
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Presentation", path: "../Presentation"),
                .project(target: "Data", path: "../Data"),
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Shared", path: "../Shared")
            ]
        ),
        .target(
            name: "HotSpotTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.coby.HotSpotTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: "HotSpot")]
        )
    ],
    schemes: [
        .scheme(
            name: "HotSpot Debug",
            buildAction: .buildAction(targets: ["HotSpot"]),
            runAction: .runAction(configuration: .debug)
        ),
        .scheme(
            name: "HotSpot Release",
            buildAction: .buildAction(targets: ["HotSpot"]),
            runAction: .runAction(configuration: .release)
        )
    ]
) 