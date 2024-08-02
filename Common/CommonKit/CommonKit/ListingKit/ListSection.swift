//
//  Section.swift
//  Listing
//
//  Created by M.Yusuf on 7.01.2022.
//

import UIKit

/// Protocol that represents individual sections inside UICollectionView
///
/// In ListingKit ListSection is the building block of collectionview. Every type that conforms
/// ListSection protocol represents a section in UICollectionView.
///
/// For simple sections you can use ``GenericSection``. It provides easy creation for in place lists. If you
/// want to create sections that will be used across the application or has custom logic other than listing data you should consider creating custom implementation of
/// ``ListSection`` protocol.
public protocol ListSection: ListIdentifiable, AnyObject {
    /// Provides access to data source inside ``ListSection``.
    ///
    /// In your ``ListSection`` implementation just declare this property and do not set it. ListingKit will set it when section is added to data source
    var context: ListContext? { get set }

    /// Holds the section's header and footer view provider.
    ///
    /// When your ``ListSection`` type also conforms to ``ListSectionSupplementaryViewSource`` you don't need to declare this property. The default implementation will return same section as ``ListSectionSupplementaryViewSource``.
    var supplementaryViewSource: ListSectionSupplementaryViewSource? { get }

    /// Represents items inside section.
    ///
    /// You should override this property and return the data objects that will be displayed inside section.
    var items: [ListIdentifiable] { get }

    /// Represents inset that will be applyed to section when collectionview has flow layout.
    ///
    /// Default implementation returns `UIEdgeInsets.zero`
    var inset: UIEdgeInsets { get }

    /// Represents minimum line spacing between items when collectionview has flow layout.
    ///
    /// Default implementation returns 0
    var minimumLineSpacing: CGFloat { get }

    /// Represents spacing between two items at same line when collectionview has flow layout
    ///
    /// Default implementation returns 0
    var minimumInteritemSpacing: CGFloat { get }

    /// Asks your section to dequee and configure a new cell for the given item id at indexpath.
    ///
    /// Your implementation of this method is responsible for creating, configuring, and returning the appropriate cell for the given item identifier. You do this by calling the ``ListSection/dequeueCell(at:)`` method and passing the indexPath. Upon receiving the cell, you should set any properties that correspond to the data of the corresponding item, perform any additional needed configuration, and return the cell. If somehow you can't return a cell ListingKit will use placeholder cell.
    /// - Parameters:
    ///   - itemIdentifier: The item identifier for corresponding item. You can find the data that has this id and configure your cell.
    ///   - indexPath: The index path for the cell. You can use it to dequeue new cell.
    /// - Returns: A configured cell object.
    func cell(for itemIdentifier: String, at indexPath: IndexPath) -> UICollectionViewCell?
    
    /// Asks your section to configure given cell. You can use this method if you want to later reload cell. If cell is not needed to be reloaded later you can make configuration in ``ListSection/cell(for:at:)`` method.
    /// - Parameters:
    ///   - cell: The cell that will be configured
    ///   - itemIdentifier: The identifier of the item that will be used to configure the cell
    ///   - indexPath: index path of the cell
    func configure(cell: UICollectionViewCell, for itemIdentifier: String, at indexPath: IndexPath)

    /// Asks the section for the size of the specified item’s cell when collectionview has flow layout.
    ///
    /// Your implementation of this method can return a fixed set of sizes or dynamically adjust the sizes based on the cell’s content. Default implementation returns `CGSize.zero`
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the item.
    /// - Returns: The width and height of the specified item. Both values must be greater than 0.
    func size(at indexPath: IndexPath) -> CGSize

    /// Tells the section that the specified cell that is configured for the item is about to be displayed in the collection view.
    ///
    /// The collection view calls this method before adding a cell to its content. Use this method to detect cell additions, as opposed to monitoring the cell itself to see when it appears.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the data item that the cell represents.
    func willDisplay(at indexPath: IndexPath)

    /// Tells the section that the specified cell that is configured for the item was removed from the collection view.
    /// - Parameters:
    ///   - indexPath: The index path of the data item that the cell represents.
    func didEndDisplay(at indexPath: IndexPath)

    /// Tells the section that the item with the identifier at the specified index path was selected.
    ///
    /// The collection view calls this method when the user successfully selects an item in the collection view. It does not call this method when you programmatically set the selection.
    ///
    /// - Parameters:
    ///   - itemIdentifier: The identifier for the item that is selected.
    ///   - indexPath: The index path of the cell that was selected.
    func didSelectItem(for itemIdentifier: String, at indexPath: IndexPath)

