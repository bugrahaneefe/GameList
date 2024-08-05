//
//  HomeHandler.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import Foundation
import CommonKit

private extension HomeHandler {
    public enum Constant {
        public static let gameListURL = "https://api.rawg.io/api/games?key=2728bd542342447cbf3dccb350fb91da"
    }
}

public final class HomeHandler {
    public static let shared: HomeHandlerInterface = HomeHandler()
    private let interactor: HomeHandlerInteractorInterface
    
    init(interactor: HomeHandlerInteractorInterface  = HomeHandlerInteractor()) {
        self.interactor = interactor
    }
    
}

// MARK: - MLFavoriteHandlerInterface
extension HomeHandler: HomeHandlerInterface {
    public func gameListDetails(request: HomeModuleGameListRequest, completion: @escaping (GameListDetailsResult) -> Void) {
        interactor.gameListDetails(request: request) { [weak self] result in
            guard let self = self else { return }
            if case .success(let response) = result {
                print(response.games as Any)
            }
            completion(result)
        }
    }
}
