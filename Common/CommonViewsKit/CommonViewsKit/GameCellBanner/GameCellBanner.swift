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
    func setGameNameLabel(name: String?, isAlreadyClicked: Bool)
    func setRating(rating: Int)
    func setPlatforms(with platforms: [String])
    func setDetails(with infos: [(name: String, value: String)])
    func setFavoriteButton(selected: Bool)
}

private enum Constant {
    enum Thresholds {
        static let Green = 75
        static let Orange = 50
    }
}

public final class GameCellBanner: UICollectionViewCell {
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var gameNameLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet weak var gamePlatformView: UIView!
    @IBOutlet weak var gameDetailsView: UIView!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    
    public var presenter: GameCellBannerPresenterInterface! {
        didSet {
            presenter?.load()
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        bannerImageView.image = CommonViewsImages.gamesIcon.uiImage
        gameNameLabel.textColor = .white
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        presenter.favoriteButtonTapped(isSelected: favoriteButton.isSelected)
    }
    
    //MARK: Private Functions
    private func setGamePlatformView(with platforms: [String]) {
        gamePlatformView.setupWithSwiftUIView(
            with: GameCellBannerPlatformView(buttonNames: platforms),
            parentCollectionViewCell: self)
    }
    
    private func setGameDetailsView(with infos: [(name: String, value: String)]) {
        gameDetailsView.setupWithSwiftUIView(
            with: GameCellBannerDetailsView(infos: infos),
            parentCollectionViewCell: self)
    }
}

// MARK: - GameCellBannerViewInterface
extension GameCellBanner: GameCellBannerViewInterface {
    public func setBannerImage(path: String?) {
        guard let urlString = path else { return }
        if let url = URL(string: urlString) {
            self.bannerImageView.loadFrom(url: url, placeholder: CommonViewsImages.gamesIcon.uiImage)
        }
    }
    
    public func setGameNameLabel(name: String?, isAlreadyClicked: Bool) {
        if isAlreadyClicked {
            self.gameNameLabel.textColor = UIColor.GameCellColor.TextGray
        }
        self.gameNameLabel.text = name
    }
 
    public func setRating(rating: Int) {
        self.ratingLabel.text = "\(rating)"
        if rating > Constant.Thresholds.Green {
            self.ratingView.backgroundColor = UIColor.RatingViewColor.RatingViewGreen
            self.ratingLabel.textColor = UIColor.RatingViewColor.RatingLabelGreen
        } else if rating > Constant.Thresholds.Orange {
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
    
    public func setDetails(with infos: [(name: String, value: String)]) {
        setGameDetailsView(with: infos)
    }
    
    public func setFavoriteButton(selected: Bool) {
        favoriteButton.isSelected = selected
    }
}
