import ProjectDescription
import ProjectDescriptionHelpers

let appTarget = Target.target(
    name: "GameList",
    destinations: .iOS,
    product: .app,
    bundleId: "com.gamelist",
    deploymentTargets: .iOS("15.0"),
    infoPlist: .extendingDefault(with: [
        "UILaunchStoryboardName" : "LaunchScreen"
    ]),
    sources: ["GameList/Sources/**"],
    resources: ["GameList/Resources/**"],
    dependencies: [
        homeModule,
        networkKit,
        alamofire,
        common
    ]
)

let project = Project(
    name: "GameList",
    targets: [
        appTarget
    ]
)
