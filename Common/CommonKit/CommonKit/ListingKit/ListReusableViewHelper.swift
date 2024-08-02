//
//  ReusableViewRegistering.swift
//  ListingKit
//
//  Created by Mustafa Yusuf on 1.06.2022.
//

import UIKit

public protocol ListReusableViewHelperProtocol {
    var supplementaryViewKinds: Set<String> { get }
    var boundarySupplementaryViewKinds: Set<String> { get }

    func dequeueCell<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell
    func dequeueCell<Cell: UICollectionViewCell>(withReuseIdentifier identifier: String, at indexPath: IndexPath) -> Cell
    func dequeueCell<Cell: UICollectionViewCell>(withNibName name: String, bundle: Bundle?, at indexPath: IndexPath) -> Cell
    func dequeueSupplementaryView<ReusableView: UICollectionReusableView>(ofKind kind: String, at indexPath: IndexPath) -> ReusableView
    func dequeueSupplementaryView<ReusableView: UICollectionReusableView>(ofKind kind: String, nibName: String, bundle: Bundle?, at indexPath: IndexPath) -> ReusableView
}

final class ListReusableViewHelper {
    weak var collectionView: UICollectionView!

    private var registeredCellIdentifiers: Set<String> = []
    private var registeredNibNames: Set<String> = []
    private var registeredSupplementaryViewIdentifiers: Set<String> = []
    private var registeredSupplementaryViewNibNames: Set<String> = []
    var supplementaryViewKinds: Set<String> = []
    var boundarySupplementaryViewKinds: Set<String> = []

    private func registerCellIfNeeded(_ cellClass: AnyClass, reuseIdentifier: String) {
        guard !registeredCellIdentifiers.contains(reuseIdentifier) else { return }
        registeredCellIdentifiers.insert(reuseIdentifier)

        collectionView?.register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
    }

    private func registerCellWithNibnameIfNeeded(nibName: String, bundle: Bundle?) {
        guard !registeredNibNames.contains(nibName) else { return }
        registeredNibNames.insert(nibName)
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: nibName)
    }

    private func registerSupplementaryViewIfNeeded(kind: String, resuableViewClass class: AnyClass, identifier: String) {
        guard !registeredSupplementaryViewIdentifiers.contains(identifier) else { return }
        registeredSupplementaryViewIdentifiers.insert(identifier)

        collectionView.register(`class`, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        saveSupplementaryViewKind(kind)
    }

    private func registerSupplementaryViewWithNibnameIfNeeded(kind: String, nibName: String, bundle: Bundle?) {
        guard !registeredSupplementaryViewNibNames.contains(nibName) else { return }
        registeredSupplementaryViewNibNames.insert(nibName)

        let nib = UINib(nibName: nibName, bundle: bundle)
        collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: nibName)
        saveSupplementaryViewKind(kind)
    }

    private func listReusableViewIdentifier(from viewClass: AnyClass, kind: String? = nil, reuseIdentifer: String? = nil) -> String {
        "\(kind ?? "")\(reuseIdentifer ?? String(describing: viewClass))"
    }

    private func saveSupplementaryViewKind(_ kind: String) {
        if kind == UICollectionView.elementKindSectionHeader || kind == UICollectionView.elementKindSectionFooter {
            boundarySupplementaryViewKinds.insert(kind)
        } else {
            supplementaryViewKinds.insert(kind)
        }
    }
}

extension ListReusableViewHelper: ListReusableViewHelperProtocol {
    func dequeueCell<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell {
        let identifier = listReusableViewIdentifier(from: Cell.self)
        registerCellIfNeeded(Cell.self, reuseIdentifier: identifier)
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Cell
    }

    func dequeueCell<Cell: UICollectionViewCell>(withReuseIdentifier identifier: String, at indexPath: IndexPath) -> Cell {
        let identifier = listReusableViewIdentifier(from: Cell.self, reuseIdentifer: identifier)
        registerCellIfNeeded(Cell.self, reuseIdentifier: identifier)
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Cell
    }

    func dequeueCell<Cell: UICollectionViewCell>(withNibName name: String, bundle: Bundle?, at indexPath: IndexPath) -> Cell {
        registerCellWithNibnameIfNeeded(nibName: name, bundle: bundle)
        return collectionView.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as! Cell
    }

    func dequeueSupplementaryView<ReusableView: UICollectionReusableView>(ofKind kind: String, at indexPath: IndexPath) -> ReusableView {
        let identifier = listReusableViewIdentifier(from: ReusableView.self, kind: kind)
        registerSupplementaryViewIfNeeded(kind: kind, resuableViewClass: ReusableView.self, identifier: identifier)

        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as! ReusableView
    }

    func dequeueSupplementaryView<ReusableView: UICollectionReusableView>(ofKind kind: String, nibName: String, bundle: Bundle?, at indexPath: IndexPath) -> ReusableView {
        registerSupplementaryViewWithNibnameIfNeeded(kind: kind, nibName: nibName, bundle: bundle)
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: nibName, for: indexPath) as! ReusableView
    }
}
