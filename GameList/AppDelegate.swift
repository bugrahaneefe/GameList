import UIKit
import HomeModule
import CommonKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Register dependencies
        HomeModuleDependencyRegistration.register(to: DependencyEngine.shared)
        
        print("AppDelegate started")
        return true
    }
}
