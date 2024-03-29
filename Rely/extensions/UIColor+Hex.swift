//
//  UIColor+Convenience.swift
//  RelySIGNATURE
//
//  Created by Ryan Auger on 5/19/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: Double) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    convenience init(rgb: Int, alpha: Double) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
    convenience init(rgb: Int) {
        self.init(rgb: rgb, alpha: 1.0)
    }
}
