//
//  Config.swift
//  Rely
//
//  Created by kavii on 4/2/19.
//  Copyright © 2019 kavii. All rights reserved.
//

import Foundation

class Config {
    var webCredentialUrl = "node.Relyapi.com"
    var pyUrl = "http://localhost:8080"
    
    #if targetEnvironment(simulator)
    // Simulator-specific code
//    var rootUrl = "https://node.Relyapi.com"
    var rootUrl = "http://localhost:3000"
    #else
    // Device-specific code
    var rootUrl = "https://node.Relyapi.com"
    #endif
    
}
