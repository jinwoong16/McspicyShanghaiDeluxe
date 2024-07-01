//
//  BigmacCalculatable.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/1/24.
//

import Foundation

protocol BigmacCalculatable {
    func exchange(_ money: String, to currencyId: Currency.ID) -> String
    func countBigmacs(with dollarData: Double) -> Int
    func getAvailableCurrencies() -> [Currency]
}
