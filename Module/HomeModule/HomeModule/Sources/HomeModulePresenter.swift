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
    private var currentPage = 1
    private var isFetchingAvailable = true
    
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
    private func fetchGameList(at page: Int) {
        guard isFetchingAvailable else { return }
        isFetchingAvailable = false
        
        view?.showLoading()
        
        let endpoint = HomeEndpointItem.gameListDetails(at: page)
        
        guard let url = endpoint.url else {
            view?.hideLoading()
            return
        }
        
        interactor.fetchGameList(with: url, at: page)
    }
    
    private func handleEmptyGameStatus() {
        view?.hideLoading()
        view?.showResponseNilLabel()
        isFetchingAvailable = false
    }
    
    private func handleGameSection(with response: GameListDetailsResponse) {
        games.append(contentsOf: response.results)
        self.gameSection = GameSection(games: games, delegate: self)
        
        view?.reloadCollectionView()
        view?.hideLoading()
        isFetchingAvailable = true
    }
    
    private func handleNetworkErrorStatus(of error: String) {
        view?.hideLoading()
        view?.showResponseNilLabel(with: error)
        isFetchingAvailable = true
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
    }
    
    func viewWillAppear() {
        fetchGameList(at: currentPage)
    }
    
    func numberOfItemsInGameSection() -> Int {
        return games.count
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
        isFetchingAvailable = true
        fetchGameList(at: currentPage)
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
            currentPage += 1
            handleGameSection(with: response)
        case .failure(_):
            handleNetworkErrorStatus(of: "Network error")
        }
    }
}

//MARK: Pagination
extension HomeModulePresenter {
    func willDisplayItemAt(_ indexPath: IndexPath) {
        guard indexPath.item == games.count - 1 else { return }
        fetchGameList(at: currentPage)
    }
}
