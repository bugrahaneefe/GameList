//
//  WishlistModuleViewController.swift
//  WishlistModule
//
//  Created by Buğrahan Efe on 16.09.2024.
//

import CommonKit
import CommonViewsKit
import UIKit
import SwiftUI

protocol WishlistViewInterface: AlertPresentable {
    func prepareUI()
    func prepareCollectionView()
    func reloadCollectionView()
    func showLoading()
    func hideLoading()
    func showResponseNilLabel()
    func hideResponseNilLabel()
}

private enum Constant {
    enum NavigationBar {
        static let title: String = "Wishlist"
        static let titleFont: CGFloat = 16.0
    }
}

final class WishlistModuleViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var responseNilLabel: UILabel!

    var presenter: WishlistModulePresenterInterface!
    private var loadingIndicator: UIActivityIndicatorView?
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    // MARK: Private Methods
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = view.center
        loadingIndicator?.hidesWhenStopped = true
        loadingIndicator?.color = UIColor.LoadingIndicatorColor.Tint
        if let loadingIndicator = loadingIndicator {
            view.addSubview(loadingIndicator)
        }
    }
    
    private func setupNavigationBar() {
        self.title = Constant.NavigationBar.title
        self.navigationController?.navigationBar.tintColor = .white

        navigationController?.navigationBar.setTitleTextAttributes(attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(
                ofSize: Constant.NavigationBar.titleFont,
                weight: .semibold)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        presenter.pullToRefresh()
        refreshControl.endRefreshing()
    }
}

extension WishlistModuleViewController: WishlistViewInterface {
    func prepareUI() {
        setupCollectionView()
        setupNavigationBar()
    }
    
    func prepareCollectionView() {
        collectionView.register(cellType: GameCell.self, bundle: CommonViewsKitResources.bundle)
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func showLoading() {
        if loadingIndicator == nil {
            setupLoadingIndicator()
        }
        loadingIndicator?.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator?.stopAnimating()
    }
    
    func showResponseNilLabel() {
        responseNilLabel.isHidden = false
    }
    
    func hideResponseNilLabel() {
        responseNilLabel.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource
extension WishlistModuleViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItemsInGameSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return presenter.cellForGame(at: indexPath, in: collectionView)
    }
}

// MARK: - UICollectionViewDelegate
extension WishlistModuleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectGame(at: indexPath)
    }
}

// MARK: - AlertPresentable
extension WishlistModuleViewController {
    var navController: UIViewController? {
        self
    }
}
