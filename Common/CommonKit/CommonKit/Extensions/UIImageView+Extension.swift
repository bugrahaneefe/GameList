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
    static let shared = NSCache<NSString, UIImage>()
}

// todo sdwebimage
extension UIImageView {
    public func setImageWith(url: String?) {
        guard let url = url, let imageUrl = URL(string: url) else { return }
        
        if let cachedImage = ImageCache.shared.object(forKey: NSString(string: url)) {
            self.image = cachedImage
            return
        }
        AF.request(url).responseImage { response in
            if case .success(let image) = response.result {
                self.image = image
            }
        }
    }
}
