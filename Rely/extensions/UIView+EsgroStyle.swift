//
//  UIView+lightGreenStyle.swift
//  Rely
//
//  Created by Ryan Auger on 7/11/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

extension UIView {
    func lightGreenStyle() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(rgb: 0x25D7FD).cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.clipsToBounds = true
    }
    func greenStyle() {
        self.setGradientBackgroundColor(colorOne: UIColor(rgb: 0x25D7FD), colorTwo: UIColor(rgb: 0x25D7FD), startPoint: gridLoc.LEFT_MIDDLE.rawValue, endPoint: gridLoc.RIGHT_MIDDLE.rawValue)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
    }
}
