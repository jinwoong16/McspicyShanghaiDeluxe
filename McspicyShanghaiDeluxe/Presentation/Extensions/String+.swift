//
//  String+.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/8/24.
//

import Foundation

extension String {
    func addThousandSeparators() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        
        if let number = numberFormatter.number(from: self),
           let formattedNumber = numberFormatter.string(from: number) {
            return formattedNumber
        } else {
            return nil
        }
    }
}
