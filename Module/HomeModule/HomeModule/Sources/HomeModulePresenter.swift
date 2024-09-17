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

protocol HomeModulePresenterInterface: PresenterInterface, HomeModuleSectionDelegate {
    var appearanceType: AppereanceType { get }
    
    func numberOfItemsInGameSection() -> Int
    func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell
    func didSelectGame(at indexPath: IndexPath)
    func changeAppearanceTapped()
    func pullToRefresh()
    func willDisplayItemAt(_ indexPath: IndexPath)
    func filterWith(_ searchBar: UISearchBar)
    func fetchPlatforms(of selectedPlatform: Int?)
}

private enum Constant {
    enum Defaults {
        static let isBannerStateActive = "isBannerStateActive"
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
    private var argument: GameListArgument
    private var gameSection: GameSection?
    private var currentPage = 1
    private var currentName = ""
    private var isFetchingAvailable = true
    private let throttler: CommonKit.ThrottlerInterface
    
    init(interactor: HomeModuleInteractorInterface,
         router: HomeModuleRouterInterface,
         view: HomeViewInterface? = nil,
         defaults: DefaultsProtocol.Type = Defaults.self,
         throttler: CommonKit.ThrottlerInterface = Throttler(minimumDelay: Constant.throttleInterval),
         argument: GameListArgument) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.defaults = defaults
        self.throttler = throttler
        self.argument = argument
    }
    
    // MARK: Private Methods
    private func fetchGameList(
        at page: Int = 1,
        contains name: String = "",
        with platform: String? = nil) {
        guard isFetchingAvailable else { return }
        isFetchingAvailable = false
        
        view?.showLoading()
        let endpoint = HomeEndpointItem.gameListDetails(at: page, contains: name, with: platform)
        guard let url = endpoint.url else {
            view?.hideLoading()
            return
        }
        interactor.fetchGameList(with: url, at: page, contains: name, with: platform)
    }
    
    private func handleEmptyGameStatus() {
        argument.games.removeAll()
        view?.reloadCollectionView()
        view?.hideLoading()
        view?.showResponseNilLabel()
        isFetchingAvailable = false
    }
    
    private func handleGameSection(with response: GameListDetailsResponse) {
        view?.hideResponseNilLabel()
        argument.games.append(contentsOf: response.results)
        self.gameSection = GameSection(games: argument.games, delegate: self)
        
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
        return argument.games.count
    }
    
    func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        return gameSection?.configureCell(for: collectionView, at: indexPath, with: appearanceType) ?? UICollectionViewCell()
    }
    
    func didSelectGame(at indexPath: IndexPath) {
        guard let gameName = argument.games[indexPath.row].name else { return }
        defaults.save(data: true, key: gameName)
        router.navigateToGameDetail(with: argument.games[indexPath.row])
    }
    
    func changeAppearanceTapped() {
        defaults.save(data: !defaults.bool(key: Constant.Defaults.isBannerStateActive), key: Constant.Defaults.isBannerStateActive)
        view?.reloadCollectionView()
    }
    
    func pullToRefresh() {
        isFetchingAvailable = true
        fetchGameList(at: currentPage)
    }
    
    func filterWith(_ searchBar: UISearchBar) {
        guard let name = searchBar.text else { return }
        throttler.throttle { [weak self] in
            self?.argument.games.removeAll()
            self?.isFetchingAvailable = true
            self?.fetchGameList(contains: name)
        }
        currentName = name
    }
    
    func fetchPlatforms(of selectedPlatform: Int?) {
        argument.games.removeAll()
        isFetchingAvailable = true
        if selectedPlatform != nil {
            guard let selectedPlatform = selectedPlatform else { return }
            fetchGameList(contains: currentName, with: "\(selectedPlatform)")
        } else {
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
        guard indexPath.item == argument.games.count - 1 else { return }
        fetchGameList(at: currentPage)
    }
}
