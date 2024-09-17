//
//  CommonViewsImages.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 17.09.2024.
//

import CoreUtils
import Foundation

enum CommonViewsImages: String, ImageSource, Equatable {
    case favoriteButton = "favoriteButton"
    case favoriteButtonTapped = "favoriteButtonTapped"

    var bundle: Bundle? { .module }
}

