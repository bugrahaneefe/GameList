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
}

private enum Constant {
}

final class GameDetailPresenter: Observation {
    private let defaults: DefaultsProtocol.Type
    private let interactor: GameDetailInteractorInterface
    private let router: GameDetailRouterInterface
    private var view: GameDetailViewInterface?
    private var game: Game?
    private var gameDetail: GameDetailResponse? = nil
    @Published private var isFavored: Bool = false
    
    init(interactor: GameDetailInteractorInterface,
         router: GameDetailRouterInterface,
         view: GameDetailViewInterface? = nil,
         game: Game,
         defaults: DefaultsProtocol.Type = Defaults.self) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.game = game
        self.defaults = defaults
    }
    
    override public func setupObservation() {
        observe($isFavored) { fav in
            self.view?.setFavoriteButtonImage(isSelected: self.isFavored)
        }
    }
    
    //MARK: Private Functions
    private func fetchGameDetail(with id: Int) {
        view?.showLoading()
        interactor.fetchDetail(with: id)
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
    
    private func handleGameDescription() {
        guard let description = gameDetail?.description else { return }
        view?.setGameDescription(with: description)
    }
    
    private func handleGameInformation() {
        if let releasedDate = game?.released,
           let playtime = game?.playtime {
            view?.setGameInformation(with: [
                ("Release Date:", releasedDate),
                ("Playtime:", "\(playtime)")
            ])
        }
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
        guard let gameId = game?.id else { return }
        self.isFavored = defaults.bool(key: "\(gameId)") ? true : false
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
    func viewDidLoad() {
        setupObservation()
        view?.prepareUI()
    }
    
    func viewWillAppear() {
        guard let gameId = game?.id else { return }
        fetchGameDetail(with: gameId)
    }
    
    public func favoriteButtonTapped() {
        guard let gameId = game?.id else { return }
        defaults.save(data: !defaults.bool(key: "\(gameId)"), key: "\(gameId)")
        handleFavoriteButton()
        guard let name = game?.name else { return }
        let message = isFavored ?  "is added into wishlist!" : "is removed from wishlist!"
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
