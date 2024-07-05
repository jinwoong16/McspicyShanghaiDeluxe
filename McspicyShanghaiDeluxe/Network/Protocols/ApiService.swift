//
//  ApiService.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/2/24.
//

import Foundation

protocol ApiService {
    var session: URLSession { get }
}

extension ApiService {
    func request<R: Decodable, E: Requestable & Responsable>(
        with endpoint: E
    ) async throws -> R where E.Response == R {
        let request = try endpoint.buildRequest()
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HttpError.badResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw HttpError.errorWith(code: httpResponse.statusCode, data: data)
        }
        
        return try decode(data: data)
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
