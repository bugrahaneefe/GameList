//
//  File.swift
//  
//
//  Created by Mustafa Yusuf on 4.01.2023.
//

import UIKit

final class NewDiffableDataSource {
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

    var throttler: DiffQueueThrottleInterface = DiffQueueThrottler(
        queue: .main,
        interval: 0.001
    )

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

extension NewDiffableDataSource: ListDataSourceProtocol {
    func append(newSections: [ListSection], animatingDifferences: Bool, completion: (() -> Void)?) {
        throttler.run { [weak self] in
            guard let self else { return }

            var snapshot = self.dataSource.snapshot()
            let uniqueuSections = self.makeSectionsUniqueuForAppend(newSections)

            guard !uniqueuSections.isEmpty else { return }

            snapshot.appendSections(uniqueuSections.map(\.listIdentifier))

            for section in uniqueuSections {
                self.sections.append(section)
                self.configureSectionForFirstTime(section)
                snapshot.appendItems(self.uniqueItemIdentifiers(in: section), toSection: section.listIdentifier)
            }

            self.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
    }

    func reload(newSections: [ListSection], completion: (() -> Void)?) {
        throttler.run { [weak self] in
            guard let self = self else { return }

            self.sections = []

            let uniqueuSections = self.makeSectionsUniqueuForReload(newSections)
            var snapshot = NSDiffableDataSourceSnapshot<String, String>()

            var reloadIds: [String] = []
            for section in uniqueuSections {
                self.sections.append(section)
                self.configureSectionForFirstTime(section)
                snapshot.appendSections([section.listIdentifier])
                snapshot.appendItems(self.uniqueItemIdentifiers(in: section))

                reloadIds.append(section.listIdentifier)
            }

            if #available(iOS 15.0, *) {
                self.apply(snapshot, shouldUseReload: true, animatingDifferences: false, completion: completion)
            } else {
                if !self.dataSource.snapshot().sectionIdentifiers.isEmpty {
                    snapshot.reloadSections(reloadIds)
                }
                self.apply(snapshot, animatingDifferences: false, completion: completion)
            }
        }
    }

    func update(newSections: [ListSection], reloadVisibleViews: Bool, animatingDifferences: Bool, completion: (() -> Void)?) {
        throttler.run { [weak self] in
            guard let self else { return }
            
            self.sections = []

            let uniqueuSections = self.makeSectionsUniqueuForReload(newSections)
            var snapshot = NSDiffableDataSourceSnapshot<String, String>()
            snapshot.appendSections(uniqueuSections.map(\.listIdentifier))

            for section in uniqueuSections {
                self.sections.append(section)
                self.configureSectionForFirstTime(section)
                snapshot.appendItems(self.uniqueItemIdentifiers(in: section), toSection: section.listIdentifier)
            }

            self.apply(snapshot, animatingDifferences: animatingDifferences) { [weak self] in
                if reloadVisibleViews {
                    self?.reloadAllVisibleViews()
                }
                completion?()
            }
        }
    }

