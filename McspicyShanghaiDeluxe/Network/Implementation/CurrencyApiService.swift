//
//  CurrencyApiService.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/2/24.
//

import Foundation

final class CurrencyApiService: ApiService {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}