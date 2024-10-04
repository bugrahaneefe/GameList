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
        dependencyEngine,
        common,
        commonViews,
        alamofireImage,
        homeHandlerKit,
        gameDetailHandlerKit,
        wishlistModule
    ],
    settings: .settings(
        base: [
            "OTHER_LDFLAGS": "-ObjC"
        ]
    )
)

let gameListUITestsTarget = Target.target(
    name: "GameListUITests",
    destinations: .iOS,
    product: .uiTests,
    bundleId: "com.gamelist.GameListUITests",
    deploymentTargets: .iOS("16.0"),
    infoPlist: .default,
    sources: "GameListUITests/**/*.swift",
    resources: [
        "GameListUITests/**/*.json",
    ],
    dependencies: [
        .target(name: "GameList")
    ]
)

let project = Project(
    name: "GameList",
    targets: [
        appTarget,
        gameListUITestsTarget
    ],
    schemes: [
        .scheme(
            name: "GameList",
            shared: true,
            buildAction: .buildAction(targets: ["GameList"]),
            testAction: .targets(
                ["GameListUITests"],
                configuration: .debug
            ),
            runAction: .runAction(
                configuration: .release
            )
        )
    ]
)
