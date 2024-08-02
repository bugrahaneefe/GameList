//
//  UICollectionView+Extension.swift
//  ListingKit
//
//  Created by Mustafa Yusuf on 29.06.2022.
//

import UIKit

extension UICollectionView {
    func scrollingDirection(isOrthogonal: Bool) -> UICollectionView.ScrollDirection {
        var scrollDirection: UICollectionView.ScrollDirection = .vertical

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            scrollDirection = layout.scrollDirection
        }

        if let layout = collectionViewLayout as? UICollectionViewCompositionalLayout {
            let layoutScrollDirection = layout.configuration.scrollDirection
            switch (layoutScrollDirection, isOrthogonal) {
            case (.vertical, true): scrollDirection = .horizontal
            case (.horizontal, true): scrollDirection = .vertical
            default: scrollDirection = layoutScrollDirection
            }
        }

        return scrollDirection
    }
}
