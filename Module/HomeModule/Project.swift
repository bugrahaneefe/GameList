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
    sources: ["HomeModule/Sources/**"],
    resources: ["HomeModule/Resources/**"],
    dependencies: [
        networkKit,
        alamofire
    ]
)

let project = Project(
    name: "HomeModule",
    targets: [
        frameworkTarget
    ]
)
