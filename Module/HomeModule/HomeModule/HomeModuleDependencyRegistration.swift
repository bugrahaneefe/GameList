//
//  HomeModuleDependencyRegistration.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 2.08.2024.
//

import CommonKit
import UIKit
import DependencyEngine
import CoreUtils

public enum HomeModuleDependencyRegistration: DependencyRegistration {
    public static func register(to engine: DependencyEngine) {
        engine.register(value: HomeModule(), for: HomeModuleInterface.self)
    }
}

public final class HomeModule: HomeModuleInterface {
    public init() {}

    public func gameList(navigationController: UINavigationController?) -> UIViewController {
        let storyboard = StoryboardHelper<Storyboards>.create(storyboard: .home)
        let view = storyboard.instantiateViewController(viewClass: HomeModuleViewController.self)
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
