//
//  ReloadDataSource.swift
//  Listing
//
//  Created by M.Yusuf on 11.01.2022.
//

import UIKit

final class ReloadDataSource: NSObject, ListDataSourceProtocol {
    weak var viewController: UIViewController?
    weak var collectionView: UICollectionView?
    private(set) var sections: [ListSection] = []
    var listDelegate: ListDelegate?
    weak var scrollDelegate: UIScrollViewDelegate?
    weak var collectionDelegate: UICollectionViewDelegate?
    weak var paginationDelegate: ListPaginationDelegate?
    var sectionCount: Int { sections.count }
    private let config: ListConfig
    private let context = DefaultListContext()
    private let _reusableViewHelper = ListReusableViewHelper()
    private var prefetchingDataSource: CollectionViewWithPrefetchingDataSource?
    var queue: DispatchQueueProtocol = DispatchQueue.main

    init(config: ListConfig,
         viewController: UIViewController? = nil) {
        self.config = config
        self.viewController = viewController
        super.init()

        context.defaultContext = self
    }

    func prepare(for collectionView: UICollectionView) {
        _reusableViewHelper.collectionView = collectionView
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
        collectionView.dataSource = self
    }

    func append(newSections: [ListSection], animatingDifferences: Bool, completion: (() -> Void)?) {
        let appendStart = sections.count
        let appendEnd = appendStart + newSections.count

        queue.performAsync {
            self.collectionView?.performBatchUpdates({
                self.sections.append(contentsOf: newSections)
                newSections.forEach(self.configureSectionForFirstTime)
                self.collectionView?.insertSections(IndexSet.init(integersIn: appendStart..<appendEnd))
            }, completion: { _ in
                completion?()
            })
        }
    }

    func reload(newSections: [ListSection], completion: (() -> Void)?) {
        sections = newSections
        newSections.forEach(configureSectionForFirstTime)
        collectionView?.reloadData()
        completion?()
    }

    func update(newSections: [ListSection], reloadVisibleViews: Bool, animatingDifferences: Bool, completion: (() -> Void)?) {
        sections = newSections
        newSections.forEach(configureSectionForFirstTime)
        collectionView?.reloadData()
        completion?()
    }

    func insert(newSections: [ListSection], beforeSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        guard
            let sectionIndex = sections.firstIndex(where: { $0.listIdentifier == beforeSection.listIdentifier })
        else { return }

        let index = max(0, sections.index(before: sectionIndex))
        sections.insert(contentsOf: newSections, at: index)

        newSections.forEach(configureSectionForFirstTime)
        collectionView?.reloadData()
        completion?()
    }

    func insert(newSections: [ListSection], afterSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        guard
            let sectionIndex = sections.firstIndex(where: { $0.listIdentifier == afterSection.listIdentifier })
        else { return }

        let index = sections.index(after: sectionIndex)
        sections.insert(contentsOf: newSections, at: index)

        newSections.forEach(configureSectionForFirstTime)
        collectionView?.reloadData()
        completion?()
    }

    func delete(sections: [ListSection], animatingDifferences: Bool, completion: (() -> Void)?) {
        self.sections = self.sections.filter { section in
            !sections.contains { $0.listIdentifier == section.listIdentifier }
        }

        collectionView?.reloadData()
        completion?()
    }

    func move(section: ListSection, afterSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        var sections = self.sections
        guard
            let sectionIndex = sections.firstIndex(where: { $0.listIdentifier == section.listIdentifier })
        else { return }

        let removedSection = sections.remove(at: sectionIndex)

        guard
            let afterIndex = sections.firstIndex(where: { $0.listIdentifier == afterSection.listIdentifier })
        else { return }

        sections.insert(removedSection, at: sections.index(after: afterIndex))

        self.sections = sections
        collectionView?.reloadData()
        completion?()
    }

    func move(section: ListSection, beforeSection: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        var sections = self.sections
        guard
            let sectionIndex = sections.firstIndex(where: { $0.listIdentifier == section.listIdentifier })
        else { return }

        sections.remove(at: sectionIndex)

        guard
            let beforeIndex = sections.firstIndex(where: { $0.listIdentifier == beforeSection.listIdentifier })
        else { return }

        sections.insert(section, at: max(0, sections.index(before: beforeIndex)))

        self.sections = sections
        collectionView?.reloadData()
        completion?()
    }
    
    func section(at index: Int) -> ListSection? {
        guard sections.count > index else { return nil }
        return sections[index]
    }

    func itemIdentifier(at indexPath: IndexPath) -> String? {
        guard
            let section = section(at: indexPath.section),
            section.items.count > indexPath.item
        else { return nil }

        return section.items[indexPath.item].listIdentifier
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
            .map { sections[$0] }

        return visibleSections
    }
}

