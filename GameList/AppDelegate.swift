import UIKit
import HomeModule
import GameDetailModule
import WishlistModule
import CommonKit
import DependencyEngine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: Dependency Registration
        HomeModuleDependencyRegistration.register(to: DependencyEngine.shared)
        GameDetailDependencyRegistration.register(to: DependencyEngine.shared)
        WishlistModuleDependencyRegistration.register(to: DependencyEngine.shared)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}
