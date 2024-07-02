//
//  HttpError.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/2/24.
//

import Foundation

enum HttpError: Error {
    case errorWith(code: Int, data: Data)
    case badResponse
    case badURL
    case badComponents
}