    /// Tells the section that it is added to collectionview
    ///
    /// Implement this method to perform additional work for your section. For example you can initiate an api request for loading content that will be displayed in section.
    func didMoveToList()

    /// Tells the section it will be displayed on screen.
    ///
    /// This method can be called multiple times. To use this, call `ListDataSource.didBecomeActive` method inside `viewWillAppear` method of `UIViewController` that manages `UICollectionView`. When `ListDataSource.didBecomeActive` is called data source will calculate the sections that is visible on the screen and will call each sections `didBecomeActive` method.
    func didBecomeActive()

    /// Tells the section it will be no longer displayed on screen.
    ///
    /// This method can be called multiple times. To use this, call `ListDataSource.didBecomeDeactive` method inside `viewWillDisappear` method of `UIViewController` that manages `UICollectionView`. When `ListDataSource.didBecomeDeactive` is called data source will calculate the sections that is visible on the screen and will call each sections `didBecomeDeactive` method.
    func didBecomeDeactive()

    /// Asks the section if it has pagination in progress.
    ///
    /// If section has it's own pagination return `true`. This will prevent `ListDataSource` to call pagination delegate.
    ///
    /// - Parameter indexPath: The index path of the item is currently displayed.
    /// - Returns: Return value of whether section has pagination
    func hasPagination(for indexPath: IndexPath) -> Bool

    /// Called when collectionview has compositional layout. Implement this method and return the NSCollectionLayoutSection instance that represents sections layout.
    /// - Parameter environment: The object that holds information about current trait collection and container size.
    /// - Returns: NSCollectionLayoutSection object that represents sections layout for compositional layout
    func layout(in environment: NSCollectionLayoutEnvironment?) -> NSCollectionLayoutSection?
}

public extension ListSection {
    var inset: UIEdgeInsets { .zero }
    var minimumLineSpacing: CGFloat { 0 }
    var minimumInteritemSpacing: CGFloat { 0 }

    var supplementaryViewSource: ListSectionSupplementaryViewSource? { nil }
    
    func didMoveToList() { }
    func size(at indexPath: IndexPath) -> CGSize { .zero }
    func configure(cell: UICollectionViewCell, for itemIdentifier: String, at indexPath: IndexPath) { }
    func willDisplay(at indexPath: IndexPath) { }
    func didEndDisplay(at indexPath: IndexPath) { }
    func didSelectItem(for itemIdentifier: String, at indexPath: IndexPath) { }
    func didBecomeActive() { }
    func didBecomeDeactive() { }
    func hasPagination(for indexPath: IndexPath) -> Bool { false }
    func layout(in environment: NSCollectionLayoutEnvironment?) -> NSCollectionLayoutSection? { nil }
}

