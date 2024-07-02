//
//  ApiServiceStub.swift
//  McspicyShanghaiDeluxeTests
//
//  Created by jinwoong Kim on 7/2/24.
//

import Foundation
@testable import McspicyShanghaiDeluxe

final class ApiServiceStub: ApiService {
    var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
}
