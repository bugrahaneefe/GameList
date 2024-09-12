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

protocol GameDetailPresenterInterface: PresenterInterface, GameDetailModuleGameDelegate {
}

private enum Constant {
}

final class GameDetailPresenter {
    private let interactor: GameDetailInteractorInterface
    private let router: GameDetailRouterInterface
    private var view: GameDetailViewInterface?
    private var game: Game?
    
    init(interactor: GameDetailInteractorInterface,
         router: GameDetailRouterInterface,
         view: GameDetailViewInterface? = nil,
         game: Game) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.game = game
    }
    
    //MARK: Private Functions
    private func fetchGameDetail(with id: Int) {
        view?.showLoading()
        
        let endpoint = GameDetailEndpointItem.gameDetails(with: id)
        
        guard let url = endpoint.url else {
            view?.hideLoading()
            return
        }
        
        print(url)
        
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
    
    private func handleGameDescription(of id: Int) {
        let id = game?.id
//        view?.setGameDescription
    }
}

extension GameDetailPresenter: GameDetailPresenterInterface {
    func viewDidLoad() {
        view?.prepareUI()
        handleGameName()
        handleGameImage()
        handleGameRating()
    }
    
    func viewWillAppear() {
        fetchGameDetail(with: game?.id ?? 348)
    }
}

//MARK: - GameDetailInteractorOutput
extension GameDetailPresenter: GameDetailInteractorOutput {
    func handleGameDetailResult(_ result: GameDetailResult) {
        view?.hideLoading()
        switch result {
        case .success(let response):
            print(response)
//            handleGameSection(with: response)
        case .failure(_):
            print("error")
//            handleNetworkErrorStatus(of: "Network error")
        }
    }
}
