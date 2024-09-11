//
//  Storyboards.swift
//  GameDetailModule
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import CommonKit
import CoreUtils
import Foundation

enum Storyboards: StoryboardProtocol {
    case gameDetail

    var identifier: String {
        switch self {
        case .gameDetail: return "GameDetail"
        }
    }

    var bundle: Bundle { .module }
}
