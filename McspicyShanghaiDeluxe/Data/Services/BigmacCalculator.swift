//
//  BigmacCalculator.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/4/24.
//

import Foundation
import Combine
import os

final class BigmacCalculator {
    private var bigmacIndexStore: any ModelStore<BigmacIndex> = AnyModelStore(models: [])
    private var countryStore: any ModelStore<Country> = AnyModelStore(models: [])
    
    private var updateUIEvent = CurrentValueSubject<Bool, Never>(false)
    
    private let logger: Logger
    
    init(
        factory: StoreFactory
    ) {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.McspicyShanghaiDeluxe",
            category: "BigmacCalculator"
        )
        Task {
            self.bigmacIndexStore = factory.buildBigmacIndexStore()
            self.countryStore = await factory.buildCountryStore()
            self.updateUIEvent.send(true)
        }
    }
}

extension BigmacCalculator: BigmacCalculatable {
    func exchange(_ money: Int, to countryId: Country.ID) -> Double {
        guard let rate = countryStore.fetch(by: countryId)?.currency.rate else {
            logger.debug("countryStore fetch did not work")
            return 0
        }
        return Double(money) * rate
    }
    
    func countBigmacs(with exchangedMoney: Double, countryId: Country.ID) -> Int {
        guard let bigmacLocalPrice = bigmacIndexStore.fetch(by: countryId)?.localPrice else {
            logger.debug("bigmacIndexStore fetch did not work")
            return 0
        }
        return Int(exchangedMoney / bigmacLocalPrice)
    }
    
    func getAvailableCountries() -> [Country] {
        countryStore.fetchAll()
    }
    
    func readyToUpdateUI() -> AnyPublisher<Bool, Never> {
        updateUIEvent
            .filter { $0 }
            .eraseToAnyPublisher()
    }
}
