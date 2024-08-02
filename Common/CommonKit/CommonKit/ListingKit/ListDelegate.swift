//
//  ListDelegate.swift
//  Listing
//
//  Created by Ersen Tekin on 17.01.2022.
//

import UIKit

protocol ListDelegate {
    var impressionHandler: ImpressionHandlerInterface? { get set }
    func prepare(for collectionView: UICollectionView, dataSource: ListDataSourceProtocol)
}

final class ListDelegateFactory {
    static func createDelegate() -> ListDelegate {
        CollectionDelegateWithFlowLayout()
    }
}
