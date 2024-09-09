//
//  FavoriteButton.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 28.08.2024.
//

import UIKit
import CommonKit

protocol FavoriteButtonInterface {
    func prepareUI()
}

public final class FavoriteButton: NibView {
    @IBOutlet weak var favoriteButton: UIButton!
        
    var presenter: FavoriteButtonPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    // MARK: IBActions
    @IBAction public func favoriteButtonPressed(_ sender: Any) {
        presenter?.favoriteButtonTapped()
    }
}

extension FavoriteButton: FavoriteButtonInterface {
    func prepareUI() {
        favoriteButton.backgroundColor = UIColor.FavoriteButtonColor.White
    }
}
