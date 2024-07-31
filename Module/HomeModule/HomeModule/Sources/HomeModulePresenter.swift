//
//  HomeModulePresenter.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import Foundation
import Common

protocol HomeModulePresenterInterface: PresenterInterface {
//  todo
}

final class HomeModulePresenter {
    private let interactor: HomeModuleInteractorInterface
    private let router: HomeModuleRouterInterface
    private var view: HomeViewInterface?
    
    init(interactor: HomeModuleInteractorInterface, router: HomeModuleRouterInterface, view: HomeViewInterface? = nil) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
    private func fetchGameList() {
//        todo: showloading
        let request = MLFavoriteRestaurantsDetailsRequest(latitude: location.lat.stringValue,
                                                          longitude: location.lon.stringValue,
                                                          restaurantStatus: selectedStatus)
        
        interactor.fetchGameList(request: request)
    }
}

//MARK: - HomeModulePresenterInterface
extension HomeModulePresenter: HomeModulePresenterInterface {
    func viewDidLoad() {
        view?.prepareUI()
    }
    
    func viewWillAppear() {
        fetchGameList()
    }
}
