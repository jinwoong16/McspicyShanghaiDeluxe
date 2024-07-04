//
//  StoreFactoryTests.swift
//  McspicyShanghaiDeluxeTests
//
//  Created by jinwoong Kim on 7/4/24.
//

import XCTest
@testable import McspicyShanghaiDeluxe

final class StoreFactoryTests: XCTestCase {
    private var storeFactory: StoreFactory!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        
        let apiService = ApiServiceStub(
            session: URLSession(
                configuration: configuration
            )
        )
        
        storeFactory = StoreFactory(
            bigmacCSVParser: BigmacCSVParser(),
            apiService: apiService
        )
    }

    override func tearDownWithError() throws {
        storeFactory = nil
    }
    
    func test_buildBigmacIndexStore() throws {
        // given
        
        // when
        let bigmacIndexStore = storeFactory.buildBigmacIndexStore()
        
        // then
        XCTAssertEqual(5.69, bigmacIndexStore.fetch(by: "USD")?.localPrice)
        XCTAssertEqual("JPN", bigmacIndexStore.fetch(by: "JPY")?.isoCountryCode)
    }
    
    func test_buildCurrencyStore() async throws {
        // given
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: URL(string: "https://api.frankfurter.app/latest?from=KRW&to=AED,ARS,AUD,AZN,BHD,BRL,CAD,CHF,CLP,CNY,COP,CRC,CZK,DKK,EGP,EUR,GBP,GTQ,HKD,HNL,HUF,IDR,INR,ILS,JOD,JPY,KRW,KWD,LBP,LKR,MDL,MXN,MYR,NIO,NOK,NZD,OMR,PKR,PEN,PHP,PLN,QAR,RON,SAR,SGD,SEK,THB,TRY,TWD,UAH,UYU,USD,VES,VND,ZAR")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            return (response!, jsonData)
        }
        let _ = storeFactory.buildBigmacIndexStore()
        
        // when
        let currencyStore = await storeFactory.buildCurrencyStore()
        
        // then
        XCTAssertEqual("미국", currencyStore.fetch(by: "USD")?.country.name)
        XCTAssertEqual("🇺🇸", currencyStore.fetch(by: "USD")?.country.flag)
        
        XCTAssertEqual("헝가리", currencyStore.fetch(by: "HUF")?.country.name)
        XCTAssertEqual("🇭🇺", currencyStore.fetch(by: "HUF")?.country.flag)
    }
}
