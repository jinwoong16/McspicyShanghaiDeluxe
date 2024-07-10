//
//  FeedbackHandler.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/8/24.
//

import UIKit
import AudioToolbox

final class FeedbackHandler {
    private let hapticGenerator: UISelectionFeedbackGenerator
    
    init(targetView: UIView) {
        self.hapticGenerator = UISelectionFeedbackGenerator(view: targetView)
    }
    
    func sendFeedback() {
        hapticGenerator.selectionChanged()
        AudioServicesPlaySystemSound(1157)
    }
}
