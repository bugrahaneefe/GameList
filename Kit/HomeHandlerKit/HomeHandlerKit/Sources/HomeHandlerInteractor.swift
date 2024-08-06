//
//  HomeHandlerInteractor.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import Foundation
import CommonKit

protocol HomeHandlerInteractorInterface: AnyObject {
    func gameListDetails(completion: @escaping (GameListDetailsResult) -> Void)
}

final class HomeHandlerInteractor: Networker<HomeEndpointItem> { }

// MARK: - HomeHandlerInteractorInterface
extension HomeHandlerInteractor: HomeHandlerInteractorInterface {
    func gameListDetails(completion: @escaping (GameListDetailsResult) -> Void) {
        request(endpoint: .gameListDetails) { (result: Result<GameListDetailsResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
