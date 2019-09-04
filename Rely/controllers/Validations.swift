//
//  Validations.swift
//  Rely
//
//  Created by Ryan Auger on 6/4/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation

class Validations{
    
    // email validation
    func validateEmail(email: String) -> Bool{
        let EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", EMAIL_REGEX)
        return emailTest.evaluate(with: email)
    }
    
    // contact validation
    func validatePhoneNumber(contact: String) -> Bool{
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return phoneTest.evaluate(with: contact)
    }
    
    //validate Password
    func validatePassword(password: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: password, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, password.count)) != nil){
                
                if(password.count>=6 && password.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }

}
