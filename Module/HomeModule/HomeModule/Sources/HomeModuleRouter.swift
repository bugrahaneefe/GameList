//
//  HomeModuleRouter.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import CommonKit
import CoreUtils
import UIKit

public protocol HomeModuleRouterInterface {}

public final class HomeModuleRouter: HomeModuleRouterInterface {
    public init() {}
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    public func create(navigationController: UINavigationController?) -> UIViewController {
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
