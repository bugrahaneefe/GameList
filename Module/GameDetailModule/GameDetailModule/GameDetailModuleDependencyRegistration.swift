//
//  GameDetailModuleDependencyRegistration.swift
//  GameDetailModule
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import CommonKit
import CoreUtils
import DependencyEngine
import UIKit

public protocol GameDetailInterface {
    func gameDetail(navigationController: UINavigationController?, with game: Game) -> UIViewController
}

public enum GameDetailDependencyRegistration: DependencyRegistration {
    public static func register(to engine: DependencyEngine) {
        engine.register(value: GameDetail(), for: GameDetailInterface.self)
    }
}

public final class GameDetail: GameDetailInterface {
    public init() {}

    public func gameDetail(navigationController: UINavigationController?, with game: Game) -> UIViewController {
        GameDetailRouter.create(navigationController: navigationController, with: game)
    }
}
