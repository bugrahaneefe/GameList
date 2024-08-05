//
//  UIImageView+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import UIKit
import CoreUtils
import SDWebImage

public enum ImageCache {
    public static var imageCachePurgeThreshold: Int = 0
}

fileprivate enum Constant {
    static let numberOfListingItemsLoaded = "numberOfListingItemsLoaded"
}

public typealias ImageLoadingErrorCompletion = (_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void

public extension UIImageView {
    /// Asynchronously downloads an image from the specified URL, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
    /// If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
    ///
    /// - Parameters:
    ///   - path: The string path for the image.
    ///   - placeholder: The image to be set initially, until the image request finishes. Default value is `nil`
    ///   - completion: A block called when operation has been completed. This block has no return value and takes the requested UIImage as first parameter. In case of error the image parameter is nil and the second parameter may contain an NSError. The third parameter is the original image url. Default value is `nil`
    @objc
    func setImageWith(path: String?,
                      placeholder: UIImage? = nil,
                      completion: ImageLoadingErrorCompletion? = nil) {
        guard let unwrappedPath = path?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), let url = URL(string: unwrappedPath) else { return }
        sd_setImage(with: url, placeholderImage: placeholder) { image, error, _, url in
            completion?(image, error, url)
        }
    }

    /// Asynchronously downloads an image from the specified URL, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
    /// If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
    ///
    /// - Parameters:
    ///   - path: The string path for the image.
    ///   - placeholder: The image to be set initially, until the image request finishes. Default value is `nil`
    ///   - options: WebCache options. Default value is []
    ///   - completion: A block called when operation has been completed. This block has no return value and takes the requested UIImage as first parameter. In case of error the image parameter is nil and the second parameter may contain an NSError. The third parameter is the original image url. Default value is `nil`
    @objc
    func setImageWith(path: String?,
                      placeholder: UIImage? = nil,
                      options: SDWebImageOptions = [],
                      completion: ImageLoadingErrorCompletion? = nil) {
        guard let unwrappedPath = path?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), let url = URL(string: unwrappedPath) else { return }
        sd_setImage(with: url, placeholderImage: placeholder, options: options) { image, error, _, url in
            completion?(image, error, url)
        }
    }

    /// Asynchronously downloads an image from the specified URL, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
    /// If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
    ///
    /// - Parameters:
    ///   - path: The string path for the image.
    ///   - placeholder: The image to be set initially, until the image request finishes. Default value is `nil`
    ///   - shouldDownsampleImage: To decide image should be down sampled within its frame. Defaults value is `false`
    ///   - completion: A block called when operation has been completed. This block has no return value and takes the requested UIImage as first parameter. In case of error the image parameter is nil and the second parameter may contain an NSError. The third parameter is the original image url. Default value is `nil`
    @objc
    func setImageWith(path: String?,
                      placeholder: UIImage? = nil,
                      completion: ImageLoadingErrorCompletion? = nil,
                      shouldDownsampleImage: Bool = false) {
        guard let unwrappedPath = path?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), let url = URL(string: unwrappedPath) else { return }
        if shouldDownsampleImage {
            let scale = UIScreen.main.scale
            let thumbnailSize = CGSize(width: frame.size.width * scale, height: frame.size.height * scale)
            sd_setImage(with: url, placeholderImage: placeholder, context: [.imageThumbnailPixelSize: thumbnailSize], progress: nil) { image, error, _, url in
                completion?(image, error, url)
            }
        } else {
            setImageWith(path: path, placeholder: placeholder, completion: completion)
        }
    }

    func setImage(named: String, for bundle: Bundle) {
        image = UIImage(named: named, in: bundle, compatibleWith: nil)
    }

    func rounded() {
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
    }

    func calculateNewHeightWithAspectRatio(from image: UIImage) -> CGFloat {
        let ratio = image.size.width / image.size.height
        return frame.width / ratio
    }

    func calculateNewWidthWithAspectRatio(from image: UIImage?, frameHeight: CGFloat) -> CGFloat {
        guard let image = image else { return .zero }
        let ratio = image.size.height / image.size.width
        return frameHeight / ratio
    }
}

public extension UIButton {
    func setImage(named: String, state: UIControl.State, for bundle: Bundle) {
        setImage(UIImage(named: named, in: bundle, compatibleWith: nil), for: state)
    }
}

// MARK: - Hidable
public extension UIImageView {
    var hidableImage: UIImage? {
        get { return image }
        set {
            image = newValue
            isHidden = newValue.isNil
        }
    }
}
