//
//  XCTest+.swift
//  McspicyShanghaiDeluxeTests
//
//  Created by jinwoong Kim on 7/6/24.
//

import XCTest

extension XCTest {
    func XCTAssertAsyncThrowsError<T>(
        _ expression: @autoclosure () async throws -> T,
        _ errorHandler: ((any Error) -> Void) = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail("This expression did not throw any error.")
        } catch {
            errorHandler(error)
        }
    }
}
