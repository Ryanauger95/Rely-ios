//
//  Request.swift
//  Rely
//
//  Created by Ryan Auger on 7/1/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

class RequestBuilder {
    var payer : User?
    var collector : User?
    var originator: Int!
    var totalAmount: Double?
    var reserveAmount: Double?
    var description: String?
    
    init(originator: Int) {
        self.originator = originator
    }
}
