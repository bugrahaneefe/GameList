//
//  MockHomeModuleRouter.swift
//  HomeModulePresenterTests
//
//  Created by Buğrahan Efe on 23.09.2024.
//

import UIKit
import CommonKit

@testable import HomeModule

final class MockHomeModuleRouter: HomeModuleRouterInterface {
    var invokedNavigateToGameDetail = false
    var invokedNavigateToGameDetailCount = 0
    var invokedNavigateToGameDetailParameters: (Game)?
    var invokedNavigateToGameDetailParametersList = [(Game)]()
    
    func navigateToGameDetail(with game: Game) {
        invokedNavigateToGameDetail = true
        invokedNavigateToGameDetailCount += 1
        invokedNavigateToGameDetailParameters = (game)
        invokedNavigateToGameDetailParametersList.append((game))
    }
}
