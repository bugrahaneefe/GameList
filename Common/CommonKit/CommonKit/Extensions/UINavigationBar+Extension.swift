//
//  UINavigationBar+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 26.08.2024.
//

import UIKit

public extension UINavigationBar {
    func setTitleTextAttributes(attributes: [NSAttributedString.Key: Any]) {
        standardAppearance.titleTextAttributes = attributes

        if #available(iOS 15.0, *) {
            scrollEdgeAppearance = standardAppearance
        }
    }
    
    func configureNavigationBar(isTranslucent: Bool, backgroundImage: UIImage?, shadowColor: UIColor?, backgroundColor: UIColor) {
        self.isTranslucent = isTranslucent
        standardAppearance.backgroundImage = backgroundImage
        standardAppearance.backgroundColor = backgroundColor
        standardAppearance.backgroundEffect = .none

        if #available(iOS 15.0, *) {
            scrollEdgeAppearance = standardAppearance
        }
    }
}
