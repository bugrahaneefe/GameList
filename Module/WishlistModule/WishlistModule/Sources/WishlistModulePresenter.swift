//
//  WishlistModulePresenter.swift
//  WishlistModule
//
//  Created by Buğrahan Efe on 16.09.2024.
//

import CommonKit
import CommonViewsKit
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
    enum GameCell {
        static let cellCornerRadius = 10.0
    }
    enum CollectionView {
        static let leftInset = 15.0
        static let rightInset = 15.0
        static let bottomInset = 15.0
        static let topInset = 0.0
        static let logoCellWidth = 165.0
        static let logoCellHeight = 184.0
        static let bannerCellWidth = 345.0
        static let bannerCellHeight = 257.0
    }
    enum Alerts {
        static let NetworkError = "Network error"
    }
}

final class WishlistModulePresenter {
    private let defaults: DefaultsProtocol.Type
    private let interactor: WishlistInteractorInterface
    private let router: WishlistModuleRouterInterface
    private var view: WishlistViewInterface?
    private var argument: GameListArgument
    
    init(interactor: WishlistInteractorInterface,
         router: WishlistModuleRouterInterface,
         view: WishlistViewInterface? = nil,
         defaults: DefaultsProtocol.Type = Defaults.self,
         argument: GameListArgument
    ) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.defaults = defaults
        self.argument = argument
    }
    
    // MARK: Private Methods
    private func fetchGameList(
        at page: Int? = nil,
        contains name: String = "",
        with platforms: String? = nil) {
            view?.showLoading()
            
            let endpoint = HomeEndpointItem.gameListDetails(at: page, contains: name, with: platforms)
            
            guard let url = endpoint.url else {
                view?.hideLoading()
                return
            }
            
            interactor.fetchWishlist(with: url, at: page, contains: name, with: platforms)
        }
    
    private func handleEmptyGameStatus() {
        view?.hideResponseNilLabel()
        argument.games.removeAll()
        view?.reloadCollectionView()
        view?.showResponseNilLabel()
        view?.hideLoading()
    }
    
    private func handleGameSection(with response: GameListDetailsResponse) {
        if argument.games.isEmpty {
            view?.showResponseNilLabel()
        } else {
            view?.hideResponseNilLabel()
        }
//        argument.games.append(contentsOf: response.results)
        view?.reloadCollectionView()
        view?.hideLoading()
    }
    
    private func handleNetworkErrorStatus(of error: String) {
        view?.hideResponseNilLabel()
        view?.hideLoading()
        view?.showAlert(title: error, message: "")
        view?.showResponseNilLabel()
    }
}

//MARK: - WishlistModulePresenterInterface
extension WishlistModulePresenter: WishlistModulePresenterInterface {
    func numberOfItemsInGameSection() -> Int {
        return argument.games.count
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
            argument: GameCellArgument(game: argument.games[indexPath.row]))
        cell.layer.cornerRadius = Constant.GameCell.cellCornerRadius
        cell.presenter = presenter
        return cell
    }
    
    func didSelectGame(at indexPath: IndexPath) {
        router.navigateToGameDetail(with: argument.games[indexPath.row])
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
            handleNetworkErrorStatus(of: Constant.Alerts.NetworkError)
        }
    }
    
}
