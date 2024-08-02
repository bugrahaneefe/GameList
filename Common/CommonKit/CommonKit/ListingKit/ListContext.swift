//
//  ListContext.swift
//  Listing
//
//  Created by M.Yusuf on 7.01.2022.
//

import UIKit

/// Provides access to data source from sections.
///
/// You can use `ListContext` to access data source from your ``ListSection``. You don't need to implement `ListContext`. The implementation is provided by ``ListingKit``.
/// Most of the methods here also called from ``ListSection`` extensions and can be used interchangeably. For example the following calls inside ``ListSection`` does the same thing. ``ListSection`` extension
/// implementations just provides default arguments and some shorthands.
/// ```swift
/// context?.insertItems(newItems, afterItem: theItem, in: self, animatingDifferences: true, completion: nil)
/// self.insertItems(newItems, afterItem: theItem)
/// ```
///
/// You use `ListContext` for
/// * Getting current size of collection view
/// * Getting current index of the section from data source
/// * Getting identifier for item at index path
/// * updating reloading section's items
/// * scrolling to an item
/// * inserting new items and deleting existing items from section
/// * moving items inside section
/// * reloading existing items
public protocol ListContext: AnyObject {
    /// Returns size of the collection view. It can be useful for calculating cell sizes etc.
    var listSize: CGSize { get }
    
    /// Gets the view controller that holds the collectionview
    var viewController: UIViewController? { get }
    var reusableHelper: ListReusableViewHelperProtocol { get }

    /// Triggers cell reloading for given items.
    ///
    /// You can call this method after the data updated and you want to reflect the changes in the visible cells. When underlying data source is reloading data source this call just reloads the collection view.
    /// When data source is diffable data source this call uses `NSDiffableDataSourceSnapshot.reloadItems` for ios 14. For targets above ios 15 it uses `NSDiffableDataSourceSnapshot.reconfigureItems` api.
    /// - Parameters:
    ///   - items: The items that are going to be reloaded.
    ///   - section: section that reloading happens.
    ///   - animatingDifferences: Provide `true` for animated updates when data source is diffable data source.
    ///   - completion: Completion block that will be called after reload.
    func reconfigureItems(_ items: [ListIdentifiable], in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)
    
    /// Makes data source to call cell configurattion for the given items. It does not update diffable data source.
    /// - Parameters:
    ///   - items: items whose cells will be updated
    ///   - section: The section that wants to update its cells
    func reloadCells(for items: [ListIdentifiable], in section: ListSection)
    
    /// Makes data source to updates given sections header view.
    /// - Parameter section: The section that wants to update its header view
    func reloadHeader(in section: ListSection)
    
    /// Makes data source to updates given sections footer view.
    /// - Parameter section: The section that wants to update its footer view
    func reloadFooter(in section: ListSection)

    /// Makes data source to updates given supplementary view at given index path
    ///
    /// - Parameters:
    ///   - kind: Kind of the supplementary view
    ///   - section: The section that supplementary view belongs
    ///   - indexPath: Indexpath of the supplementary view
    func reloadSupplementaryElement(kind: String, in section: ListSection, at indexPath: IndexPath)

    /// Updates the sections items.
    ///
    /// When data source is diffable data source the update operation does not reloads currently visible cells. To force reloading you can provided `reconfigureItems` array. When data source is reloading data source this
    /// call just reloads the collection view.
    /// - Parameters:
    ///   - section: section that update happens.
    ///   - reconfigureItems: The items that their cells will be reloaded.
    ///   - reloadHeaderAndFooter: Provide `true` if you want to also reload header and footer views.
    ///   - animatingDifferences: Provide `true` for animated updates when data source is diffable data source.
    ///   - completion: Completion block that will be called after update.
    @available(*, deprecated, message: "use update(section:reloadingItems:reloadingHeader:reloadingFooter:animatingDifferences:completion")
    func update(section: ListSection, reconfigureItems: [ListIdentifiable], reloadHeaderAndFooter: Bool, animatingDifferences: Bool, completion: (() -> Void)?)
    
    /// Updates the sections items.
    ///
    /// When data source is diffable data source the update operation does not reloads currently visible cells. To force reloading you can provided `reloadingItems` array. When data source is reloading data source this
    /// call just reloads the collection view.
    /// - Parameters:
    ///   - section: section that update happens.
    ///   - reloadingItems: The items that their cells will be reloaded.
    ///   - reloadingHeader: When provided `true` header view will be reloaded
    ///   - reloadingFooter: When provided `true` footer view will be reloaded
    ///   - animatingDifferences: Provide `true` for animated updates when data source is diffable data source.
    ///   - completion: Completion block that will be called after update.
    func update(section: ListSection, reloadingItems: [ListIdentifiable], reloadingHeader: Bool, reloadingFooter: Bool, animatingDifferences: Bool, completion: (() -> Void)?)
    
    /// Appends new items at the end of the section
    /// - Parameters:
    ///   - section: The section that appends new items
    ///   - items: The items that will be appended to section
    ///   - animatingDifferences: Provide `true` for animating append operation when data source is diffable data source.
    ///   - completion: Completion block that will be called after appending new items.
    func append(section: ListSection, items: [ListIdentifiable], animatingDifferences: Bool, completion: (() -> Void)?)

