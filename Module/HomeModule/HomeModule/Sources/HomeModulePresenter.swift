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
//    todo
//    var appearanceType: AppereanceType { get }
    
    func numberOfItemsInGameSection() -> Int
    func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell
    func didSelectGame(at indexPath: IndexPath)
    func changeAppearanceTapped()
}

private enum Constant {
    enum GameListRequest {
        static let request = HomeModuleGameListRequest(
            count: 0,
            next: "",
            previous: "",
            results: [])
    }
}

enum AppereanceType {
    case logo, banner
}

final class HomeModulePresenter {
    private let interactor: HomeModuleInteractorInterface
    private let router: HomeModuleRouterInterface
    private var view: HomeViewInterface?
    private var gameSection: GameSection?
    
    private var appearanceType: AppereanceType = .logo
    
    init(interactor: HomeModuleInteractorInterface,
         router: HomeModuleRouterInterface,
         view: HomeViewInterface? = nil) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
    // MARK: Private Methods
    private func fetchGameList() {
        view?.showLoading()
        interactor.fetchGameList(request: Constant.GameListRequest.request)
    }
    
    private func handleEmptyGameStatus() {
        view?.hideLoading()
//        todo
    }
    
    private func handleGameSection(with games: [Game]) {
        self.gameSection = GameSection(games: games, delegate: self)
        view?.reloadCollectionView()
        view?.hideLoading()
    }
}

//MARK: - HomeModulePresenterInterface
extension HomeModulePresenter: HomeModulePresenterInterface {
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
        appearanceType = (appearanceType == .logo) ? .banner : .logo
        view?.reloadCollectionView()
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
        case .failure(let error):
            // todo: handle error
            print(error)
        }
    }
}
