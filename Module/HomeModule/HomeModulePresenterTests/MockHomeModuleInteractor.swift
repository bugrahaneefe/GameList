//
//  MockHomeModuleInteractor.swift
//  HomeModulePresenterTests
//
//  Created by Buğrahan Efe on 23.09.2024.
//

import UIKit

@testable import HomeModule

final class MockHomeModuleInteractor: HomeModuleInteractorInterface {
    var invokedFetchGameList = false
    var invokedFetchGameListCount = 0
    var invokedFetchGameListParameters: (URL?, at: Int, contains: String, with: String?)?
    var invokedFetchGameListParametersList = [(URL?, at: Int, contains: String, with: String?)]()

    func fetchGameList(with: URL?, at page: Int, contains name: String, with platform: String?) {
        invokedFetchGameList = true
        invokedFetchGameListCount += 1
        invokedFetchGameListParameters = (with, page, name, platform)
        invokedFetchGameListParametersList.append((with, page, name, platform))
    }
}
