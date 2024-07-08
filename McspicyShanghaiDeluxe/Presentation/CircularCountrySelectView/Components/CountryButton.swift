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
    
    private lazy var checkImageView: UIImageView = {
        let checkImageView = UIImageView()
        checkImageView.image = UIImage(systemName: "checkmark")
        checkImageView.alpha = 0
        
        return checkImageView
    }()
    
    private(set) var country: Country
    
    init(country: Country) {
        self.country = country
        super.init(frame: .zero)
        
        configureUI()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeToFit() {
        super.sizeToFit()
        let width = countryLabel.bounds.width + checkImageView.bounds.width
        let height = countryLabel.bounds.height + checkImageView.bounds.height
    
        frame = CGRect(x: 0, y: 0, width: width + 10, height: height)
    }
    
    private func configureUI() {
        addSubview(countryLabel)
        addSubview(checkImageView)
        
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        checkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: topAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            checkImageView.leadingAnchor.constraint(equalTo: countryLabel.trailingAnchor, constant: 10),
            checkImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        checkImageView.transform = CGAffineTransform(translationX: -30, y: 0).scaledBy(x: 0.3, y: 0.3)
    }
    
    func configureLabel() {
        countryLabel.text = "\(country.name) / \(country.currency.code)"
        countryLabel.sizeToFit()
        checkImageView.sizeToFit()
    }
    
    func turnOn() {
        let springParameter = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: .init(dx: 0.8, dy: 0.8))
        let animator = UIViewPropertyAnimator(duration: 0.6, timingParameters: springParameter)
        
        animator.addAnimations {
            self.checkImageView.alpha = 1
            self.checkImageView.transform = .identity
        }
        
        animator.startAnimation()
    }
    
    func turnOff() {
        let springParameter = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: .init(dx: 0.8, dy: 0.8))
        let animator = UIViewPropertyAnimator(duration: 0.6, timingParameters: springParameter)
        
        animator.addAnimations {
            self.checkImageView.alpha = 0
            self.checkImageView.transform = CGAffineTransform(translationX: -30, y: 0).scaledBy(x: 0.3, y: 0.3)
        }
        
        animator.startAnimation()
    }
}
