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
    func filterWith(_ searchBar: UISearchBar)
    func fetchPlatforms(of selectedPlatforms: [Int])
}

private enum Constant {
    enum Defaults {
        static let isBannerStateActive = "isBannerStateActive"
    }
    
    enum Platform {
        static let allPlatformIndexes = "1,2,3,4,5,6,7,8,9,10,11,12,13,14"
    }
    
    static let throttleInterval = 0.7
}

enum AppereanceType {
    case logo, banner
}

final class HomeModulePresenter {
    private let defaults: DefaultsProtocol.Type
    private let interactor: HomeModuleInteractorInterface
    private let router: HomeModuleRouterInterface
    private var view: HomeViewInterface?
    private var games: [Game] = []
    private var gameSection: GameSection?
    private var currentPage = 1
    private var currentName = ""
    private var currentPlatforms = Constant.Platform.allPlatformIndexes
    private var isFetchingAvailable = true
    private let throttler: CommonKit.ThrottlerInterface
    
    init(interactor: HomeModuleInteractorInterface,
         router: HomeModuleRouterInterface,
         view: HomeViewInterface? = nil,
         defaults: DefaultsProtocol.Type = Defaults.self,
         throttler: CommonKit.ThrottlerInterface = Throttler(minimumDelay: Constant.throttleInterval)) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.defaults = defaults
        self.throttler = throttler
    }
    
    // MARK: Private Methods
    private func fetchGameList(
        at page: Int = 1,
        contains name: String = "",
        with platforms: String = Constant.Platform.allPlatformIndexes) {
        guard isFetchingAvailable else { return }
        isFetchingAvailable = false
        
        view?.showLoading()
        
        let endpoint = HomeEndpointItem.gameListDetails(at: page, contains: name, with: platforms)
        
        guard let url = endpoint.url else {
            view?.hideLoading()
            return
        }
        
        interactor.fetchGameList(with: url, at: page, contains: name, with: platforms)
    }
    
    private func handleEmptyGameStatus() {
        games.removeAll()
        view?.reloadCollectionView()
        view?.hideLoading()
        view?.showResponseNilLabel()
        isFetchingAvailable = false
    }
    
    private func handleGameSection(with response: GameListDetailsResponse) {
        view?.hideResponseNilLabel()
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
        router.navigateToGameDetail(with: games[indexPath.row])
    }
    
    func changeAppearanceTapped() {
        defaults.save(data: !defaults.bool(key: Constant.Defaults.isBannerStateActive), key: Constant.Defaults.isBannerStateActive)
        view?.reloadCollectionView()
    }
    
    func pullToRefresh() {
        isFetchingAvailable = true
        fetchGameList(at: currentPage, with: currentPlatforms)
    }
    
    func filterWith(_ searchBar: UISearchBar) {
        let platforms = currentPlatforms
        guard let name = searchBar.text else { return }
        throttler.throttle { [weak self] in
            self?.games.removeAll()
            self?.isFetchingAvailable = true
            self?.fetchGameList(contains: name, with: platforms)
        }
        currentName = name
    }
    
    func fetchPlatforms(of selectedPlatforms: [Int]) {
        games.removeAll()
        isFetchingAvailable = true
        if !selectedPlatforms.isEmpty {
            let platformsQuery = selectedPlatforms.map { String($0) }.joined(separator: ",")
            currentPlatforms = platformsQuery
            fetchGameList(contains: currentName, with: platformsQuery)
        } else {
            currentPlatforms = Constant.Platform.allPlatformIndexes
            fetchGameList(at: 1, contains: currentName)
        }
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
