//
//  HomeHandler.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import Foundation
import CommonKit

public protocol HomeHandlerInterface {
    func gameListDetails(request: HomeModuleGameListRequest, completion: @escaping (GameListDetailsResult) -> Void)
}

public final class HomeHandler {
    public static let shared: HomeHandlerInterface = HomeHandler()
    private let interactor: HomeHandlerInteractorInterface
    
    init(interactor: HomeHandlerInteractorInterface  = HomeHandlerInteractor()) {
        self.interactor = interactor
    }
}

// MARK: - HomeHandlerInterface
extension HomeHandler: HomeHandlerInterface {
    public func gameListDetails(request: HomeModuleGameListRequest, completion: @escaping (GameListDetailsResult) -> Void) {
        interactor.gameListDetails() { [weak self] (result: Result<GameListDetailsResponse, Error>) in
            guard self != nil else { return }
            if case .success(let response) = result {
                print(response.results as Any)
            }
            completion(result)
        }
    }
}
