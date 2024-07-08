//
//  CircularCountryButtonsView.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/7/24.
//

import UIKit

final class CircularCountryButtonsView: UIView {
    enum RotateDirection: CGFloat {
        case up = -1
        case down = 1
    }
    
    private let countryButtons: [CountryButton]
    
    private var angle: CGFloat = 0
    private let minorAxis: CGFloat = 250
    private let majorAxis: CGFloat = 320
    private var theta: CGFloat = 0
    private var currentCountryIndex: Int = 0
    
    private var countryCount: Int {
        countryButtons.count
    }
    
    var selectedCountry: Country {
        countryButtons[currentCountryIndex].country
    }
    
    init(
        countries: [Country],
        currentCountry: Country? = nil,
        frame: CGRect = .zero
    ) {
        if let currentCountry,
           let index = countries.firstIndex(where: { $0.name == currentCountry.name }) {
            self.countryButtons = countries
                .rotated(by: index)
                .map(CountryButton.init(country:))
        } else {
            self.countryButtons = countries.map(CountryButton.init(country:))
        }
        super.init(frame: frame)
        
        configureuUI()
        setPosition(to: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate(to direction: RotateDirection) {
        self.angle += theta * direction.rawValue
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: .zero) {
            self.setPosition(to: self.angle)
        }
    }
    
    func updateCheckmark() {
        let index = calculateIndex(
            with: Int(round(angle / theta)) % countryCount
        )
        
        if index != currentCountryIndex {
            countryButtons[currentCountryIndex].turnOff()
            countryButtons[index].turnOn()
            
            currentCountryIndex = index
        }
    }
    
    private func setPosition(to angle: CGFloat) {
        let center = CGPoint(
            x: bounds.width / 2,
            y: bounds.height / 2
        )
        
        countryButtons.enumerated().forEach { index, button in
            let angle = theta * CGFloat(index) + angle
            let half = button.frame.width / 2
            
            button.center = CGPoint(
                x: center.x + (half + minorAxis) * cos(angle) - minorAxis * 1.2,
                y: center.y + (half + majorAxis) * sin(angle)
            )
            button.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    private func calculateIndex(with position: Int) -> Int {
        if position <= 0 {
            return abs(position)
        } else {
            return countryCount - position
        }
    }
    
    private func configureuUI() {
        countryButtons.enumerated().forEach { index, countryButton in
            countryButton.sizeToFit()
            countryButton.addAction(
                UIAction { [weak self] action in
                    guard let self else {
                        return
                    }
                    self.countryButtons[self.currentCountryIndex].turnOff()
                    self.countryButtons[index].turnOn()
                    self.currentCountryIndex = index
                },
                for: .touchUpInside
            )
            
            addSubview(countryButton)
        }
        countryButtons.first?.turnOn()
        theta = 2 * .pi / CGFloat(countryButtons.count)
    }
}
