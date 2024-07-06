//
//  ApiServiceTests.swift
//  McspicyShanghaiDeluxeTests
//
//  Created by jinwoong Kim on 7/2/24.
//

import XCTest
@testable import McspicyShanghaiDeluxe

final class ApiServiceTests: XCTestCase {
    private var apiService: (any ApiService)!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        
        apiService = ApiServiceStub(
            session: URLSession(
                configuration: configuration
            )
        )
    }

    override func tearDownWithError() throws {
        apiService = nil
        MockURLSessionProtocol.loadingHandler = nil
    }
    
    func test_request_withValidRequest_shouldReturnCurrencyData() async throws {
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
        
        let endpoint: Endpoint<CurrencyDTO> = Endpoint(
            baseURL: "https://api.frankfurter.app",
            path: "/latest",
            queryItems: [
                .init(name: "from", value: "KRW"),
                .init(name: "to", value: "AED,ARS,AUD,AZN,BHD,BRL,CAD,CHF,CLP,CNY,COP,CRC,CZK,DKK,EGP,EUR,GBP,GTQ,HKD,HNL,HUF,IDR,INR,ILS,JOD,JPY,KRW,KWD,LBP,LKR,MDL,MXN,MYR,NIO,NOK,NZD,OMR,PKR,PEN,PHP,PLN,QAR,RON,SAR,SGD,SEK,THB,TRY,TWD,UAH,UYU,USD,VES,VND,ZAR")
            ]
        )
        
        // when
        let result = try await apiService.request(with: endpoint)
        
        // then
        XCTAssertEqual(28, result.rates.count)
        XCTAssertEqual(0.00067, result.rates.first(where: { $0.code == "EUR" })?.rate)
    }
    
    func test_request_withServerError_shouldThrowErrorWithCode() async throws {
        // given
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: URL(string: "https://api.frankfurter.app/latest?from=KRW&to=AED,ARS,AUD,AZN,BHD,BRL,CAD,CHF,CLP,CNY,COP,CRC,CZK,DKK,EGP,EUR,GBP,GTQ,HKD,HNL,HUF,IDR,INR,ILS,JOD,JPY,KRW,KWD,LBP,LKR,MDL,MXN,MYR,NIO,NOK,NZD,OMR,PKR,PEN,PHP,PLN,QAR,RON,SAR,SGD,SEK,THB,TRY,TWD,UAH,UYU,USD,VES,VND,ZAR")!,
                statusCode: 500,    // Internal server error code
                httpVersion: nil,
                headerFields: nil
            )
            
            return (response!, nil)
        }
        
        let endpoint: Endpoint<CurrencyDTO> = Endpoint(
            baseURL: "https://api.frankfurter.app",
            path: "/latest",
            queryItems: [
                .init(name: "from", value: "KRW"),
                .init(name: "to", value: "AED,ARS,AUD,AZN,BHD,BRL,CAD,CHF,CLP,CNY,COP,CRC,CZK,DKK,EGP,EUR,GBP,GTQ,HKD,HNL,HUF,IDR,INR,ILS,JOD,JPY,KRW,KWD,LBP,LKR,MDL,MXN,MYR,NIO,NOK,NZD,OMR,PKR,PEN,PHP,PLN,QAR,RON,SAR,SGD,SEK,THB,TRY,TWD,UAH,UYU,USD,VES,VND,ZAR")
            ]
        )
        
        // when
        await XCTAssertAsyncThrowsError(try await apiService.request(with: endpoint)) { error in
            // then
            guard let error = error as? HttpError else {
                XCTFail("Thrown error is not Http error.")
                return
            }
            if case let .errorWith(code, _) = error {
                XCTAssertEqual(500, code)
            }
        }
    }
}