extension ReloadDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let section = section(at: indexPath.section),
            section.items.count > indexPath.item,
            let cell = section.cell(for: section.items[indexPath.item].listIdentifier, at: indexPath)
        else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.reusedentifier, for: indexPath)
        }
        
        section.configure(cell: cell, for: section.items[indexPath.item].listIdentifier, at: indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return section.supplementaryViewSource?.headerView(for: indexPath) ?? UICollectionReusableView()
        case UICollectionView.elementKindSectionFooter:
            return section.supplementaryViewSource?.footerView(for: indexPath) ?? UICollectionReusableView()
        default:
            guard let view = section.supplementaryViewSource?.supplementaryView(for: indexPath, kind: kind) else {
                return UICollectionReusableView()
            }

            return view
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

extension ReloadDataSource: ListContext {
    var reusableHelper: ListReusableViewHelperProtocol {
        _reusableViewHelper
    }

    var listSize: CGSize {
        collectionView?.bounds.size ?? .zero
    }

    func reconfigureItems(_ items: [ListIdentifiable], in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        collectionView?.reloadData()
        completion?()
    }
    
    func reloadCells(for items: [ListIdentifiable], in section: ListSection) {
        collectionView?.reloadData()
    }
    
    func reloadHeader(in section: ListSection) {
        collectionView?.reloadData()
    }
    
    func reloadFooter(in section: ListSection) {
        collectionView?.reloadData()
    }

    func reloadSupplementaryElement(kind: String, in section: ListSection, at indexPath: IndexPath) {
        collectionView?.reloadData()
    }

    func update(section: ListSection, reconfigureItems: [ListIdentifiable], reloadHeaderAndFooter: Bool, animatingDifferences: Bool, completion: (() -> Void)?) {
        collectionView?.reloadData()
        completion?()
    }
    
    func update(section: ListSection, reloadingItems: [ListIdentifiable], reloadingHeader: Bool, reloadingFooter: Bool, animatingDifferences: Bool, completion: (() -> Void)?) {
        collectionView?.reloadData()
        completion?()
    }
    
    func append(section: ListSection, items: [ListIdentifiable], animatingDifferences: Bool, completion: (() -> Void)?) {
        collectionView?.reloadData()
        completion?()
    }

    func reload(section: ListSection, completion: (() -> Void)?) {
        collectionView?.reloadData()
        completion?()
    }

    func delete(section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        delete(sections: [section], animatingDifferences: animatingDifferences, completion: completion)
    }

    func scrollTo(item: ListIdentifiable, in section: ListSection, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard
            let sectionIndex = index(for: section),
            let itemIndex = section.items.firstIndex(where: { $0.listIdentifier == item.listIdentifier })
        else { return }

        collectionView?.scrollToItem(at: IndexPath(item: itemIndex, section: sectionIndex),
                                     at: scrollPosition,
                                     animated: animated)
    }

    func insertItems(_ items: [ListIdentifiable], afterItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        collectionView?.reloadData()
        completion?()
    }

    func insertItems(_ items: [ListIdentifiable], beforeItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        collectionView?.reloadData()
        completion?()
    }

    func deleteItems(_ items: [ListIdentifiable], in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        collectionView?.reloadData()
        completion?()
    }

    func moveItem(_ item: ListIdentifiable, afterItem toItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        collectionView?.reloadData()
        completion?()
    }

    func moveItem(_ item: ListIdentifiable, beforeItem toItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        collectionView?.reloadData()
        completion?()
    }

    func index(for section: ListSection) -> Int? {
        sections.firstIndex { $0.listIdentifier == section.listIdentifier }
    }

    func cell<Cell>(for item: ListIdentifiable, in section: ListSection) -> Cell? where Cell : UICollectionViewCell {
        guard
            let sectionIndex = sections.firstIndex(where: { $0.listIdentifier == section.listIdentifier }),
            let itemIndex = section.items.firstIndex(where: { $0.listIdentifier == item.listIdentifier }),
            let cell = collectionView?.cellForItem(at: IndexPath(item: itemIndex, section: sectionIndex))
        else { return nil }

        return cell as? Cell
    }

    func supplementaryView<View: UICollectionReusableView>(in section: ListSection, kind: String, for item: ListIdentifiable?) -> View? {
        let itemIndex: Int
        if let item = item, let index = section.items.firstIndex(where: { $0.listIdentifier == item.listIdentifier }) {
            itemIndex = index
        } else {
            itemIndex = 0
        }

        guard
            let index = sections.firstIndex(where: { $0.listIdentifier == section.listIdentifier }),
            let view = collectionView?.supplementaryView(forElementKind: kind, at: IndexPath(item: itemIndex, section: index)) as? View
        else { return nil }

        return view
    }
    
    func relayout(animated: Bool, completion: (() -> Void)?) {
        if animated {
            collectionView?.performBatchUpdates({}, completion: { _ in completion?() })
        } else {
            collectionView?.reloadData()
            completion?()
        }
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
}
