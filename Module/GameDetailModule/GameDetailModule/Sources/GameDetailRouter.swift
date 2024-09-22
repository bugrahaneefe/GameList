//
//  GameDetailRouter.swift
//  GameDetailModule
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import CommonKit
import UIKit

public protocol GameDetailRouterInterface {}

public final class GameDetailRouter: GameDetailRouterInterface {
    public init() {}
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    static func create(navigationController: UINavigationController?, with game: Game) -> UIViewController {
        let storyboard = StoryboardHelper<Storyboards>.create(storyboard: .gameDetail)
        let view = storyboard.instantiateViewController(viewClass: GameDetailViewController.self)
        let interactor = GameDetailInteractor()
        let router = GameDetailRouter(
            navigationController: navigationController)
        let presenter = GameDetailPresenter(
            interactor: interactor,
            router: router,
            view: view,
            argument: GameCellArgument(game: game))
        
        view.presenter = presenter
        interactor.output = presenter
        
        return view
    }
}
