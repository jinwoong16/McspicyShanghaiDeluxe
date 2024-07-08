//
//  BigmacCSVParser.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/3/24.
//

import Foundation
import TabularData
import os

final class BigmacCSVParser {
    private let logger: Logger
    
    init() {
        self.logger = Logger(
            subsystem: "co.kr.codegrove.McspicyShanghaiDeluxe",
            category: "BigmacCSVParser"
        )
    }
    
    func parse() -> [BigmacIndex] {
        let filePath = Bundle.main.path(forResource: "big-mac-2024-01-01", ofType: "csv")!
        let fileURL = URL(fileURLWithPath: filePath)
        let options = CSVReadingOptions()
        
        do {
            let columns = ["Country", "iso_a3", "currency_code", "local_price"]
            let dataFrame = try DataFrame(contentsOfCSVFile: fileURL, columns: columns, options: options)
            
            logger.debug("Successfully created data frame - Countries: \(dataFrame.rows.count)")
            
            return dataFrame
                .rows
                .compactMap { row in
                    guard let countryName = row["Country"] as? String,
                          let isoCode = row["iso_a3"] as? String,
                          let currencyCode = row["currency_code"] as? String,
                          let localPrice = row["local_price"] as? Double else {
                        logger.debug("Missing row is \(row)")
                        return nil
                    }
                    return BigmacIndex(
                        countryName: countryName,
                        isoCountryCode: isoCode,
                        currencyCode: currencyCode,
                        localPrice: localPrice
                    )
                }
        } catch {
            logger.error("Erro occured when csv parsing: \(error)")
            return []
        }
    }
}
