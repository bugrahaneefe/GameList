//
//  GameCellPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 4.08.2024.
//

import Foundation
import CommonKit

public protocol GameCellPresenterInterface {
    func load()
}

public final class GameCellPresenter {
    private var view: GameCellViewInterface?
    private let game: Game
    private weak var homeModuleGameDelegate: HomeModuleGameDelegate?
    
    public init(
        view: GameCellViewInterface?,
        argument: GameCellArgument,
        homeModuleGameDelegate: HomeModuleGameDelegate? = nil) {
            self.view = view
            game = argument.game
            self.homeModuleGameDelegate = homeModuleGameDelegate
        }
    
    private func handleBannerImage() {
        if let path = game.background_image {
            view?.setBannerImage(path: path)
        }
    }
    
    private func handleGameName() {
        if let name = game.name {
            view?.setGameNameLabel(name: name)
        }
    }
    
    private func handleRating() {
        let rating = Int(game.rating*20)
        view?.setRating(rating: rating)
    }
}

// MARK: - GameCellPresenterInterface
extension GameCellPresenter: GameCellPresenterInterface {
    public func load() {
        view?.prepareUI()
        handleBannerImage()
        handleGameName()
        handleRating()
    }

    //    todo
    public func prepareForReuse() {}
}

