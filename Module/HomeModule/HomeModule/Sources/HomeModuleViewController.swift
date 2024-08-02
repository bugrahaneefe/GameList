//
//  HomeModuleViewController.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import UIKit
import CommonKit

protocol HomeViewInterface {
    func prepareUI()
}

private enum Constant {
    enum CollectionView {
        static let minimumInteritemSpacing: CGFloat = 10
        static let bottomInset: CGFloat = 10
        static let topInset: CGFloat = -15
    }
}

final class HomeModuleViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
//    @IBOutlet private weak var emptyShowableView: UIView!
    
    var presenter: HomeModulePresenterInterface!
    private lazy var listDataSource = ListDataSource(alwaysUseReloadDataSource: true, viewController: self)
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
        print("listDataSource.prepare(for: collectionView)")
    }
}
