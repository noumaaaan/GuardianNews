//
//  guardian_newsfeedTests.swift
//  guardian-newsfeedTests
//
//  Created by Nouman on 05/05/2021.
//

import XCTest
@testable import guardian_newsfeed

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        guard let handler = Self.requestHandler else {
            XCTFail("you forgot to set the mock protocol request handler")
            return
        }
        do {
            let (response, data) = try handler(request)
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        } catch {
            self.client?.urlProtocol(self, didFailWithError:error)
        }
    }
}




class guardian_newsfeedTests: XCTestCase {
    
    let newsfeed = Newsfeed()

    func test_api_call_returns_data_for_page_1() {
        
        let initialCount = 0
        
        let expectation = self.expectation(description: "Testing")
        var data: [Result]
        
        newsfeed.loadData(pageParam: 1, search: nil, key: nil) {
            data = $0
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        XCTAssertGreaterThan(data.count, initialCount)
        
    }
    
    func test_api_call_returns_data_for_page_2() {
        newsfeed.loadData(pageParam: 2, search: nil, key: nil)
        
        XCTAssertNotNil(newsfeed.data)
        XCTAssertEqual(newsfeed.error, "")
    }
    
    func test_api_call_returns_data_for_different_search() {
        newsfeed.loadData(pageParam: 1, search: "football", key: nil)
        
        XCTAssertNotNil(newsfeed.data)
        XCTAssertEqual(newsfeed.error, "")
    }
    
    func test_api_call_returns_error_for_invalid_api() {
        newsfeed.loadData(pageParam: 1, search: nil, key: "12345")
        
        print("Error: " + newsfeed.error)
        
        XCTAssertEqual(newsfeed.data, [])
        XCTAssertEqual(newsfeed.error, "Invalid authentication credentials")
    }
    
    func test_api_call_returns_no_data_for_failed_fetch() {
        newsfeed.loadData(pageParam: 1, search: "askhvsfkhbfkw", key: nil)
        
        XCTAssertNil(newsfeed.data)
        XCTAssertEqual(newsfeed.error, "")
    }
    

}
