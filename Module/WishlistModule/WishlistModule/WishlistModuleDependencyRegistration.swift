//
//  WishlistModuleDependencyRegistration.swift
//  WishlistModule
//
//  Created by Buğrahan Efe on 16.09.2024.
//

import CommonKit
import DependencyEngine
import UIKit

public protocol WishlistModuleInterface {
    func gameList(navigationController: UINavigationController?) -> UIViewController
}

public enum WishlistModuleDependencyRegistration: DependencyRegistration {
    public static func register(to engine: DependencyEngine) {
        engine.register(value: WishlistModule(), for: WishlistModuleInterface.self)
    }
}

public final class WishlistModule: WishlistModuleInterface {
    public init() {}

    public func gameList(navigationController: UINavigationController?) -> UIViewController {
        WishlistModuleRouter.create(navigationController: navigationController)
    }
}
