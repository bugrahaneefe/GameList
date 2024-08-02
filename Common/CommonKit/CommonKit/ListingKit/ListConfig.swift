//
//  ListConfig.swift
//  ListingKit
//
//  Created by Mustafa Yusuf on 1.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

/// Provides various configurations for ListingKit
struct ListConfig {
    let collectImpression: Bool
    let alwaysUseReloadDataSource: Bool
    let prefetchingEnabled: Bool
    let useNewDiffableDataSource: Bool
    
    init(collectImpression: Bool = false, alwaysUseReloadDataSource: Bool = false, prefetchingEnabled: Bool = false, useNewDiffableDataSource: Bool = false) {
        self.collectImpression = collectImpression
        self.alwaysUseReloadDataSource = alwaysUseReloadDataSource
        self.prefetchingEnabled = prefetchingEnabled
        self.useNewDiffableDataSource = useNewDiffableDataSource
    }
}
