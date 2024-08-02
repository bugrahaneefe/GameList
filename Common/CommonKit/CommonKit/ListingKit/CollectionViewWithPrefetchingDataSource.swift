//
//  CollectionViewWithPrefetchingDataSource.swift
//  ListingKit
//
//  Created by Omer Ulusal on 26.08.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

final class CollectionViewWithPrefetchingDataSource: NSObject {
    weak var dataSource: ListDataSourceProtocol?

    func prepare(for collectionView: UICollectionView, dataSource: ListDataSourceProtocol) {
        self.dataSource = dataSource
        collectionView.prefetchDataSource = self
    }
}

extension CollectionViewWithPrefetchingDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var dict: [Int: [IndexPath]] = [:]
        for indexPath in indexPaths {
            dict[indexPath.section, default: []].append(indexPath)
        }

        for (section, indexPaths) in dict {
            guard let section = dataSource?.section(at: section) as? ListSectionPrefetchingDataSource else { continue }
            section.prefetchItemsAt(indexPaths)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        var dict: [Int: [IndexPath]] = [:]
        for indexPath in indexPaths {
            dict[indexPath.section, default: []].append(indexPath)
        }

        for (section, indexPaths) in dict {
            guard let section = dataSource?.section(at: section) as? ListSectionPrefetchingDataSource else { continue }
            section.cancelPrefetchingForItemsAt(indexPaths)
        }
    }
}


