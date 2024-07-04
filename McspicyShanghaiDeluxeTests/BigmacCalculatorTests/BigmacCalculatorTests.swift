//
//  BigmacCalculatorTests.swift
//  McspicyShanghaiDeluxeTests
//
//  Created by jinwoong Kim on 7/4/24.
//

import XCTest
@testable import McspicyShanghaiDeluxe

final class BigmacCalculatorTests: XCTestCase {
    private var bigmacCalculator: BigmacCalculator!
    
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
    }
    
    func test_exchange() throws {
        // given
        let money = 5000
        let currencyId = "USD"
        sleep(2)
        
        // when
        let exchangedMoney = bigmacCalculator.exchange(money, to: currencyId)
        
        // then
        XCTAssertEqual(5000 * 0.00072, exchangedMoney)
    }
    
    func test_countBicamcs() throws {
        // given
        let money = 100000
        let currencyId = "USD"
        sleep(2)
        
        let exchangedMoney = bigmacCalculator.exchange(money, to: currencyId)
        
        // when
        let bigmacs = bigmacCalculator.countBigmacs(with: exchangedMoney, currencyId: currencyId)
        
        // then
        XCTAssertEqual(12, bigmacs)
    }
    
    func test_getAvailableCurrencies() throws {
        // given
        sleep(2)
        
        // when
        let currencies = bigmacCalculator.getAvailableCurrencies()
        
        // then
        XCTAssert(!currencies.isEmpty)
    }
}
