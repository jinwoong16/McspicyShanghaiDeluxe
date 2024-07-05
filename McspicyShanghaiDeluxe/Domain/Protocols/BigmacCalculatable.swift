//
//  BigmacCalculatable.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/1/24.
//

import Foundation
import Combine

protocol BigmacCalculatable {
    func exchange(_ money: Int, to countryId: Country.ID) -> Double
    func countBigmacs(with exchangedMoney: Double, countryId: Country.ID) -> Int
    func getAvailableCountries() -> [Country]
    func readyToUpdateUI() -> AnyPublisher<Bool, Never>
}
