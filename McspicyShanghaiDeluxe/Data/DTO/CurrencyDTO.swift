//
//  CurrencyDTO.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/2/24.
//

import Foundation

struct CurrencyRateDTO {
    let code: String
    let rate: Double
}

struct CurrencyDTO: Decodable {
    let rates: [CurrencyRateDTO]
    
    enum CodingKeys: CodingKey {
        case rates
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let rateDictionary = try container.decode([String: Double].self, forKey: .rates)
        rates = rateDictionary.map { CurrencyRateDTO(code: $0.key, rate: $0.value) }
    }
}
