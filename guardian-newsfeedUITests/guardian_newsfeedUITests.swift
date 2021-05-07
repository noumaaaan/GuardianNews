//
//  guardian_newsfeedUITests.swift
//  guardian-newsfeedUITests
//
//  Created by Nouman on 05/05/2021.
//

import XCTest

class guardian_newsfeedUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }
    
    func test_renders_list_on_homescreen() {
        let app = XCUIApplication()
        app.launch()
        
        let render = app.tables["newsList"].exists
        XCTAssertTrue(render)
    }
    
    func test_renders_detail_view_scroll() {
        let app = XCUIApplication()
        app.launch()
        
        let firstCell = app.tables["newsList"].cells.element(boundBy: 0)
        firstCell.tap()
        
        let render = app.scrollViews["detailList"].exists
        XCTAssertTrue(render)
    }
    
    func test_cell_contains_chil_elements() {
        let app = XCUIApplication()
        app.launch()
        
        let firstCell = app.tables["newsList"].cells.element(boundBy: 0)
        let res = firstCell.children(matching: .any).count
        
        XCTAssertEqual(res, 2)
    }
}
