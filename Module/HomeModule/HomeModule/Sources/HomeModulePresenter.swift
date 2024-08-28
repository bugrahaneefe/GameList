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
//    todo
//    var appearanceType: AppereanceType { get }
    
    func prepareUI(for collectionView: UICollectionView)
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
    
    enum CollectionView {
        static let leftInset: CGFloat = 15
        static let rightInset: CGFloat = 15
        static let bottomInset: CGFloat = 15
        static let topInset: CGFloat = 0
        static let logoCellWidth: CGFloat = 165
        static let logoCellHeight: CGFloat = 184
        static let bannerCellWidth: CGFloat = 345
        static let bannerCellHeight: CGFloat = 257
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
    func prepareUI(for collectionView: UICollectionView) {
        switch appearanceType {
        case .logo:
            collectionView.register(cellType: GameCell.self, bundle: CommonViewsKitResources.bundle)
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionInset = UIEdgeInsets(
                    top: Constant.CollectionView.topInset,
                    left: Constant.CollectionView.leftInset,
                    bottom: Constant.CollectionView.bottomInset,
                    right: Constant.CollectionView.rightInset
                )
                
                layout.itemSize = CGSize(
                    width: Constant.CollectionView.logoCellWidth,
                    height: Constant.CollectionView.logoCellHeight)
                
                layout.estimatedItemSize = .zero
            }
            collectionView.backgroundColor = .black
        case .banner:
            //            implement gamecellbanner
            collectionView.register(cellType: GameCell.self, bundle: CommonViewsKitResources.bundle)
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionInset = UIEdgeInsets(
                    top: Constant.CollectionView.topInset,
                    left: Constant.CollectionView.leftInset,
                    bottom: Constant.CollectionView.bottomInset,
                    right: Constant.CollectionView.rightInset
                )
                
                layout.itemSize = CGSize(
                    width: Constant.CollectionView.bannerCellWidth,
                    height: Constant.CollectionView.bannerCellHeight)
                
                layout.estimatedItemSize = .zero
            }
            collectionView.backgroundColor = .black
        }
    }
    
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
    
    func changeAppearanceTapped() {
        appearanceType = (appearanceType == .logo) ? .banner : .logo
        view?.prepareUI()
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
