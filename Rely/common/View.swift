//
//  View.swift
//  Rely
//
//  Created by Ryan Auger on 6/28/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import UIKit

class View: UIView {
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
        self.dropShadow()
    }
    

}
