//
//  RequestableStub.swift
//  McspicyShanghaiDeluxeTests
//
//  Created by jinwoong Kim on 7/2/24.
//

import Foundation
@testable import McspicyShanghaiDeluxe

struct RequestableStub: Requestable {
    var baseURL: String
    var path: String
    var queryItems: [URLQueryItem]?
    var method: McspicyShanghaiDeluxe.HttpMethod
}
