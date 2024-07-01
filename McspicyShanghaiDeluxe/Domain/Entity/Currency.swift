//
//  Currency.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/1/24.
//

import Foundation

struct Currency: Identifiable {
    let name: String
    let code: String
    let rate: Double
    
    var id: String { code }
}
