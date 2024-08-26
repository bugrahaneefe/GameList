//
//  HomeModuleViewController.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import UIKit
import CommonKit
import CommonViewsKit
import CoreUtils

protocol HomeViewInterface {
    func showLoading()
    func hideLoading()
    func prepareUI()
    func reloadCollectionView()
}

private enum Constant {
    enum CollectionView {
        static let leftInset: CGFloat = 10
        static let rightInset: CGFloat = 10
        static let bottomInset: CGFloat = 10
        static let topInset: CGFloat = -15
    }
}

final class HomeModuleViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var presenter: HomeModulePresenterInterface!
    private var loadingIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        presenter.viewDidLoad()
        setupNavigationBar()
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
        self.title = "Games"
        self.navigationController?.navigationBar.tintColor = .white

        navigationController?.navigationBar.setTitleTextAttributes(attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        ])
        
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonItemTapped)
        )
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func rightBarButtonItemTapped() {
        print("Right bar button tapped")
    }
}

// MARK: - HomeViewInterface
extension HomeModuleViewController: HomeViewInterface {
    func showLoading() {
        if loadingIndicator == nil {
            setupLoadingIndicator()
        }
        loadingIndicator?.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator?.stopAnimating()
    }
    
    func prepareUI() {
        collectionView.register(cellType: GameCell.self, bundle: CommonViewsKitResources.bundle)
        collectionView.contentInset = .init(top: Constant.CollectionView.topInset,
                                            left: Constant.CollectionView.leftInset,
                                            bottom: Constant.CollectionView.bottomInset,
                                            right: Constant.CollectionView.rightInset)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
        collectionView.backgroundColor = .white
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
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
}
