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
    private var sections: MockHomeModuleSection!
    private var defaults: MockDefaults!
    
    override func setUp() {
        super.setUp()
        view = .init()
        interactor = .init()
        router = .init()
        sections = .init()
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
        sections = nil
    }
    
    private func reCreate(
        with argument: GameListArgument =  GameListArgument(games: [])
    ) {
        presenter = .init(
            interactor: interactor,
            router: router,
            view: view,
            defaults: MockDefaults.self,
            argument: argument
        )
    }
    
    func test_ViewDidLoad() {
        XCTAssertFalse(view.invokedPrepareUI)
        XCTAssertFalse(view.invokedPrepareCollectionView)

        presenter.viewDidLoad()
        
        XCTAssertTrue(view.invokedPrepareUI)
        XCTAssertTrue(view.invokedPrepareCollectionView)
    }
    
    func test_ViewWillAppear() {
        XCTAssertFalse(interactor.invokedFetchGameList)
        
        presenter.viewWillAppear()
        
        XCTAssertTrue(interactor.invokedFetchGameList)
    }
    
    func test_AppearanceTypeBanner() {
        MockDefaults.stubbedIsBannerStateActive = true
        reCreate()
        
        XCTAssertEqual(presenter.appearanceType, .banner)
    }
    
    func test_AppearanceTypeLogo() {
        MockDefaults.stubbedIsBannerStateActive = false
        reCreate()
        
        XCTAssertEqual(presenter.appearanceType, .logo)
    }
    
    func test_numberOfItemsInGameSection() {
        reCreate()
        
        XCTAssertEqual(presenter.numberOfItemsInGameSection(), 0)
    }
}
