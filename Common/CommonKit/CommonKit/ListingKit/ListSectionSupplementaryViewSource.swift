//
//  SectionSupplementaryViewSource.swift
//  Listing
//
//  Created by M.Yusuf on 11.01.2022.
//

import UIKit

/// The methods adopted by the object you use to create supplementary views for the ``ListSection``.
///
/// A list section supplementary view source creates header and footer views for section. It can also create custom supplementary views.
/// These views don't have to be registered in collectionview. ``ListingKit`` automatically registers them when they first dequeued. It is often the object that conforms ``ListSection`` also
/// conforms the ``ListSectionSupplementaryViewSource``. Also ``GenericSection`` conforms the ``ListSectionSupplementaryViewSource`` too.
public protocol ListSectionSupplementaryViewSource {
    /// Asks the view source to create header view at the given index
    /// - Parameter indexPath: the index path of the header view
    /// - Returns: A configured header view object
    ///
    func headerView(for indexPath: IndexPath) -> UICollectionReusableView?
    /// Asks the view source to create footer view at the given index
    /// - Parameter indexPath: the index path of the footer view
    /// - Returns: A configured footer view object
    func footerView(for indexPath: IndexPath) -> UICollectionReusableView?

    /// Asks the view source to create custom supplementary view.
    ///
    /// If the supplementary view kind is `UICollectionView.elementKindSectionFooter` or `UICollectionView.elementKindSectionHeader` ``ListDataSource`` won't call
    /// this method. This method will get called only for custom supplementary views.
    /// - Parameters:
    ///   - indexPath: the index path of the supplementary view
    ///   - kind: the string that describes the kind of the supplementary view.
    /// - Returns: A configured suppelementary view object
    func supplementaryView(for indexPath: IndexPath, kind: String) -> UICollectionReusableView?
    
    /// Asks the section to configure header view. You can use this method if you want to later reload header view. If header view is not needed to be reloaded later you can make configuration in ``ListSectionSupplementaryViewSource/headerView(for:)-6dfdh`` method.
    /// - Parameters:
    ///   - headerView: The header view that will be configured
    ///   - indexPath: Index path of the header view
    func configureHeader(headerView: UICollectionReusableView, at indexPath: IndexPath)
    
    /// Asks the section to configure its footer view. You can use this method if you want to later reload footer view. If footer view is not needed to be reloaded later you can make configuration in ``ListSectionSupplementaryViewSource/footerView(for:)-9kx9d`` method.
    /// - Parameters:
    ///   - footerView: The footer view that will be configured
    ///   - indexPath: Index path of the header view
    func configureFooter(footerView: UICollectionReusableView, at indexPath: IndexPath)
    
    /// Asks the section to configure its supplementary view. You can use this method if you want to later reload supplementary view. If supplementary view is not needed to be reloaded later you can make configuration in ``ListSectionSupplementaryViewSource/supplementaryView(for:kind:)-8aerr`` method.
    /// - Parameters:
    ///   - view: The supplementary view that will be configured
    ///   - kind: Kind of the supplementary view
    ///   - indexPath: Index path of the supplementary view
    func configureSupplementaryView(view: UICollectionReusableView, kind: String, at indexPath: IndexPath)

    /// Asks the view source to proved size for the header view.
    ///
    /// This method will be called when collection views layout is `UICollectionViewFlowLayout`.  When you use compositional layout don't implement it
    /// - Parameter section: section of the header view
    /// - Returns: size of the header view
    func referenceSizeForHeaderView(section: Int) -> CGSize

    /// Asks the view source to proved size for the footer view.
    ///
    /// This method will be called when collection views layout is `UICollectionViewFlowLayout`.  When you use compositional layout don't implement it
    /// - Parameter section: section of the footer view
    /// - Returns: size for the footer view
    func referenceSizeForFooterView(section: Int) -> CGSize


    /// Provides a way to add decoration views for section
    /// - Parameter layout: layout object that registers decoration views
    func registerDecorationViews(for layout: UICollectionViewLayout)
}

public extension ListSectionSupplementaryViewSource {
    func headerView(for indexPath: IndexPath) -> UICollectionReusableView? { nil }
    func footerView(for indexPath: IndexPath) -> UICollectionReusableView? { nil }
    func supplementaryView(for indexPath: IndexPath, kind: String) -> UICollectionReusableView? { return nil }
    func registerDecorationViews(for layout: UICollectionViewLayout) { }
    
    func referenceSizeForHeaderView(section: Int) -> CGSize { .zero }
    func referenceSizeForFooterView(section: Int) -> CGSize { .zero }
}

public extension ListSection where Self: ListSectionSupplementaryViewSource {
    var supplementaryViewSource: ListSectionSupplementaryViewSource? { self }
    
    func headerView<Header: UICollectionReusableView>() -> Header? {
        context?.supplementaryView(in: self, kind: UICollectionView.elementKindSectionHeader, for: nil)
    }

    func footerView<Footer: UICollectionReusableView>() -> Footer? {
        context?.supplementaryView(in: self, kind: UICollectionView.elementKindSectionFooter, for: nil)
    }

    func supplementaryView<View: UICollectionReusableView>(for item: ListIdentifiable, kind: String) -> View? {
        context?.supplementaryView(in: self, kind: kind, for: item)
    }
    
    /// Triggers ``ListSectionSupplementaryViewSource/configureFooter(footerView:at:)`` method for reloading sections header view.
    func reloadHeader() {
        context?.reloadHeader(in: self)
    }
    
    /// Triggers ``ListSectionSupplementaryViewSource/configureFooter(footerView:at:)`` method for reloading sections footer view.
    func reloadFooter() {
        context?.reloadFooter(in: self)
    }

    func configureHeader(headerView: UICollectionReusableView, at indexPath: IndexPath) { }

    func configureFooter(footerView: UICollectionReusableView, at indexPath: IndexPath) { }

    func configureSupplementaryView(view: UICollectionReusableView, kind: String, at indexPath: IndexPath) { }
}
