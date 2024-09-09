//
//  PlatformSliderWidgetPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 9.09.2024.
//

import Foundation
import UIKit

public protocol PlatformSliderWidgetPresenterInterface {
    func load()
    func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell
    func didSelectGame(at indexPath: IndexPath)
}

public final class PlatformSliderWidgetPresenter {
    private var view: PlatformSliderWidgetInterface?
    
    public init(view: PlatformSliderWidgetInterface? = nil) {
        self.view = view
    }
    
    private func configureCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return UICollectionViewCell() }
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        layout.estimatedItemSize = .zero
        collectionView.backgroundColor = .green
        layout.itemSize = CGSize(
            width: 30,
            height: 30)
        
        let cell = collectionView.dequeueReusableCell(with: PlatformSliderWidgetCell.self, for: indexPath)
        let presenter = PlatformSliderWidgetCellPresenter(view: cell)
        cell.layer.cornerRadius = 15

        cell.presenter = presenter
        return cell
    }
}

extension PlatformSliderWidgetPresenter: PlatformSliderWidgetPresenterInterface {
    public func load() {
        view?.prepareUI()
        view?.prepareCollectionView()
    }
    
    public func cellForGame(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        return configureCell(for: collectionView, at: indexPath)
    }
    
    public func didSelectGame(at indexPath: IndexPath) {
        //        todo
    }
}