public extension ListSection {
    /// Reloads specified items in the section.
    ///
    /// In ios 15 this will be used reconfigureItems method in diffable data source. Below ios 15 it will simple reload the cells. Use this method to trigger ``cell(for:at:)`` method to specified items.
    ///
    /// - Parameters:
    ///   - items: The item list that will be reloaded
    ///   - animatingDifferences: The boolean flag whether reload will be animated
    ///   - completion: The completion block that will be called after reload
    func reconfigure(items: [ListIdentifiable], animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        context?.reconfigureItems(items, in: self, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    /// Triggers ``ListSection/configure(cell:for:at:)-6ikc6`` methods for given items. It does not trigger snapshot apply. So if you just want to trigger cell loading without layout change and animation you can call this method instead of ``ListSection/reconfigure(items:animatingDifferences:completion:)``
    /// - Parameter items: The items whose cells will be reloaded
    func reloadCells(for items: [ListIdentifiable]) {
        context?.reloadCells(for: items, in: self)
    }

    /// Updates the sections items.
    ///
    /// When data source is diffable data source the update operation does not reloads currently visible cells. To force reloading you can provided `reconfigureItems` array. When data source is reloading data source this
    /// call just reloads the collection view.
    /// - Parameters:
    ///   - reconfigureItems: The items that their cells will be reloaded.
    ///   - reloadHeaderAndFooter: Provide `true` if you want to also reload header and footer views.
    ///   - animatingDifferences: Provide `true` for animated updates when data source is diffable data source.
    ///   - completion: Completion block that will be called after update.
    @available(*, deprecated, message: "use newUpdate(reloadingItems:reloadingItems:reloadingHeader:reloadingFooter:animatingDifferences:completion")
    func update(reconfigureItems: [ListIdentifiable] = [], reloadHeaderAndFooter: Bool = false, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        context?.update(section: self, reconfigureItems: reconfigureItems, reloadHeaderAndFooter: reloadHeaderAndFooter, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    func newUpdate(reloadingItems: [ListIdentifiable] = [], reloadingHeader: Bool = false, reloadingFooter: Bool = false, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        context?.update(section: self, reloadingItems: reloadingItems, reloadingHeader: reloadingHeader, reloadingFooter: reloadingFooter, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    /// Appends new items at the end of the section
    /// - Parameters:
    ///   - items: The items that will be appended to section
    ///   - animatingDifferences: Provide `true` for animating append operation when data source is diffable data source.
    ///   - completion: Completion block that will be called after appending new items.
    func append(items: [ListIdentifiable], animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        context?.append(section: self, items: items, animatingDifferences: animatingDifferences, completion: completion)
    }

    /// Reloads the section's cells and header footer views
    /// - Parameter completion: Callback that is called after reload
    func reload(completion: (() -> Void)? = nil) {
        context?.reload(section: self, completion: completion)
    }

    /// Removes section from the list.
    /// - Parameters:
    ///   - animatingDifferences: The boolean flag whether removing section is animated.
    ///   - completion: The completion block that will be called after section is removed.
    func removeFromDataSource(animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        context?.delete(section: self, animatingDifferences: animatingDifferences, completion: completion)
    }

    /// Scrolls the collection view contents until the specified item is visible.
    /// - Parameters:
    ///   - item: The item of the cell scroll into view.
    ///   - scrollPosition: An option that specifies where the item should be positioned when scrolling finishes. For a list of possible values, see UICollectionView.ScrollPosition.
    ///   - animated: Specify true to animate the scrolling behavior or false to adjust the scroll view’s visible content immediately.
    func scrollTo(item: ListIdentifiable, at scrollPosition: UICollectionView.ScrollPosition = .top, animated: Bool = true) {
        context?.scrollTo(item: item, in: self, at: scrollPosition, animated: animated)
    }

    /// Inserts the provided items immediately after the item with the specified identifier.
    /// - Parameters:
    ///   - items: The array of items to add to the section.
    ///   - afterItem: The item after which to insert the new items.
    ///   - animatingDifferences: Specify true to animate the insert.
    ///   - completion: The completion block that will be called after the insert animation is done.
    func insertItems(_ items: [ListIdentifiable], afterItem: ListIdentifiable, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        context?.insertItems(items, afterItem: afterItem, in: self, animatingDifferences: animatingDifferences, completion: nil)
    }

    /// Inserts the provided items immediately before the item with the specified identifier.
    /// - Parameters:
    ///   - items: The array of items to add to the section.
    ///   - beforeItem: The item before which to insert the new items.
    ///   - animatingDifferences: Specify true to animate the insert.
    ///   - completion: The completion block that will be called after the insert animation is done.
    func insertItems(_ items: [ListIdentifiable], beforeItem: ListIdentifiable, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        context?.insertItems(items, beforeItem: beforeItem, in: self, animatingDifferences: animatingDifferences, completion: completion)
    }

    /// Deletes the items from the section.
    /// - Parameters:
    ///   - items: The array of items to delete from the section.
    ///   - animatingDifferences: Specify true to animate the deletion.
    ///   - completion: The completion block that will be called after the delete animation is done.
    func deleteItems(_ items: [ListIdentifiable], animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        context?.deleteItems(items, in: self, animatingDifferences: animatingDifferences, completion: completion)
    }

    /// Moves the item from its current position in the section to the position immediately after the specified item.
    /// - Parameters:
    ///   - item: The item to move in the section.
    ///   - toItem: The item after which to move the specified item.
    ///   - animatingDifferences: Specify true to animate the move item.
    ///   - completion: The completion block that will be called after the move animation is done.
    func moveItem(_ item: ListIdentifiable, afterItem toItem: ListIdentifiable, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        context?.moveItem(item, afterItem: toItem, in: self, animatingDifferences: animatingDifferences, completion: completion)
    }

    /// Moves the item from its current position in the section to the position immediately before the specified item.
    /// - Parameters:
    ///   - item: The item to move in the section.
    ///   - toItem: The item before which to move the specified item.
    ///   - animatingDifferences: Specify true to animate the move item.
    ///   - completion: The completion block that will be called after the move animation is done.
    func moveItem(_ item: ListIdentifiable, beforeItem toItem: ListIdentifiable, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        context?.moveItem(item, beforeItem: toItem, in: self, animatingDifferences: animatingDifferences, completion: completion)
    }

    /// Represents the index of the section inside collectionview.
    var sectionIndex: Int? {
        context?.index(for: self)
    }

    /// Represents the size of collectionview. You can query this property during the layout process to get the collectionview size
    var listSize: CGSize {
        context?.listSize ?? CGSize.zero
    }
    
    /// Returns the cell that is displayed in collectionview for the given item
    /// - Parameter item: The item that is used for configuring cell
    /// - Returns: Optional UICollectionViewCell
    func cell<Cell: UICollectionViewCell>(for item: ListIdentifiable) -> Cell? {
        context?.cell(for: item, in: self)
    }
    
    /// Causes layout update in collection view
    /// - Parameters:
    ///   - animated: Provide `true` for animating layout update
    ///   - completion: Optional completion block that will be called after layout update
    func relayout(animated: Bool = true, completion: (() -> Void)? = nil) {
        context?.relayout(animated: animated, completion: completion)
    }
    
    /// Scrolls to header view of the section
    /// - Parameter animated: Provide `true` to animate scrolling
    func scrollToHeader(animated: Bool = true) {
        context?.scrollToHeader(in: self, animated: animated)
    }
}

public extension ListSection {
    /// Dequeues a new cell from the collectionview at the given indexPath.
    ///
    /// Use this method to dequeue cell that is implemented only source file. Provide return type to get strongly typed cell instance.
    /// - Parameter indexPath: The index path that collectionview will use to dequeue cell
    /// - Returns: A valid UICollectionViewCell object.
    func dequeueCell<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell? {
        context?.reusableHelper.dequeueCell(at: indexPath)
    }

    /// Dequeues a new cell from the collectionview at the given indexPath.
    ///
    /// Use this method to dequeue a cell with .xib file. The .xib file has to have same name with the cell class. Provide return type to get strongly typed cell instance
    /// - Parameters:
    ///   - indexPath: The index path that collectionview will use to dequeue cell
    ///   - bundle: A bundle object that contains the xib file for the cell
    /// - Returns: A valid UICollectionViewCell object.
    func dequeueCell<Cell: UICollectionViewCell>(at indexPath: IndexPath, bundle: Bundle) -> Cell? {
        let nibName = String(describing: Cell.self)
        return context?.reusableHelper.dequeueCell(withNibName: nibName, bundle: bundle, at: indexPath)
    }

    /// Dequeues a new cell from the collectionview at the given indexPath.
    ///
    /// Use this method to dequeue a cell with .xib file. The .xib file can have different name with the cell class. Provide return type to get strongly typed cell instance
    /// - Parameters:
    ///   - name: Name of the xib file that has ui for the cell
    ///   - bundle: A bundle object that contains the xib file for the cell
    ///   - indexPath: The index path that collectionview will use to dequeue cell
    /// - Returns: A valid UICollectionViewCell object.
    func dequeueCell<Cell: UICollectionViewCell>(withNibName name: String, bundle: Bundle? = nil, at indexPath: IndexPath) -> Cell? {
        context?.reusableHelper.dequeueCell(withNibName: name, bundle: bundle, at: indexPath)
    }
}

public extension ListSection where Self: ListSectionSupplementaryViewSource {
    /// Dequeues a new header view from the collectionview at the given indexPath.
    ///
    /// Use this method to dequeue header view that is implemented only in source file. Provide return type to get strongly typed header view instance.
    /// - Parameter indexPath: The index path that collectionview will use to dequeue header view
    /// - Returns: A valid UICollectionReusableView object.
    func dequeHeaderView<Header: UICollectionReusableView>(at indexPath: IndexPath) -> Header? {
        dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
    }

    /// Dequeues a new footer view from the collectionview at the given indexPath.
    ///
    /// Use this method to dequeue header view that is implemented only in source file. Provide return type to get strongly typed header view instance.
    /// - Parameter indexPath: The index path that collectionview will use to dequeue footer view
    /// - Returns: A valid UICollectionReusableView object.
    func dequeFooterView<Header: UICollectionReusableView>(at indexPath: IndexPath) -> Header? {
        dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
    }

    /// Dequeues a new header view from the collectionview at the given indexPath.
    ///
    /// Use this method to dequeue a header view with .xib file. The .xib file has to have same name with the header view class. Provide return type to get strongly typed header view instance
    /// - Parameters:
    ///   - indexPath: The index path that collectionview will use to dequeue header view
    ///   - bundle: A bundle object that contains the xib file for the header view
    /// - Returns: A valid UICollectionReusableView object.
    func dequeHeaderView<Header: UICollectionReusableView>(at indexPath: IndexPath, bundle: Bundle) -> Header? {
        let nibName = String(describing: Header.self)
        return dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, nibName: nibName, bundle: bundle, at: indexPath)
    }

    /// Dequeues a new footer view from the collectionview at the given indexPath.
    ///
    /// Use this method to dequeue a footer view with .xib file. The .xib file has to have same name with the footer view class. Provide return type to get strongly typed footer view instance
    /// - Parameters:
    ///   - indexPath: The index path that collectionview will use to dequeue footer view
    ///   - bundle: A bundle object that contains the xib file for the footer view
    /// - Returns: A valid UICollectionReusableView object.
    func dequeFooterView<Footer: UICollectionReusableView>(at indexPath: IndexPath, bundle: Bundle) -> Footer? {
        let nibName = String(describing: Footer.self)
        return dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, nibName: nibName, bundle: bundle, at: indexPath)
    }

    /// Dequeues a new header view from the collectionview at the given indexPath.
    ///
    /// Use this method to dequeue a header view with .xib file. The .xib file can have different name with the header view class. Provide return type to get strongly typed header view instance
    /// - Parameters:
    ///   - nibName: Name of the xib file that has ui for the header view
    ///   - bundle: A bundle object that contains the xib file for the header view
    ///   - indexPath: The index path that collectionview will use to dequeue header view
    /// - Returns: A valid UICollectionReusableView object.
    func dequeHeaderView<Header: UICollectionReusableView>(nibName: String, bundle: Bundle? = nil, at indexPath: IndexPath) -> Header? {
        dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, nibName: nibName, bundle: bundle, at: indexPath)
    }

    /// Dequeues a new footer view from the collectionview at the given indexPath.
    ///
    /// Use this method to dequeue a footer view with .xib file. The .xib file can have different name with the footer view class. Provide return type to get strongly typed footer view instance
    /// - Parameters:
    ///   - nibName: Name of the xib file that has ui for the footer view
    ///   - bundle: A bundle object that contains the xib file for the footer view
    ///   - indexPath: The index path that collectionview will use to dequeue footer view
    /// - Returns: A valid UICollectionReusableView object.
    func dequeFooterView<Footer: UICollectionReusableView>(nibName: String, bundle: Bundle? = nil, at indexPath: IndexPath) -> Footer? {
        dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, nibName: nibName, bundle: bundle, at: indexPath)
    }

    /// Dequeues a new supplementary view for section from the collectionview at the given indexPath and given kind.
    ///
    /// For footer and header views you can directly use ``ListSection/dequeHeaderView(at:)`` and ``ListSection/dequeFooterView(at:)`` methods. For custom supplementary views
    /// you can use this method to dequeue. Use this method if your custom supplemantry view has no .xib. Otherwise use ``ListSection/dequeueSupplementaryView(ofKind:nibName:bundle:at:)`` method.
    /// - Parameters:
    ///   - kind: kind of the supplementary view.
    ///   - indexPath: The index path that collectionview will use to dequeue supplementary view
    /// - Returns: A valid UICollectionReusableView object.
    func dequeueSupplementaryView<ReusableView: UICollectionReusableView>(ofKind kind: String, at indexPath: IndexPath) -> ReusableView? {
        context?.reusableHelper.dequeueSupplementaryView(ofKind: kind, at: indexPath)
    }

    /// Dequeues a new supplementary view for section from the collectionview at the given indexPath and given kind.
    ///
    /// For footer and header views you can directly use ``ListSection/dequeHeaderView(at:)`` and ``ListSection/dequeFooterView(at:)`` methods. For custom supplementary views
    /// you can use this method to dequeue. Use this method if your custom supplemantry view has .xib file. Otherwise use ``ListSection/dequeueSupplementaryView(ofKind:at:)`` method.
    /// - Parameters:
    ///   - kind: kind of the supplementary view.
    ///   - nibName: Name of the xib file that has ui for the supplementary view
    ///   - bundle: A bundle object that contains the xib file for the supplementary view
    ///   - indexPath: The index path that collectionview will use to dequeue supplementary view
    /// - Returns: A valid UICollectionReusableView object.
    func dequeueSupplementaryView<ReusableView: UICollectionReusableView>(ofKind kind: String, nibName: String, bundle: Bundle? = nil, at indexPath: IndexPath) -> ReusableView? {
        context?.reusableHelper.dequeueSupplementaryView(ofKind: kind, nibName: nibName, bundle: bundle, at: indexPath)
    }
}
