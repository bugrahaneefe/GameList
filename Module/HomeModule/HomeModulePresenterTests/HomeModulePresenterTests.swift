//
//  HomeModulePresenterTests.swift
//  HomeModulePresenterTests
//
//  Created by Buğrahan Efe on 23.09.2024.
//

import XCTest
import CommonKit

@testable import HomeModule

final class HomeModulePresenterTests: XCTestCase {
    private var presenter: HomeModulePresenter!
    private var view: MockHomeView!
    private var interactor: MockHomeModuleInteractor!
    private var router: MockHomeModuleRouter!
    
    override func setUp() {
        super.setUp()
        view = .init()
        interactor = .init()
        router = .init()
        presenter = .init(
            interactor: interactor,
            router: router,
            view: view,
            argument: GameListArgument(games: [])
        )
    }
    
    override func tearDown() {
        super.tearDown()
        presenter = nil
        view = nil
        interactor = nil
        router = nil
    }
    
    private func reCreate() {
        presenter = .init(
            interactor: interactor,
            router: router,
            view: view,
            argument: GameListArgument(games: [])
        )
    }
    
    func test() {
        presenter.viewDidLoad()
    }
}
