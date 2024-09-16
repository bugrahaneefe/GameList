// SceneDelegate.swift

import UIKit
import HomeModule

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        AppRouter.shared.start(with: windowScene)
        self.window = globalWindow
    }
}
