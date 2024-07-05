//
//  Country.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/1/24.
//

import Foundation

struct Country: Identifiable {
    let isoCountryCode: String
    let name: String
    let flag: String
    let currency: Currency
    let localPrice: Double
    
    var id: String { isoCountryCode }
}
