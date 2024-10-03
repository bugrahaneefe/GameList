//
//  GameCellPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 4.08.2024.
//

import CommonKit
import Foundation

public protocol GameCellPresenterDelegate: AnyObject {
    func favoriteButtonIsSelected(isSelected: Bool)
}

public protocol GameCellPresenterInterface: PresenterInterface {
    func favoriteButtonTapped(isSelected: Bool)
}

public final class GameCellPresenter: Observation {
    private let view: GameCellViewInterface?
    private let argument: GameCellArgument
    private let defaults: DefaultsProtocol.Type
    private weak var delegate: GameCellPresenterDelegate?
        
    public init(
        view: GameCellViewInterface?,
        argument: GameCellArgument,
        defaults: DefaultsProtocol.Type = Defaults.self,
        delegate: GameCellPresenterDelegate? = nil
        ) {
            self.view = view
            self.argument = argument
            self.defaults = defaults
            self.delegate = delegate
        }
    
    override public func setupObservation() {
        observe(argument.$isFavored) { [weak self] fav in
            self?.view?.setFavoriteButton(selected: self?.argument.isFavored ?? false)
        }
        observe(argument.$isAlreadyClicked) { [weak self] isAlreadyClicked in
            self?.view?.setGameNameLabel(name: self?.argument.game.name, isAlreadyClicked: self?.argument.isAlreadyClicked ?? false)
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
        handleFavoriteGames(isSelected: argument.isFavored)
    }
    
    private func handleFavoriteGames(isSelected: Bool) {
        guard let gameId = argument.game.id else { return }
        var favoredGamesData = defaults.array(key: "favoredGames") as? [Data] ?? []
        var favoredGames = favoredGamesData.compactMap { try? JSONDecoder().decode(Game.self, from: $0) }
        if isSelected {
            if !favoredGames.contains(where: { $0.id == gameId }) {
                favoredGames.append(argument.game)
            }
        } else {
            favoredGames.removeAll { $0.id == gameId }
        }
        let encodedGames = favoredGames.compactMap { try? JSONEncoder().encode($0) }
        defaults.save(data: encodedGames, key: "favoredGames")
        
        delegate?.favoriteButtonIsSelected(isSelected: isSelected)
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
