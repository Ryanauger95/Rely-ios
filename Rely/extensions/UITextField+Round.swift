//
//  UITextField+Round.swift
//  Rely
//
//  Created by Ryan Auger on 7/9/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

extension UITextField {

    func addCorners() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.3
    }
}
