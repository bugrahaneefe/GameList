//
//  GameCell.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 4.08.2024.
//

import UIKit
import CoreUtils

public protocol GameCellViewInterface {
    func setBannerImage(path: String?)
    func setGameNameLabel(name: String?)
    func setRating(rating: Int)
    func setFavoriteButton()
}

public final class GameCell: UICollectionViewCell {
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var gameNameLabel: UILabel!
    @IBOutlet private weak var favoriteButtonView: FavoriteButton!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    public var presenter: GameCellPresenterInterface! {
        didSet {
            presenter.viewDidLoad()
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        bannerImageView.image = UIImage(systemName: "gamecontroller.fill")
        favoriteButtonView.favoriteButton.setImage(nil, for: .normal)
    }
}

// MARK: - GameCellViewInterface
extension GameCell: GameCellViewInterface {
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
    
    public func setFavoriteButton() {
        favoriteButtonView.presenter = FavoriteButtonPresenter(
            view: FavoriteButton(),
            delegate: presenter.favoriteButtonDelegate)
    }
}
