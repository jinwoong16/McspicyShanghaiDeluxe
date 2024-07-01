//
//  BigmacIndex.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/1/24.
//

import Foundation

struct BigmacIndex: Identifiable {
    let countryName: String
    let isoCountryCode: String
    let currencyCode: String
    let localPrice: Double
    
    var id: String { currencyCode }
}
