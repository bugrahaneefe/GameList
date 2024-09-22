//
//  GameCell.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 4.08.2024.
//

import UIKit
import CommonKit

public protocol GameCellViewInterface {
    func setBannerImage(path: String?)
    func setGameNameLabel(name: String?, isAlreadyClicked: Bool)
    func setRating(rating: Int)
    func setFavoriteButton(selected: Bool)
}

private enum Constant {
    enum RatingThresholds {
        static let Green = 75
        static let Orange = 50
    }
}

public final class GameCell: UICollectionViewCell {
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var gameNameLabel: UILabel!
    @IBOutlet private weak var favoriteButton: FavoriteButton!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!

    public var presenter: GameCellPresenterInterface! {
        didSet {
            presenter.viewDidLoad()
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
}

// MARK: - GameCellViewInterface
extension GameCell: GameCellViewInterface {
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
        if rating > Constant.RatingThresholds.Green {
            self.ratingView.backgroundColor = UIColor.RatingViewColor.RatingViewGreen
            self.ratingLabel.textColor = UIColor.RatingViewColor.RatingLabelGreen
        } else if rating > Constant.RatingThresholds.Orange {
            self.ratingView.backgroundColor = UIColor.RatingViewColor.RatingViewOrange
            self.ratingLabel.textColor = UIColor.RatingViewColor.RatingLabelOrange
        } else {
            self.ratingView.backgroundColor = UIColor.RatingViewColor.RatingViewRed
            self.ratingLabel.textColor = UIColor.RatingViewColor.RatingLabelRed
        }
        ratingView.layer.cornerRadius = 3
    }
    
    public func setFavoriteButton(selected: Bool) {
        favoriteButton.isSelected = selected
    }
}
