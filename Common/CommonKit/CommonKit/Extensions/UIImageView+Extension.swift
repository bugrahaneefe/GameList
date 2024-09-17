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

extension UIImage {
    public static let gameController = UIImage(systemName: "gamecontroller")
    public static let gameControllerFill = UIImage(systemName: "gamecontroller.fill")
    public static let heart = UIImage(systemName: "heart")
    public static let heartFill = UIImage(systemName: "heart.fill")
    public static let rightBarIcon = UIImage(systemName: "line.3.horizontal")
    
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
    public func setImageWith(url: String?) {
        guard let url = url, let imageUrl = URL(string: url) else {
            self.image = nil
            return
        }
        
        if let cachedImage = ImageCache.shared.object(forKey: NSString(string: url)) {
            self.image = cachedImage
            return
        }
        
        self.image = UIImage.gameControllerFill
        
        AF.request(imageUrl).responseImage { response in
            if case .success(let image) = response.result {
                ImageCache.shared.setObject(image, forKey: NSString(string: url))
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
