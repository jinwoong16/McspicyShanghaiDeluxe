//
//  Requestable.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/2/24.
//

import Foundation

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HttpMethod { get }
}

extension Requestable {
    func buildRequest() throws -> URLRequest {
        let url = try buildURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    private func buildURL() throws -> URL {
        guard let url = URL(string: baseURL) else {
            throw HttpError.badURL
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.path = path
        components?.queryItems = queryItems
        
        guard let targetURL = components?.url else {
            throw HttpError.badComponents
        }
        
        return targetURL
    }
}
