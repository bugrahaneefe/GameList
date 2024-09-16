import SwiftUI
import CommonKit
import HomeModule
import DependencyEngine
import WishlistModule

private enum Constant {
    enum TabBar {
        static let GameTitle: String = "Games"
        static let WishlistTitle: String = "Wishlist"
    }
}

public final class GameListTabBarController: UITabBarController {
    @ModuleDependency var homeModule: HomeModuleInterface
    @ModuleDependency var wishlistModule: WishlistModuleInterface
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let navigationController = UINavigationController()
        tabBar.tintColor = UIColor.TabBarColor.TabBarTint
        
        let wishlistNavigationController = UINavigationController()
        let wishlistVC = wishlistModule.gameList(navigationController: wishlistNavigationController)
        wishlistNavigationController.viewControllers = [wishlistVC]
        wishlistNavigationController.tabBarItem = .init(
            title: Constant.TabBar.WishlistTitle,
            image: UIImage.heart,
            selectedImage: UIImage.heartFill
        )
        
        let homeNavigationController = UINavigationController()
        let homeVC = homeModule.gameList(navigationController: homeNavigationController)
        homeNavigationController.viewControllers = [homeVC]
        homeNavigationController.tabBarItem = .init(
            title: Constant.TabBar.GameTitle,
            image: UIImage.gameController,
            selectedImage: UIImage.gameControllerFill
        )
        
        viewControllers = [homeNavigationController, wishlistNavigationController]
        tabBar.setCustomAppearance(backgroundColor: UIColor.TabBarColor.TabBarBackground)
    }
}
