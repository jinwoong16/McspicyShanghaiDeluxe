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
    let exchangeIcon = UIImageView()
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
        baseCurrencySuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        exchangeIcon.translatesAutoresizingMaskIntoConstraints = false
        
        baseCurrencyCountryLabel.text = "🇰🇷 대한민국"
        baseCurrencyCountryLabel.textColor = .white
        baseCurrencyCountryLabel.font = UIFont.systemFont(ofSize: 16)
        baseCurrencyCountryLabel.backgroundColor = .defaultBoxColor
        baseCurrencyCountryLabel.layer.cornerRadius = 5
        baseCurrencyCountryLabel.layer.masksToBounds = true
        
        baseCurrencySuffixLabel.text = " 원"
        baseCurrencySuffixLabel.textColor = .white
        baseCurrencySuffixLabel.font = UIFont.interRegular(ofSize: 36)
        
        exchangeIcon.image = UIImage(systemName: "chevron.down")
        exchangeIcon.tintColor = UIColor.secondaryTextColor
        exchangeIcon.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            baseCurrencyCountryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            baseCurrencyCountryLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            baseCurrencyTextField.topAnchor.constraint(equalTo: baseCurrencyCountryLabel.bottomAnchor, constant: 20),
            baseCurrencyTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 43),
//            baseCurrencyTextField.widthAnchor.constraint(equalToConstant: 307),
            baseCurrencyTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -43),
            //이 코드로 바꾸고 싶은데 이걸로 바꾸면 화면이 찌그러져요 ...
            
            baseCurrencySuffixLabel.leadingAnchor.constraint(equalTo: baseCurrencyTextField.trailingAnchor, constant: -45),
            baseCurrencySuffixLabel.bottomAnchor.constraint(equalTo: baseCurrencyTextField.bottomAnchor, constant: -2),
            
            exchangeIcon.topAnchor.constraint(equalTo: baseCurrencyTextField.bottomAnchor, constant: 30),
            exchangeIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            exchangeIcon.widthAnchor.constraint(equalToConstant: 22),
            exchangeIcon.heightAnchor.constraint(equalToConstant: 22)
            
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

final class BaseCurrencyTextField: UITextField, UITextFieldDelegate {
    let textFieldmaxCharacters = 10
    private let placeholderAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.lightGray,
        .font: UIFont.interRegular(ofSize: 40)
    ]
    private let bottomBorder = CALayer()
    private let numberFormatter = NumberFormatter()
    
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
        
        self.attributedPlaceholder = NSAttributedString(string: "0", attributes: placeholderAttributes)
        self.font = UIFont.interLight(ofSize: 36)
        self.textColor = .white
        self.textAlignment = .right
        self.keyboardType = .numberPad
        
        // 금액 입력되는 오른쪽에 패딩을 주어서 "원"이랑 겹치지 않게 했어요.
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        
        self.delegate = self
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorder.frame = CGRect(x: 0, y: frame.height + 5, width: frame.width, height: 1)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        let filterdText = newText.filter { "0123456789".contains($0) }
        
        if filterdText.count > textFieldmaxCharacters {
            return false
        }
        
        if let number = numberFormatter.number(from: filterdText) {
            if let formattedNumber = numberFormatter.string(from: number) {
                textField.text = formattedNumber
                print("formattedNumber: \(formattedNumber)")
            } else {
                textField.text = ""
            }
        } else if newText.isEmpty {
            textField.text = ""
        }
        return false
    }
}

#Preview {
    BaseCurrencyView()
}