    /// Reloads the whole section without any animation.
    ///
    /// This also reloads the header and footer view and calls cell for item method for every cell in section
    /// - Parameters:
    ///   - section: section that reloading happens.
    ///   - completion: Completion block that will be called after reload.
    func reload(section: ListSection, completion: (() -> Void)?)

    /// Deletes the section from the data source
    /// - Parameters:
    ///   - section: section that will be deleted from data source
    ///   - animatingDifferences: Provide `true` for animation when data source is diffable data source.
    ///   - completion: Completion block that will be called after deletion.
    func delete(section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)

    /// Scrolls the given item in section.
    /// - Parameters:
    ///   - item: The item that will be scrolled in collection view.
    ///   - section: The section that has the item
    ///   - scrollPosition: Determines where the scroll will end.
    ///   - animated: Provide `true` for animated scrolling.
    func scrollTo(item: ListIdentifiable, in section: ListSection, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool)

    /// Inserts the given items into list.
    ///
    /// You are responsible to put the items into ``ListSection/items``
    /// - Parameters:
    ///   - items: Items that will be inserted to list
    ///   - afterItem: The item after which to insert the new items.
    ///   - section: The section that the items will be inserted
    ///   - animatingDifferences: Provide `true` for animating insertion when the data source is diffable data source
    ///   - completion: Completion block that will be called after insertion
    func insertItems(_ items: [ListIdentifiable], afterItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)

    /// Inserts the given items into list.
    ///
    /// You are responsible to put the items into ``ListSection/items``
    /// - Parameters:
    ///   - items: Items that will be inserted to list
    ///   - beforeItem: The item before which to insert the new items.
    ///   - section: The section that the items will be inserted
    ///   - animatingDifferences: Provide `true` for animating insertion when the data source is diffable data source
    ///   - completion: Completion block that will be called after insertion
    func insertItems(_ items: [ListIdentifiable], beforeItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)

    /// Deletes the given items from the section
    ///
    /// You have to remove items from ``ListSection/items`` array then call this method.
    /// - Parameters:
    ///   - items: Items that will be deleted from the section
    ///   - section: The section that has the items
    ///   - animatingDifferences: Provide `true` for animating deletion when the data source is diffable data source
    ///   - completion: Completion block that will be called after deletion.
    func deleteItems(_ items: [ListIdentifiable], in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)

    /// Moves item inside section to after another item.
    ///
    /// You should perform moving item in ``ListSection/items`` array than call this method.
    /// - Parameters:
    ///   - item: The item that will be moved
    ///   - toItem: The item after which item is moved
    ///   - section: The section that moving happens
    ///   - animatingDifferences: Provide `true` for animate moving item when the data source is diffable data source
    ///   - completion: Completion block that will be called after moving the item
    func moveItem(_ item: ListIdentifiable, afterItem toItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)

    /// Moves item inside section to before another item.
    /// - Parameters:
    ///   - item: The item that will be moved
    ///   - toItem: The item before which item is moved
    ///   - section: The section that moving happens
    ///   - animatingDifferences: Provide `true` for animate moving item when the data source is diffable data source
    ///   - completion: Completion block that will be called after moving the item
    func moveItem(_ item: ListIdentifiable, beforeItem toItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?)

    /// Returns sections current index in data source
    /// - Parameter section: The section whose index will return
    /// - Returns: Index of the section in data source
    func index(for section: ListSection) -> Int?

    /// Returns the identifier of the item at the given index path
    /// - Parameter indexPath: Index path of the item
    /// - Returns: Identifier of the item
    func itemIdentifier(at indexPath: IndexPath) -> String?
    
    /// Returns  UICollectionViewCell that is visible in collection view.
    /// - Parameters:
    ///   - item: The item that creates the cell
    ///   - section: The section whose cell view will be returned
    /// - Returns: The cell view that is found in given section.
    func cell<Cell>(for item: ListIdentifiable, in section: ListSection) -> Cell? where Cell : UICollectionViewCell
    
    /// Returns supplementary view that is visible in collection view.
    /// - Parameters:
    ///   - section: The section whose supplementary view will be returned
    ///   - kind: Kind of supplementary view
    ///   - item: Optional item for querying supplementary view.
    /// - Returns: The supplementary view that is found in given section.
    func supplementaryView<View: UICollectionReusableView>(in section: ListSection, kind: String, for item: ListIdentifiable?) -> View?
    
    ///  This will make collection view to relayouts the section cells and header footer views.
    /// - Parameters:
    ///   - animated: provide `true` for animating layout change
    ///   - completion:  The completion that will be called after layout changed.
    func relayout(animated: Bool, completion: (() -> Void)?)
    
    /// Scrolls collectionview to given sections header
    /// - Parameters:
    ///   - section: The section whose header will be scrolled to.
    ///   - animated: Provide `true` for animating scrolling
    func scrollToHeader(in section: ListSection, animated: Bool)
}
