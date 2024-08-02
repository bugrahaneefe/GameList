//
//  HomeModuleRouter.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import UIKit
import CommonKit

protocol HomeModuleRouterInterface {
    //  todo
}

final class HomeModuleRouter: HomeModuleRouterInterface {
    
    weak var navigationController: UINavigationController?
    
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
            view: view)
        
        view.presenter = presenter
        interactor.output = presenter
        
        return view
    }
}
