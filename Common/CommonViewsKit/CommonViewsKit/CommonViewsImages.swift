//
//  CommonViewsImages.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 17.09.2024.
//

import CoreUtils
import Foundation

public enum CommonViewsImages: String, ImageSource, Equatable {
    case favoriteButton = "favoriteButton"
    case favoriteButtonTapped = "favoriteButtonTapped"
    case bannerCellAppearanceButton = "bannerCellAppearanceButton"
    case logoCellAppearanceButton = "logoCellAppearanceButton"
    case gamesIcon = "gamesIcon"
    case gamesIconTapped = "gamesIconTapped"

    public var bundle: Bundle? { .module }
}
