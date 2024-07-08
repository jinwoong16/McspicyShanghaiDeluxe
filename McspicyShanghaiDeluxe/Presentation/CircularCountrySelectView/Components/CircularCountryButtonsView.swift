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
    
    private var rotateAngle: CGFloat {
        2 * .pi / CGFloat(countryButtons.count)
    }
    
    private var countryCount: Int {
        countryButtons.count
    }
    
    init(countries: [Country]) {
        self.countryButtons = countries.map(CountryButton.init(country:))
        super.init(frame: .zero)
        
        configureuUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(
            x: bounds.width / 2,
            y: bounds.height / 2
        )
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: .zero) {
            self.countryButtons.enumerated().forEach { index, button in
                let angle = self.theta * CGFloat(index) + self.angle
                let half = button.frame.width / 2
                
                button.center = CGPoint(
                    x: center.x + (half + self.minorAxis) * cos(angle) - self.minorAxis * 1.2,
                    y: center.y + (half + self.majorAxis) * sin(angle)
                )
                button.transform = CGAffineTransform(rotationAngle: angle)
            }
        }
    }
    
    func rotate(to direction: RotateDirection) {
        self.angle += rotateAngle * direction.rawValue
        setNeedsLayout()
    }
    
    func updateCheckmark() {
        let index = calculateIndex(
            with: Int(round(angle / rotateAngle)) % countryCount
        )
        
        if index != currentCountryIndex {
            countryButtons[currentCountryIndex].turnOff()
            countryButtons[index].turnOn()
            
            currentCountryIndex = index
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
        countryButtons.forEach { countryButton in
            countryButton.sizeToFit()
            
            addSubview(countryButton)
            
        }
        countryButtons.first?.turnOn()
        theta = 2 * .pi / CGFloat(countryButtons.count)
    }
}
