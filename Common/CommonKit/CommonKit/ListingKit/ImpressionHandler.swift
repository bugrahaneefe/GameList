//
//  ImpressionHandler.swift
//  ListingKit
//
//  Created by M.Yusuf on 9.04.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import UIKit

protocol ImpressionHandlerInterface {
    func calculateImpressions(for collectionView: UICollectionView?,
                              dataSource: ListDataSourceProtocol?,
                              scrollDirection: UICollectionView.ScrollDirection,
                              section: Int?)
}

final class ImpressionHandler: ImpressionHandlerInterface {
    private var impressionData: [String: Set<String>] = [:]

    func calculateImpressions(for collectionView: UICollectionView?,
                              dataSource: ListDataSourceProtocol?,
                              scrollDirection: UICollectionView.ScrollDirection,
                              section: Int?) {
        guard let collectionView = collectionView,
              let containerView = collectionView.superview else { return }

        collectionView.indexPathsForVisibleItems.forEach { indexPath in
            guard
                let cell = collectionView.cellForItem(at: indexPath),
                let cellSuperView = cell.superview
            else { return }

            if section != nil && indexPath.section != section {
                return
            }

            let cellFrameInContainer = cellSuperView.convert(cell.frame, to: containerView)
            let interSectionRect = cellFrameInContainer.intersection(containerView.bounds)

            var percentOfIntersection: CGFloat = 0.0
            switch scrollDirection {
            case .horizontal:
                percentOfIntersection = interSectionRect.width / cellFrameInContainer.width
            case .vertical: fallthrough
            @unknown default:
                percentOfIntersection = interSectionRect.height / cellFrameInContainer.height
            }

            guard percentOfIntersection > 0.5,
                  let section = dataSource?.section(at: indexPath.section),
                  let impressionSection = section as? ImpressionDisplaySection,
                  section.items.count > indexPath.item
            else { return }

            let itemId = section.items[indexPath.item].listIdentifier

            if var impressions = impressionData[section.listIdentifier] {
                if !impressions.contains(itemId) {
                    impressions.insert(itemId)
                    impressionData[section.listIdentifier] = impressions
                    impressionSection.didHaveImpression(for: itemId, at: indexPath)
                }
            } else {
                impressionData[section.listIdentifier] = [itemId]
                impressionSection.didHaveImpression(for: itemId, at: indexPath)
            }
        }
    }
}
