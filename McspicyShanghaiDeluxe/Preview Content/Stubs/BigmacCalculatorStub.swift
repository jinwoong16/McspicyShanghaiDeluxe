//
//  BigmacCalculatorStub.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/1/24.
//

import Foundation
import Combine

final class BigmacCalculatorStub: BigmacCalculatable {
    private let rawData = [
        ("크로네", "NOK", 0.00119, "🇳🇴", "노르웨이"),
        ("링깃", "MYR", 0.00342, "🇲🇾", "말레이시아"),
        ("달러", "USD", 0.00073, "🇺🇸", "미국"),
        ("크로나", "SEK", 0.0077, "🇸🇪", "스웨덴"),
        ("프랑", "CHF", 0.00065, "🇨🇭", "스위스"),
        ("파운드", "GBP", 0.00057, "🇬🇧", "영국"),
        ("엔", "JPY", 0.11658, "🇯🇵", "일본"),
        ("위안", "CNY", 0.00527, "🇨🇳", "중국"),
        ("달러", "CAD", 0.00099, "🇨🇦", "캐나다"),
        ("달러", "HKD", 0.00567, "🇭🇰", "홍콩"),
        ("바트", "THB", 0.02666, "🇹🇭","태국"),
        ("달러", "AUD", 0.00109, "🇦🇺", "호주"),
        ("달러", "NZD", 0.00119, "🇳🇿","뉴질랜드"),
        ("달러", "SGD", 0.00098, "🇸🇬","싱가포르")
    ]
    
    private let localPrices = [
        "노르웨이": 75.0,
        "말레이시아": 13.15,
        "미국": 5.69,
        "스웨덴": 61.29,
        "스위스": 7.1,
        "영국": 4.49,
        "일본": 450.0,
        "중국": 25.0,
        "캐나다": 7.47,
        "홍콩": 23.0,
        "태국": 135.0,
        "호주": 7.7,
        "뉴질랜드": 8.2,
        "싱가포르": 6.65
    ]
    
    private lazy var currencies: [Currency] = {
        rawData
            .map {
                Currency(
                    name: $0.0,
                    code: $0.1,
                    rate: $0.2,
                    country: Country(
                        name: $0.4,
                        flag: $0.3
                    )
                )
            }
    }()
    
    func exchange(_ money: Int, to currencyId: Currency.ID) -> Double {
        if let target = currencies.first(where: { $0.id == currencyId }) {
            return target.rate * Double(money)
        } else {
            return 0.0
        }
    }
    
    func countBigmacs(
        with exchangedMoney: Double,
        currencyId: Currency.ID
    ) -> Int {
        let targetCurrency = currencies
            .first(where: { $0.id == currencyId })!
        let targetBigmacPrice = localPrices
            .first(where: { targetCurrency.country.name == $0.key })!
            .value
        
        return Int(exchangedMoney / targetBigmacPrice)
    }
    
    func getAvailableCurrencies() -> [Currency] {
        currencies
    }
    
    func readyToUpdateUI() -> AnyPublisher<Bool, Never> {
            Just(true)
                .delay(for: .seconds(2), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
}
