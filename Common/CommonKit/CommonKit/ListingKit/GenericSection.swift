//
//  GenericSection.swift
//  ListingKit
//
//  Created by M.Yusuf on 5.02.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

/// An object that manages single section in ``ListingKit/ListDataSource``
///
/// You can create ``GenericSection`` instances for individual sections in ``ListDataSource``. ``GenericSection`` has single cell type and single data type. You should use
/// ``GenericSection`` for displaying simple sections. If you have multiple cell types and custom logic that may be used in other lists you should create custom implementation for ``ListSection``.
///
/// Creating a ``GenericSection`` is simple. For initializer you only supply items that conforms ``ListIdentifiable`` and optional ``GenericSection/listIdentifier``. If you don't provide
/// ``GenericSection/listIdentifier`` it will automatically have unique identifier.
///
/// ```swift
/// let section = GenericSection(items: [items])
/// ```
///
/// Once you've created the section you can chain methods on it to further configure cell creation and sizing etc.
///
/// ```swift
/// let section = GenericSection(items: [items])
///    .onCellConfigure(for: MyCustomCell.self) { item, cell, indexPath in
///        // configure your cell with the item
///    }
///    .onCellSize { item, listSize in
///        // configure your cell size with item and listSize
///    }
/// ```
public final class GenericSection<Item: ListIdentifiable>: ListSection, ListSectionSupplementaryViewSource, ImpressionDisplaySection {
    /// unique identifier for the section
    public let listIdentifier: String
    public var context: ListContext?
    public var items: [ListIdentifiable] {
        _items
    }

    private var cellConfigure: (String, IndexPath) -> UICollectionViewCell? = { _, _ in nil }
    private var laterCellConfigure: (UICollectionViewCell, String, IndexPath) -> Void = { _, _, _ in }
    private var cellSizeConfigure: (Item, CGSize) -> CGSize = { _, _ in .zero }
    private var headerConfigure: (IndexPath) -> UICollectionReusableView? = { _ in nil }
    private var laterHeaderConfigure: (UICollectionReusableView, IndexPath) -> Void = { _, _ in }
    private var headerSizeConfigure: (Int, CGSize) -> CGSize = { _, _ in .zero }
    private var footerConfigure: (IndexPath) -> UICollectionReusableView? = { _ in nil }
    private var laterFooterConfigure: (UICollectionReusableView, IndexPath) -> Void = { _, _ in }
    private var footerSizeConfigure: (Int, CGSize) -> CGSize = { _, _ in .zero }
    private var supplementaryViewConfigurations: [String: (IndexPath, String) -> UICollectionReusableView?] = [:]
    private var decorationViewConfiguration: (UICollectionViewLayout) -> Void = { _ in }
    private var willDisplayCalback: (IndexPath) -> Void = { _ in }
    private var didEndDisplayCalback: (IndexPath) -> Void = { _ in }
    private var didSelectCallback: (String, IndexPath) -> Void = { _, _ in }
    private var onImpressionCallback: (String, IndexPath) -> Void = { _, _ in }
    private var onLayoutCallback: (Any?) -> Any? = { _ in nil }
    private var _inset: UIEdgeInsets = .zero
    private var _minimumLineSpacing: CGFloat = 0
    private var _minimumInteritemSpacing: CGFloat = 0

    /// Creates generic section object with specified items and identifier
    /// - Parameters:
    ///   - listIdentifier: unique identifier for the section in list. The defailt value is uuid string
    ///   - items: The data objects that will be displayed each in a cell. Items must conform ``ListIdentifiable`` protocol and have unique identifiers
    public init(
        listIdentifier: String = UUID().uuidString,
        items: [Item]
    ) {
        self.listIdentifier = listIdentifier
        self._items = items
    }

    private var _items: [Item]

    public var inset: UIEdgeInsets {
        _inset
    }

    public var minimumLineSpacing: CGFloat {
        _minimumLineSpacing
    }

    public var minimumInteritemSpacing: CGFloat {
        _minimumInteritemSpacing
    }

    public func cell(for itemIdentifier: String, at indexPath: IndexPath) -> UICollectionViewCell? {
        cellConfigure(itemIdentifier, indexPath)
    }

