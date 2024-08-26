import SwiftUI
import CommonKit
import HomeModule
import DependencyEngine

public final class GameListTabBarController: UITabBarController {
    @ModuleDependency var homeModule: HomeModuleInterface
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let navigationController = UINavigationController()
        tabBar.tintColor = UIColor(named: "TabBarTint")
        
        let homeVC = homeModule.gameList(navigationController: navigationController)
        navigationController.viewControllers = [homeVC]
        navigationController.tabBarItem = .init(
            title: "Games",
            image: UIImage(systemName: "gamecontroller"),
            selectedImage: UIImage(systemName: "gamecontroller.fill")
        )
        
        viewControllers = [navigationController]
        
        navigationController.navigationBar
            .configureNavigationBar(isTranslucent: true,
                                    backgroundImage: nil,
                                    shadowColor: nil,
                                    backgroundColor: UIColor(named: "NavigationBarBackground") ?? .clear)
        tabBar.setCustomAppearance(backgroundColor: UIColor(named: "TabBarBackground"))
    }
}
