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
import UIKit

protocol HomeModulePresenterInterface: PresenterInterface, HomeModuleHeaderCollectionReusablePresenterDelegate, HomeModuleGameDelegate, HomeModuleSectionDelegate {
    func numberOfItemsInGameSection() -> Int
    func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell
    func didSelectGame(at indexPath: IndexPath)
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

final class HomeModulePresenter {
    private let interactor: HomeModuleInteractorInterface
    private let router: HomeModuleRouterInterface
    private var view: HomeViewInterface?
    private var gameSection: GameSection?
    
    init(interactor: HomeModuleInteractorInterface,
         router: HomeModuleRouterInterface,
         view: HomeViewInterface? = nil) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
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
    func changeAppearanceTapped() {}
    
    func viewDidLoad() {
        view?.prepareUI()
    }
    
    func viewWillAppear() {
        fetchGameList()
    }
    
    func numberOfItemsInGameSection() -> Int {
        return gameSection?.numberOfItems() ?? 0
    }
    
    func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        return gameSection?.configureCell(collectionView, indexPath: indexPath) ?? UICollectionViewCell()
    }
    
    func didSelectGame(at indexPath: IndexPath) {
//        todo
//        router.navigateToGameDetails(game)
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
