//
//  Fonts.swift
//  McspicyShanghaiDeluxe
//
//  Created by Yule on 7/5/24.
//

import Foundation
import UIKit

struct Fonts {
    static let interLight: String = "Inter-Light"
    static let interExtraLight: String = "Inter-ExtraLight"
    static let interRegular: String = "Inter-Regular"
}

extension UIFont {
    static func interRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Fonts.interRegular, size: size)!
    }

    static func interLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Fonts.interLight, size: size)!
    }

    static func interExtraLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Fonts.interExtraLight, size: size)!
    }
}
