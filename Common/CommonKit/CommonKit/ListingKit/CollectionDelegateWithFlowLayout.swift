//
//  StandardDelegate.swift
//  Listing
//
//  Created by Ersen Tekin on 17.01.2022.
//

import Foundation
import UIKit

final class CollectionDelegateWithFlowLayout: NSObject, ListDelegate {
    weak var dataSource: ListDataSourceProtocol?
    weak var collectionView: UICollectionView?
    var impressionHandler: ImpressionHandlerInterface?
    
    func prepare(for collectionView: UICollectionView, dataSource: ListDataSourceProtocol) {
        self.dataSource = dataSource
        self.collectionView = collectionView
        collectionView.delegate = self
    }
}

extension CollectionDelegateWithFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard
            let section = dataSource?.section(at: indexPath.section)
        else { return .zero }

        return section.size(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let section = dataSource?.section(at: section) else { return .zero }
        return section.inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = dataSource?.section(at: section) else { return .zero }
        return section.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = dataSource?.section(at: section) else { return .zero }
        return section.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let currentSection = dataSource?.section(at: section),
              let viewSource = currentSection.supplementaryViewSource else { return .zero }
        return viewSource.referenceSizeForHeaderView(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let currentSection = dataSource?.section(at: section),
              let viewSource = currentSection.supplementaryViewSource else { return .zero }
        return viewSource.referenceSizeForFooterView(section: section)
    }
}

extension CollectionDelegateWithFlowLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource?.collectionDelegate?.collectionView?(collectionView, didSelectItemAt: indexPath)

        guard
            let section = dataSource?.section(at: indexPath.section),
            let itemIdentifier = dataSource?.itemIdentifier(at: indexPath)
        else { return }

        section.didSelectItem(for: itemIdentifier, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        dataSource?.collectionDelegate?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)

        guard
            let section = dataSource?.section(at: indexPath.section)
        else { return }

        if let impressionHandler = impressionHandler {
            if collectionView.collectionViewLayout is UICollectionViewCompositionalLayout {
                let behavior = section.layout(in: nil)?.orthogonalScrollingBehavior
                let isOrthogonal = (behavior != .some(.none)) && (behavior != Optional.none)
                let scrollDirection = collectionView.scrollingDirection(isOrthogonal: isOrthogonal)

                DispatchQueue.main.async {
                    impressionHandler.calculateImpressions(for: collectionView, dataSource: self.dataSource, scrollDirection: scrollDirection, section: indexPath.section)
                }
            } else {
                DispatchQueue.main.async {
                    impressionHandler.calculateImpressions(for: collectionView, dataSource: self.dataSource, scrollDirection: collectionView.scrollingDirection(isOrthogonal: false), section: indexPath.section)
                }
            }
        }

        section.willDisplay(at: indexPath)

        if !section.hasPagination(for: indexPath) {
            dataSource?.paginationDelegate?.willDisplayForPagination(section: indexPath.section,
                                                                     sectionCount: dataSource?.sectionCount ?? 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        dataSource?.collectionDelegate?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)

        guard
            let section = dataSource?.section(at: indexPath.section)
        else { return }
        
        section.didEndDisplay(at: indexPath)
    }
}

extension CollectionDelegateWithFlowLayout: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dataSource?.scrollDelegate?.scrollViewDidScroll?(scrollView)
        impressionHandler?.calculateImpressions(for: collectionView, dataSource: dataSource, scrollDirection: collectionView?.scrollingDirection(isOrthogonal: false) ?? .vertical, section: nil)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        dataSource?.scrollDelegate?.scrollViewDidZoom?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dataSource?.scrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        dataSource?.scrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dataSource?.scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        dataSource?.scrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        dataSource?.scrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }


    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        dataSource?.scrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        dataSource?.scrollDelegate?.viewForZooming?(in: scrollView)
    }


    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        dataSource?.scrollDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        dataSource?.scrollDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }


    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        dataSource?.scrollDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        dataSource?.scrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }

    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        dataSource?.scrollDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}
