//
//  ImpressionDisplaySection.swift
//  ListingKit
//
//  Created by M.Yusuf on 8.04.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

/// The methods adopted by the object that conforms to ``ListSection`` that wants to get impression callbacks.
///
/// ``ListingKit`` comes with impression handling. When creating ``ListDataSource`` provide `true` for the `collectImpression` parameter.
/// ```swift
/// let dataSource = ListDataSource(collectImpression: true)
/// ```
///
/// While user is scrolling the list if the cell is visible more than %50 then ``ListDataSource`` calls sections ``didHaveImpression(for:at:)`` method. If the cell already has impression event before ``ListDataSource`` won't call it again. So you don't need to keep track of which cell's impression event is sent.
public protocol ImpressionDisplaySection {
    /// Tells the section that the impression event happened for the specified item at the given index path
    /// - Parameters:
    ///   - item: Identifier of the item whose cell is visible in collection view.
    ///   - indexPath: index path of the item.
    func didHaveImpression(for item: String, at indexPath: IndexPath)
}
