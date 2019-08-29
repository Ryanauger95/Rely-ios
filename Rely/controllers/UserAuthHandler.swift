//
//  UserAuthHandler.swift
//  Rely
//
//  Created by kavii on 4/5/19.
//  Copyright © 2019 kavii. All rights reserved.
//

import Foundation


class UserAuthHandler{
    
    // manage logout
    func userLogout(){
        UserDefaults.standard.set(nil , forKey: "userDetails")
    }
    
    // check is logged?
    func isUserLogged() -> Bool{
       let decoded  = UserDefaults.standard.data(forKey: "userDetails")
        if decoded != nil{
            return true
        }
       return false
    }
    
}
