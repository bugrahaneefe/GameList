//
//  ImageSource.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 22.09.2024.
//

import UIKit

public protocol ImageSource: RawRepresentable where RawValue == String {
    var bundle: Bundle? { get }
    var compatibleWith: UITraitCollection? { get }
}

public extension ImageSource {
    var compatibleWith: UITraitCollection? { return nil }
    var uiImage: UIImage? { UIImage(self) }
}

public extension UIImage {
    convenience init?<T: ImageSource>(_ image: T) {
        self.init(named: image.rawValue, in: image.bundle, compatibleWith: image.compatibleWith)
    }
}
