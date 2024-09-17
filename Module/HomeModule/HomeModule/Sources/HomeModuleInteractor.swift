//
//  HomeModuleInteractor.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import CommonKit
import Foundation
import HomeHandlerKit
import NetworkKit

protocol HomeModuleInteractorInterface: AnyObject {
    func fetchGameList(with: URL?, at page: Int, contains name: String, with platform: String?)
}

protocol HomeModuleInteractorOutput: AnyObject {
    func handleGameListResult(_ result: GameListDetailsResult)
}

final class HomeModuleInteractor {
    weak var output: HomeModuleInteractorOutput?
}

//MARK: - HomeModuleInteractorInterface
extension HomeModuleInteractor: HomeModuleInteractorInterface {
    func fetchGameList(with: URL?, at page: Int, contains name: String, with platform: String?) {
        HomeHandler.shared.gameListDetails(at: page, contains: name, with: platform) { [weak output] result in
            output?.handleGameListResult(result)
        }
    }
}
