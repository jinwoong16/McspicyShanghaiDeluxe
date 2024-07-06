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
        XCTAssertEqual(5.69, bigmacIndexStore.fetch(by: "USA")?.localPrice)
        XCTAssertEqual("Japan", bigmacIndexStore.fetch(by: "JPN")?.countryName)
    }
    
    func test_buildCurrencyStore_withValidEndpoint_shouldReturnNonEmptryStore() async throws {
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
        let countryStore = await storeFactory.buildCountryStore()
        
        // then
        XCTAssertEqual("미국", countryStore.fetch(by: "USA")?.name)
        XCTAssertEqual("🇺🇸", countryStore.fetch(by: "USA")?.flag)
        
        XCTAssertEqual("헝가리", countryStore.fetch(by: "HUN")?.name)
        XCTAssertEqual("🇭🇺", countryStore.fetch(by: "HUN")?.flag)
        
        XCTAssertEqual("독일", countryStore.fetch(by: "DEU")?.name)
        XCTAssertEqual("🇩🇪", countryStore.fetch(by: "DEU")?.flag)
        
        XCTAssertEqual("프랑스", countryStore.fetch(by: "FRA")?.name)
        XCTAssertEqual("🇫🇷", countryStore.fetch(by: "FRA")?.flag)
        
        XCTAssertEqual("이탈리아", countryStore.fetch(by: "ITA")?.name)
        XCTAssertEqual("🇮🇹", countryStore.fetch(by: "ITA")?.flag)
    }
}
