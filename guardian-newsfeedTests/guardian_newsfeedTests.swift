//
//  guardian_newsfeedTests.swift
//  guardian-newsfeedTests
//
//  Created by Nouman on 05/05/2021.
//

import XCTest
@testable import guardian_newsfeed

class guardian_newsfeedTests: XCTestCase {
    
    let newsfeed = Newsfeed()
    
    func test_api_call_returns_data_for_page_1() {
        let expectedCount = 10
        let expectation = self.expectation(description: "Fetch correct data for page 1")
        newsfeed.loadData(pageParam: 1, search: nil, key: nil) { (result, size) in
            XCTAssertNotNil(result)
            XCTAssertEqual(size, expectedCount)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func test_api_call_returns_data_for_page_2() {
        let expectedCount = 10
        let expectation = self.expectation(description: "Fetch correct data for page 2")
        newsfeed.loadData(pageParam: 2, search: nil, key: nil) { (result, size) in
            XCTAssertNotNil(result)
            XCTAssertEqual(size, expectedCount)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func test_api_call_returns_data_for_different_search() {
        let expectedCount = 10
        let expectation = self.expectation(description: "Fetch correct data with different search")
        newsfeed.loadData(pageParam: 1, search: "football", key: nil) { (result, size) in
            XCTAssertNotNil(result)
            XCTAssertEqual(size, expectedCount)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func test_api_call_returns_no_data_for_failed_fetch() {
        let expectedCount = 10
        let expectation = self.expectation(description: "Fetch no data when failed fetch")
        newsfeed.loadData(pageParam: 1, search: "dsfgsdgsdggsdg", key: nil) { (result, size) in
            XCTAssertNotNil(result)
            XCTAssertEqual(size, expectedCount)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

}
