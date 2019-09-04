//
//  UserAuthHandler.swift
//  Rely
//
//  Created by Ryan Auger 6/15/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
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
