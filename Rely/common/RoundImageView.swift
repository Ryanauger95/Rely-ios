//
//  RoundImageView.swift
//  Rely
//
//  Created by Ryan Auger on 7/8/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }

}
