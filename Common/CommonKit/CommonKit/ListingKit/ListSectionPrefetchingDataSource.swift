//
//  ListSectionPrefetchingDataSource.swift
//  ListingKit
//
//  Created by Omer Ulusal on 26.08.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

/// Conform this protocol in your section decleration to enable collection view prefetching for your section
public protocol ListSectionPrefetchingDataSource {
    
    /// Called to prefetch items at the given index paths
    /// - Parameter indexPaths: indexpaths of the items
    func prefetchItemsAt(_ indexPaths: [IndexPath])
    
    /// Called to cancel prefetch items at the given indexpaths
    /// - Parameter indexPaths: indexpaths of the items
    func cancelPrefetchingForItemsAt(_ indexPaths: [IndexPath])
}

public extension ListSectionPrefetchingDataSource {
    func cancelPrefetchingForItemsAt(_ indexPaths: [IndexPath]) { }
}
