//
//  HomeModulePresenter.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import Foundation
import CommonKit
import CoreUtils

protocol HomeModulePresenterInterface: PresenterInterface, HomeModuleHeaderCollectionReusablePresenterDelegate, HomeModuleGameDelegate {
//    todo
}

final class HomeModulePresenter {
    private let interactor: HomeModuleInteractorInterface
    private let router: HomeModuleRouterInterface
    private var view: HomeViewInterface?
    private var games: [Game]?
    
    init(interactor: HomeModuleInteractorInterface,
         router: HomeModuleRouterInterface,
         view: HomeViewInterface? = nil) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
    private func fetchGameList() {
        //        todo: showloading
        let request = HomeModuleGameListRequest(
            count: 10,
            next: "",
            previous: "",
            results: [])
        
        interactor.fetchGameList(request: request)
    }
    
    private func handleEmptyGameStatus() {
//        todo
    }
    
    private func handleGameSection() {
        let gameSection = GameSection(games: games ?? [])
        view?.reloadCollectionView(listSections: [gameSection])
    }
}

//MARK: - HomeModulePresenterInterface
extension HomeModulePresenter: HomeModulePresenterInterface {
    func changeAppearanceTapped() {}
    
    func viewDidLoad() {
        view?.prepareUI()
    }
    
    func viewWillAppear() {
        fetchGameList()
    }
}

//MARK: - HomeModuleInteractorOutput
extension HomeModulePresenter: HomeModuleInteractorOutput {
    func handleGameListResult(_ result: GameListDetailsResult) {
        switch result {
        case .success(let response):
            guard !response.results.isEmpty else {
                handleEmptyGameStatus()
                return
            }
            games = response.results
            print(games ?? "none")
            handleGameSection()
        case .failure(let error):
//            todo error extensions
            print(error)
        }
    }
}


//MARK: - HomeModuleSectionDelegate
extension HomeModulePresenter: HomeModuleSectionDelegate {
    func gameSelected(_ game: CommonKit.Game) {
    }
}
