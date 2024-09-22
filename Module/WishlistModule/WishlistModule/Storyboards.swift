//
//  Storyboards.swift
//  WishlistModule
//
//  Created by Buğrahan Efe on 16.09.2024.
//

import CommonKit
import Foundation

enum Storyboards: StoryboardProtocol {
    case wishlist

    var identifier: String {
        switch self {
        case .wishlist: return "Wishlist"
        }
    }

    var bundle: Bundle { .module }
}
