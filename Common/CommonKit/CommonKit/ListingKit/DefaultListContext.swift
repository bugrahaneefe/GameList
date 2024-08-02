//
//  DefaultListContext.swift
//  ListingKit
//
//  Created by M.Yusuf on 22.04.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

class DefaultListContext: ListContext {
    weak var defaultContext: ListContext?

    var listSize: CGSize {
        defaultContext?.listSize ?? CGSize.zero
    }

    var viewController: UIViewController? {
        defaultContext?.viewController
    }

    var reusableHelper: ListReusableViewHelperProtocol {
        defaultContext!.reusableHelper
    }

    func reconfigureItems(_ items: [ListIdentifiable], in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        defaultContext?.reconfigureItems(items, in: section, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    func reloadCells(for items: [ListIdentifiable], in section: ListSection) {
        defaultContext?.reloadCells(for: items, in: section)
    }
    
    func reloadHeader(in section: ListSection) {
        defaultContext?.reloadHeader(in: section)
    }
    
    func reloadFooter(in section: ListSection) {
        defaultContext?.reloadFooter(in: section)
    }

    func reloadSupplementaryElement(kind: String, in section: ListSection, at indexPath: IndexPath) {
        defaultContext?.reloadSupplementaryElement(kind: kind, in: section, at: indexPath)
    }

    func update(section: ListSection, reconfigureItems: [ListIdentifiable], reloadHeaderAndFooter: Bool, animatingDifferences: Bool, completion: (() -> Void)?) {
        defaultContext?.update(section: section, reconfigureItems: reconfigureItems, reloadHeaderAndFooter: reloadHeaderAndFooter, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    func update(section: ListSection, reloadingItems: [ListIdentifiable], reloadingHeader: Bool, reloadingFooter: Bool, animatingDifferences: Bool, completion: (() -> Void)?) {
        defaultContext?.update(section: section, reloadingItems: reloadingItems, reloadingHeader: reloadingHeader, reloadingFooter: reloadingFooter, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    func append(section: ListSection, items: [ListIdentifiable], animatingDifferences: Bool, completion: (() -> Void)?) {
        defaultContext?.append(section: section, items: items, animatingDifferences: animatingDifferences, completion: completion)
    }

    func reload(section: ListSection, completion: (() -> Void)?) {
        defaultContext?.reload(section: section, completion: completion)
    }

    func delete(section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        defaultContext?.delete(section: section, animatingDifferences: animatingDifferences, completion: completion)
    }

    func scrollTo(item: ListIdentifiable, in section: ListSection, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        defaultContext?.scrollTo(item: item, in: section, at: scrollPosition, animated: animated)
    }

    func scrollToHeader(in section: ListSection, animated: Bool) {
        defaultContext?.scrollToHeader(in: section, animated: animated)
    }

    func insertItems(_ items: [ListIdentifiable], afterItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        defaultContext?.insertItems(items, afterItem: afterItem, in: section, animatingDifferences: animatingDifferences, completion: completion)
    }

    func insertItems(_ items: [ListIdentifiable], beforeItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        defaultContext?.insertItems(items, beforeItem: beforeItem, in: section, animatingDifferences: animatingDifferences, completion: completion)
    }

    func deleteItems(_ items: [ListIdentifiable], in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        defaultContext?.deleteItems(items, in: section, animatingDifferences: animatingDifferences, completion: completion)
    }

    func moveItem(_ item: ListIdentifiable, afterItem toItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        defaultContext?.moveItem(item, afterItem: toItem, in: section, animatingDifferences: animatingDifferences, completion: completion)
    }
    
    func moveItem(_ item: ListIdentifiable, beforeItem toItem: ListIdentifiable, in section: ListSection, animatingDifferences: Bool, completion: (() -> Void)?) {
        defaultContext?.moveItem(item, beforeItem: toItem, in: section, animatingDifferences: animatingDifferences, completion: completion)
    }

    func index(for section: ListSection) -> Int? {
        defaultContext?.index(for: section)
    }

    func itemIdentifier(at indexPath: IndexPath) -> String? {
        defaultContext?.itemIdentifier(at: indexPath)
    }

    func cell<Cell>(for item: ListIdentifiable, in section: ListSection) -> Cell? where Cell : UICollectionViewCell {
        defaultContext?.cell(for: item, in: section)
    }

    func supplementaryView<View: UICollectionReusableView>(in section: ListSection, kind: String, for item: ListIdentifiable?) -> View? {
        defaultContext?.supplementaryView(in: section, kind: kind, for: item)
    }

    func relayout(animated: Bool, completion: (() -> Void)?) {
        defaultContext?.relayout(animated: animated, completion: completion)
    }
}
