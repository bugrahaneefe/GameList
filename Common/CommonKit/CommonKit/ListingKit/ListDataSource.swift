//
//  File.swift
//  
//
//  Created by Mustafa Yusuf on 9.01.2023.
//

import UIKit

/// Represents the data source in ListingKit
///
/// Data source is the core part of the ListingKit. It manages collection view and sections. There is two implementation for `ListDataSource` in ListingKit.
/// One is reloading data source which reloads collection view in every change. The other one uses diffable data source under the hood to animate changes in collection view
///
/// To create data source you use ``ListDataSource/init(collectImpression:alwaysUseReloadDataSource:prefetchingEnabled:useNewDiffableDataSource:viewController:)`` class.
/// ```swift
/// let dataSource = ListDataSource()
/// ```
///
/// After you create data source you need to call the ``ListDataSource/prepare(for:)`` method to prepare collection view for data source.
public class ListDataSource {
    var _dataSource: ListDataSourceProtocol
    
    init(_dataSource: ListDataSourceProtocol) {
        self._dataSource = _dataSource
    }
    
    /// Set this property to get scrolling events from collection view. Do not set UICollectionView.delegate property.
    public var scrollDelegate: UIScrollViewDelegate? {
        get {
            _dataSource.scrollDelegate
        }
        set {
            _dataSource.scrollDelegate = newValue
        }
    }
    
    /// Set this property to get some of the UICollectionViewDelegate callback. Do not set UICollectionView.delegate property.
    public var collectionDelegate: UICollectionViewDelegate? {
        get {
            _dataSource.collectionDelegate
        }
        set {
            _dataSource.collectionDelegate = newValue
        }
    }
    
    /// Set this property to get pagination events
    public var paginationDelegate: ListPaginationDelegate? {
        get {
            _dataSource.paginationDelegate
        }
        set {
            _dataSource.paginationDelegate = newValue
        }
    }
    
    /// Represents current count of the sections in data source
    public var sectionCount: Int {
        _dataSource.sectionCount
    }
    
    /// Returns currently visible sections in collection view
    public var visibleSections: [ListSection] {
        _dataSource.visibleSections
    }
    
    /// Prepares collection view for the data source.
    /// - Parameter collectionView: The collection view that is going to used for data source
    public func prepare(for collectionView: UICollectionView) {
        _dataSource.prepare(for: collectionView)
    }
    
