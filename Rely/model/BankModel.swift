//
//  BankModel.swift
//  Rely
//
//  Created by Ryan Auger on 7/16/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation
class BankModel{
    var id : String
    var name: String
    var mask: String
    var type: String
    var subtype: String
    
    init(id: String, name: String, mask: String, type: String, subtype: String) {
        self.id = id
        self.name = name
        self.mask = mask
        self.type = type
        self.subtype = subtype
    }
}

