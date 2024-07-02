//
//  RequestableTests.swift
//  McspicyShanghaiDeluxeTests
//
//  Created by jinwoong Kim on 7/2/24.
//

import XCTest
@testable import McspicyShanghaiDeluxe

final class RequestableTests: XCTestCase {
    private var stub: (any Requestable)!

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        stub = nil
    }
    
    func test_buildRequest_withValidProperties_shouldPassAllCases() throws {
        // given
        stub = RequestableStub(
            baseURL: "https://example.com",
            path: "/latest",
            queryItems: [
                .init(name: "first", value: "firstValue"),
                .init(name: "second", value: "secondValue")
            ],
            method: .GET
        )
        
        // when
        let result = try stub.buildRequest()
        
        // then
        XCTAssertEqual("GET", result.httpMethod)
        XCTAssertEqual("/latest", result.url?.path())
        XCTAssertEqual("first=firstValue&second=secondValue", result.url?.query())
        XCTAssertNil(result.httpBody)
        XCTAssert(result.allHTTPHeaderFields!.isEmpty)
    }
    
    func test_buildRequest_withInvalidURL_shouldThrowBadURL() throws {
        // given
        stub = RequestableStub(
            baseURL: "",  // Bad url
            path: "/latest",
            queryItems: [
                .init(name: "first", value: "firstValue"),
                .init(name: "second", value: "secondValue")
            ],
            method: .GET
        )
        
        // when
        XCTAssertThrowsError(try stub.buildRequest()) { error in
            // then
            XCTAssertEqual(HttpError.badURL, error as! HttpError)
        }
    }
}