    func insert(newSections: [ListSection], beforeSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        throttler.run { [weak self] in
            guard let self else { return }

            var snapshot = self.dataSource.snapshot()

            let uniqueSections = self.makeSectionsUniqueuForAppend(newSections)
            guard
                let beforeIndex = self.sections.firstIndex(where: { beforeSection.listIdentifier == $0.listIdentifier }),
                !uniqueSections.isEmpty
            else { return }

            if beforeIndex == 0 {
                self.sections.insert(contentsOf: newSections, at: 0)
            } else {
                self.sections.insert(contentsOf: newSections, at: beforeIndex)
            }

            snapshot.insertSections(uniqueSections.map(\.listIdentifier), beforeSection: beforeSection.listIdentifier)

            for section in uniqueSections {
                self.configureSectionForFirstTime(section)
                snapshot.appendItems(self.uniqueItemIdentifiers(in: section), toSection: section.listIdentifier)
            }

            self.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
    }

    func insert(newSections: [ListSection], afterSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        throttler.run { [weak self] in
            guard let self else { return }

            var snapshot = self.dataSource.snapshot()

            let uniqueSections = self.makeSectionsUniqueuForAppend(newSections)
            guard
                let afterIndex = self.sections.firstIndex(where: { afterSection.listIdentifier == $0.listIdentifier }),
                !uniqueSections.isEmpty
            else { return }

            snapshot.insertSections(uniqueSections.map(\.listIdentifier), afterSection: afterSection.listIdentifier)

            if afterIndex == self.sections.count - 1 {
                self.sections.append(contentsOf: newSections)
            } else {
                self.sections.insert(contentsOf: newSections, at: afterIndex + 1)
            }

            for section in uniqueSections {
                self.configureSectionForFirstTime(section)
                snapshot.appendItems(self.uniqueItemIdentifiers(in: section), toSection: section.listIdentifier)
            }

            self.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
    }

    func move(section: ListSection, afterSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        throttler.run { [weak self] in
            guard
                let self,
                let index = self.sections.firstIndex(where: { $0.listIdentifier == section.listIdentifier })
            else { return }

            let movedSection = self.sections.remove(at: index)

            guard
                var afterIndex = self.sections.firstIndex(where: { $0.listIdentifier == afterSection.listIdentifier })
            else { return }

            if afterIndex == self.sections.count - 1 {
                self.sections.append(movedSection)
            } else {
                afterIndex = self.sections.index(after: afterIndex)
                self.sections.insert(movedSection, at: afterIndex)
            }

            var snapshot = self.dataSource.snapshot()
            snapshot.moveSection(movedSection.listIdentifier, afterSection: afterSection.listIdentifier)

            self.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
    }

    func move(section: ListSection, beforeSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        throttler.run { [weak self] in
            guard
                let self,
                let index = self.sections.firstIndex(where: { $0.listIdentifier == section.listIdentifier })
            else { return }

            let movedSection = self.sections.remove(at: index)

            guard
                var beforeIndex = self.sections.firstIndex(where: { $0.listIdentifier == beforeSection.listIdentifier })
            else { return }

            if beforeIndex == 0 {
                self.sections.insert(movedSection, at: 0)
            } else {
                beforeIndex = self.sections.index(before: beforeIndex)
                self.sections.insert(movedSection, at: beforeIndex)
            }

            var snapshot = self.dataSource.snapshot()
            snapshot.moveSection(movedSection.listIdentifier, beforeSection: beforeSection.listIdentifier)

            self.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
    }

    func delete(sections: [ListSection], animatingDifferences: Bool, completion: (() -> Void)?) {
        throttler.run { [weak self] in
            guard let self else { return }

            let uniqueSections = self.makeSectionsUniqueuForRemove(sections)
            guard !uniqueSections.isEmpty else { return }

            self.sections = self.sections
                .filter { section in sections.contains(where: { $0.listIdentifier != section.listIdentifier }) }

            var snapshot = self.dataSource.snapshot()
            snapshot.deleteSections(uniqueSections.map(\.listIdentifier))

            self.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
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

extension NewDiffableDataSource: ListContext {
    var reusableHelper: ListReusableViewHelperProtocol {
        _reusableHelper
    }

    var listSize: CGSize {
        collectionView?.bounds.size ?? .zero
    }

    func update(
        section: ListSection,
        reconfigureItems: [ListIdentifiable],
        reloadHeaderAndFooter: Bool,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        self.update(
            section: section,
            reloadingItems: reconfigureItems,
            reloadingHeader: reloadHeaderAndFooter,
            reloadingFooter: reloadHeaderAndFooter,
            animatingDifferences: animatingDifferences,
            completion: completion
        )
    }

    func update(
        section: ListSection,
        reloadingItems: [ListIdentifiable],
        reloadingHeader: Bool,
        reloadingFooter: Bool,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        throttler.run { [weak self] in
            guard let self = self else { return }

            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>()
            sectionSnapshot.append(self.uniqueItemIdentifiers(in: section))

            self.apply(
                sectionSnapshot,
                to: section.listIdentifier,
                animatingDifferences: animatingDifferences
            ) { [weak self] in
                if !reloadingItems.isEmpty {
                    self?.reloadCells(for: reloadingItems, in: section)
                }
                if reloadingHeader {
                    self?.reloadHeader(in: section)
                }
                if reloadingFooter {
                    self?.reloadFooter(in: section)
                }
                completion?()
            }
        }
    }
    
    func append(
        section: ListSection,
        items: [ListIdentifiable],
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        throttler.run { [weak self] in
            guard let self = self else { return }

            var snapshot = self.dataSource.snapshot(for: section.listIdentifier)
            snapshot.append(self.uniqueItemIdentifiers(for: items, in: section))

            self.apply(
                snapshot,
                to: section.listIdentifier,
                animatingDifferences: animatingDifferences,
                completion: completion
            )
        }
    }

    func reload(section: ListSection, completion: (() -> Void)?) {
        self.update(
            section: section,
            reloadingItems: section.items,
            reloadingHeader: true,
            reloadingFooter: true,
            animatingDifferences: false,
            completion: completion
        )
    }

    func delete(section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        delete(sections: [section], animatingDifferences: animatingDifferences, completion: completion)
    }

    func reconfigureItems(
        _ items: [ListIdentifiable],
        in section: ListSection,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        throttler.run { [weak self] in
            guard let self = self else { return }

            let identifiers = self.uniqueItemIdentifiers(for: items, in: section)
            var snapshot = self.dataSource.snapshot()

            guard
                !identifiers.isEmpty,
                snapshot.indexOfSection(section.listIdentifier) != nil,
                Set(identifiers).subtracting(Set(snapshot.itemIdentifiers(inSection: section.listIdentifier))).isEmpty
            else { return }

            if #available(iOS 15.0, *) {
                snapshot.reconfigureItems(identifiers)
            } else {
                snapshot.reloadItems(identifiers)
            }

            self.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
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
            collectionView.setContentOffset(topOfHeader, animated: animated)
        }
    }

    func insertItems(
        _ items: [ListIdentifiable],
        afterItem: ListIdentifiable,
        in section: ListSection,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        throttler.run { [weak self] in
            guard let self = self else { return }

            var snapshot = self.dataSource.snapshot(for: section.listIdentifier)
            snapshot.insert(
                self.uniqueItemIdentifiers(for: items, in: section),
                after: self.itemIdentifier(for: afterItem, in: section)
            )

            self.apply(
                snapshot,
                to: section.listIdentifier,
                animatingDifferences: animatingDifferences,
                completion: completion
            )
        }
    }

    func insertItems(
        _ items: [ListIdentifiable],
        beforeItem: ListIdentifiable,
        in section: ListSection,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        throttler.run { [weak self] in
            guard let self = self else { return }

            var snapshot = self.dataSource.snapshot(for: section.listIdentifier)
            snapshot.insert(
                self.uniqueItemIdentifiers(for: items, in: section),
                before: self.itemIdentifier(for: beforeItem, in: section)
            )

            self.apply(
                snapshot,
                to: section.listIdentifier,
                animatingDifferences: animatingDifferences,
                completion: completion
            )
        }
    }

    func deleteItems(
        _ items: [ListIdentifiable],
        in section: ListSection,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        throttler.run { [weak self] in
            guard let self = self else { return }

            var snapshot = self.dataSource.snapshot(for: section.listIdentifier)
            snapshot.delete(self.uniqueItemIdentifiers(for: items, in: section))

            self.apply(
                snapshot,
                to: section.listIdentifier,
                animatingDifferences: animatingDifferences,
                completion: completion
            )
        }
    }

    func moveItem(
        _ item: ListIdentifiable,
        afterItem toItem:
        ListIdentifiable,
        in section: ListSection,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        throttler.run { [weak self] in
            guard let self = self else { return }

            var snapshot = self.dataSource.snapshot()
            snapshot.moveItem(item.listIdentifier, afterItem: toItem.listIdentifier)

            self.apply(
                snapshot,
                animatingDifferences: animatingDifferences,
                completion: completion
            )
        }
    }

    func moveItem(_ item: ListIdentifiable, beforeItem toItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        throttler.run { [weak self] in
            guard let self = self else { return }

            var snapshot = self.dataSource.snapshot()
            snapshot.moveItem(item.listIdentifier, beforeItem: toItem.listIdentifier)

            self.apply(
                snapshot,
                animatingDifferences: animatingDifferences,
                completion: completion
            )
        }
    }

    func index(for section: ListSection) -> Int? {
        if #available(iOS 15.0, *) {
            return dataSource.index(for: section.listIdentifier)
        } else {
            return dataSource.snapshot().sectionIdentifiers.firstIndex(of: section.listIdentifier)
        }
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
            let view = collectionView?.supplementaryView(forElementKind: kind, at: indexPath)
        else { return }

        if kind == UICollectionView.elementKindSectionHeader {
            section.supplementaryViewSource?.configureHeader(headerView: view, at: indexPath)
        } else if kind == UICollectionView.elementKindSectionFooter {
            section.supplementaryViewSource?.configureFooter(footerView: view, at: indexPath)
        } else {
            section.supplementaryViewSource?.configureSupplementaryView(view: view, kind: kind, at: indexPath)
        }
    }
}

extension NewDiffableDataSource {
    func apply(
        _ snapshot: NSDiffableDataSourceSnapshot<String, String>,
        shouldUseReload: Bool = false,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        if shouldUseReload, #available(iOS 15.0, *) {
            dataSource.applySnapshotUsingReloadData(snapshot, completion: completion)
        } else {
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
    }

    func apply(
        _ snapshot: NSDiffableDataSourceSectionSnapshot<String>,
        to section: String,
        animatingDifferences: Bool,
        completion: (() -> Void)?
    ) {
        dataSource.apply(
            snapshot,
            to: section,
            animatingDifferences: animatingDifferences,
            completion: completion
        )
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

private extension NewDiffableDataSource {
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

extension NewDiffableDataSource {
//    func runSectionOperations(_ operations: [ListSectionOperation], isAnimated: Bool) {
//        var snapshot = dataSource.snapshot()
//        var completions = [() -> Void]()
//        
//        for operation in operations {
//            switch operation {
//            case let .append(section, items, completion):
//                makeAppend(in: &snapshot, to: section, items: items)
//                if let completion = completion {
//                    completions.append(completion)
//                }
//            case let .update(section, reloadingItems, reloadingHeader, reloadingFooter, completion):
//                makeUpdate(in: &snapshot, to: section)
//                completions.append { [weak self] in
//                    if !reloadingItems.isEmpty {
//                        self?.reloadCells(for: reloadingItems, in: section)
//                    }
//                    if reloadingHeader {
//                        self?.reloadHeader(in: section)
//                    }
//                    if reloadingFooter {
//                        self?.reloadFooter(in: section)
//                    }
//                    completion?()
//                }
//            case let .reconfigure(section, items, completion):
//                makeReconfigure(in: &snapshot, to: section, items: items)
//                if let completion = completion {
//                    completions.append(completion)
//                }
//            case let .insertAfter(section, items, afterItem, completion):
//                makeInsertAfter(in: &snapshot, to: section, items: items, afterItem: afterItem)
//                if let completion = completion {
//                    completions.append(completion)
//                }
//            case let .insertBefore(section, items, beforeItem, completion):
//                makeInsertBefore(in: &snapshot, to: section, items: items, beforeItem: beforeItem)
//                if let completion = completion {
//                    completions.append(completion)
//                }
//            case let .delete(section, items, completion):
//                makeDelete(in: &snapshot, to: section, items: items)
//                if let completion = completion {
//                    completions.append(completion)
//                }
//            case let .moveBefore(section, item, beforeItem, completion):
//                makeMoveBefore(in: &snapshot, to: section, item: item, beforeItem: beforeItem)
//                if let completion = completion {
//                    completions.append(completion)
//                }
//            case let .moveAfter(section, item, afterItem, completion):
//                makeMoveAfter(in: &snapshot, to: section, item: item, afterItem: afterItem)
//                if let completion = completion {
//                    completions.append(completion)
//                }
//            }
//        }
//        
//        apply(snapshot, animatingDifferences: isAnimated) {
//            completions.forEach { $0() }
//        }
//    }
}

// MARK: - Section snapshot operations

//private extension NewDiffableDataSource {
//    func makeAppend(
//        in snapshot: inout NSDiffableDataSourceSnapshot<String, String>,
//        to section: ListSection,
//        items: [ListIdentifiable]
//    ) {
//        let uniqueItems = uniqueItemIdentifiers(for: items, in: section)
//        snapshot.appendItems(uniqueItems, toSection: section.listIdentifier)
//    }
//    
//    func makeUpdate(
//        in snapshot: inout NSDiffableDataSourceSnapshot<String, String>,
//        to section: ListSection
//    ) {
//        guard snapshot.indexOfSection(section.listIdentifier) != nil else { return }
//        let items = snapshot.itemIdentifiers(inSection: section.listIdentifier)
//        snapshot.deleteItems(items)
//        let newItems = uniqueItemIdentifiers(in: section)
//        snapshot.appendItems(newItems, toSection: section.listIdentifier)
//    }
//    
//    func makeReconfigure(
//        in snapshot: inout NSDiffableDataSourceSnapshot<String, String>,
//        to section: ListSection,
//        items: [ListIdentifiable]
//    ) {
//        let identifiers = uniqueItemIdentifiers(for: items, in: section)
//        
//        guard
//            !identifiers.isEmpty,
//            snapshot.indexOfSection(section.listIdentifier) != nil,
//            Set(identifiers).subtracting(Set(snapshot.itemIdentifiers(inSection: section.listIdentifier))).isEmpty
//        else { return }
//        
//        if #available(iOS 15.0, *) {
//            snapshot.reconfigureItems(identifiers)
//        } else {
//            snapshot.reloadItems(identifiers)
//        }
//    }
//    
//    func makeInsertAfter(
//        in snapshot: inout NSDiffableDataSourceSnapshot<String, String>,
//        to section: ListSection,
//        items: [ListIdentifiable],
//        afterItem: ListIdentifiable
//    ) {
//        snapshot.insertItems(
//            uniqueItemIdentifiers(for: items, in: section),
//            afterItem: itemIdentifier(for: afterItem, in: section)
//        )
//    }
//    
//    func makeInsertBefore(
//        in snapshot: inout NSDiffableDataSourceSnapshot<String, String>,
//        to section: ListSection,
//        items: [ListIdentifiable],
//        beforeItem: ListIdentifiable
//    ) {
//        snapshot.insertItems(
//            uniqueItemIdentifiers(for: items, in: section),
//            beforeItem: itemIdentifier(for: beforeItem, in: section)
//        )
//    }
//    
//    func makeDelete(
//        in snapshot: inout NSDiffableDataSourceSnapshot<String, String>,
//        to section: ListSection,
//        items: [ListIdentifiable]
//    ) {
//        snapshot.deleteItems(uniqueItemIdentifiers(for: items, in: section))
//    }
//    
//    func makeMoveBefore(
//        in snapshot: inout NSDiffableDataSourceSnapshot<String, String>,
//        to section: ListSection,
//        item: ListIdentifiable,
//        beforeItem: ListIdentifiable
//    ) {
//        snapshot.moveItem(
//            itemIdentifier(for: item, in: section),
//            beforeItem: itemIdentifier(for: beforeItem, in: section)
//        )
//    }
//    
//    func makeMoveAfter(
//        in snapshot: inout NSDiffableDataSourceSnapshot<String, String>,
//        to section: ListSection,
//        item: ListIdentifiable,
//        afterItem: ListIdentifiable
//    ) {
//        snapshot.moveItem(
//            itemIdentifier(for: item, in: section),
//            afterItem: itemIdentifier(for: afterItem, in: section)
//        )
//    }
//}
