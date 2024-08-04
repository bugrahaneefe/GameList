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
    func prepareUI()
}

public final class GameCell: UICollectionViewCell {
    @IBOutlet private weak var bannerImageView: UIImageView!

    public var presenter: GameCellPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - MLRestaurantListCellViewInterface
extension GameCell: GameCellViewInterface {
    public func setBannerImage(path: String?) {
        bannerImageView.setImageWith(path: path) { [weak self] _, _, _ in
            self?.presenter.bannerImageLoaded()
        }
    }
    
//    todo
    public func prepareUI() {
    }
}

