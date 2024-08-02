//
//  ListPaginationDelegate.swift
//  ListingKit
//
//  Created by M.Yusuf on 11.04.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

/// The protocol that is adapted to get pagination callbacks.
///
/// ``ListingKit`` will call this method repeatedly as the cell's are visible in the collection view.
public protocol ListPaginationDelegate: AnyObject {
    /// Tells the delegate specified section at index is visible in collection view
    ///
    /// Implement custom logic to trigger your own pagination here.
    /// - Parameters:
    ///   - section: The index of the section that is just become visible in the collection view
    ///   - sectionCount: The total number of the section in collection view.
    func willDisplayForPagination(section: Int, sectionCount: Int)
}
