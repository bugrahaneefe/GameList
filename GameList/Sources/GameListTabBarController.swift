import SwiftUI
import CommonKit
import HomeModule
import DependencyEngine

private enum Constant {
    enum TabBar {
        static let title: String = "Games"
    }
}

public final class GameListTabBarController: UITabBarController {
    @ModuleDependency var homeModule: HomeModuleInterface
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let navigationController = UINavigationController()
        tabBar.tintColor = UIColor.TabBarColor.TabBarTint
        
        let homeVC = homeModule.gameList(navigationController: navigationController)
        navigationController.viewControllers = [homeVC]
        navigationController.tabBarItem = .init(
            title: Constant.TabBar.title,
            image: UIImage.gameController,
            selectedImage: UIImage.gameControllerFill
        )
        
        viewControllers = [navigationController]
        
        navigationController.navigationBar
            .configureNavigationBar(isTranslucent: true,
                                    backgroundImage: nil,
                                    shadowColor: nil,
                                    backgroundColor: UIColor.NavigationBarColor.Background)
        tabBar.setCustomAppearance(backgroundColor: UIColor.TabBarColor.TabBarBackground)
    }
}
