import ProjectDescription
import ProjectDescriptionHelpers

let appTarget = Target.target(
    name: "GameList",
    destinations: .iOS,
    product: .app,
    bundleId: "com.gamelist",
    deploymentTargets: .iOS("16.0"),
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
        "UIApplicationDelegateClassName": "$(PRODUCT_MODULE_NAME).AppDelegate",
        "UIAppFonts": "Lato-Regular.ttf",
        "UIUserInterfaceStyle": "Dark"
    ]),
    sources: ["GameList/**/*.swift"],
    resources: [
        "GameList/**/*.xib",
        "GameList/**/*.storyboard",
        "GameList/**/*.xcassets",
        "GameList/**/*.strings",
        "GameList/**/*.ttf",
        "GameList/**/*.xcdatamodeld",
        "GameList/**/*.json",
        "GameList/**/*.gif"
    ],
    dependencies: [
        homeModule,
        gameDetailModule,
        networkKit,
        alamofire,
        listingKit,
        dependencyEngine,
        common,
        commonViews,
        alamofireImage,
        homeHandlerKit,
        gameDetailHandlerKit,
        wishlistModule
    ]
)

let project = Project(
    name: "GameList",
    targets: [
        appTarget
    ]
)
