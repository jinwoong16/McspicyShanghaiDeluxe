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
    let chevronRight = UIImageView()
    let convertedAmountUnderLine = UIView()
    let fromLabel = UILabel() //에서
    let toLabel = UILabel() //(으)로
    let destinationBackground = UIView()
    
    var toAmountLabels: [UILabel] = []
    var toAmountTopConstraints: [NSLayoutConstraint] = []
    
    private let calculator: BigmacCalculatable = BigmacCalculatorStub()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .backgroundColor
        
        addSubview(destinationBackground)
        addSubview(destinationCountryButton)
        addSubview(convertedAmountLabel)
        addSubview(convertedAmountSuffixLabel)
        addSubview(chevronRight)
        addSubview(convertedAmountUnderLine)
        addSubview(fromLabel)
        addSubview(toLabel)
        
        destinationCountryButton.translatesAutoresizingMaskIntoConstraints = false
        convertedAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        convertedAmountSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronRight.translatesAutoresizingMaskIntoConstraints = false
        convertedAmountUnderLine.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationBackground.translatesAutoresizingMaskIntoConstraints = false
        
        chevronRight.image = UIImage(systemName: "chevron.right")
        chevronRight.tintColor = UIColor.secondaryTextColor
        chevronRight.contentMode = .scaleAspectFit
        
        fromLabel.text = "에서"
        fromLabel.textColor = .secondaryTextColor
        fromLabel.font = UIFont.interExtraLight(ofSize: 15)
        
        convertedAmountSuffixLabel.text = " 달러"
        convertedAmountSuffixLabel.textColor = .white
        convertedAmountSuffixLabel.font = UIFont.interRegular(ofSize: 36)
        
        convertedAmountUnderLine.backgroundColor = .secondaryTextColor
        
        toLabel.text = "(으)로"
        toLabel.textColor = .secondaryTextColor
        toLabel.font = UIFont.interExtraLight(ofSize: 15)
        
        destinationBackground.backgroundColor = .defaultBoxColor
        destinationBackground.layer.cornerRadius = 15
        destinationBackground.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            destinationCountryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            destinationCountryButton.topAnchor.constraint(equalTo: destinationBackground.topAnchor, constant: 20),
            
            chevronRight.centerYAnchor.constraint(equalTo: destinationCountryButton.centerYAnchor, constant: 0),
            chevronRight.leadingAnchor.constraint(equalTo: destinationCountryButton.trailingAnchor, constant: -10),
            
            fromLabel.leadingAnchor.constraint(equalTo: destinationCountryButton.trailingAnchor, constant: 10),
            fromLabel.bottomAnchor.constraint(equalTo: destinationCountryButton.bottomAnchor, constant: -8),
            
            convertedAmountSuffixLabel.trailingAnchor.constraint(equalTo: convertedAmountUnderLine.trailingAnchor, constant: -5),
            convertedAmountSuffixLabel.bottomAnchor.constraint(equalTo: convertedAmountUnderLine.bottomAnchor, constant: -2),
            
            convertedAmountUnderLine.topAnchor.constraint(equalTo: destinationCountryButton.bottomAnchor, constant: 60),
            convertedAmountUnderLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 43),
            convertedAmountUnderLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -43),
            convertedAmountUnderLine.heightAnchor.constraint(equalToConstant: 1),
            
            toLabel.centerXAnchor.constraint(equalTo: convertedAmountUnderLine.centerXAnchor),
            toLabel.topAnchor.constraint(equalTo: convertedAmountUnderLine.bottomAnchor, constant: 20),
            
            destinationBackground.topAnchor.constraint(equalTo: topAnchor, constant: 302),
            destinationBackground.centerXAnchor.constraint(equalTo: centerXAnchor),
            destinationBackground.widthAnchor.constraint(equalToConstant: 357),
            destinationBackground.heightAnchor.constraint(equalToConstant: 353),
        ])
    }
    
    private func setupData() {
        let country = calculator.getAvailableCountries().first { $0.id == "USA" }!
        let exchangeAmount = calculator.exchange(10000, to: country.id)
        let bigmacCount = calculator.countBigmacs(with: exchangeAmount, countryId: country.id)
        
        destinationCountryButton.setTitle("\(country.flag) \(country.name)", for: .normal)
        setuptoAmountLabels(with: "\(bigmacCount)")
    }
    
    func setuptoAmountLabels(with text: String) {
        let formattedText = text.addThousandSeparators()
        let digits = Array(formattedText)
        var previousLabel: UILabel? = nil
        
        var totalWidth: CGFloat = 0
        var labelWidths: [CGFloat] = []
        
        for label in toAmountLabels {
            label.removeFromSuperview()
        }
        toAmountLabels.removeAll()
        toAmountTopConstraints.removeAll()
        
        for digit in digits {
            let toAmountLabel = createtoAmountLabel(with: String(digit))
            let labelWidth = toAmountLabel.intrinsicContentSize.width
            labelWidths.append(labelWidth)
            totalWidth += labelWidth + 5
        }
        
        if !labelWidths.isEmpty {
            totalWidth -= 5
        }
        
        for (_, digit) in digits.enumerated() {
            let toAmountLabel = createtoAmountLabel(with: String(digit))
            addSubview(toAmountLabel)
            
            let toAmountTopConstraint = toAmountLabel.topAnchor.constraint(equalTo: convertedAmountSuffixLabel.topAnchor, constant: -30)
            toAmountTopConstraints.append(toAmountTopConstraint)
            toAmountLabels.append(toAmountLabel)
            
            var toAmountConstraints = [toAmountTopConstraint]
            
            if let previous = previousLabel {
                toAmountConstraints.append(toAmountLabel.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 1))
            } else {
                toAmountConstraints.append(toAmountLabel.leadingAnchor.constraint(equalTo: convertedAmountSuffixLabel.leadingAnchor, constant: -totalWidth + 13))
            }
            
            NSLayoutConstraint.activate(toAmountConstraints)
            previousLabel = toAmountLabel
        }
        
        if let lastLabel = toAmountLabels.last {
            NSLayoutConstraint.activate([
                lastLabel.trailingAnchor.constraint(equalTo: convertedAmountSuffixLabel.leadingAnchor, constant: -1)
            ])
        }
        
        for label in toAmountLabels {
            bringSubviewToFront(label)
        }
        
        bringSubviewToFront(convertedAmountSuffixLabel)
        animateDigits()
    }
    
    func createtoAmountLabel(with text: String) -> UILabel {
        let toAmountLabel = UILabel()
        toAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        toAmountLabel.text = text
        toAmountLabel.font = UIFont.interLight(ofSize: 36)
        toAmountLabel.textColor = .white
        toAmountLabel.alpha = 0.0
        return toAmountLabel
    }
    
    func animateDigits() {
        UIView.animate(withDuration: 0.5) {
            for label in self.toAmountLabels {
                label.alpha = 1.0
            }
        }
    }
}

final class DestinationCountryButton: UIButton {
    let country: UILabel = UILabel()
    let chevron: UIImageView = UIImageView()
    let CountryBoxButton: UIImageView = UIImageView()
    
    
    //        destinationCountryButton.setTitle("🇺🇸 미국", for: .normal)
    //        destinationCountryButton.setTitleColor(.white, for: .normal)
    //        destinationCountryButton.titleLabel?.font = UIFont.interExtraLight(ofSize: 16)
    //        destinationCountryButton.backgroundColor = .destinationCountryButtonColor
    //        destinationCountryButton.layer.cornerRadius = 5
    //        destinationCountryButton.layer.masksToBounds = true
}

#Preview {
    ConvertedAmountLabel()
}

