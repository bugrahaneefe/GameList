import ProjectDescription
import ProjectDescriptionHelpers

let frameworkTarget = Target.target(
    name: "HomeModule",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "com.gamelist.HomeModule",
    deploymentTargets: .iOS("15.0"),
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
        networkKit,
        alamofire,
        listingKit,
        dependencyEngine,
        coreUtils,
        common,
        commonViews,
        sdWebImage,
        homeHandlerKit
    ]
)

let project = Project(
    name: "HomeModule",
    targets: [
        frameworkTarget
    ]
)
