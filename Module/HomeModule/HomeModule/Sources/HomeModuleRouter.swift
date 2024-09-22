//
//  HomeModuleRouter.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import CommonKit
import DependencyEngine
import UIKit
import GameDetailModule

public protocol HomeModuleRouterInterface {
    func navigateToGameDetail(with game: Game)
}

public final class HomeModuleRouter: HomeModuleRouterInterface {
    weak var navigationController: UINavigationController?
    
    @ModuleDependency var gameDetail: GameDetailInterface

    public init() {}
        
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    static func create(navigationController: UINavigationController?) -> UIViewController {
        let storyboard = StoryboardHelper<Storyboards>.create(storyboard: .home)
        let view = storyboard.instantiateViewController(
            viewClass: HomeModuleViewController.self)
        let interactor = HomeModuleInteractor()
        let router = HomeModuleRouter(
            navigationController: navigationController)
        let presenter = HomeModulePresenter(
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
