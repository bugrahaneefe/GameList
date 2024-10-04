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

    func test_selectFirstGame() throws {
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
    
    func test_addWishlist_firstGame() throws {
        let app = XCUIApplication()
        app.launch()
        
        let button = app.collectionViews
            .children(matching: .cell)
            .element(boundBy: 0)
            .children(matching: .other)
            .element
            .children(matching: .button)
            .element
        XCTAssertTrue(button.exists)
        
        button.tap()
    }
    
    func test_filterWithPlatformSlider() throws {
        let app = XCUIApplication()
        app.launch()
        
        let scrollViewsQuery = XCUIApplication().scrollViews
        XCTAssertTrue(scrollViewsQuery.element.exists)
        
        scrollViewsQuery
            .otherElements
            .containing(.button, identifier:"PC")
            .element
            .swipeLeft()
        
        let elementsQuery = scrollViewsQuery.otherElements
        XCTAssertTrue(elementsQuery.element.exists)
        
        elementsQuery.buttons["SEGA"].swipeRight()
        elementsQuery.buttons["iOS"].tap()
    }
    
    func test_filterWithSearch_selectFirstGame() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.searchFields["Search"].tap()
        
        let gKey = app/*@START_MENU_TOKEN@*/.keys["G"]/*[[".keyboards.keys[\"G\"]",".keys[\"G\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        gKey.tap()
        
        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        
        let nKey = app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nKey.tap()
        
        let dKey = app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        dKey.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"Ara\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
    }
}
