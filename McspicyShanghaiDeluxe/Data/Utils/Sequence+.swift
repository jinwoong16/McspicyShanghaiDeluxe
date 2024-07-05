//
//  Sequence+.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/4/24.
//

import Foundation

extension Sequence where Element: Identifiable {
    func groupingByID() -> [Element.ID: Element] {
        return Dictionary(uniqueKeysWithValues: self.map { ($0.id, $0) })
    }
}
