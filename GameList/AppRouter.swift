import UIKit

public var globalWindow: UIWindow?

final class AppRouter {
    static let shared = AppRouter()

    private init() {}

    func start(with windowScene: UIWindowScene) {
        if globalWindow == nil {
            globalWindow = UIWindow(windowScene: windowScene)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "GameListTabBarController") as? GameListTabBarController {
            globalWindow?.rootViewController = tabBarController
            globalWindow?.makeKeyAndVisible()
        } else {
            print("Could not instantiate GameListTabBarController")
        }
    }
}
