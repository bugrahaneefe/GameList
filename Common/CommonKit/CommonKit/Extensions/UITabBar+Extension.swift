//
//  UITabBar+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 26.08.2024.
//

import UIKit

public extension UITabBar {
    func setCustomAppearance(backgroundColor: UIColor? = nil) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        if let backgroundColor = backgroundColor {
            tabBarAppearance.backgroundColor = backgroundColor
        }
        
        self.standardAppearance = tabBarAppearance
        
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = tabBarAppearance
        }
    }
}
