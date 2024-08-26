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
    func prepareUI()
}

public final class GameCell: UICollectionViewCell {
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var gameNameLabel: UILabel!
    
    public var presenter: GameCellPresenterInterface! {
        didSet {
            presenter?.load()
        }
    }
}

// MARK: - GameCellViewInterface
extension GameCell: GameCellViewInterface {
    public func setBannerImage(path: String?) {
        bannerImageView.setImageWith(path: path) { [weak self] _, _, _ in
            self?.presenter.bannerImageLoaded()
        }
    }
    
    public func setGameNameLabel(name: String?) {
        self.gameNameLabel.text = name
    }
 
//    todo
    public func prepareUI() {
    }
}
