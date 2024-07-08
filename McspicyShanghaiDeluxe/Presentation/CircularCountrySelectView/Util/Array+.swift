//
//  Array+.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/9/24.
//

import Foundation

extension Array {
    func rotated(by offset: Int) -> Self {
        return Array(self[offset..<self.endIndex] + self[self.startIndex..<offset])
    }
}
