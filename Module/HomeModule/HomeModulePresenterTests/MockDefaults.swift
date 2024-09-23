//
//  MockDefaults.swift
//  HomeModulePresenterTests
//
//  Created by Buğrahan Efe on 23.09.2024.
//

import UIKit
import CommonKit

@testable import HomeModule

final class MockDefaults: DefaultsProtocol {
    
    public static var stubbedIsBannerStateActive = false

    public static func bool(key: String) -> Bool {
        if key == "isBannerStateActive" {
            return stubbedIsBannerStateActive
        }
        return false
    }
}
