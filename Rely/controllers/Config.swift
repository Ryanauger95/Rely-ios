//
//  Config.swift
//  Rely
//
//  Created by Ryan Auger on 6/2/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation

class Config {
    #if targetEnvironment(simulator)
//    var rootUrl = "https://node.Relyapi.com"
    var rootUrl = "http://localhost:3000"
    #else
    // Device-specific code
    var rootUrl = "https://node.Relyapi.com"
    #endif
    
}
