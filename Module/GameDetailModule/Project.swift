import ProjectDescription
import ProjectDescriptionHelpers

let frameworkTarget = Target.target(
    name: "GameDetailModule",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "com.gamelist.GameDetailModule",
    deploymentTargets: .iOS("15.0"),
    infoPlist: .default,
    sources: ["GameDetailModule/**/*.swift"],
    resources: [
        "GameDetailModule/**/*.xib",
        "GameDetailModule/**/*.storyboard",
        "GameDetailModule/**/*.xcassets",
        "GameDetailModule/**/*.strings",
        "GameDetailModule/**/*.ttf",
        "GameDetailModule/**/*.json",
        "GameDetailModule/**/*.gif"
    ],
    dependencies: [
        networkKit,
        alamofire,
        listingKit,
        dependencyEngine,
        coreUtils,
        common,
        commonViews,
        alamofireImage,
        homeHandlerKit
    ]
)

let project = Project(
    name: "GameDetailModule",
    targets: [
        frameworkTarget
    ]
)
