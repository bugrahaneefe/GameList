//
//  GameCellBanner.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 29.08.2024.
//

import UIKit
import CoreUtils
import SwiftUI

public protocol GameCellBannerViewInterface {
    func setBannerImage(path: String?)
    func setGameNameLabel(name: String?)
    func setRating(rating: Int)
    func setPlatforms(with platforms: [String])
    func prepareUI()
}

public final class GameCellBanner: UICollectionViewCell {
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var gameNameLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet weak var gamePlatformView: UIView!
    
    public var presenter: GameCellBannerPresenterInterface! {
        didSet {
            presenter?.load()
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        bannerImageView.image = nil
    }
    
    //MARK: Private Functions
    private func setGamePlatformView(with platforms: [String]) {
        let child = UIHostingController(rootView: GameCellBannerPlatformView(buttonNames: platforms))
        let swiftuiView = child.view!
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false
        gamePlatformView.addSubview(swiftuiView)

        NSLayoutConstraint.activate([
            swiftuiView.leadingAnchor.constraint(equalTo: gamePlatformView.leadingAnchor),
            swiftuiView.topAnchor.constraint(equalTo: gamePlatformView.topAnchor),
            swiftuiView.bottomAnchor.constraint(equalTo: gamePlatformView.bottomAnchor),
            swiftuiView.widthAnchor.constraint(equalTo: gamePlatformView.widthAnchor)
        ])
    }
}

// MARK: - GameCellBannerViewInterface
extension GameCellBanner: GameCellBannerViewInterface {
    public func setBannerImage(path: String?) {
        self.bannerImageView.setImageWith(url: path)
    }
    
    public func setGameNameLabel(name: String?) {
        self.gameNameLabel.text = name
    }
 
    public func setRating(rating: Int) {
        self.ratingLabel.text = "\(rating)"
        if rating > 80 {
            self.ratingView.backgroundColor = UIColor.RatingViewColor.RatingViewGreen
            self.ratingLabel.textColor = UIColor.RatingViewColor.RatingLabelGreen
        } else if rating > 60 {
            self.ratingView.backgroundColor = UIColor.RatingViewColor.RatingViewOrange
            self.ratingLabel.textColor = UIColor.RatingViewColor.RatingLabelOrange
        } else {
            self.ratingView.backgroundColor = UIColor.RatingViewColor.RatingViewRed
            self.ratingLabel.textColor = UIColor.RatingViewColor.RatingLabelRed
        }
        ratingView.layer.cornerRadius = 3
    }
    
    public func setPlatforms(with platforms: [String]) {
        setGamePlatformView(with: platforms)
    }
    
    public func prepareUI() {
        
    }
}
