//
//  ConvertedAmountLabel.swift
//  McspicyShanghaiDeluxe
//
//  Created by Yule on 7/2/24.
//

import UIKit

final class ConvertedAmountLabel: UIView {
    let destinationCountryButton = UIButton()
    let convertedAmountLabel = UILabel()
    let convertedAmountSuffixLabel = UILabel()
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
        addSubview(fromLabel)
        addSubview(toLabel)
        
        destinationCountryButton.translatesAutoresizingMaskIntoConstraints = false
        convertedAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        convertedAmountSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
