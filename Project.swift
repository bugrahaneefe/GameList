import ProjectDescription
import ProjectDescriptionHelpers

let appTarget = Target.target(
    name: "GameList",
    destinations: .iOS,
    product: .app,
    bundleId: "com.gamelist",
    deploymentTargets: .iOS("15.0"),
    infoPlist: .extendingDefault(with: [
        "UILaunchStoryboardName": "LaunchScreen",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                        "StoryboardName": "Main"
                    ]
                ]
            ]
        ],
        "UIApplicationDelegateClassName": "$(PRODUCT_MODULE_NAME).AppDelegate"
    ]),
    sources: ["GameList/**/*.swift"],
    resources: [
        "GameList/**/*.xib",
        "GameList/**/*.storyboard",
        "GameList/**/*.xcassets",
        "GameList/**/*.strings",
        "GameList/**/*.ttf",
        "GameList/**/*.json",
        "GameList/**/*.gif"
    ],
    dependencies: [
        homeModule,
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
    name: "GameList",
    targets: [
        appTarget
    ]
)
