//
//  DataSource.swift
//  Listing
//
//  Created by M.Yusuf on 7.01.2022.
//

import UIKit

final class DiffableDataSource {
    weak var viewController: UIViewController?
    weak var scrollDelegate: UIScrollViewDelegate?
    weak var collectionDelegate: UICollectionViewDelegate?
    weak var paginationDelegate: ListPaginationDelegate?
    var sectionCount: Int { sections.count }

    weak var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<String, String>!
    private var listDelegate: ListDelegate?
    private let _reusableHelper = ListReusableViewHelper()
    private let config: ListConfig
    private let context = DefaultListContext()
    private var sections: [ListSection] = []
    private var prefetchingDataSource: CollectionViewWithPrefetchingDataSource?
    var collectionViewDiffableDataSourceCreator: (UICollectionView, @escaping UICollectionViewDiffableDataSource<String, String>.CellProvider) -> UICollectionViewDiffableDataSource<String, String> = { _, _ in fatalError() }

    init(config: ListConfig,
         viewController: UIViewController? = nil) {
        self.config = config
        self.viewController = viewController
        context.defaultContext = self
        collectionViewDiffableDataSourceCreator = { collectionView, cellProvider in
            UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: cellProvider)
        }
    }

    func prepare(for collectionView: UICollectionView) {
        _reusableHelper.collectionView = collectionView
        listDelegate = ListDelegateFactory.createDelegate()
        if config.collectImpression {
            listDelegate?.impressionHandler = ImpressionHandler()
        }
        listDelegate?.prepare(for: collectionView, dataSource: self)
        if config.prefetchingEnabled {
            let prefetchingDataSource = CollectionViewWithPrefetchingDataSource()
            prefetchingDataSource.prepare(for: collectionView, dataSource: self)
            self.prefetchingDataSource = prefetchingDataSource
        }

        self.collectionView = collectionView

        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: EmptyCollectionViewCell.reusedentifier)
        collectionView.register(EmptyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyHeaderView.reusedentifier)
        collectionView.register(EmptyFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: EmptyFooterView.reusedentifier)

        let cellProvider: UICollectionViewDiffableDataSource<String, String>.CellProvider = { [weak self] collectionView, indexPath, itemIdentifier in
            guard
                let self = self,
                let cell = self.cellProvider(for: collectionView, for: itemIdentifier, at: indexPath)
            else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.reusedentifier, for: indexPath)
            }

            return cell
        }

        dataSource = collectionViewDiffableDataSourceCreator(collectionView, cellProvider)
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            self?.supplementaryViewProvider(for: collectionView, elementKind: kind, at: indexPath)
        }
    }

    private func cellProvider(for collectionView: UICollectionView, for item: String, at indexPath: IndexPath) -> UICollectionViewCell? {
        guard
            let section = self.section(for: item),
            let cell = section.cell(for: itemIdentiferFrom(id: item, in: section), at: indexPath)
        else { return nil }
        
        section.configure(cell: cell, for: itemIdentiferFrom(id: item, in: section), at: indexPath)

        return cell
    }

    private func supplementaryViewProvider(for collectionView: UICollectionView, elementKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        let section = section(at: indexPath.section)

        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = section?.supplementaryViewSource?.headerView(for: indexPath) else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyHeaderView.reusedentifier, for: indexPath)
            }
            section?.supplementaryViewSource?.configureHeader(headerView: header, at: indexPath)
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footer =  section?.supplementaryViewSource?.footerView(for: indexPath) else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: EmptyFooterView.reusedentifier, for: indexPath)
            }
            section?.supplementaryViewSource?.configureFooter(footerView: footer, at: indexPath)
            return footer
        } else {
            let view = section?.supplementaryViewSource?.supplementaryView(for: indexPath, kind: kind)
            if let view = view {
                section?.supplementaryViewSource?.configureSupplementaryView(view: view, kind: kind, at: indexPath)
            }
            return view
        }
    }
}

