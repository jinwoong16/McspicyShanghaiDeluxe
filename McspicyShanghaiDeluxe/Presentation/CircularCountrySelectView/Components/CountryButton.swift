//
//  CountryButton.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/7/24.
//

import UIKit

final class CountryButton: UIButton {
    private lazy var countryLabel: UILabel = {
        let countryLabel = UILabel()
        countryLabel.font = .interLight(ofSize: 17)
        
        return countryLabel
    }()
    
    private let country: Country
    
    init(country: Country) {
        self.country = country
        super.init(frame: .zero)
        
        configureUI()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(countryLabel)
        
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: topAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configureLabel() {
        countryLabel.text = "\(country.name) / \(country.currency.code)"
    }
}

#Preview {
    let button = CountryButton(country: Country(isoCountryCode: "", name: "Korea", flag: "🇰🇷", currency: Currency(name: "won", code: "KRW", rate: 0), localPrice: 0))
    return button
}
