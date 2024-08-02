//
//  ListIdentifiable.swift
//  Listing
//
//  Created by M.Yusuf on 7.01.2022.
//

import Foundation

/// A class of types whose instances hold the value of an entity with stable identity.
///
/// Use the `ListIdentifiable` protocol to provide stable notion of identity to a class or value type to uniquely identify them inside ``ListingKit``
/// Every section in ``ListDataSource`` has to have unique identifer and every cell inside each section has to have unique identifier.
public protocol ListIdentifiable {
    var listIdentifier: String { get }
}
