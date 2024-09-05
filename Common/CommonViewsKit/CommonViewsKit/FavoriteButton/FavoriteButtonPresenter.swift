//
//  FavoriteButtonPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 28.08.2024.
//

import UIKit
import CoreUtils

public protocol FavoriteButtonDelegate: AnyObject {
    func favoriteButtonTapped()
}

public protocol FavoriteButtonPresenterInterface: PresenterInterface {
    func load()
    func favoriteButtonTapped()
}

final class FavoriteButtonPresenter {
    private var view: FavoriteButtonInterface?
    private weak var delegate: FavoriteButtonDelegate?
    private var selected: Bool = false
    
    init(view: FavoriteButtonInterface? = nil,
         delegate: FavoriteButtonDelegate? ,
         selected: Bool = false) {
        self.view = view
        self.delegate = delegate
        self.selected = selected
    }
    
}

extension FavoriteButtonPresenter: FavoriteButtonPresenterInterface {
    func load() {
        view?.prepareUI()
    }
    
    func favoriteButtonTapped() {
        delegate?.favoriteButtonTapped()
    }
}
