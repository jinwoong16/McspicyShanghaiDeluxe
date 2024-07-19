//
//  BigmacCalculatorStub.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/1/24.
//

import Foundation
import Combine
import UIKit

final class BigmacCalculatorStub: BigmacCalculatable {
    private let rawData = [
        ("NOR", "크로네", "NOK", 0.00119, "🇳🇴", "노르웨이", 75.0),
        ("MYS", "링깃", "MYR", 0.00342, "🇲🇾", "말레이시아", 13.15),
        ("USA", "달러", "USD", 0.00073, "🇺🇸", "미국", 5.69),
        ("SWD", "크로나", "SEK", 0.0077, "🇸🇪", "스웨덴", 61.29),
        ("CHE", "프랑", "CHF", 0.00065, "🇨🇭", "스위스", 7.1),
        ("GBR", "파운드", "GBP", 0.00057, "🇬🇧", "영국", 4.49),
        ("JPN", "엔", "JPY", 0.11658, "🇯🇵", "일본", 450.0),
        ("CHN", "위안", "CNY", 0.00527, "🇨🇳", "중국", 25.0),
        ("CAN", "달러", "CAD", 0.00099, "🇨🇦", "캐나다", 7.47),
        ("HKG", "달러", "HKD", 0.00567, "🇭🇰", "홍콩", 23.0),
        ("THA", "바트", "THB", 0.02666, "🇹🇭","태국", 135.0),
        ("AUS", "달러", "AUD", 0.00109, "🇦🇺", "호주", 7.7),
        ("NZL", "달러", "NZD", 0.00119, "🇳🇿","뉴질랜드", 8.2),
        ("SGP", "달러", "SGD", 0.00098, "🇸🇬","싱가포르", 6.65),
        ("NOR2", "크로네", "NOK", 0.00119, "🇳🇴", "노르웨이2", 75.0),
        ("MYS2", "링깃", "MYR", 0.00342, "🇲🇾", "말레이시아2", 13.15),
        ("USA2", "달러", "USD", 0.00073, "🇺🇸", "미국2", 5.69),
        ("SWD2", "크로나", "SEK", 0.0077, "🇸🇪", "스웨덴2", 61.29),
        ("CHE2", "프랑", "CHF", 0.00065, "🇨🇭", "스위스2", 7.1),
        ("GBR2", "파운드", "GBP", 0.00057, "🇬🇧", "영국2", 4.49),
        ("JPN2", "엔", "JPY", 0.11658, "🇯🇵", "일본2", 450.0),
        ("CHN2", "위안", "CNY", 0.00527, "🇨🇳", "중국2", 25.0),
        ("CAN2", "달러", "CAD", 0.00099, "🇨🇦", "캐나다2", 7.47),
        ("HKG2", "달러", "HKD", 0.00567, "🇭🇰", "홍콩2", 23.0),
        ("THA2", "바트", "THB", 0.02666, "🇹🇭","태국2", 135.0),
        ("AUS2", "달러", "AUD", 0.00109, "🇦🇺", "호주2", 7.7),
        ("NZL2", "달러", "NZD", 0.00119, "🇳🇿","뉴질랜드2", 8.2),
        ("SGP2", "달러", "SGD", 0.00098, "🇸🇬","싱가포르2", 6.65),
        ("GBR2", "파운드", "GBP", 0.00057, "🇬🇧", "영국2", 4.49),
        ("NOR2", "크로네", "NOK", 0.00119, "🇳🇴", "노르웨이2", 75.0),
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
    
    private lazy var countries: [Country] = {
        rawData
            .map {
                Country(
                    isoCountryCode: $0.0,
                    name: $0.5,
                    flag: $0.4,
                    currency: Currency(
                        name: $0.1,
                        code: $0.2,
                        rate: $0.3
                    ),
                    localPrice: $0.6
                )
            }
    }()
    
    func exchange(_ money: Int, to countryId: Country.ID) -> Double {
        if let target = countries.first(where: { $0.id == countryId }) {
            return target.currency.rate * Double(money)
        } else {
            return 0.0
        }
    }
    
    func countBigmacs(
        with exchangedMoney: Double,
        countryId: Country.ID
    ) -> Int {
        let targetCountry = countries
            .first(where: { $0.id == countryId })!
        let targetBigmacPrice = localPrices
            .first(where: { targetCountry.name == $0.key })!
            .value
        
        return Int(exchangedMoney / targetBigmacPrice)
    }
    
    func getAvailableCountries() -> [Country] {
        countries
    }
    
    func readyToUpdateUI() -> AnyPublisher<Bool, Never> {
        Just(true)
            .delay(for: .seconds(0.2), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
