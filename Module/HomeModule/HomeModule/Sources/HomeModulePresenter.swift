//
//  HomeModulePresenter.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import CommonKit
import CommonViewsKit
import CoreUtils
import Foundation
import HomeHandlerKit
import UIKit

protocol HomeModulePresenterInterface: PresenterInterface, HomeModuleGameDelegate, HomeModuleSectionDelegate {
    var appearanceType: AppereanceType { get }
    
    func numberOfItemsInGameSection() -> Int
    func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell
    func didSelectGame(at indexPath: IndexPath)
    func changeAppearanceTapped()
    func pullToRefresh()
    func willDisplayItemAt(_ indexPath: IndexPath)
}

private enum Constant {
    enum GameListRequest {
        static let request = HomeModuleGameListRequest(
            count: 0,
            next: nil,
            previous: nil,
            results: [])
    }
    
    enum Defaults {
        static let isBannerStateActive = "isBannerStateActive"
    }
}

enum AppereanceType {
    case logo, banner
}

final class HomeModulePresenter {
    private let interactor: HomeModuleInteractorInterface
    private let router: HomeModuleRouterInterface
    private let defaults: DefaultsProtocol.Type
    private var view: HomeViewInterface?
    private var games: [Game] = []
    private var gameSection: GameSection?
    private var gameResponse: GameListDetailsResponse?
    private var isFetchingAvailable: Bool = true
    
    init(interactor: HomeModuleInteractorInterface,
         router: HomeModuleRouterInterface,
         view: HomeViewInterface? = nil,
         defaults: DefaultsProtocol.Type = Defaults.self) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.defaults = defaults
    }
    
    // MARK: Private Methods
    private func fetchGameList(next: String? = nil) {
        guard isFetchingAvailable else { return }
        isFetchingAvailable = false
        
        view?.showLoading()
        
        let request: HomeModuleGameListRequest
        if let next = next, !next.isEmpty {
            request = HomeModuleGameListRequest(
                count: games.count,
                next: next,
                previous: nil,
                results: [])
        } else {
            request = Constant.GameListRequest.request
        }
        
        interactor.fetchGameList(request: request)
    }
    
    private func handleEmptyGameStatus() {
        view?.hideLoading()
        view?.showResponseNilLabel()
    }
    
    private func handleGameSection(with response: GameListDetailsResponse) {
        gameResponse = response
        
        games.append(contentsOf: response.results)
        self.gameSection = GameSection(games: games, delegate: self)
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadCollectionView()
            self?.view?.hideLoading()
            self?.isFetchingAvailable = true
        }
    }
    
    private func handleNetworkErrorStatus(of error: String) {
        view?.hideLoading()
        view?.showResponseNilLabel(with: error)
        self.isFetchingAvailable = true
    }
}

//MARK: - HomeModulePresenterInterface
extension HomeModulePresenter: HomeModulePresenterInterface {
    var appearanceType: AppereanceType {
        defaults.bool(key: Constant.Defaults.isBannerStateActive) ? .banner : .logo
    }
    
    func viewDidLoad() {
        view?.prepareUI()
        view?.prepareCollectionView()
        fetchGameList()
    }
    
//    func viewWillAppear() {
//        fetchGameList()
//    }
    
    func numberOfItemsInGameSection() -> Int {
        return games.count
//        return gameSection?.numberOfItems() ?? 0
    }
    
    func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        return gameSection?.configureCell(for: collectionView, at: indexPath, with: appearanceType) ?? UICollectionViewCell()
    }
    
    func didSelectGame(at indexPath: IndexPath) {
//        todo
//        router.navigateToGameDetails(game)
    }
    
    func changeAppearanceTapped() {
        defaults.save(data: !defaults.bool(key: Constant.Defaults.isBannerStateActive), key: Constant.Defaults.isBannerStateActive)
        view?.reloadCollectionView()
    }
    
    func pullToRefresh() {
        games.removeAll()
        gameSection = nil
        fetchGameList()
    }
}

//MARK: - HomeModuleInteractorOutput
extension HomeModulePresenter: HomeModuleInteractorOutput {
    func handleGameListResult(_ result: GameListDetailsResult) {
        view?.hideLoading()
        switch result {
        case .success(let response):
            guard !response.results.isEmpty else {
                handleEmptyGameStatus()
                return
            }
            handleGameSection(with: response)
        case .failure(_):
            handleNetworkErrorStatus(of: "Network error")
        }
    }
}

//MARK: Pagination
extension HomeModulePresenter {
    func willDisplayItemAt(_ indexPath: IndexPath) {
        guard indexPath.item == games.count - 1,
              let next = gameResponse?.next,
              let urlComponents = URLComponents(string: next) else { return }

        var nextRequestComponents = URLComponents()
        nextRequestComponents.path.append(urlComponents.path)
        nextRequestComponents.query = urlComponents.query

        if let nextUrl = nextRequestComponents.url {
            fetchGameList(next: nextUrl.absoluteString)
        }
    }
}