    public func configure(cell: UICollectionViewCell, for itemIdentifier: String, at indexPath: IndexPath) {
        laterCellConfigure(cell, itemIdentifier, indexPath)
    }

    public func size(at indexPath: IndexPath) -> CGSize {
        guard _items.count > indexPath.item else { return .zero }
        
        let item = _items[indexPath.item]
        return cellSizeConfigure(item, listSize)
    }

    public func headerView(for indexPath: IndexPath) -> UICollectionReusableView? {
        headerConfigure(indexPath)
    }

    public func configureHeader(headerView: UICollectionReusableView, at indexPath: IndexPath) {
        laterHeaderConfigure(headerView, indexPath)
    }

    public func referenceSizeForHeaderView(section: Int) -> CGSize {
        headerSizeConfigure(section, listSize)
    }

    public func footerView(for indexPath: IndexPath) -> UICollectionReusableView? {
        footerConfigure(indexPath)
    }

    public func configureFooter(footerView: UICollectionReusableView, at indexPath: IndexPath) {
        laterFooterConfigure(footerView, indexPath)
    }

    public func referenceSizeForFooterView(section: Int) -> CGSize {
        return footerSizeConfigure(section, listSize)
    }

    public func supplementaryView(for indexPath: IndexPath, kind: String) -> UICollectionReusableView? {
        supplementaryViewConfigurations[kind]?(indexPath, kind)
    }

    public func registerDecorationViews(for layout: UICollectionViewLayout) {
        decorationViewConfiguration(layout)
    }

    public func willDisplay(at indexPath: IndexPath) {
        willDisplayCalback(indexPath)
    }

    public func didEndDisplay(at indexPath: IndexPath) {
        didEndDisplayCalback(indexPath)
    }

    public func didSelectItem(for itemIdentifier: String, at indexPath: IndexPath) {
        didSelectCallback(itemIdentifier, indexPath)
    }

    public func didHaveImpression(for item: String, at indexPath: IndexPath) {
        onImpressionCallback(item, indexPath)
    }

    public func layout(in environment: NSCollectionLayoutEnvironment?) -> NSCollectionLayoutSection? {
        onLayoutCallback(environment) as? NSCollectionLayoutSection
    }
}

public extension GenericSection {
    /// Configuration block for the cell.
    /// First parameter is the generic data object that will be used for configuring cell.
    /// Second parameter is the `UICollectionViewCell` subclass.
    /// Third parameter is the index path of the cell.
    typealias CellConfiguration<Cell: UICollectionViewCell> = (Item, Cell, IndexPath) -> Void

    /// Provides cell configuration for the section. The cell has no .xib file.
    /// - Parameters:
    ///   - cellType: The type of the cell that will be configured
    ///   - configure: cell configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onCellConfigure<Cell: UICollectionViewCell>(for cellType: Cell.Type, configure: @escaping CellConfiguration<Cell>) -> Self {
        laterCellConfigure = { [weak self] cell, itemId, indexPath in
            guard
                let self = self,
                let cell = cell as? Cell,
                let item = self._items.first(where: { $0.listIdentifier == itemId })
            else { return }

            configure(item, cell, indexPath)
        }

        cellConfigure = { [weak self] id, indexPath in
            guard
                let self = self,
                let item = self._items.first(where: { $0.listIdentifier == id }),
                let cell: Cell = self.dequeueCell(at: indexPath)
            else { return nil }

            configure(item, cell, indexPath)

            return cell
        }

