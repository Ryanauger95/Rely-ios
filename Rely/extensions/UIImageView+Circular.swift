//
//  UIView+Circular.swift
//  Rely
//
//  Created by Ryan Auger on 7/7/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func makeCircular() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
