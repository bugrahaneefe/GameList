//
//  AlertRepresentable.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 15.09.2024.
//

import UIKit

public protocol AlertPresentable: AnyObject {
    var navController: UIViewController? { get }

    func showAlert(title: String, message: String)
}

public extension AlertPresentable {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        navController?.present(alertController, animated: true, completion: nil)
    }
}
