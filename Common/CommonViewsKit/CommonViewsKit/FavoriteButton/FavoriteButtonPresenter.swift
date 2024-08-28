//
//  FavoriteButtonPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 28.08.2024.
//

import Foundation

public protocol FavoriteButtonPresenterInterface {
    func load()
    func favoriteButtonPressed()
}

final class FavoriteButtonPresenter {
    private var view: FavoriteButtonInterface
    
    init(view: FavoriteButtonInterface) {
        self.view = view
    }
}

extension FavoriteButtonPresenter: FavoriteButtonPresenterInterface {
    func load() {
    }
    
    func favoriteButtonPressed() {
        view.setFavoriteButton()
    }
}
