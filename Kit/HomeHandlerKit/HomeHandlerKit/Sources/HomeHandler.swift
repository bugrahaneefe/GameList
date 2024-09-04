//
//  HomeHandler.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import CommonKit
import Foundation

public protocol HomeHandlerInterface {
    func gameListDetails(at page: Int, contains name: String, completion: @escaping (GameListDetailsResult) -> Void)
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
    public func gameListDetails(at page: Int, contains name: String, completion: @escaping (GameListDetailsResult) -> Void) {
        interactor.gameListDetails(at: page, contains: name) { [weak self] (result: Result<GameListDetailsResponse, Error>) in
            guard self != nil else { return }
            completion(result)
        }
    }
}
