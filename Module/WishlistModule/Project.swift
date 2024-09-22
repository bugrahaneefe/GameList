import ProjectDescription
import ProjectDescriptionHelpers

let frameworkTarget = Target.target(
    name: "WishlistModule",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "com.gamelist.WishlistModule",
    deploymentTargets: .iOS("16.0"),
    infoPlist: .default,
    sources: ["WishlistModule/**/*.swift"],
    resources: [
        "WishlistModule/**/*.xib",
        "WishlistModule/**/*.storyboard",
        "WishlistModule/**/*.xcassets",
        "WishlistModule/**/*.strings",
        "WishlistModule/**/*.ttf",
        "WishlistModule/**/*.json",
        "WishlistModule/**/*.gif"
    ],
    dependencies: [
        gameDetailModule,
        networkKit,
        alamofire,
        dependencyEngine,
        common,
        commonViews,
        alamofireImage,
        homeHandlerKit,
        gameDetailHandlerKit
    ]
)

let project = Project(
    name: "WishlistModule",
    targets: [
        frameworkTarget
    ]
)
