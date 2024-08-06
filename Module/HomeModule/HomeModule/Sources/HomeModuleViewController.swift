//
//  HomeModuleViewController.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import UIKit
import CommonKit
import ListingKit
import CoreUtils

protocol HomeViewInterface: ViewInterface {
    func prepareUI()
    func reloadCollectionView(listSections: [ListSection])
}

private enum Constant {
    enum CollectionView {
        static let minimumInteritemSpacing: CGFloat = 10
        static let bottomInset: CGFloat = 10
        static let topInset: CGFloat = -15
    }
}

final class HomeModuleViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var presenter: HomeModulePresenterInterface!
    private lazy var listDataSource = ListDataSource(alwaysUseReloadDataSource: true, viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

extension HomeModuleViewController: HomeViewInterface {
    
    func prepareUI() {
        collectionView.contentInset = .init(top: Constant.CollectionView.topInset,
                                            left: .zero,
                                            bottom: Constant.CollectionView.bottomInset,
                                            right: .zero)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
        collectionView.backgroundColor = .clear
        listDataSource.prepare(for: collectionView)
    }
    
    func reloadCollectionView(listSections: [ListSection]) {
        listDataSource.reload(newSections: listSections, completion: nil)
    }
    
    func prepareBackButton(tintColor: UIColor) {}
    
    func prepareBackButton(tintColor: UIColor, target: Any?, action: Selector?) {}
}
