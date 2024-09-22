//
//  Collection+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 22.09.2024.
//

import UIKit

public extension UITableViewCell {
    class func getNib(for bundle: Bundle?) -> UINib {
        return UINib(nibName: className, bundle: bundle)
    }

    class var identifier: String {
        return className
    }
}

public extension UICollectionReusableView {
    class func getNib(for bundle: Bundle) -> UINib {
        return UINib(nibName: className, bundle: bundle)
    }

    class var identifier: String {
        return className
    }
}

public extension UICollectionView {
    func indexPathIsValid(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfItems(inSection: indexPath.section)
    }

    func register(cellType: UICollectionViewCell.Type, bundle: Bundle) {
        register(cellType.getNib(for: bundle), forCellWithReuseIdentifier: cellType.identifier)
    }

    func register(cellType: UICollectionViewCell.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }

    func register(cellTypes: [UICollectionViewCell.Type], bundle: Bundle) {
        cellTypes.forEach({ register(cellType: $0, bundle: bundle) })
    }

    func register(reusableViewType: UICollectionReusableView.Type, ofKind kind: String = UICollectionView.elementKindSectionHeader, bundle: Bundle) {
        register(reusableViewType.getNib(for: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: reusableViewType.identifier)
    }

    func register(reusableViewTypes: [UICollectionReusableView.Type], ofKind kind: String = UICollectionView.elementKindSectionHeader, bundle: Bundle) {
        reusableViewTypes.forEach({ register(reusableViewType: $0, ofKind: kind, bundle: bundle) })
    }

    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T else {
            fatalError()
        }

        return cell
    }

    func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath, ofKind kind: String =  UICollectionView.elementKindSectionHeader) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.identifier, for: indexPath) as! T
    }
}
