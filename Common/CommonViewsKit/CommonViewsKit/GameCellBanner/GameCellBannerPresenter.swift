//
//  GameCellBannerPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 29.08.2024.
//

import CommonKit
import Foundation

public protocol GameCellBannerPresenterInterface {
    func favoriteButtonTapped(isSelected: Bool)
    func load()
}

public final class GameCellBannerPresenter: Observation {
    private var view: GameCellBannerViewInterface?
    private let game: Game
    private let defaults: DefaultsProtocol.Type
    private weak var homeModuleGameDelegate: HomeModuleGameDelegate?
    @Published private var isFavored: Bool = false
    
    public init(
        view: GameCellBannerViewInterface?,
        argument: GameCellArgument,
        homeModuleGameDelegate: HomeModuleGameDelegate? = nil,
        defaults: DefaultsProtocol.Type = Defaults.self
    ) {
            self.view = view
            game = argument.game
            self.homeModuleGameDelegate = homeModuleGameDelegate
        self.defaults = defaults
        }
    
    override public func setupObservation() {
        observe($isFavored) { fav in
            self.view?.setFavoriteButton(selected: self.isFavored)
        }
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
    
    private func handleFavoriteButton() {
        guard let gameId = game.id else { return }
        self.isFavored = defaults.bool(key: "\(gameId)") ? true : false
    }
    
    private func handleDetails() {
//        todo array
//        todo gameentity genres?
        if let releasedDate = game.released,
           let playtime = game.playtime {
            view?.setDetails(with: [
                ("Release Date:", releasedDate),
                ("Playtime:", "\(playtime)")
            ])
        }
    }
}

// MARK: - GameCellBannerPresenterInterface
extension GameCellBannerPresenter: GameCellBannerPresenterInterface {
    public func load() {
        setupObservation()
        view?.prepareUI()
        handleBannerImage()
        handleGameName()
        handleRating()
        handlePlatforms()
        handleDetails()
        handleFavoriteButton()
    }

    public func favoriteButtonTapped(isSelected: Bool) {
        guard let gameId = game.id else { return }
        defaults.save(data: !defaults.bool(key: "\(gameId)"), key: "\(gameId)")
        handleFavoriteButton()
    }
}

