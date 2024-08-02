//
//  Storyboards.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 2.08.2024.
//

import CommonKit

enum Storyboards: StoryboardProtocol {
    case home

    var identifier: String {
        switch self {
        case .home: return "Home"
        }
    }

    var bundle: Bundle { .module }
}
