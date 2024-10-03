//
//  GameCellBannerPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 29.08.2024.
//

import CommonKit
import Foundation

public protocol GameCellBannerPresenterDelegate: AnyObject {
    func favoriteButtonIsSelected(isSelected: Bool)
}

public protocol GameCellBannerPresenterInterface: PresenterInterface {
    func favoriteButtonTapped(isSelected: Bool)
}

private enum Constant {
    enum Details {
        static let ReleaseDateTitle = "Release Date:"
        static let GenresTitle = "Genres:"
        static let PlaytimeTitle = "Playtime:"
    }
}

public final class GameCellBannerPresenter: Observation {
    private let view: GameCellBannerViewInterface?
    private let argument: GameCellArgument
    private let defaults: DefaultsProtocol.Type
    private weak var delegate: GameCellBannerPresenterDelegate?
    
    public init(
        view: GameCellBannerViewInterface?,
        argument: GameCellArgument,
        defaults: DefaultsProtocol.Type = Defaults.self,
        delegate: GameCellBannerPresenterDelegate? = nil
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
            self?.view?.setGameNameLabel(name: self?.argument.game.name, isAlreadyClicked: isAlreadyClicked)
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
    
    private func handleDetails() {
        var details: [(name: String, value: String)] = []

        if let releasedDate = argument.game.released {
            details.append((Constant.Details.ReleaseDateTitle, "\(releasedDate)"))
        }
        
        if let genres = argument.game.genres, !genres.isEmpty {
            let genreNames = genres.compactMap { $0.name }
            let genresString = genreNames.joined(separator: ", ")
            details.append((Constant.Details.GenresTitle, genresString))
        }
        
        if let playtime = argument.game.playtime {
            details.append((Constant.Details.PlaytimeTitle, "\(playtime) hours"))
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

