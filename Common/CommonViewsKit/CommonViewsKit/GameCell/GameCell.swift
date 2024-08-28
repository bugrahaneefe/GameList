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
    func prepareUI()
}

public final class GameCell: UICollectionViewCell {
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var gameNameLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    public var presenter: GameCellPresenterInterface! {
        didSet {
            presenter?.load()
        }
    }
}

// MARK: - GameCellViewInterface
extension GameCell: GameCellViewInterface {
    public func setBannerImage(path: String?) {
        bannerImageView.setImageWith(url: path)
    }
    
    public func setGameNameLabel(name: String?) {
        self.gameNameLabel.text = name
    }
 
    public func setRating(rating: Int) {
        self.ratingLabel.text = "\(rating)"
        if rating > 80 {
            self.ratingView.backgroundColor = #colorLiteral(red: 0.1698472798, green: 0.3133658767, blue: 0.2018784285, alpha: 1)
            self.ratingLabel.textColor = #colorLiteral(red: 0.2944766879, green: 0.778819263, blue: 0.3979456425, alpha: 1)
        } else if rating > 60 {
            self.ratingView.backgroundColor = #colorLiteral(red: 0.2888736725, green: 0.1919786334, blue: 0.1317017376, alpha: 1)
            self.ratingLabel.textColor = #colorLiteral(red: 1, green: 0.5022648573, blue: 0.2186617553, alpha: 1)
        } else {
            self.ratingView.backgroundColor = #colorLiteral(red: 0.2452892661, green: 0.1486651599, blue: 0.1509629786, alpha: 1)
            self.ratingLabel.textColor = #colorLiteral(red: 0.78265661, green: 0.2927912474, blue: 0.2924315929, alpha: 1)
        }
        ratingView.layer.cornerRadius = 3
    }
//    todo
    public func prepareUI() {
    }
}
