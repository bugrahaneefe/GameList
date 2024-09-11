//
//  GameDetailPresenter.swift
//  GameDetailModule
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import CommonKit
import CommonViewsKit
import CoreUtils
import Foundation
import HomeHandlerKit
import UIKit

protocol GameDetailPresenterInterface: PresenterInterface {
}

private enum Constant {
}

final class GameDetailPresenter {
    private let interactor: GameDetailInteractorInterface
    private let router: GameDetailRouterInterface
    private var view: GameDetailViewInterface?
    private var game: Game?
    
    init(interactor: GameDetailInteractorInterface,
         router: GameDetailRouterInterface,
         view: GameDetailViewInterface? = nil,
         game: Game) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.game = game
    }
    
    private func handleGameName() {
        guard let name = game?.name else { return }
        view?.setGameName(of: name)
    }
    
    private func handleGameImage() {
        if let path = game?.background_image {
            view?.setGameImage(path: path)
        }
    }
    
    private func handleGameRating() {
        guard let rating = game?.rating else { return }
        view?.setGameRating(rating: Int(rating*20))
    }
}

extension GameDetailPresenter: GameDetailPresenterInterface {
    func viewDidLoad() {
        view?.prepareUI()
        handleGameName()
        handleGameImage()
        handleGameRating()
    }
}
