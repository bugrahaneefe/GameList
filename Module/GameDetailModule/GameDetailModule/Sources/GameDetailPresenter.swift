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
import GameDetailHandlerKit
import UIKit

protocol GameDetailPresenterInterface: PresenterInterface {
    func favoriteButtonTapped()
    func expandDescription()
}

private enum Constant {
}

final class GameDetailPresenter: Observation {
    private let defaults: DefaultsProtocol.Type
    private let interactor: GameDetailInteractorInterface
    private let router: GameDetailRouterInterface
    private var view: GameDetailViewInterface?
    private let argument: GameCellArgument
    private var gameDetail: GameDetailResponse? = nil
    private var isDescriptionExpanded = false
    
    init(interactor: GameDetailInteractorInterface,
         router: GameDetailRouterInterface,
         view: GameDetailViewInterface? = nil,
         argument: GameCellArgument,
         defaults: DefaultsProtocol.Type = Defaults.self) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.argument = argument
        self.defaults = defaults
    }
    
    override public func setupObservation() {
        observe(argument.$isFavored) { fav in
            self.view?.setFavoriteButtonImage(isSelected: self.argument.isFavored)
        }
    }
    
    //MARK: Private Functions
    private func fetchGameDetail(with id: Int) {
        view?.showLoading()
        interactor.fetchDetail(with: id)
    }
    
    private func handleGameName() {
        guard let name = argument.game.name else { return }
        view?.setGameName(of: name)
    }
    
    private func handleGameImage() {
        if let path = argument.game.background_image {
            view?.setGameImage(path: path)
        }
    }
    
    private func handleGameRating() {
        view?.setGameRating(rating: Int(argument.game.rating*20))
    }
    
    private func handleGameDescription() {
        guard let description = gameDetail?.description else { return }
        view?.setGameDescription(with: description)
    }
    
    private func handleGameInformation() {
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
        
        view?.setGameInformation(with: details)
    }
    
    private func handleVisitButtons() {
        guard let gameDetail = gameDetail else { return }
        let websiteAvailable = !(gameDetail.website?.isEmpty ?? true)
        let redditAvailable = !(gameDetail.reddit_url?.isEmpty ?? true)
        view?.setupGameVisitButtons(
            byWeb: {
                if let website = gameDetail.website, let websiteUrl = URL(string: website) {
                    UIApplication.shared.open(websiteUrl)
                }
            },
            byReddit: {
                if let reddit = gameDetail.reddit_url, let redditUrl = URL(string: reddit) {
                    UIApplication.shared.open(redditUrl)
                }
            },
            websiteAvailable,
            redditAvailable
        )
    }
    
    private func handleFavoriteButton() {
        guard let gameId = argument.game.id else { return }
        argument.isFavored = defaults.bool(key: "\(gameId)") ? true : false
    }
    
    private func handleGameDetail(with response: GameDetailResponse) {
        gameDetail = response
        view?.hideLoading()
        handleGameDescription()
        handleGameName()
        handleGameImage()
        handleGameRating()
        handleGameInformation()
        handleVisitButtons()
        handleFavoriteButton()
    }
}

extension GameDetailPresenter: GameDetailPresenterInterface {
    func expandDescription() {
        isDescriptionExpanded.toggle()
        if isDescriptionExpanded {
            view?.updateDescriptionHeight(to: nil)
        } else {
            view?.updateDescriptionHeight(to: 91.0)
        }
    }
    
    func viewDidLoad() {
        setupObservation()
        view?.prepareUI()
    }
    
    func viewWillAppear() {
        guard let gameId = argument.game.id else { return }
        fetchGameDetail(with: gameId)
    }
    
    public func favoriteButtonTapped() {
        guard let gameId = argument.game.id else { return }
        defaults.save(data: !defaults.bool(key: "\(gameId)"), key: "\(gameId)")
        handleFavoriteButton()
        guard let name = argument.game.name else { return }
        let message = argument.isFavored ?  "is added into wishlist!" : "is removed from wishlist!"
        view?.showAlert(title: name, message: message)
    }
}

//MARK: - GameDetailInteractorOutput
extension GameDetailPresenter: GameDetailInteractorOutput {
    func handleGameDetailResult(_ result: GameDetailResult) {
        view?.hideLoading()
        switch result {
        case .success(let response):
            handleGameDetail(with: response)
        case .failure(_):
            print("error")
//            handleNetworkErrorStatus(of: "Network error")
        }
    }
}
