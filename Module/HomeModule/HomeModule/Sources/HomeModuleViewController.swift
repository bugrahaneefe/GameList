//
//  HomeModuleViewController.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import CommonKit
import CommonViewsKit
import CoreUtils
import UIKit

protocol HomeViewInterface {
    func prepareUI()
    func prepareCollectionView()
    func reloadCollectionView()
    func showLoading()
    func hideLoading()
    func showResponseNilLabel()
    func showResponseNilLabel(with: String)
    func hideResponseNilLabel()
}

private enum Constant {    
    enum NavigationBar {
        static let title: String = "Games"
        static let titleFont: CGFloat = 16.0
    }
}

final class HomeModuleViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var responseNilLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var presenter: HomeModulePresenterInterface!
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
        if let loadingIndicator = loadingIndicator {
            view.addSubview(loadingIndicator)
        }
    }
    
    private func setupNavigationBar() {
        self.title = Constant.NavigationBar.title
        self.navigationController?.navigationBar.tintColor = .white

        navigationController?.navigationBar.setTitleTextAttributes(attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: Constant.NavigationBar.titleFont, weight: .semibold)
        ])
        
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage.rightBarIcon,
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
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }
    
    private func setupSearchBar() {
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard)))
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.SearchBarColor.Background
        searchBar.tintColor = UIColor.SearchBarColor.Cursor
        searchBar.searchTextField.backgroundColor = UIColor.SearchBarColor.TextfieldBackground
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14.0),
                .foregroundColor: UIColor.SearchBarColor.Text])
        searchBar.searchTextField.leftView?.tintColor = UIColor.SearchBarColor.Text
        searchBar.searchTextField.textColor = UIColor.SearchBarColor.Text
    }
    
    @objc 
    private func rightBarButtonItemTapped() {
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
    
    func showResponseNilLabel(with text: String) {
        responseNilLabel.text = text
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
        presenter.filterWith(searchBar)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        presenter.filterWith(searchBar)
    }
}
