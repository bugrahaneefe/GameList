//
//  HomeHandlerInteractor.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import CommonKit
import Foundation
import NetworkKit

protocol HomeHandlerInteractorInterface: AnyObject {
    func gameListDetails(at page: Int, completion: @escaping (GameListDetailsResult) -> Void)
}

final class HomeHandlerInteractor: Networker<HomeEndpointItem> { }

// MARK: - HomeHandlerInteractorInterface
extension HomeHandlerInteractor: HomeHandlerInteractorInterface {
    func gameListDetails(at page: Int, completion: @escaping (GameListDetailsResult) -> Void) {
        request(endpoint: .gameListDetails(at: page)) { (result: Result<GameListDetailsResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
