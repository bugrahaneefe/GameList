//
//  UIImageView+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import UIKit
import Alamofire
import AlamofireImage

class ImageCache {
    static let shared = AutoPurgingImageCache()

    private init() {}
}

extension UIImageView {
    public func loadFrom(url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        let cacheKey = url.absoluteString
        
        if let cachedImage = ImageCache.shared.image(withIdentifier: cacheKey) {
            self.image = cachedImage
            return
        }
        
        self.af.setImage(withURL: url, placeholderImage: placeholder, imageTransition: .flipFromTop(0.2), runImageTransitionIfCached: true) { [weak self] response in
            guard let self = self, case .success(let image) = response.result else { return }
            
            ImageCache.shared.add(image, withIdentifier: cacheKey)
        }
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
