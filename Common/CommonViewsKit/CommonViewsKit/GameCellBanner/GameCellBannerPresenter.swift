//
//  GameCellBannerPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 29.08.2024.
//

import CommonKit
import Foundation
import CoreUtils

public protocol GameCellBannerPresenterInterface: PresenterInterface {
    func favoriteButtonTapped(isSelected: Bool)
}

public final class GameCellBannerPresenter: Observation {
    private var view: GameCellBannerViewInterface?
    private let argument: GameCellArgument
    private let defaults: DefaultsProtocol.Type
    
    public init(
        view: GameCellBannerViewInterface?,
        argument: GameCellArgument,
        defaults: DefaultsProtocol.Type = Defaults.self
    ) {
        self.view = view
        self.argument = argument
        self.defaults = defaults
    }
    
    override public func setupObservation() {
        observe(argument.$isFavored) { fav in
            self.view?.setFavoriteButton(selected: self.argument.isFavored)
        }
        observe(argument.$isAlreadyClicked) { isAlreadyClicked in
            self.view?.setGameNameLabel(name: self.argument.game.name, isAlreadyClicked: isAlreadyClicked)
        }
    }
    
    private func handleBannerImage() {
        if let path = argument.game.background_image {
            view?.setBannerImage(path: path)
        }
    }
    
    private func handleGameName() {
        if let name = argument.game.name {
            argument.isAlreadyClicked = defaults.bool(key: "\(name)")
            view?.setGameNameLabel(name: name, isAlreadyClicked: argument.isAlreadyClicked)
        }
    }
    
    private func handleRating() {
        let rating = Int(argument.game.rating*20)
        view?.setRating(rating: rating)
    }
    
    private func handlePlatforms() {
        var platformNames: [String] = []
        if let platforms = argument.game.platforms {
            for platformInfo in platforms {
                let name = platformInfo.platform.name
                platformNames.append(name)
            }
        }
        view?.setPlatforms(with: platformNames)
    }
    
    private func handleFavoriteButton() {
        guard let gameId = argument.game.id else { return }
        argument.isFavored = defaults.bool(key: "\(gameId)") ? true : false
    }
    
    private func handleDetails() {
        var details: [(name: String, value: String)] = []

        if let releasedDate = argument.game.released {
            details.append(("Release Date:", "\(releasedDate)"))
        }
        
        if let genres = argument.game.genres, !genres.isEmpty {
            let genreNames = genres.compactMap { $0.name }
            let genresString = genreNames.joined(separator: ", ")
            details.append(("Genres:", genresString))
        }
        
        if let playtime = argument.game.playtime {
            details.append(("Playtime:", "\(playtime) hours"))
        }
        
        view?.setDetails(with: details)
    }
}

// MARK: - GameCellBannerPresenterInterface
extension GameCellBannerPresenter: GameCellBannerPresenterInterface {
    public func viewDidLoad() {
        setupObservation()
        handleBannerImage()
        handleGameName()
        handleRating()
        handlePlatforms()
        handleDetails()
        handleFavoriteButton()
    }

    public func favoriteButtonTapped(isSelected: Bool) {
        guard let gameId = argument.game.id else { return }
        defaults.save(data: !defaults.bool(key: "\(gameId)"), key: "\(gameId)")
        handleFavoriteButton()
    }
}

