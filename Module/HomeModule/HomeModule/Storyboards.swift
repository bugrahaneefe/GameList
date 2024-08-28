//
//  Storyboards.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 2.08.2024.
//

import CommonKit
import CoreUtils
import Foundation

enum Storyboards: StoryboardProtocol {
    case home
    case gameDetail

    var identifier: String {
        switch self {
        case .home: return "Home"
        case .gameDetail: return "GameDetail"
        }
    }

    var bundle: Bundle { .module }
}
