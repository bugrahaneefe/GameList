//
//  GameDetailHandlerInteractor.swift
//  GameDetailHandlerKit
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import CommonKit
import Foundation
import NetworkKit

protocol GameDetailHandlerInteractorInterface: AnyObject {
    func gameDetails(with id: Int, completion: @escaping (GameDetailResult) -> Void)
}

final class GameDetailHandlerInteractor: Networker<GameDetailEndpointItem> { }

// MARK: - GameDetailHandlerInteractorInterface
extension GameDetailHandlerInteractor: GameDetailHandlerInteractorInterface {
    func gameDetails(with id: Int, completion: @escaping (GameDetailResult) -> Void) {
        request(endpoint: .gameDetails(with: id)) { (result: Result<GameDetailResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
