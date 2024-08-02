//
//  NSObject+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 2.08.2024.
//

import Foundation

public extension NSObject {
    @objc var className: String {
        return type(of: self).className
    }

    @objc static var className: String {
        return String(describing: self)
    }
}
