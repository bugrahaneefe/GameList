import SwiftUI
import CommonKit
import HomeModule
import DependencyEngine
import WishlistModule
import CommonViewsKit

private enum Constant {
    enum TabBar {
        static let HomeTitle = "Games"
        static let HomeIconSize = CGSize(width: 28.9, height: 15)
        static let WishlistTitle = "Wishlist"
        static let WishlistIconSize = CGSize(width: 20, height: 17.5)
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
        let wishlistNavigationController = UINavigationController()
        let wishlistVC = wishlistModule.gameList(navigationController: wishlistNavigationController)
        wishlistNavigationController.viewControllers = [wishlistVC]
        wishlistNavigationController.tabBarItem = .init(
            title: Constant.TabBar.WishlistTitle,
            image: CommonViewsImages.favoriteButton.uiImage?.resizedImage(Size: Constant.TabBar.WishlistIconSize),
            selectedImage: CommonViewsImages.favoriteButtonTapped.uiImage?.resizedImage(Size: Constant.TabBar.WishlistIconSize)
        )
        let homeNavigationController = UINavigationController()
        let homeVC = homeModule.gameList(navigationController: homeNavigationController)
        homeNavigationController.viewControllers = [homeVC]
        homeNavigationController.tabBarItem = .init(
            title: Constant.TabBar.HomeTitle,
            image: CommonViewsImages.gamesIcon.uiImage?.resizedImage(Size: Constant.TabBar.HomeIconSize),
            selectedImage: CommonViewsImages.gamesIconTapped.uiImage?.resizedImage(Size: Constant.TabBar.HomeIconSize)
        )
        viewControllers = [homeNavigationController, wishlistNavigationController]
        tabBar.tintColor = UIColor.TabBarColor.TabBarTint
        tabBar.setCustomAppearance(backgroundColor: UIColor.TabBarColor.TabBarBackground)
    }
}
