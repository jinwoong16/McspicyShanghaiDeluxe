//
//  BigmacCalculatorTests.swift
//  McspicyShanghaiDeluxeTests
//
//  Created by jinwoong Kim on 7/4/24.
//

import XCTest
import Combine
@testable import McspicyShanghaiDeluxe

final class BigmacCalculatorTests: XCTestCase {
    private var bigmacCalculator: BigmacCalculator!
    private var anyCancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        
        let apiService = ApiServiceStub(
            session: URLSession(
                configuration: configuration
            )
        )
        
        let factory = StoreFactory(
            bigmacCSVParser: BigmacCSVParser(),
            apiService: apiService
        )
        
        bigmacCalculator = BigmacCalculator(factory: factory)
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: URL(string: "https://api.frankfurter.app/latest?from=KRW&to=AED,ARS,AUD,AZN,BHD,BRL,CAD,CHF,CLP,CNY,COP,CRC,CZK,DKK,EGP,EUR,GBP,GTQ,HKD,HNL,HUF,IDR,INR,ILS,JOD,JPY,KRW,KWD,LBP,LKR,MDL,MXN,MYR,NIO,NOK,NZD,OMR,PKR,PEN,PHP,PLN,QAR,RON,SAR,SGD,SEK,THB,TRY,TWD,UAH,UYU,USD,VES,VND,ZAR")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            return (response!, jsonData)
        }
    }
    
    override func tearDownWithError() throws {
        bigmacCalculator = nil
        MockURLSessionProtocol.loadingHandler = nil
        anyCancellables = []
    }
    
    func test_exchange() throws {
        // given
        let expectation = XCTestExpectation(description: "exchange method test")
        
        let money = 5000
        let countryCode = "USA"
        
        bigmacCalculator
            .readyToUpdateUI()
            .filter { $0 }
            .sink { _ in
                // when
                let exchangedMoney = self.bigmacCalculator.exchange(money, to: countryCode)
                
                // then
                XCTAssertEqual(5000 * 0.00072, exchangedMoney)
                expectation.fulfill()
            }
            .store(in: &anyCancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_countBicamcs() throws {
        // given
        let expectation = XCTestExpectation(description: "countBicamcs method test")
        
        let money = 100000
        let countryCode = "USA"
        
        bigmacCalculator
            .readyToUpdateUI()
            .sink { _ in
                // when
                let exchangedMoney = self.bigmacCalculator.exchange(money, to: countryCode)
                let bigmacs = self.bigmacCalculator.countBigmacs(with: exchangedMoney, countryId: countryCode)
                
                // then
                XCTAssertEqual(12, bigmacs)
                expectation.fulfill()
            }
            .store(in: &anyCancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_getAvailableCountries() throws {
        // given
        let expectation = XCTestExpectation(description: "getAvailableCountries method test")
        
        // when
        bigmacCalculator
            .readyToUpdateUI()
            .sink { _ in
                // when
                let contries = self.bigmacCalculator.getAvailableCountries()
                
                // then
                XCTAssert(!contries.isEmpty)
                XCTAssertEqual(30, contries.count)
                
                expectation.fulfill()
            }
            .store(in: &anyCancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }
}
