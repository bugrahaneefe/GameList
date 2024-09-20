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
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
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

extension UIImageView {
    public func loadFrom(url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        let cacheKey = url.absoluteString
        if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        AF.request(url).responseImage { [weak self] response in
            guard let self = self else { return }

            if case .success(let image) = response.result {
                ImageCache.shared.setImage(image, forKey: cacheKey)

                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
