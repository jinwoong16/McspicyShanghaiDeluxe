//
//  Endpoint.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/2/24.
//

import Foundation

struct Endpoint<R: Decodable>: Requestable, Responsable {
    typealias Response = R
    
    var baseURL: String
    var path: String
    var queryItems: [URLQueryItem]?
    var method: HttpMethod
    
    init(
        baseURL: String,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        method: HttpMethod = .GET
    ) {
        self.baseURL = baseURL
        self.path = path
        self.queryItems = queryItems
        self.method = method
    }
}
