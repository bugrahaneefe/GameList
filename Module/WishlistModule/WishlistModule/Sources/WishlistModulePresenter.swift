//
//  WishlistModulePresenter.swift
//  WishlistModule
//
//  Created by Buğrahan Efe on 16.09.2024.
//

import CommonKit
import CommonViewsKit
import CoreUtils
import Foundation
import HomeHandlerKit
import UIKit

protocol WishlistModulePresenterInterface: PresenterInterface {
    
}

final class WishlistModulePresenter {
    private let defaults: DefaultsProtocol.Type
    private let interactor: WishlistInteractorInterface
    private let router: WishlistModuleRouterInterface
    private var view: WishlistViewInterface?
    
    init(interactor: WishlistInteractorInterface,
         router: WishlistModuleRouterInterface,
         view: WishlistViewInterface? = nil,
         defaults: DefaultsProtocol.Type = Defaults.self
    ) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.defaults = defaults
    }
}

//MARK: - WishlistModulePresenterInterface
extension WishlistModulePresenter: WishlistModulePresenterInterface {
    func viewDidLoad() {
        view?.prepareUI()
    }
}
