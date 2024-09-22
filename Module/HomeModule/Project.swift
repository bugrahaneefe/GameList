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
        listingKit,
        dependencyEngine,
        common,
        commonViews,
        alamofireImage,
        homeHandlerKit,
        gameDetailHandlerKit
    ]
)

let project = Project(
    name: "HomeModule",
    targets: [
        frameworkTarget
    ]
)
