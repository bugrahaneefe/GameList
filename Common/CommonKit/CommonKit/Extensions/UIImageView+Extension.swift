//
//  UIImageView+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import UIKit
import SDWebImage

extension UIImageView {
    public func loadFrom(url: URL, placeholder: UIImage? = nil) {
        self.sd_setImage(
            with: url,
            placeholderImage: placeholder
        )
    }
}

extension UIImage {
    public func resizedImage(Size sizeImage: CGSize) -> UIImage?
    {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sizeImage.width, height: sizeImage.height))
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        self.draw(in: frame)
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.withRenderingMode(.alwaysOriginal)
        return resizedImage
    }
}
