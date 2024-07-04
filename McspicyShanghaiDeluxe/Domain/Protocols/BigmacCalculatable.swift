//
//  BigmacCalculatable.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/1/24.
//

import Foundation
import Combine

protocol BigmacCalculatable {
    func exchange(_ money: Int, to currencyId: Currency.ID) -> Double
    func countBigmacs(with exchangedMoney: Double, currencyId: Currency.ID) -> Int
    func getAvailableCurrencies() -> [Currency]
    func readyToUpdateUI() -> AnyPublisher<Bool, Never>
}
