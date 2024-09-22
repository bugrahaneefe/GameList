import ProjectDescription
import ProjectDescriptionHelpers

let frameworkTarget = Target.target(
    name: "GameDetailModule",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "com.gamelist.GameDetailModule",
    deploymentTargets: .iOS("16.0"),
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
        dependencyEngine,
        common,
        commonViews,
        alamofireImage,
        gameDetailHandlerKit
    ]
)

let project = Project(
    name: "GameDetailModule",
    targets: [
        frameworkTarget
    ]
)
