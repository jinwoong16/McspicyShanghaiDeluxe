//
//  IntensityVisualEffectView.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/10/24.
//

import UIKit

final class IntensityVisualEffectView: UIVisualEffectView {
    private let targetEffect: UIVisualEffect
    private let intensity: CGFloat
    private var animator: UIViewPropertyAnimator?
    
    init(effect: UIVisualEffect, intensity: CGFloat) {
        self.targetEffect = effect
        self.intensity = intensity
        
        super.init(effect: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinit")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
            self?.effect = self?.targetEffect
        }
        animator?.fractionComplete = intensity
    }
}

