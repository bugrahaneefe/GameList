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
//        todo
        let navigationController = UINavigationController()
        let homeVC = homeModule.gameList(navigationController: navigationController)
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        navigationController.viewControllers = [homeVC]
        
        viewControllers = [navigationController]
    }
}