extension DiffableDataSource: ListDataSourceProtocol {
    func append(newSections: [ListSection], animatingDifferences: Bool, completion: (() -> Void)?) {
        var snapshot = dataSource.snapshot()
        let uniqueuSections = makeSectionsUniqueuForAppend(newSections)

        guard !uniqueuSections.isEmpty else { return }

        snapshot.appendSections(uniqueuSections.map(\.listIdentifier))

        for section in uniqueuSections {
            sections.append(section)
            configureSectionForFirstTime(section)

            snapshot.appendItems(uniqueItemIdentifiers(in: section), toSection: section.listIdentifier)
        }

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func reload(newSections: [ListSection], completion: (() -> Void)?) {
        sections.removeAll()

        let uniqueuSections = makeSectionsUniqueuForReload(newSections)
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()

        var reloadIds: [String] = []
        for section in uniqueuSections {
            sections.append(section)
            configureSectionForFirstTime(section)
            snapshot.appendSections([section.listIdentifier])
            snapshot.appendItems(uniqueItemIdentifiers(in: section))

            reloadIds.append(section.listIdentifier)
        }

        if #available(iOS 15.0, *) {
            dataSource.applySnapshotUsingReloadData(snapshot, completion: completion)
        } else {
            if !dataSource.snapshot().sectionIdentifiers.isEmpty {
                snapshot.reloadSections(reloadIds)
            }
            apply(snapshot, animatingDifferences: false, completion: completion)
        }
    }

    func update(newSections: [ListSection], reloadVisibleViews: Bool, animatingDifferences: Bool, completion: (() -> Void)?) {
        sections.removeAll()

        let uniqueuSections = makeSectionsUniqueuForReload(newSections)
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(uniqueuSections.map(\.listIdentifier))

        for section in uniqueuSections {
            sections.append(section)
            configureSectionForFirstTime(section)
            snapshot.appendItems(uniqueItemIdentifiers(in: section), toSection: section.listIdentifier)
        }

        apply(snapshot, animatingDifferences: animatingDifferences) { [weak self] in
            if reloadVisibleViews {
                self?.reloadAllVisibleViews()
            }
            completion?()
        }
    }

    func insert(newSections: [ListSection], beforeSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        var snapshot = dataSource.snapshot()

        let uniqueSections = makeSectionsUniqueuForAppend(newSections)
        guard
            let beforeIndex = sections.firstIndex(where: { beforeSection.listIdentifier == $0.listIdentifier }),
            !uniqueSections.isEmpty
        else { return }

        if beforeIndex == 0 {
            sections.insert(contentsOf: newSections, at: 0)
        } else {
            sections.insert(contentsOf: newSections, at: beforeIndex)
        }

        snapshot.insertSections(uniqueSections.map(\.listIdentifier), beforeSection: beforeSection.listIdentifier)

        for section in uniqueSections {
            configureSectionForFirstTime(section)
            snapshot.appendItems(uniqueItemIdentifiers(in: section), toSection: section.listIdentifier)
        }

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func insert(newSections: [ListSection], afterSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        var snapshot = dataSource.snapshot()

        let uniqueSections = makeSectionsUniqueuForAppend(newSections)
        guard
            let afterIndex = sections.firstIndex(where: { afterSection.listIdentifier == $0.listIdentifier }),
            !uniqueSections.isEmpty
        else { return }

        snapshot.insertSections(uniqueSections.map(\.listIdentifier), afterSection: afterSection.listIdentifier)

        if afterIndex == sections.count - 1 {
            sections.append(contentsOf: newSections)
        } else {
            sections.insert(contentsOf: newSections, at: afterIndex + 1)
        }

        for section in uniqueSections {
            configureSectionForFirstTime(section)
            snapshot.appendItems(uniqueItemIdentifiers(in: section), toSection: section.listIdentifier)
        }

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)

    }

