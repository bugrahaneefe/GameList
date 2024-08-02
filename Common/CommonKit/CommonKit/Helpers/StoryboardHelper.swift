//
//  StoryboardHelper.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 2.08.2024.
//

import UIKit

public protocol StoryboardProtocol {
    var identifier: String { get }
    var bundle: Bundle { get }
}

protocol StoryboardHelperProtocol {
    associatedtype Storyboard: StoryboardProtocol

    static func create(storyboard: Storyboard) -> UIStoryboard
}

public class StoryboardHelper<Storyboard: StoryboardProtocol>: StoryboardHelperProtocol {
    public static func create(storyboard: Storyboard) -> UIStoryboard {
        return UIStoryboard.init(name: storyboard.identifier, bundle: storyboard.bundle)
    }
}

public extension StoryboardProtocol where Self: RawRepresentable, RawValue == String {
    var identifier: String { rawValue }
}
