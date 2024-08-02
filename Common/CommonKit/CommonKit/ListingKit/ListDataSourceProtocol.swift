//
//  ListDataSource.swift
//  Listing
//
//  Created by M.Yusuf on 11.01.2022.
//

import UIKit

protocol ListDataSourceProtocol: AnyObject {
    var scrollDelegate: UIScrollViewDelegate? { get set }
    var collectionDelegate: UICollectionViewDelegate? { get set }
    var paginationDelegate: ListPaginationDelegate? { get set }
    var sectionCount: Int { get }
    var visibleSections: [ListSection] { get }

    func prepare(for collectionView: UICollectionView)
    func append(newSections: [ListSection], animatingDifferences: Bool, completion: (() -> Void)?)
    func reload(newSections: [ListSection], completion: (() -> Void)?)
    func update(newSections: [ListSection], reloadVisibleViews: Bool, animatingDifferences: Bool, completion: (() -> Void)?)
    func insert(newSections: [ListSection], beforeSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)
    func insert(newSections: [ListSection], afterSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)
    func delete(sections: [ListSection], animatingDifferences: Bool, completion: (() -> Void)?)
    func move(section: ListSection, afterSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)
    func move(section: ListSection, beforeSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)
    
    func section(at index: Int) -> ListSection?
    func itemIdentifier(at indexPath: IndexPath) -> String?

    func didBecomeActive()
    func didBecomeDeactive()

    func compositionalSectionLayoutProvider(at index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
}
