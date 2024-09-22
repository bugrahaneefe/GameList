//
//  HomeModuleDependencyRegistration.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 2.08.2024.
//

import CommonKit
import DependencyEngine
import UIKit

public protocol HomeModuleInterface {
    func gameList(navigationController: UINavigationController?) -> UIViewController
}

public enum HomeModuleDependencyRegistration: DependencyRegistration {
    public static func register(to engine: DependencyEngine) {
        engine.register(value: HomeModule(), for: HomeModuleInterface.self)
    }
}

public final class HomeModule: HomeModuleInterface {
    public init() {}

    public func gameList(navigationController: UINavigationController?) -> UIViewController {
        HomeModuleRouter.create(navigationController: navigationController)
    }
}
