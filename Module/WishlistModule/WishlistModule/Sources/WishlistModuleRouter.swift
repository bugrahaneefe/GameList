//
//  WishlistModuleRouter.swift
//  WishlistModule
//
//  Created by Buğrahan Efe on 16.09.2024.
//

import CommonKit
import CoreUtils
import DependencyEngine
import UIKit
import GameDetailModule

public protocol WishlistModuleRouterInterface {
    func navigateToGameDetail(with game: Game)
}

public final class WishlistModuleRouter: WishlistModuleRouterInterface {
    weak var navigationController: UINavigationController?
    
    @ModuleDependency var gameDetail: GameDetailInterface

    public init() {}
        
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    static func create(navigationController: UINavigationController?) -> UIViewController {
        let storyboard = StoryboardHelper<Storyboards>.create(storyboard: .wishlist)
        let view = storyboard.instantiateViewController(
            viewClass: WishlistModuleViewController.self)
        let interactor = WishlistInteractor()
        let router = WishlistModuleRouter(
            navigationController: navigationController)
        let presenter = WishlistModulePresenter(
            interactor: interactor,
            router: router,
            view: view,
            argument: GameListArgument(games: []))
        
        navigationController?.navigationBar
            .configureNavigationBar(isTranslucent: true,
                                    backgroundImage: nil,
                                    shadowColor: nil,
                                    backgroundColor: UIColor.NavigationBarColor.Background)
        view.presenter = presenter
        interactor.output = presenter
        
        return view
    }
    
    public func navigateToGameDetail(with game: Game) {
        let gameDetailvc = gameDetail.gameDetail(navigationController: navigationController, with: game)
        navigationController?.navigationBar.configureNavigationBar(
            isTranslucent: true,
            backgroundImage: nil,
            shadowColor: .blue,
            backgroundColor: UIColor.NavigationBarColor.Background)
        navigationController?.pushViewController(gameDetailvc, animated: true)
    }
}
