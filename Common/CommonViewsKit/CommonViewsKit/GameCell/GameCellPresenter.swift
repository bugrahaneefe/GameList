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
    func bannerImageLoaded()
    func prepareForReuse()
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
        if let path = game.backgroundImage {
            view?.setBannerImage(path: path)
        }
    }
}

extension GameCellPresenter: GameCellPresenterInterface {
    public func load() {
        view?.prepareUI()
        handleBannerImage()
    }
    
//    todo
    public func bannerImageLoaded() {    }
//    todo
    public func prepareForReuse() {}
}

