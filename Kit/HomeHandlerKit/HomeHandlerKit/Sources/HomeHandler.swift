//
//  HomeHandler.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import CommonKit
import Foundation

public struct HomeModuleGameListRequest: Decodable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [Game]
    
    public init(count: Int, next: String?, previous: String?, results: [Game]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

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