    /// Appends new sections to data source
    /// - Parameters:
    ///   - newSections: The new sections that is going to be added to collection view
    ///   - animatingDifferences: Provide `true` for animating append when data source is diffable data source.
    ///   - completion: Completion block that will be called after appending sections.
    public func append(
        newSections: [ListSection],
        animatingDifferences: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        _dataSource.append(newSections: newSections, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    /// Reloads the collection view with new sections.
    /// - Parameters:
    ///   - newSections: The new sections that will replace existing sections in collection view
    ///   - completion: Completion block that will be called after reloading sections.
    public func reload(newSections: [ListSection], completion: (() -> Void)? = nil) {
        _dataSource.reload(newSections: newSections, completion: completion)
    }
    
    /// Updates the collection view with new sections. When data source is diffable data source this will animate changes
    /// - Parameters:
    ///   - newSections: The new sections that will replace existing sections in collection view
    ///   - reloadVisibleViews: Provide true for reloding already visible cells and headers and footers.
    ///   - animatingDifferences: Provide `true` for animating append when data source is diffable data source.
    ///   - completion: Completion block that will be called after reloading sections.
    public func update(
        newSections: [ListSection],
        reloadVisibleViews: Bool = false,
        animatingDifferences: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        _dataSource.update(
            newSections: newSections,
            reloadVisibleViews: reloadVisibleViews,
            animatingDifferences: animatingDifferences,
            completion: completion
        )
    }
    
    /// Inserts new sections to collection view
    /// - Parameters:
    ///   - newSections: The new sections that will be inserted into collection view
    ///   - beforeSection: The section which before the sections inserted.
    ///   - animatingDifferences: Provide `true` for animating insertion when data source is diffable data source.
    ///   - completion: Completion block that will be called after inserting sections.
    public func insert(
        newSections: [ListSection],
        beforeSection: ListSection,
        animatingDifferences: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        _dataSource.insert(
            newSections: newSections,
            beforeSection: beforeSection,
            animatingDifferences: animatingDifferences,
            completion: completion
        )
    }
    
    /// Inserts new sections to collection view
    /// - Parameters:
    ///   - newSections: The new sections that will be inserted into collection view
    ///   - afterSection: The section which after the sections inserted.
    ///   - animatingDifferences: Provide `true` for animating insertion when data source is diffable data source.
    ///   - completion: Completion block that will be called after inserting sections.
    public func insert(
        newSections: [ListSection],
        afterSection: ListSection,
        animatingDifferences: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        _dataSource.insert(
            newSections: newSections,
            afterSection: afterSection,
            animatingDifferences: animatingDifferences,
            completion: completion
        )
    }
    
    /// Deletes sections from collection view
    /// - Parameters:
    ///   - sections: he new sections that will be deleted from collection view
    ///   - animatingDifferences: Provide `true` for animating deletion when data source is diffable data source.
    ///   - completion: Completion block that will be called after deleting sections.
    public func delete(
        sections: [ListSection],
        animatingDifferences: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        _dataSource.delete(
            sections: sections,
            animatingDifferences: animatingDifferences,
            completion: completion
        )
    }
    
    /// Moves the section after another section in collection view
    /// - Parameters:
    ///   - section: The section that will be moved
    ///   - afterSection: The section which after the section moved
    ///   - animatingDifferences: Provide `true` for animate moving when data source is diffable data source.
    ///   - completion: Completion block that will be called after moving sections.
    public func move(
        section: ListSection,
        afterSection: ListSection,
        animatingDifferences: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        _dataSource.move(
            section: section,
            afterSection: afterSection,
            animatingDifferences: animatingDifferences,
            completion: completion
        )
    }
    
    /// Moves the section after another section in collection view
    /// - Parameters:
    ///   - section: The section that will be moved
    ///   - beforeSection: The section which before the section moved
    ///   - animatingDifferences: Provide `true` for animate moving when data source is diffable data source.
    ///   - completion: Completion block that will be called after moving sections.
    public func move(
        section: ListSection,
        beforeSection: ListSection,
        animatingDifferences: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        _dataSource.move(
            section: section,
            beforeSection: beforeSection,
            animatingDifferences: animatingDifferences,
            completion: completion
        )
    }
    
    /// Returns the section at the given index
    /// - Parameter index: Index of the section
    /// - Returns: The section at the index
    public func section(at index: Int) -> ListSection? {
        _dataSource.section(at: index)
    }
    
    /// Returns item identifer at the given index path
    /// - Parameter indexPath: The index path of the item
    /// - Returns: Item identifier
    public func itemIdentifier(at indexPath: IndexPath) -> String? {
        _dataSource.itemIdentifier(at: indexPath)
    }
    
    /// Calls the all visible ``ListSection/didBecomeActive()-33wan`` methods.
    ///
    /// You can call this method in `UIViewController.viewDidAppear` method to start repeating tasks in visible sections like timers.
    public func didBecomeActive() {
        _dataSource.didBecomeActive()
    }
    
    /// Calls the all visible ``ListSection/didBecomeDeactive()-5ucxe`` methods
    ///
    /// You can call this method in `UIViewController.viewWillDisappear` method to stop repeating tasks in visible sections like timers.
    public func didBecomeDeactive() {
        _dataSource.didBecomeDeactive()
    }
    
    /// This method is used for creating compositional layout for collection view.
    ///
    ///  Here is how to create compositional layout with `ListDataSource`:
    /// - Parameters:
    ///   - index: The index of section
    ///   - environment: The environment object for compositional layout.
    /// - Returns: Sections compositional layout object
    ///
    /// ```swift
    ///  let dataSource = ListDataSource()
    ///  let configuration = UICollectionViewCompositionalLayoutConfiguration()
    ///  configuration.scrollDirection = .horizontal
    ///
    ///  let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, environment in
    ///     dataSource.compositionalSectionLayoutProvider(at: sectionIndex, environment: environment)
    ///  }, configuration: configuration)
    ///
    ///  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    ///  dataSource.prepare(for: collectionView)
    ///  ```
    public func compositionalSectionLayoutProvider(
        at index: Int,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? {
        _dataSource.compositionalSectionLayoutProvider(
            at: index,
            environment: environment
        )
    }
}

extension ListDataSource {
    /// Creates ListDataSource with configurations
    /// - Parameters:
    ///   - collectImpression: When provided `true` ListDataSource will collect impression data
    ///   - alwaysUseReloadDataSource: When provided `true` reloading data source will be used under the hood
    ///   - prefetchingEnabled: This will enable collectionview prefetching
    ///   - useNewDiffableDataSource: When provided `true` new experimental diffable data source will be used
    ///   - viewController: The view controller that hosts the collectionview. Sections can access view controller if it is provided.
    public convenience init(
        collectImpression: Bool = false,
        alwaysUseReloadDataSource: Bool = false,
        prefetchingEnabled: Bool = false,
        useNewDiffableDataSource: Bool = false,
        viewController: UIViewController? = nil
    ) {
        let config = ListConfig(
            collectImpression: collectImpression,
            alwaysUseReloadDataSource: alwaysUseReloadDataSource,
            prefetchingEnabled: prefetchingEnabled,
            useNewDiffableDataSource: useNewDiffableDataSource
        )
        
        func makeDataSource() -> ListDataSourceProtocol {
            if #available(iOS 13.0, *), !config.alwaysUseReloadDataSource {
                if config.useNewDiffableDataSource {
                    return NewDiffableDataSource(config: config, viewController: viewController)
                } else {
                    return DiffableDataSource(config: config, viewController: viewController)
                }
            } else {
                return ReloadDataSource(config: config, viewController: viewController)
            }
        }
        
        self.init(_dataSource: makeDataSource())
    }
}