    func move(section: ListSection, afterSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        guard
            let index = sections.firstIndex(where: { $0.listIdentifier == section.listIdentifier })
        else { return }

        let movedSection = sections.remove(at: index)

        guard
            var afterIndex = sections.firstIndex(where: { $0.listIdentifier == afterSection.listIdentifier })
        else { return }

        if afterIndex == sections.count - 1 {
            sections.append(movedSection)
        } else {
            afterIndex = sections.index(after: afterIndex)
            sections.insert(movedSection, at: afterIndex)
        }

        var snapshot = dataSource.snapshot()
        snapshot.moveSection(movedSection.listIdentifier, afterSection: afterSection.listIdentifier)



        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func move(section: ListSection, beforeSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        guard
            let index = sections.firstIndex(where: { $0.listIdentifier == section.listIdentifier })
        else { return }

        let movedSection = sections.remove(at: index)

        guard
            var beforeIndex = sections.firstIndex(where: { $0.listIdentifier == beforeSection.listIdentifier })
        else { return }

        if beforeIndex == 0 {
            sections.insert(movedSection, at: 0)
        } else {
            beforeIndex = sections.index(before: beforeIndex)
            sections.insert(movedSection, at: beforeIndex)
        }

        var snapshot = dataSource.snapshot()
        snapshot.moveSection(movedSection.listIdentifier, beforeSection: beforeSection.listIdentifier)

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func delete(sections: [ListSection], animatingDifferences: Bool, completion: (() -> Void)?) {
        let uniqueSections = makeSectionsUniqueuForRemove(sections)
        guard !uniqueSections.isEmpty else { return }

        self.sections = self.sections
            .filter { section in sections.contains(where: { $0.listIdentifier != section.listIdentifier }) }

        var snapshot = dataSource.snapshot()
        snapshot.deleteSections(uniqueSections.map(\.listIdentifier))

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func section(at index: Int) -> ListSection? {
        if index < sectionCount {
            return sections[index]
        } else {
            return nil
        }
    }

    func itemIdentifier(at indexPath: IndexPath) -> String? {
        guard
            let section = section(at: indexPath.section),
            let id = dataSource.itemIdentifier(for: indexPath)
        else { return nil }

        return itemIdentiferFrom(id: id, in: section)
    }

    func didBecomeActive() {
        visibleSections.forEach { $0.didBecomeActive() }
    }

    func didBecomeDeactive() {
        visibleSections.forEach { $0.didBecomeDeactive() }
    }

    func compositionalSectionLayoutProvider(at index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        guard
            let layout = section(at: index)?.layout(in: environment)
        else { return nil }

        if config.collectImpression {
            let orthogonalScrollingBehavior = layout.orthogonalScrollingBehavior
            let invalidationHandler = layout.visibleItemsInvalidationHandler
            layout.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
                invalidationHandler?(visibleItems, point, environment)

                guard
                    let self = self
                else { return }

                let isOrthogonalScrolling = orthogonalScrollingBehavior != .none
                let scrollDirection = self.collectionView?.scrollingDirection(isOrthogonal: isOrthogonalScrolling) ?? .vertical

                self.listDelegate?.impressionHandler?.calculateImpressions(for: self.collectionView, dataSource: self, scrollDirection: scrollDirection, section: index)
            }
        }

        return layout
    }

    var visibleSections: [ListSection] {
        let indexPaths = collectionView?.indexPathsForVisibleItems ?? []
        let visibleSections = indexPaths
            .reduce(into: Set<Int>()) { partialResult, indexPath in
                partialResult.insert(indexPath.section)
            }
            .compactMap { section(at: $0) }

        return visibleSections
    }

    private func makeSectionsUniqueuForReload(_ sections: [ListSection]) -> [ListSection] {
        var uniqueSectionsDict: [String: ListSection] = [:]
        var uniqueSections: [ListSection] = []

        for section in sections {
            if uniqueSectionsDict[section.listIdentifier] == nil {
                uniqueSectionsDict[section.listIdentifier] = section
                uniqueSections.append(section)
            }
        }

        return uniqueSections
    }

    private func makeSectionsUniqueuForAppend(_ sections: [ListSection]) -> [ListSection] {
        var uniqueSections: [ListSection] = []

        for section in sections {
            let dataSourceContainsSection = dataSource.snapshot().sectionIdentifiers.contains(section.listIdentifier)
            let uniqueSectionsContainsSection = uniqueSections.contains { $0.listIdentifier == section.listIdentifier }

            if !dataSourceContainsSection && !uniqueSectionsContainsSection {
                uniqueSections.append(section)
            }
        }

        return uniqueSections
    }

    private func makeSectionsUniqueuForRemove(_ sections: [ListSection]) -> [ListSection] {
        var uniqueSections: [ListSection] = []

        for section in sections {
            let dataSourceContainsSection = dataSource.snapshot().sectionIdentifiers.contains(section.listIdentifier)
            let uniqueSectionsContainsSection = uniqueSections.contains { $0.listIdentifier == section.listIdentifier }

            if dataSourceContainsSection && !uniqueSectionsContainsSection {
                uniqueSections.append(section)
            }
        }

        return uniqueSections
    }

    private func section(for item: String) -> ListSection? {
        guard
            let sectionId = dataSource.snapshot().sectionIdentifier(containingItem: item),
            let section = sections.first(where: { $0.listIdentifier == sectionId })
        else { return nil }

        return section
    }
    
    private func reloadAllVisibleViews() {
        guard let visibleIndexPaths = collectionView?.indexPathsForVisibleItems, !visibleIndexPaths.isEmpty else { return }
        var sections: [Int: ListSection] = [:]

        for indexPath in visibleIndexPaths {
            guard
                let section = section(at: indexPath.section),
                let identifier = itemIdentifier(at: indexPath)
            else { return }

            if let cell = collectionView?.cellForItem(at: indexPath) {
                section.configure(cell: cell, for: identifier, at: indexPath)
                sections[indexPath.section] = section
            }

            for supplementaryViews in reusableHelper.supplementaryViewKinds {
                reloadSupplementaryElement(kind: supplementaryViews,
                                           in: section,
                                           at: indexPath)
            }
        }

        for (_, section) in sections {
            reloadHeader(in: section)
            reloadFooter(in: section)
        }
    }

    private func configureSectionForFirstTime(_ section: ListSection) {
        section.context = context
        section.didMoveToList()
        if let layout = collectionView?.collectionViewLayout {
            section.supplementaryViewSource?.registerDecorationViews(for: layout)
        }
    }
}

extension DiffableDataSource: ListContext {
    var reusableHelper: ListReusableViewHelperProtocol {
        _reusableHelper
    }

    var listSize: CGSize {
        collectionView?.bounds.size ?? .zero
    }

    func update(section: ListSection, reconfigureItems: [ListIdentifiable], reloadHeaderAndFooter: Bool, animatingDifferences: Bool, completion: (() -> Void)?) {
        if reloadHeaderAndFooter, let index = index(for: section) {
            let context = UICollectionViewFlowLayoutInvalidationContext()
            context.invalidateSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader, at: [IndexPath(item: 0, section: index)])
            context.invalidateSupplementaryElements(ofKind: UICollectionView.elementKindSectionFooter, at: [IndexPath(item: 0, section: index)])
            (collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.invalidateLayout(with: context)
        }

        let oldSnapshot = dataSource.snapshot()
        let oldItemIdentifiers = Set(oldSnapshot.itemIdentifiers)
        var newSnapshot = NSDiffableDataSourceSnapshot<String, String>()
        let reloadItems = uniqueItemIdentifiers(for: reconfigureItems, in: section)
            .filter {
                oldItemIdentifiers.contains($0)
            }

        newSnapshot.appendSections(oldSnapshot.sectionIdentifiers)

        for sectionId in oldSnapshot.sectionIdentifiers {
            if sectionId == section.listIdentifier {
                let newItemIdentifiers = uniqueItemIdentifiers(in: section)
                newSnapshot.appendItems(newItemIdentifiers, toSection: sectionId)
                if !reloadItems.isEmpty {
                    newSnapshot.reloadItems(reloadItems)
                }
            } else {
                newSnapshot.appendItems(oldSnapshot.itemIdentifiers(inSection: sectionId), toSection: sectionId)
            }
        }

        apply(newSnapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    func update(section: ListSection, reloadingItems: [ListIdentifiable], reloadingHeader: Bool, reloadingFooter: Bool, animatingDifferences: Bool, completion: (() -> Void)?) {
        self.update(section: section, reconfigureItems: reloadingItems, reloadHeaderAndFooter: reloadingHeader || reloadingFooter, animatingDifferences: animatingDifferences, completion: completion)
    }

    func reload(section: ListSection, completion: (() -> Void)?) {
        let oldSnapshot = dataSource.snapshot()
        guard oldSnapshot.sectionIdentifiers.contains(section.listIdentifier) else { return }

        var newSnapshot = NSDiffableDataSourceSnapshot<String, String>()
        newSnapshot.appendSections(oldSnapshot.sectionIdentifiers)

        for sectionId in oldSnapshot.sectionIdentifiers {
            if sectionId == section.listIdentifier {
                let newItemIdentifiers = uniqueItemIdentifiers(in: section)
                newSnapshot.appendItems(newItemIdentifiers, toSection: sectionId)
            } else {
                newSnapshot.appendItems(oldSnapshot.itemIdentifiers(inSection: sectionId), toSection: sectionId)
            }
        }

        newSnapshot.reloadSections([section.listIdentifier])

        apply(newSnapshot, animatingDifferences: false, completion: completion)
    }
    
    func append(section: ListSection, items: [ListIdentifiable], animatingDifferences: Bool, completion: (() -> Void)?) {
        var snapshot = dataSource.snapshot()
        let newItems = uniqueItemIdentifiers(for: items, in: section)
        snapshot.appendItems(newItems, toSection: section.listIdentifier)

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func delete(section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        delete(sections: [section], animatingDifferences: animatingDifferences, completion: completion)
    }

    func reconfigureItems(_ items: [ListIdentifiable], in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        var snapshot = dataSource.snapshot()
        let itemIdentifiersInSection = snapshot.itemIdentifiers(inSection: section.listIdentifier)
        let identifiers = uniqueItemIdentifiers(for: items, in: section)
            .filter { itemIdentifiersInSection.contains($0) }

        guard !identifiers.isEmpty else { return }

        if #available(iOS 15.0, *) {
            snapshot.reconfigureItems(identifiers)
        } else {
            snapshot.reloadItems(identifiers)
        }

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    func reloadCells(for items: [ListIdentifiable], in section: ListSection) {
        for item in items {
            guard
                let indexPath = dataSource.indexPath(for: itemIdentifier(for: item, in: section)),
                let cell = collectionView?.cellForItem(at: indexPath)
            else { continue }
            
            section.configure(cell: cell, for: item.listIdentifier, at: indexPath)
        }
    }
    
    func reloadHeader(in section: ListSection) {
        guard let index = index(for: section) else { return }
        reloadSupplementaryElement(kind: UICollectionView.elementKindSectionHeader, in: section, at: IndexPath(item: 0, section: index))
    }
    
    func reloadFooter(in section: ListSection) {
        guard let index = index(for: section) else { return }
        reloadSupplementaryElement(kind: UICollectionView.elementKindSectionFooter, in: section, at: IndexPath(item: 0, section: index))
    }

    func reloadSupplementaryElement(kind: String, in section: ListSection, at indexPath: IndexPath) {
        guard
            let sectionIndex = index(for: section),
            let view = collectionView?.supplementaryView(forElementKind: kind, at: indexPath)
        else { return }

        if kind == UICollectionView.elementKindSectionHeader {
            section.supplementaryViewSource?.configureHeader(headerView: view, at: IndexPath(item: 0, section: sectionIndex))
        } else if kind == UICollectionView.elementKindSectionFooter {
            section.supplementaryViewSource?.configureFooter(footerView: view, at: IndexPath(item: 0, section: sectionIndex))
        } else {
            section.supplementaryViewSource?.configureSupplementaryView(view: view, kind: kind, at: indexPath)
        }
    }

    func scrollTo(item: ListIdentifiable, in section: ListSection, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard let indexPath = dataSource.indexPath(for: itemIdentifier(for: item, in: section)) else { return }
        collectionView?.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }

    func scrollToHeader(in section: ListSection, animated: Bool) {
        collectionView?.layoutIfNeeded()
        guard let collectionView = collectionView,
              collectionView.contentSize.height > collectionView.bounds.height else { return }
        let indexPath = IndexPath(item: .zero, section: self.sections.firstIndex { $0.listIdentifier == section.listIdentifier } ?? .zero)
        if let attributes =  collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
            let topOfHeader = CGPoint(x: .zero, y: attributes.frame.origin.y - (collectionView.contentInset.top))
            collectionView.scrollRectToVisible(CGRect(origin: topOfHeader, size: collectionView.frame.size), animated: animated)
        }
    }

    func insertItems(_ items: [ListIdentifiable], afterItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        var snapshot = dataSource.snapshot()
        snapshot.insertItems(uniqueItemIdentifiers(for: items, in: section),
                             afterItem: itemIdentifier(for: afterItem, in: section))

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func insertItems(_ items: [ListIdentifiable], beforeItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        var snapshot = dataSource.snapshot()
        snapshot.insertItems(uniqueItemIdentifiers(for: items, in: section),
                             beforeItem: itemIdentifier(for: beforeItem, in: section))

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func deleteItems(_ items: [ListIdentifiable], in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(uniqueItemIdentifiers(for: items, in: section))

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func moveItem(_ item: ListIdentifiable, afterItem toItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        var snapshot = dataSource.snapshot()
        snapshot.moveItem(itemIdentifier(for: item, in: section),
                          afterItem: itemIdentifier(for: toItem, in: section))

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func moveItem(_ item: ListIdentifiable, beforeItem toItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        var snapshot = dataSource.snapshot()

        snapshot.moveItem(itemIdentifier(for: item, in: section),
                          beforeItem: itemIdentifier(for: toItem, in: section))

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func index(for section: ListSection) -> Int? {
        if #available(iOS 15.0, *) {
            return dataSource.index(for: section.listIdentifier)
        } else {
            return dataSource.snapshot().sectionIdentifiers.firstIndex(of: section.listIdentifier)
        }
    }
}

extension DiffableDataSource {
    func apply(_ snapshot: NSDiffableDataSourceSnapshot<String, String>,
               animatingDifferences: Bool,
               completion: (() -> Void)?) {
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func cell<Cell>(for item: ListIdentifiable, in section: ListSection) -> Cell? where Cell : UICollectionViewCell {
        let itemIdentifier = itemIdentifier(for: item, in: section)
        guard
            let indexPath = dataSource.indexPath(for: itemIdentifier),
            let cell = collectionView?.cellForItem(at: indexPath)
        else { return nil }

        return cell as? Cell
    }

    func supplementaryView<View: UICollectionReusableView>(in section: ListSection, kind: String, for item: ListIdentifiable?) -> View? {
        let indexPath: IndexPath?
        if let item = item {
            let identifier = itemIdentifier(for: item, in: section)
            indexPath = dataSource.indexPath(for: identifier)
        } else if let index = index(for: section) {
            indexPath = IndexPath(item: 0, section: index)
        } else {
            indexPath = nil
        }

        guard
            let indexPath = indexPath,
            let view = collectionView?.supplementaryView(forElementKind: kind, at: indexPath) as? View
        else { return nil }

        return view
    }

    func relayout(animated: Bool, completion: (() -> Void)?) {
        apply(dataSource.snapshot(), animatingDifferences: animated, completion: completion)
    }
}

private extension DiffableDataSource {
    func itemIdentifier(for item: ListIdentifiable, in section: ListSection) -> String {
        "\(section.listIdentifier)-\(item.listIdentifier)"
    }

    func uniqueItemIdentifiers(for items: [ListIdentifiable], in section: ListSection) -> [String] {
        var identifiers: [String] = []
        var identifiersSet: Set<String> = []

        for item in items {
            let id = itemIdentifier(for: item, in: section)
            if !identifiersSet.contains(id) {
                identifiersSet.insert(id)
                identifiers.append(id)
            }
        }

        return identifiers
    }

    func uniqueItemIdentifiers(in section: ListSection) -> [String] {
        uniqueItemIdentifiers(for: section.items, in: section)
    }

    func itemIdentiferFrom(id: String, in section: ListSection) -> String {
        String(id.dropFirst(section.listIdentifier.count + 1))
    }
}

final class EmptyCollectionViewCell: UICollectionViewCell {
    static let reusedentifier: String = UUID().uuidString
}

final class EmptyHeaderView: UICollectionReusableView {
    static let reusedentifier: String = UUID().uuidString
}

final class EmptyFooterView: UICollectionReusableView {
    static let reusedentifier: String = UUID().uuidString
}
