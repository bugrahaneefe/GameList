//
//  WishlistModulePresenter.swift
//  WishlistModule
//
//  Created by Buğrahan Efe on 16.09.2024.
//

import CommonKit
import CommonViewsKit
import CoreUtils
import Foundation
import HomeHandlerKit
import UIKit

protocol WishlistModulePresenterInterface: PresenterInterface {
    func numberOfItemsInGameSection() -> Int
    func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell
    func didSelectGame(at indexPath: IndexPath)
    func pullToRefresh()
}

private enum Constant {
    enum Platform {
        static let allPlatformIndexes = "1,2,3,4,5,6,7,8,9,10,11,12,13,14"
    }
    
    enum GameCell {
        static let cellCornerRadius = 10.0
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

final class WishlistModulePresenter {
    private let defaults: DefaultsProtocol.Type
    private let interactor: WishlistInteractorInterface
    private let router: WishlistModuleRouterInterface
    private var view: WishlistViewInterface?
    private var games: [Game] = []
    
    init(interactor: WishlistInteractorInterface,
         router: WishlistModuleRouterInterface,
         view: WishlistViewInterface? = nil,
         defaults: DefaultsProtocol.Type = Defaults.self
    ) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.defaults = defaults
    }
    
    // MARK: Private Methods
    private func fetchGameList(
        at page: Int? = 1,
        contains name: String = "",
        with platforms: String = Constant.Platform.allPlatformIndexes) {
            view?.showLoading()
            
            let endpoint = HomeEndpointItem.gameListDetails(at: page, contains: name, with: platforms)
            
            guard let url = endpoint.url else {
                view?.hideLoading()
                return
            }
            
            interactor.fetchWishlist(with: url, at: page, contains: name, with: platforms)
        }
    
    private func handleEmptyGameStatus() {
        view?.reloadCollectionView()
        view?.hideLoading()
    }
    
    private func handleGameSection(with response: GameListDetailsResponse) {
        view?.hideResponseNilLabel()
//        games.append(contentsOf: response.results)
        view?.reloadCollectionView()
        view?.hideLoading()
    }
    
    private func handleNetworkErrorStatus(of error: String) {
        view?.hideLoading()
    }
}

//MARK: - WishlistModulePresenterInterface
extension WishlistModulePresenter: WishlistModulePresenterInterface {
    func numberOfItemsInGameSection() -> Int {
        print(games)
        return games.count
    }
    
    func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return UICollectionViewCell() }
        layout.sectionInset = UIEdgeInsets(
            top: Constant.CollectionView.topInset,
            left: Constant.CollectionView.leftInset,
            bottom: Constant.CollectionView.bottomInset,
            right: Constant.CollectionView.rightInset
        )
        layout.estimatedItemSize = .zero
        collectionView.backgroundColor = .black
        layout.itemSize = CGSize(
            width: Constant.CollectionView.logoCellWidth,
            height: Constant.CollectionView.logoCellHeight)
        let cell = collectionView.dequeueReusableCell(with: GameCell.self, for: indexPath)
        let presenter = GameCellPresenter(
            view: cell,
            argument: GameCellArgument(game: games[indexPath.row]))
        cell.layer.cornerRadius = Constant.GameCell.cellCornerRadius
        cell.presenter = presenter
        return cell
    }
    
    func didSelectGame(at indexPath: IndexPath) {
        router.navigateToGameDetail(with: games[indexPath.row])
    }
    
    func pullToRefresh() {
        fetchGameList()
    }
    
    func viewDidLoad() {
        view?.prepareUI()
        view?.prepareCollectionView()
    }
    
    func viewWillAppear() {
        fetchGameList()
    }
}

//MARK: - WishlistInteractorOutput
extension WishlistModulePresenter: WishlistInteractorOutput {
    func handleWishlistResult(_ result: GameListDetailsResult) {
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
