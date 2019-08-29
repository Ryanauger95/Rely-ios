//
//  LGButton.swift
//  Rely
//
//  Created by Ryan Auger on 7/10/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

class LightGreenButton: UIButton {
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
        self.layer.backgroundColor = UIColor.white.cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(rgb: 0x25D7FD).cgColor
        self.titleLabel?.textColor = UIColor.black
    }
}
