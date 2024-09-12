//
//  GameDetailHandler.swift
//  GameDetailHandlerKit
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import CommonKit
import Foundation

public protocol GameDetailHandlerInterface {
    func gameDetails(with id: Int, completion: @escaping (GameDetailResult) -> Void)
}

public final class GameDetailHandler {
    public static let shared: GameDetailHandlerInterface = GameDetailHandler()
    private let interactor: GameDetailHandlerInteractorInterface
    
    init(interactor: GameDetailHandlerInteractorInterface  = GameDetailHandlerInteractor()) {
        self.interactor = interactor
    }
}

// MARK: - GameDetailHandlerInterface
extension GameDetailHandler: GameDetailHandlerInterface {
    public func gameDetails(with id: Int, completion: @escaping (GameDetailResult) -> Void) {
        interactor.gameDetails(with: id) { [weak self] (result: Result<GameDetailResponse, Error>) in
            guard self != nil else { return }
            completion(result)
        }
    }
}
