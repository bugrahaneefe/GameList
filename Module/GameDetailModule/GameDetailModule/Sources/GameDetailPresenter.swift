//
//  GameDetailPresenter.swift
//  GameDetailModule
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import CommonKit
import CommonViewsKit
import CoreUtils
import Foundation
import HomeHandlerKit
import UIKit

protocol GameDetailPresenterInterface: PresenterInterface {
}

private enum Constant {
}

final class GameDetailPresenter {
    private let interactor: GameDetailInteractorInterface
    private let router: GameDetailRouterInterface
    private var view: GameDetailViewInterface?
    
    init(interactor: GameDetailInteractorInterface,
         router: GameDetailRouterInterface,
         view: GameDetailViewInterface? = nil) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
}

extension GameDetailPresenter: GameDetailPresenterInterface {
    func viewDidLoad() {
        view?.prepareUI()
    }
}
