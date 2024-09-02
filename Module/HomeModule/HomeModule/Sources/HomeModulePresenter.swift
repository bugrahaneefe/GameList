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
}

private enum Constant {
    enum GameListRequest {
        static let request = HomeModuleGameListRequest(
            count: 0,
            next: "",
            previous: "",
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
    private var gameSection: GameSection?
    
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
    private func fetchGameList() {
        view?.showLoading()
        interactor.fetchGameList(request: Constant.GameListRequest.request)
    }
    
    private func handleEmptyGameStatus() {
        view?.hideLoading()
        view?.showResponseNilLabel()
    }
    
    private func handleGameSection(with games: [Game]) {
        view?.hideResponseNilLabel()
        self.gameSection = GameSection(games: games, delegate: self)
        view?.reloadCollectionView()
        view?.hideLoading()
    }
    
    private func handleNetworkErrorStatus(of error: String) {
        view?.hideLoading()
        view?.showResponseNilLabel(with: error)
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
        fetchGameList()
    }
    
    func numberOfItemsInGameSection() -> Int {
        return gameSection?.numberOfItems() ?? 0
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
            handleGameSection(with: response.results)
        case .failure(_):
            handleNetworkErrorStatus(of: "Network error")
        }
    }
}
