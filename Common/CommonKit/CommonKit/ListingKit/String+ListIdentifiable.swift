//
//  String+ListIdentifiable.swift
//  ListingKit
//
//  Created by Beyza İnce on 6.06.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

import Foundation

extension String: ListIdentifiable {
    public var listIdentifier: String { return self }
}
