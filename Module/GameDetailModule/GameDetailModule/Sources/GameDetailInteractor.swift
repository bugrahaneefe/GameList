//
//  GameDetailInteractor.swift
//  GameDetailModule
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import CommonKit
import Foundation
import GameDetailHandlerKit
import NetworkKit

protocol GameDetailInteractorInterface: AnyObject {
    func fetchDetail(with id: Int)
}

protocol GameDetailInteractorOutput: AnyObject {
    func handleGameDetailResult(_ result: GameDetailResult)
}

final class GameDetailInteractor {
    weak var output: GameDetailInteractorOutput?
}

//MARK: - GameDetailInteractorInterface
extension GameDetailInteractor: GameDetailInteractorInterface {
    func fetchDetail(with id: Int) {
        GameDetailHandler.shared.gameDetails(with: id) { [weak output] result in
            print(result)
            guard let output else
            {return}
            output.handleGameDetailResult(result)
        }
    }
}
