//
//  baseCurrencyTextField.swift
//  McspicyShanghaiDeluxe
//
//  Created by Yule on 7/2/24.
//

import UIKit

final class BaseCurrencyView: UIView {
    let baseCurrencyCountryLabel = BaseCurrencyCountryLabel()
    let baseCurrencyTextField = BaseCurrencyTextField()
    let exchangeIcon = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(baseCurrencyCountryLabel)
        addSubview(baseCurrencyTextField)
        addSubview(exchangeIcon)
        
        baseCurrencyCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        baseCurrencyTextField.translatesAutoresizingMaskIntoConstraints = false
        exchangeIcon.translatesAutoresizingMaskIntoConstraints = false
    }
}

// TODO: 피커뷰 버튼으로 변경
final class BaseCurrencyCountryLabel: UILabel {
    private var topInset: CGFloat = 10
    private var leftInset: CGFloat = 15
    private var rightInset: CGFloat = 15
    private var bottomInset: CGFloat = 10
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

// TODO: textfield 보더 밑변만 주기
final class BaseCurrencyTextField: UITextField {
    let baseCurrencySuffixLabel = UIButton()
    let textFieldmaxCharacters = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(baseCurrencySuffixLabel)
        
        baseCurrencySuffixLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
