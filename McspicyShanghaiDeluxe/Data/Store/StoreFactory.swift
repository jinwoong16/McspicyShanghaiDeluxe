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
    
    init(
        bigmacCSVParser: BigmacCSVParser,
        apiService: any ApiService,
        logger: Logger = .init(.default)
    ) {
        self.bigmacCSVParser = bigmacCSVParser
        self.apiService = apiService
        self.logger = logger
    }
    
    func buildBigmacIndexStore() -> any ModelStore<BigmacIndex> {
        let bigmacIndices = bigmacCSVParser.parse()
        self.bigmacIndexStore = AnyModelStore(models: bigmacIndices)
        
        return bigmacIndexStore!
    }
    
    func buildCurrencyStore() async -> some ModelStore<Currency> {
        guard let bigmacIndexStore else {
            logger.debug("No pared bigmac index data.")
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
            
            return AnyModelStore(models: currencyDto.rates.compactMap(transform))
        } catch {
            logger.error("Error occured: \(error)")
            
            return AnyModelStore(models: [])
        }
    }
    
    private func transform(_ currencyRateDto: CurrencyRateDTO) -> Currency? {
        guard let bigmacIndexStore,
              let bigmacIndex = bigmacIndexStore.fetch(by: currencyRateDto.code),
              let localizedCurrencyName = getCurrencyName(by: bigmacIndex.currencyCode),
              let localizedCountryName = getCountryName(by: bigmacIndex.isoCountryCode),
              let countryFlag = getCountryFlag(countryCode: bigmacIndex.isoCountryCode) else {
            return nil
        }
        
        return Currency(
            name: localizedCurrencyName,
            code: currencyRateDto.code,
            rate: currencyRateDto.rate,
            country: Country(
                name: localizedCountryName,
                flag: countryFlag
            )
        )
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

