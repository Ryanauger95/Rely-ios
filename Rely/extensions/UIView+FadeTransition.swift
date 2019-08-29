//
//  UIView+FadeTransition.swift
//  Rely
//
//  Created by Ryan Auger on 7/1/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

// Usage: insert view.fadeTransition right before changing content


extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
