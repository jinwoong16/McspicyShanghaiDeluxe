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
    let baseCurrencySuffixLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .backgroundColor
        
        addSubview(baseCurrencyCountryLabel)
        addSubview(baseCurrencyTextField)
        addSubview(baseCurrencySuffixLabel)
        addSubview(exchangeIcon)
        
        baseCurrencyCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        baseCurrencyTextField.translatesAutoresizingMaskIntoConstraints = false
        exchangeIcon.translatesAutoresizingMaskIntoConstraints = false
        baseCurrencySuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        
        baseCurrencyCountryLabel.text = "🇰🇷 대한민국"
        baseCurrencyCountryLabel.textColor = .white
        baseCurrencyCountryLabel.font = UIFont.systemFont(ofSize: 16)
        baseCurrencyCountryLabel.backgroundColor = .defaultBoxColor
        baseCurrencyCountryLabel.layer.cornerRadius = 5
        baseCurrencyCountryLabel.layer.masksToBounds = true
        
        baseCurrencySuffixLabel.text = " 원"
        baseCurrencySuffixLabel.textColor = .white
        baseCurrencySuffixLabel.font = UIFont.interRegular(ofSize: 36)
        
        NSLayoutConstraint.activate([
            baseCurrencyCountryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            baseCurrencyCountryLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            baseCurrencyTextField.topAnchor.constraint(equalTo: baseCurrencyCountryLabel.bottomAnchor, constant: 40),
            baseCurrencyTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 43),
            baseCurrencyTextField.widthAnchor.constraint(equalToConstant: 307),
//            baseCurrencyTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -43),
            //이 코드로 바꾸고 싶은데 이걸로 바꾸면 화면이 찌그러져요 ...
            
            baseCurrencySuffixLabel.leadingAnchor.constraint(equalTo: baseCurrencyTextField.trailingAnchor, constant: -45),
            baseCurrencySuffixLabel.bottomAnchor.constraint(equalTo: baseCurrencyTextField.bottomAnchor)
            
        ])
    }
}

// TODO: 피커뷰 버튼으로 변경
final class BaseCurrencyCountryLabel: UILabel {
    private var topInset: CGFloat = 8
    private var leftInset: CGFloat = 15
    private var rightInset: CGFloat = 15
    private var bottomInset: CGFloat = 8
    
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

final class BaseCurrencyTextField: UITextField {
    let textFieldmaxCharacters = 10
    private let bottomBorder = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        bottomBorder.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(bottomBorder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorder.frame = CGRect(x: 0, y: frame.height + 5, width: frame.width, height: 1)
    }
}

#Preview {
    BaseCurrencyView()
}
