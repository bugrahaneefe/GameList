import ProjectDescription
import ProjectDescriptionHelpers

let frameworkTarget = Target.target(
    name: "HomeModule",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "com.gamelist.HomeModule",
    deploymentTargets: .iOS("16.0"),
    infoPlist: .extendingDefault(with: [
        "UILaunchStoryboardName" : "LaunchScreen"
    ]),
    sources: ["HomeModule/**/*.swift"],
    resources: [
        "HomeModule/**/*.xib",
        "HomeModule/**/*.storyboard",
        "HomeModule/**/*.xcassets",
        "HomeModule/**/*.strings",
        "HomeModule/**/*.ttf",
        "HomeModule/**/*.json",
        "HomeModule/**/*.gif"
    ],
    dependencies: [
        gameDetailModule,
        networkKit,
        alamofire,
        dependencyEngine,
        common,
        commonViews,
        alamofireImage,
        homeHandlerKit
    ]
)

let project = Project(
    name: "HomeModule",
    targets: [
        frameworkTarget,
        Target.target(
            name: "HomeModulePresenterTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.gamelist.HomeModulePresenterTests",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: "HomeModulePresenterTests/**/*.swift",
            resources: [
                "HomeModulePresenterTests/**/*.json",
            ],
            dependencies: [
                homeModule
            ])
    ],
    schemes: [
        .scheme(
            name: "HomeModule",
            shared: true,
            buildAction: .buildAction(targets: ["HomeModule"]),
            testAction: .targets(
                ["HomeModulePresenterTests"],
                configuration: .debug
            ),
            runAction: .runAction(
                configuration: .release
            )
        )
    ]
)
