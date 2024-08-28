//
//  UIImageView+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
    public func setImageWith(url: String?) {
        if let url = url {
            AF.request(url).responseImage { response in
                if case .success(let image) = response.result {
                    self.image = image
                }
            }
        }
    }
}