        return self
    }

    /// Provides cell configuration for the section. The cell class name and the .xib file name must have same name.
    /// - Parameters:
    ///   - cellType: The type of the cell that will be configured
    ///   - bundle: The bundle object that contains .xib file
    ///   - configure: Cell configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onCellConfigure<Cell: UICollectionViewCell>(for cellType: Cell.Type, bundle: Bundle, configure: @escaping CellConfiguration<Cell>) -> Self {
        laterCellConfigure = { [weak self] cell, itemId, indexPath in
            guard
                let self = self,
                let cell = cell as? Cell,
                let item = self._items.first(where: { $0.listIdentifier == itemId })
            else { return }

            configure(item, cell, indexPath)
        }

        cellConfigure = { [weak self] id, indexPath in
            guard
                let self = self,
                let item = self._items.first(where: { $0.listIdentifier == id }),
                let cell: Cell = self.dequeueCell(at: indexPath, bundle: bundle)
            else { return nil }

            configure(item, cell, indexPath)

            return cell
        }
        return self
    }

    /// Provides cell configuration for the section. The cell class name and the .xib file name can have different names.
    /// - Parameters:
    ///   - cellType: The type of the cell that will be configured
    ///   - nibName: Name of the .xib file that has user interface of the cell.
    ///   - bundle: The bundle object that contains .xib file
    ///   - configure: Cell configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onCellConfigure<Cell: UICollectionViewCell>(for cellType: Cell.Type, nibName: String, bundle: Bundle? = nil, configure: @escaping CellConfiguration<Cell>) -> Self {
        laterCellConfigure = { [weak self] cell, itemId, indexPath in
            guard
                let self = self,
                let cell = cell as? Cell,
                let item = self._items.first(where: { $0.listIdentifier == itemId })
            else { return }

            configure(item, cell, indexPath)
        }

        cellConfigure = { [weak self] id, indexPath in
            guard
                let self = self,
                let item = self._items.first(where: { $0.listIdentifier == id }),
                let cell: Cell = self.dequeueCell(withNibName: nibName, bundle: bundle, at: indexPath)
            else { return nil }

            configure(item, cell, indexPath)

            return cell
        }
        return self
    }

    /// Provides cell size configuration when the collectionview layout is flow layout.
    /// - Parameter configure: Size configuration block with the generic item type and list size parameters
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onCellSize(_ configure: @escaping (Item, CGSize) -> CGSize) -> Self {
        cellSizeConfigure = configure
        return self
    }

    /// Provides header view configuration for the section. The header view has no .xib file.
    /// - Parameters:
    ///   - viewType: Type of the header view.
    ///   - configure: Header view configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onHeaderConfigure<Header: UICollectionReusableView>(for viewType: Header.Type, configure: @escaping (Header, IndexPath) -> Void) -> Self {
        laterHeaderConfigure = { header, indexPath in
            guard let header = header as? Header else { return }
            configure(header, indexPath)
        }

        headerConfigure = { [weak self] indexPath in
            guard
                let self = self,
                let header: Header = self.dequeHeaderView(at: indexPath)
            else { return nil }

            configure(header, indexPath)
            return header
        }

        return self
    }

    /// Provides header view configuration for the section. The header view class has the xib file.
    /// - Parameters:
    ///   - viewType: Type of the header view
    ///   - nibName: Name of the .xib file that has ui for the header view
    ///   - bundle: The bundle object that contains .xib file
    ///   - configure: Header configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onHeaderConfigure<Header: UICollectionReusableView>(for viewType: Header.Type, nibName: String, bundle: Bundle? = nil, configure: @escaping (Header, IndexPath) -> Void) -> Self {
        laterHeaderConfigure = { header, indexPath in
            guard let header = header as? Header else { return }
            configure(header, indexPath)
        }

        headerConfigure = { [weak self] indexPath in
            guard
                let self = self,
                let header: Header = self.dequeHeaderView(nibName: nibName, bundle: bundle, at: indexPath)
            else { return nil }

            configure(header, indexPath)
            return header
        }

        return self
    }

    /// Provides header view configuration for the section. The header view class has the xib file with the same name.
    /// - Parameters:
    ///   - viewType: Type of the header view
    ///   - bundle: The bundle object that contains .xib file
    ///   - configure: Header configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onHeaderConfigure<Header: UICollectionReusableView>(for viewType: Header.Type, bundle: Bundle, configure: @escaping (Header, IndexPath) -> Void) -> Self {
        laterHeaderConfigure = { header, indexPath in
            guard let header = header as? Header else { return }
            configure(header, indexPath)
        }

        headerConfigure = { [weak self] indexPath in
            guard
                let self = self,
                let header: Header = self.dequeHeaderView(at: indexPath, bundle: bundle)
            else { return nil }

            configure(header, indexPath)
            return header
        }

        return self
    }

    /// Provides header size configuration when the collectionview layout is flow layout
    /// - Parameter configure: Size configuration block with the section index and list size parameters
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onHeaderSize(_ configure: @escaping (Int, CGSize) -> CGSize) -> Self {
        headerSizeConfigure = configure
        return self
    }

    /// Provides footer view configuration for the section. The footer view has no .xib file.
    /// - Parameters:
    ///   - viewType: Type of the footer view.
    ///   - configure: footer view configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onFooterConfigure<Footer: UICollectionReusableView>(for viewType: Footer.Type, configure: @escaping (Footer, IndexPath) -> Void) -> Self {
        laterFooterConfigure = { footer, indexPath in
            guard let footer = footer as? Footer else { return }
            configure(footer, indexPath)
        }

        footerConfigure = { [weak self] indexPath in
            guard
                let self = self,
                let footer: Footer = self.dequeFooterView(at: indexPath)
            else { return nil }

            configure(footer, indexPath)
            return footer
        }

        return self
    }

    /// Provides footer view configuration for the section. The footer view class has the xib file.
    /// - Parameters:
    ///   - viewType: Type of the footer view
    ///   - nibName: Name of the .xib file that has ui for the footer view
    ///   - bundle: The bundle object that contains .xib file
    ///   - configure: Footer view configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onFooterConfigure<Footer: UICollectionReusableView>(for viewType: Footer.Type, nibName: String, bundle: Bundle? = nil, configure: @escaping (Footer, IndexPath) -> Void) -> Self {
        laterFooterConfigure = { footer, indexPath in
            guard let footer = footer as? Footer else { return }
            configure(footer, indexPath)
        }

        footerConfigure = { [weak self] indexPath in
            guard
                let self = self,
                let footer: Footer = self.dequeFooterView(nibName: nibName, bundle: bundle, at: indexPath)
            else { return nil }

            configure(footer, indexPath)
            return footer
        }

        return self
    }

    /// Provides footer view configuration for the section. The footer view class has the xib file with the same name.
    /// - Parameters:
    ///   - viewType: Type of the footer view
    ///   - bundle: The bundle object that contains .xib file
    ///   - configure: Footer view configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onFooterConfigure<Footer: UICollectionReusableView>(for viewType: Footer.Type, bundle: Bundle, configure: @escaping (Footer, IndexPath) -> Void) -> Self {
        laterFooterConfigure = { footer, indexPath in
            guard let footer = footer as? Footer else { return }
            configure(footer, indexPath)
        }

        footerConfigure = { [weak self] indexPath in
            guard
                let self = self,
                let footer: Footer = self.dequeFooterView(at: indexPath, bundle: bundle)
            else { return nil }

            configure(footer, indexPath)
            return footer
        }

        return self
    }

    /// Provides footer size configuration when the collectionview layout is flow layout
    /// - Parameter configure: Size configuration block with the section index and list size parameters
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onFooterSize(_ configure: @escaping (Int, CGSize) -> CGSize) -> Self {
        footerSizeConfigure = configure
        return self
    }

    /// Provides custom supplementary view configuration.
    ///
    /// You can call this method multiple times and provide configurations for different kind of supplementary views. Use this method if supplementary view has no .xib file
    /// - Parameters:
    ///   - for: Type of the supplementary view class
    ///   - kind: Kind of the supplementary view.
    ///   - configure: Supplementary view configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onSupplementaryViewConfigure<View: UICollectionReusableView>(for: View.Type, kind: String, configure: @escaping (View, IndexPath) -> Void) -> Self {
        supplementaryViewConfigurations[kind] = { [weak self] indexPath, kind in
            guard
                let self = self,
                let view: View = self.dequeueSupplementaryView(ofKind: kind, at: indexPath)
            else { return nil }

            configure(view, indexPath)
            return view
        }
        return self
    }

    /// Provides custom supplementary view configuration.
    ///
    /// You can call this method multiple times and provide configurations for different kind of supplementary views. Use this method if supplementary view has .xib file
    /// - Parameters:
    ///   - for: Type of the supplementary view class
    ///   - kind: Kind of the supplementary view.
    ///   - bundle: The bundle object that contains .xib file.
    ///   - configure: Supplementary view configuration block
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onSupplementaryViewConfigure<View: UICollectionReusableView>(for: View.Type, kind: String, bundle: Bundle, configure: @escaping (View, IndexPath) -> Void) -> Self {
        supplementaryViewConfigurations[kind] = { [weak self] indexPath, kind in
            let nibName = String(describing: View.self)
            guard
                let self = self,
                let view: View = self.dequeueSupplementaryView(ofKind: kind, nibName: nibName, bundle: bundle, at: indexPath)
            else { return nil }

            configure(view, indexPath)
            return view
        }
        return self
    }


    @discardableResult
    /// Provides registration for decoration views
    /// - Parameter callback: Callback that is going to be called when registering decoration views.
    /// - Returns: Same generic section for chaining other methods
    func onRegisterDecorationViews(_ callback: @escaping (UICollectionViewLayout) -> Void) -> Self {
        self.decorationViewConfiguration = callback
        return self
    }

    /// Provides callback that is called when the cell is about to be displayed.
    /// - Parameter callback: Callback that is going to be called when the cell is about to be displayed. The first parameter is the data object that configures the cell. Second parameter is the indexpath of the cell
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onWillDisplay(_ callback: @escaping (Item, IndexPath) -> Void) -> Self {
        willDisplayCalback = { [weak self] indexPath in
            guard
                let self = self,
                indexPath.item < self._items.count
            else { return }

            let item = self._items[indexPath.item]

            callback(item, indexPath)
        }
        return self
    }

    /// Provides callback that is called when the cell is removed from the collection view
    /// - Parameter callback: Callback that is going to be called when the cell is removed from the collection view. The first parameter is the data object that configures the cell. Second parameter is the indexpath of the cell
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func ondidEndDisplay(_ callback: @escaping (Item, IndexPath) -> Void) -> Self {
        didEndDisplayCalback = { [weak self] indexPath in
            guard
                let self = self,
                indexPath.item < self._items.count
            else { return }

            let item = self._items[indexPath.item]

            callback(item, indexPath)
        }
        return self
    }

    /// Provides callback that is called when the cell is selected in collection view
    /// - Parameter callback: Callback that is going to be called when the cell is selected in collection view. The first parameter is the data object that configures the cell. Second parameter is the indexpath of the cell
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onDidSelect(_ callback: @escaping (Item, IndexPath) -> Void) -> Self {
        didSelectCallback = { [weak self] id, indexPath in
            guard
                let self = self,
                let item = self._items.first(where: { $0.listIdentifier == id })
            else { return }

            callback(item, indexPath)
        }
        return self
    }

    /// Sets the sections insets when the collection view layout is flow layout.
    /// - Parameter inset: The inset that is going to be applied in sections
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func sectionInset(_ inset: UIEdgeInsets) -> Self {
        _inset = inset
        return self
    }

    /// Sets the line spacing between rows in section when the collection view layout is flow layout.
    /// - Parameter spacing: The spacing between rows in section
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func minimumLineSpacing(_ spacing: CGFloat) -> Self {
        _minimumLineSpacing = spacing
        return self
    }

    /// Sets the minimum spacing between items in section when the collection view layout is flow layout.
    /// - Parameter spacing: The minimum spacing between items.
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func minimumInterItemSpacing(_ spacing: CGFloat) -> Self {
        _minimumInteritemSpacing = spacing
        return self
    }

    /// Sets the impression callback that is going to be called when the impression event happens.
    /// - Parameter callback: The callback that is going to be called during impression event. The first parameter of the callback is the item that configures the cell. Second parameter is the index path that impression event happened.
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onImpression(_ callback: @escaping (Item, IndexPath) -> Void) -> Self {
        onImpressionCallback = { [weak self] id, indexPath in
            guard
                let self = self,
                let item = self._items.first(where: { $0.listIdentifier == id })
            else { return }

            callback(item, indexPath)
        }
        return self
    }

    /// Sets the sections layout for the compositional layout.
    /// - Parameter callback: The callback that is going to be called for compositional layout.
    /// - Returns: Same generic section for chaining other configuration methods
    @discardableResult
    func onLayout(_ callback: @escaping (NSCollectionLayoutEnvironment?) -> NSCollectionLayoutSection?) -> Self {
        onLayoutCallback = { env in
            let env = env as? NSCollectionLayoutEnvironment
            return callback(env)
        }
        return self
    }
}
