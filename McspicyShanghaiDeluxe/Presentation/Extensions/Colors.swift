//
//  Colors.swift
//  McspicyShanghaiDeluxe
//
//  Created by Yule on 7/5/24.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let mainColor = UIColor(hex: "FFC327") // 메인 컬러
    static let backgroundColor = UIColor(hex: "232123") // 배경 컬러
    static let defaultBoxColor = UIColor(hex: "363336") // 디폴트 박스 컬러
    static let destinationCountryButtonColor = UIColor(hex: "504B50") // 상대국가 선택 버튼 컬러
    static let bigMacCountBGBoxColor = UIColor(hex: "2C292C") // 인덱스탭 빅맥 갯수 배경 박스 컬러
    static let bigMacCountBoxColor = UIColor(hex: "0D0D0D") // 인덱스탭 빅맥 갯수 박스 컬러
    static let slotBox = UIColor(hex: "1D1B1D") // 햄버거 슬롯박스 컬러
    static let secondaryTextColor = UIColor(hex: "999999") // 보조 텍스트 컬러
    static let unselectedIcon = UIColor(hex: "3E3C3E") // 선택되지 않은 아이콘 컬러
    static let searchBarColor = UIColor(hex: "646464") // 서큘러뷰 검색바 컬러
    static let addButton = UIColor(hex: "D6D6D6") // 서큘러뷰 변경하기 버튼
}
