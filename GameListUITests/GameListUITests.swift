//
//  GameListUITests.swift
//  GameListUITests
//
//  Created by Buğrahan Efe on 4.10.2024.
//

import XCTest

final class GameListUITests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()
    }

    func selectFirstGame_uiTest() throws {
        let app = XCUIApplication()
        app.launch()
        app.collectionViews
            .children(matching: .cell)
            .element(boundBy: 0)
            .children(matching: .other)
            .element
            .tap()
        
        let navigationBars = app.navigationBars["Game Detail"]
        XCTAssertTrue(navigationBars.exists)
        
        let button = navigationBars.buttons["Games"]
        XCTAssertTrue(button.exists)
        
        button.tap()
    }
    
    func addWishlist_firstGame_uiTest() throws {
        
    }
}
