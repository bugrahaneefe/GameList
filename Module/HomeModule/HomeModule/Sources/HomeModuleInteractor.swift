//
//  HomeModuleInteractor.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import Foundation
import Common
import NetworkKit

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
        NetworkKit.shared.favoriteRestaurantDetails(request: request) { [weak output] result in
            output?.handleFavoriteListResult(result)
        }
    }
}


public func favoriteRestaurantDetails(request: MLFavoriteRestaurantsDetailsRequest, completion: @escaping (FavoriteRestaurantDetailsResult) -> Void) {
    interactor.favoriteRestaurantDetails(request: request) { [weak self] result in
        guard let self = self else { return }
        if case .success(let response) = result {
            response.restaurants?
                .compactMap(\.id)
                .forEach { self.insertRestaurantIdToRestaurantIdArray(restaurantId: $0) }
        }
        self.notificationCenter.post(name: .mealFavoriteStateChanged, object: self, userInfo: nil)
        completion(result)
    }
}
