//
//  ConvertedAmountLabel.swift
//  McspicyShanghaiDeluxe
//
//  Created by Yule on 7/2/24.
//

import UIKit

final class ConvertedAmountLabel: UIView {
    let destinationCountryButton = DestinationCountryButton()
    let convertedAmountLabel = UILabel()
    let convertedAmountSuffixLabel = UILabel()
    let convertedAmountUnderLine = UIView()
    let fromLabel = UILabel() //에서
    let toLabel = UILabel() //(으)로

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .backgroundColor
        
        addSubview(destinationCountryButton)
        addSubview(convertedAmountLabel)
        addSubview(convertedAmountSuffixLabel)
        addSubview(convertedAmountUnderLine)
        addSubview(fromLabel)
        addSubview(toLabel)
        
        destinationCountryButton.translatesAutoresizingMaskIntoConstraints = false
        convertedAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        convertedAmountSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        convertedAmountUnderLine.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        
        destinationCountryButton.setTitle("🇺🇸 미국", for: .normal)
        destinationCountryButton.setTitleColor(.white, for: .normal)
        destinationCountryButton.titleLabel?.font = UIFont.interExtraLight(ofSize: 16)
        destinationCountryButton.backgroundColor = .defaultBoxColor
        destinationCountryButton.layer.cornerRadius = 5
        destinationCountryButton.layer.masksToBounds = true
        
        fromLabel.text = "에서"
        fromLabel.textColor = .secondaryTextColor
        fromLabel.font = UIFont.interExtraLight(ofSize: 15)
        
        convertedAmountUnderLine.backgroundColor = .secondaryTextColor
        
        NSLayoutConstraint.activate([
            destinationCountryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            destinationCountryButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 326), //뷰컨에 붙이고 나서 쉐브론 기준으로 다시 계산하기
            
            fromLabel.leadingAnchor.constraint(equalTo: destinationCountryButton.trailingAnchor, constant: 5),
            fromLabel.bottomAnchor.constraint(equalTo: destinationCountryButton.bottomAnchor, constant: -8),
            
            convertedAmountUnderLine.topAnchor.constraint(equalTo: destinationCountryButton.bottomAnchor, constant: 60),
            convertedAmountUnderLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 43),
            convertedAmountUnderLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -43),
            convertedAmountUnderLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}

final class DestinationCountryButton: UIButton {
    private var topInset: CGFloat = 3
    private var leftInset: CGFloat = 15
    private var rightInset: CGFloat = 15
    private var bottomInset: CGFloat = 3
    
    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.draw(rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}


#Preview {
    ConvertedAmountLabel()
}
