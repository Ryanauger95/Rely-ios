//
//  UIView+Gradient.swift
//  Rely
//
//  Created by Ryan Auger on 7/20/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation
import UIKit

enum gridLoc : Int{
    case TOP_LEFT
    case TOP_MIDDLE
    case TOP_RIGHT
    case BOTTOM_LEFT
    case BOTTOM_MIDDLE
    case BOTTOM_RIGHT
    case LEFT_MIDDLE
    case RIGHT_MIDDLE
}
let gridArr : [CGPoint] = [ CGPoint(x: 0,y: 1),
                CGPoint(x: 0.5,y: 1.0),
                CGPoint(x: 1.0,y: 1.0),
                CGPoint(x: 0,y: 0),
                CGPoint(x: 0.5, y: 0.0),
                CGPoint(x: 1.0,y: 0.0),
                CGPoint(x: 0.0,y: 0.5),
                CGPoint(x: 1.0,y: 0.5),
                ]

extension UIView {

    func setGradientBackgroundColor(colorOne: UIColor, colorTwo: UIColor, startPoint: gridLoc.RawValue, endPoint: gridLoc.RawValue)  {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = gridArr[startPoint]
        gradientLayer.endPoint = gridArr[endPoint]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientBackgroundColor(colorOne: UIColor, colorTwo: UIColor) {
        setGradientBackgroundColor(colorOne: colorOne, colorTwo: colorTwo, startPoint: gridLoc.BOTTOM_MIDDLE.rawValue, endPoint: gridLoc.TOP_MIDDLE.rawValue)
    }
}
