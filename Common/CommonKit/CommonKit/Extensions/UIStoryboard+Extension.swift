//
//  UIStoryboard+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 22.09.2024.
//

import UIKit

public extension UIStoryboard {
    // Instantinate view from storyboard directly
    func instantiateViewController<T: UIViewController>(viewClass: T.Type) -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.className) as? T else { fatalError() }
        return viewController
    }

    // Instantinate view embed in navigation controller
    func instantiateViewControllerAsFirstViewControllerOfNavigationController<T: UIViewController>(viewClass: T.Type) -> T {
        guard let navigationController = instantiateViewController(withIdentifier: T.className) as? UINavigationController, let viewController = navigationController.viewControllers.first as? T else { fatalError() }
        return viewController
    }
}
