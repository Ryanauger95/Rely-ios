//
//  Button.swift
//  Rely
//
//  Created by Ryan Auger on 7/1/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.doInit()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.doInit()
    }
    
    func doInit() {
        self.setGradientBackgroundColor(colorOne: UIColor(rgb: 0x25D7FD), colorTwo: UIColor(rgb: 0x25D7FD), startPoint: gridLoc.LEFT_MIDDLE.rawValue, endPoint: gridLoc.RIGHT_MIDDLE.rawValue)
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
