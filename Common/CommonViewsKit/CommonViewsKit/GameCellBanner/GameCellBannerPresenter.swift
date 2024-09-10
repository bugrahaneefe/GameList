//
//  GameCellBannerPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 29.08.2024.
//

import CommonKit
import Foundation

public protocol GameCellBannerPresenterInterface {
    func load()
}

public final class GameCellBannerPresenter {
    private var view: GameCellBannerViewInterface?
    private let game: Game
    private weak var homeModuleGameDelegate: HomeModuleGameDelegate?
    
    public init(
        view: GameCellBannerViewInterface?,
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
    
    private func handlePlatforms() {
        var platformNames: [String] = []
        if let platforms = game.platforms {
            for platformInfo in platforms {
                let name = platformInfo.platform.name
                platformNames.append(name)
            }
        }
        view?.setPlatforms(with: platformNames)
    }
}

// MARK: - GameCellBannerPresenterInterface
extension GameCellBannerPresenter: GameCellBannerPresenterInterface {
    public func load() {
        view?.prepareUI()
        handleBannerImage()
        handleGameName()
        handleRating()
        handlePlatforms()
    }

    //    todo
    public func prepareForReuse() {}
}

