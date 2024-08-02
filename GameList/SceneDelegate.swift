// SceneDelegate.swift

import UIKit
import HomeModule

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("SceneDelegate started")
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let tabBarController = GameListTabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        
    }
}
