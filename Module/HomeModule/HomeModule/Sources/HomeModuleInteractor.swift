//
//  HomeModuleInteractor.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import Foundation
import CommonKit
import NetworkKit
import HomeHandlerKit

protocol HomeModuleInteractorInterface: AnyObject {
    func fetchGameList(request: HomeModuleGameListRequest)
}

protocol HomeModuleInteractorOutput: AnyObject {
    func handleGameListResult(_ result: GameListDetailsResult)
}

final class HomeModuleInteractor {
    weak var output: HomeModuleInteractorOutput?
}

//MARK: - MLFavoriteListInteractorInterface
extension HomeModuleInteractor: HomeModuleInteractorInterface {
    func fetchGameList(request: HomeModuleGameListRequest) {
        HomeHandler.shared.gameListDetails(request: request) { [weak output] result in
            print("heheheyyy")
            output?.handleGameListResult(result)
            print(result)
            print("heheheyyy")
        }
    }
}
