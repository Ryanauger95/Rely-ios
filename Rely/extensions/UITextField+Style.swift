//
//  UITextField+InputStyle.swift
//  Rely
//
//  Created by Ryan Auger on 7/19/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

extension UITextField {
    func inputStyle() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 0.0
        
        if self.keyboardType == UIKeyboardType.decimalPad {
            self.addDoneButtonOnKeyboard()
        }
        self.setPadding(left: 10, right: 10)
        self.setBottomBorder()
    }
    func borderStyle() {
        self.layer.cornerRadius = self.layer.frame.height/4
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.3
        self.setPadding(left: 10, right: 10)
    }
}
