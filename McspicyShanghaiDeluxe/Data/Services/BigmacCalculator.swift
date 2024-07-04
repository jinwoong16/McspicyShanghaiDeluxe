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
    private var currencyStore: any ModelStore<Currency> = AnyModelStore(models: [])
    
    private var updateUIEvent = CurrentValueSubject<Bool, Never>(false)
    
    private let logger: Logger
    
    init(
        factory: StoreFactory,
        logger: Logger = .init(.default)
    ) {
        self.logger = logger
        Task {
            self.bigmacIndexStore = factory.buildBigmacIndexStore()
            self.currencyStore = await factory.buildCurrencyStore()
            self.updateUIEvent.send(true)
        }
    }
}

extension BigmacCalculator: BigmacCalculatable {
    func exchange(_ money: Int, to currencyId: Currency.ID) -> Double {
        guard let rate = currencyStore.fetch(by: currencyId)?.rate else {
            logger.debug("currencyStore fetch did not work")
            return 0
        }
        return Double(money) * rate
    }
    
    func countBigmacs(with exchangedMoney: Double, currencyId: Currency.ID) -> Int {
        guard let bigmacLocalPrice = bigmacIndexStore.fetch(by: currencyId)?.localPrice else {
            logger.debug("bigmacIndexStore fetch did not work")
            return 0
        }
        return Int(exchangedMoney / bigmacLocalPrice)
    }
    
    func getAvailableCurrencies() -> [Currency] {
        currencyStore.fetchAll()
    }
    
    func readyToUpdateUI() -> AnyPublisher<Bool, Never> {
        updateUIEvent.eraseToAnyPublisher()
    }
}
