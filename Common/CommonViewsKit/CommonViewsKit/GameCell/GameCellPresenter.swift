//
//  GameCellPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 4.08.2024.
//

import CommonKit
import Foundation
import CoreUtils

public protocol GameCellPresenterInterface: PresenterInterface {
    func favoriteButtonTapped(isSelected: Bool)
}

public final class GameCellPresenter: Observation {
    private let view: GameCellViewInterface?
    private let argument: GameCellArgument
    private let defaults: DefaultsProtocol.Type
        
    public init(
        view: GameCellViewInterface?,
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
            self.view?.setGameNameLabel(name: self.argument.game.name, isAlreadyClicked: self.argument.isAlreadyClicked)
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
    
    private func handleFavoriteButton() {
        guard let gameId = argument.game.id else { return }
        argument.isFavored = defaults.bool(key: "\(gameId)") ? true : false
    }
}

// MARK: - GameCellPresenterInterface
extension GameCellPresenter: GameCellPresenterInterface {
    public func viewDidLoad() {
        setupObservation()
        handleBannerImage()
        handleGameName()
        handleRating()
        handleFavoriteButton()
    }
    
    public func favoriteButtonTapped(isSelected: Bool) {
        guard let gameId = argument.game.id else { return }
        defaults.save(data: !defaults.bool(key: "\(gameId)"), key: "\(gameId)")
        handleFavoriteButton()
    }
}
