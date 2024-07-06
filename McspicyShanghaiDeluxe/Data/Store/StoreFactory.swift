//
//  StoreFactory.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/4/24.
//

import Foundation
import os

final class StoreFactory {
    private let bigmacCSVParser: BigmacCSVParser
    private let apiService: any ApiService
    private let logger: Logger
    
    private var bigmacIndexStore: (any ModelStore<BigmacIndex>)?
    private var isoCodeMapper = [String: [BigmacIndex]]()
    
    init(
        bigmacCSVParser: BigmacCSVParser,
        apiService: any ApiService
    ) {
        self.bigmacCSVParser = bigmacCSVParser
        self.apiService = apiService
        self.logger = Logger(
            subsystem: "co.kr.codegrove.McspicyShanghaiDeluxe",
            category: "StoreFactory"
        )
    }
    
    func buildBigmacIndexStore() -> any ModelStore<BigmacIndex> {
        let bigmacIndices = bigmacCSVParser.parse()

        isoCodeMapper = Dictionary(grouping: bigmacIndices, by: { $0.currencyCode })
            
        self.bigmacIndexStore = AnyModelStore(models: bigmacIndices)
        
        return bigmacIndexStore!
    }
    
    func buildCountryStore() async -> some ModelStore<Country> {
        guard let bigmacIndexStore else {
            logger.debug("No parsed bigmac index data.")
            return AnyModelStore(models: [])
        }
        
        let allCurrencyCodes = bigmacIndexStore
            .fetchAll()
            .map { $0.currencyCode }
            .joined(separator: ",")
        
        let endpoint: Endpoint<CurrencyDTO> = Endpoint(
            baseURL: "https://api.frankfurter.app",
            path: "/latest",
            queryItems: [
                .init(name: "from", value: "KRW"),
                .init(name: "to", value: allCurrencyCodes)
            ]
        )
        
        do {
            let currencyDto = try await apiService.request(with: endpoint)
            
            return AnyModelStore(models: currencyDto.rates.flatMap(transform))
        } catch {
            logger.error("Error occured: \(error)")
            
            return AnyModelStore(models: [])
        }
    }
    
    private func transform(_ currencyRateDto: CurrencyRateDTO) -> [Country] {
        guard let bigmacIndices = isoCodeMapper[currencyRateDto.code] else {
            return []
        }
        
        return bigmacIndices
            .compactMap { bigmacIndex in
                guard let localizedCurrencyName = getCurrencyName(by: bigmacIndex.currencyCode),
                      let localizedCountryName = getCountryName(by: bigmacIndex.isoCountryCode),
                      let countryFlag = getCountryFlag(countryCode: bigmacIndex.isoCountryCode) else {
                    return nil
                }
                
                return Country(
                    isoCountryCode: bigmacIndex.isoCountryCode,
                    name: localizedCountryName,
                    flag: countryFlag,
                    currency: Currency(
                        name: localizedCurrencyName,
                        code: bigmacIndex.currencyCode,
                        rate: currencyRateDto.rate
                    ),
                    localPrice: bigmacIndex.localPrice
                )
            }
    }
    
    private func getCurrencyName(
        by currencyCode: String,
        languageCode: Locale.LanguageCode = .korean,
        languageRegion: Locale.Region = .southKorea
    ) -> String? {
        let locale = Locale(languageCode: languageCode, languageRegion: languageRegion)
        
        return locale.localizedString(forCurrencyCode: currencyCode)
    }
    
    private func getCountryName(
        by isoA3Code: String,
        languageCode: Locale.LanguageCode = .korean,
        languageRegion: Locale.Region = .southKorea
    ) -> String? {
        let locale = Locale(languageCode: languageCode, languageRegion: languageRegion)
        
        return locale.localizedString(forRegionCode: isoA3Code)
    }
    
    private func getCountryFlag(
        countryCode isoA3Code: String,
        languageCode: Locale.LanguageCode = .korean
    ) -> String? {
        let locale = Locale(languageCode: languageCode, languageRegion: Locale.Region(isoA3Code))
        
        return locale
            .region?
            .identifier
            .unicodeScalars
            .map { 127397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}

