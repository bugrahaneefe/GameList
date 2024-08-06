//
//  HomeHandlerInteractor.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import Foundation
import CommonKit

protocol HomeHandlerInteractorInterface: AnyObject {
    func gameListDetails(request: HomeModuleGameListRequest, completion: @escaping (GameListDetailsResult) -> Void)
}

final class HomeHandlerInteractor: MLNetworker<HomeEndpointItem> { }

// MARK: - MLFavoriteRestaurantHandlerInteractorInterface
extension HomeHandlerInteractor: HomeHandlerInteractorInterface {
    func gameListDetails(request: HomeModuleGameListRequest, completion: @escaping (GameListDetailsResult) -> Void) {
        networkManager.request(endpoint: .favoriteRestaurantDetails(request: request), type: MLFavoriteRestaurantDetailsResponse.self, completion: completion)
    }
}

