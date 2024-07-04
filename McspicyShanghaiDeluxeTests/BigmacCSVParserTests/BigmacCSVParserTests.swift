//
//  BigmacCSVParserTests.swift
//  McspicyShanghaiDeluxeTests
//
//  Created by jinwoong Kim on 7/3/24.
//

import XCTest
@testable import McspicyShanghaiDeluxe

final class BigmacCSVParserTests: XCTestCase {
    private var bigmacCSVParser: BigmacCSVParser!
    
    override func setUpWithError() throws {
        bigmacCSVParser = BigmacCSVParser()
    }
    
    override func tearDownWithError() throws {
        bigmacCSVParser = nil
    }
    
    func test_parse() throws {
        // given
        
        // when
        let result = bigmacCSVParser.parse()
        
        // then
        XCTAssert(!result.isEmpty)
    }
}
