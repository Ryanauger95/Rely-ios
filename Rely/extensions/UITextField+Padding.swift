//
//  UITextField+Padding.swift
//  Rely
//
//  Created by Ryan Auger on 7/9/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

extension UITextField {
    func setPadding(left: CGFloat, right: CGFloat){
        let paddingLeftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
        let paddingRightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
        self.leftView = paddingLeftView
        self.rightView = paddingRightView
        self.leftViewMode = .always
    }
}
