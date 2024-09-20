//
//  View+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 20.09.2024.
//

import SwiftUI
import UIKit

extension UIView {
    public func setupWithSwiftUIView<Content: View>(
        with rootView: Content,
        parentViewController: UIViewController? = nil,
        parentCollectionViewCell: UICollectionViewCell? = nil,
        height: CGFloat? = nil,
        width: CGFloat? = nil
    ) {
        let hostingController = UIHostingController(rootView: rootView)
        let swiftUIView = hostingController.view!
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false

        if parentViewController != nil {
            parentViewController?.addChild(hostingController)
            hostingController.sizingOptions = .preferredContentSize
            hostingController.didMove(toParent: parentViewController)
            parentViewController?.view.layoutIfNeeded()
        }
        
        var constraints = [
            swiftUIView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            swiftUIView.topAnchor.constraint(equalTo: self.topAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        if let height {
            constraints.append(swiftUIView.heightAnchor.constraint(equalToConstant: height))
        }
        if let width {
            constraints.append(swiftUIView.widthAnchor.constraint(equalToConstant: width))
        }
        self.addSubview(swiftUIView)
        NSLayoutConstraint.activate(constraints)
    }
}
