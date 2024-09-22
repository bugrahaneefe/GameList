//
//  HomeModuleViewController.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import CommonKit
import CommonViewsKit
import UIKit
import SwiftUI

protocol HomeViewInterface: AlertPresentable {
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
        static let title = "Games"
        static let titleFont = 16.0
        static let AppearanceButtonSize = CGSize(width: 24, height: 24)
    }
    enum SearchBar {
        static let Placeholder = "Search"
        static let Font = UIFont.systemFont(ofSize: 14.0)
    }
}

final class HomeModuleViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var responseNilLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private var platformSliderView: UIView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    private var loadingIndicator: UIActivityIndicatorView?
    private let refreshControl = UIRefreshControl()
    
    var presenter: HomeModulePresenterInterface!
    
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

        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.setTitleTextAttributes(attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(
                ofSize: Constant.NavigationBar.titleFont,
                weight: .semibold)
        ])
        
        let rightBarButtonItem = UIBarButtonItem(
            image: CommonViewsImages.bannerCellAppearanceButton.uiImage?.resizedImage(
                Size: Constant.NavigationBar.AppearanceButtonSize
            ),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonItemTapped)
        )
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.LoadingIndicatorColor.Tint
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }
    
    private func setupSearchBar() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.SearchBarColor.Background
        searchBar.tintColor = UIColor.SearchBarColor.Cursor
        searchBar.searchTextField.backgroundColor = UIColor.SearchBarColor.TextfieldBackground
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: Constant.SearchBar.Placeholder,
            attributes: [
                .font: Constant.SearchBar.Font,
                .foregroundColor: UIColor.SearchBarColor.Text])
        searchBar.searchTextField.leftView?.tintColor = UIColor.SearchBarColor.Text
        searchBar.searchTextField.textColor = UIColor.SearchBarColor.Text
    }
    
    private func setupPlatformSliderView() {
        platformSliderView.setupWithSwiftUIView(
            with: PlatformButtonView(buttonAction: { [weak self] selectedPlatform in
                self?.presenter.fetchPlatforms(of: selectedPlatform)
            }),
            parentViewController: self)
    }
    
    @objc
    private func rightBarButtonItemTapped() {
        if presenter.appearanceType == .logo {
            navigationItem.rightBarButtonItem?.image = CommonViewsImages.logoCellAppearanceButton.uiImage?.resizedImage(
                Size: Constant.NavigationBar.AppearanceButtonSize
            )
        } else if presenter.appearanceType == .banner {
            navigationItem.rightBarButtonItem?.image = CommonViewsImages.bannerCellAppearanceButton.uiImage?.resizedImage(
                Size: Constant.NavigationBar.AppearanceButtonSize
            )
        }
        presenter.changeAppearanceTapped()
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        presenter.pullToRefresh()
        refreshControl.endRefreshing()
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - HomeViewInterface
extension HomeModuleViewController: HomeViewInterface {
    func prepareUI() {
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
        setupPlatformSliderView()
    }
    
    func prepareCollectionView() {
        collectionView.register(cellType: GameCell.self, bundle: CommonViewsKitResources.bundle)
        collectionView.register(cellType: GameCellBanner.self, bundle: CommonViewsKitResources.bundle)
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
extension HomeModuleViewController: UICollectionViewDataSource {
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
extension HomeModuleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectGame(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.willDisplayItemAt(indexPath)
    }
}

// MARK: - UISearchBarDelegate
extension HomeModuleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter.filterWith(searchBar)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        presenter.filterWith(searchBar)
    }
}

// MARK: - UIScrollViewDelegate
extension HomeModuleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.platformSliderView.alpha = 0.0
                self?.collectionViewTopConstraint.constant = 0
                self?.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.platformSliderView.alpha = 1.0
                self?.collectionViewTopConstraint.constant = 60.0
                self?.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - AlertPresentable
extension HomeModuleViewController {
    var navController: UIViewController? {
        self
    }
}
