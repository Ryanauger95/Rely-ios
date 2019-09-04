//
//  UserModel.swift
//  Rely
//
//  Created by Ryan Auger on 4/2/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation

let defaultsKey = "userDetails"

enum SIGNUP_ERROR: Error {
    case DUPLICATE
    case INVALID
    case UNKNOWN
}
enum LOGIN_ERROR: Error {
    case INVALID_USERPASS
    case UNKNOWN
}

class UserModel{
    var userId: Int
    var firstName: String?
    var lastName: String?
    var email: String?
    var token: String?
    var phone: String?
    var profileImgUrl: String?
    var profileImgBase64: String?
    var phone_validated: Bool?
    var email_validated: Bool?
    
    
    init(userId: Int,
         firstName: String? = nil,
         lastName: String? = nil,
         email:String? = nil,
         token: String? = nil,
         phone: String? = nil,
         profileImgUrl: String? = nil,
         profileImgBase64: String? = nil,
         phone_validated: Bool? = nil,
         email_validated: Bool? = nil
    ) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.token = token
        self.phone = phone
        self.profileImgUrl = profileImgUrl
        self.profileImgBase64 = profileImgBase64
        self.phone_validated = phone_validated
        self.email_validated = email_validated
    }
    
    convenience init?(defaults: Bool) {
       if defaults == false {
            return nil
        }
        guard
            let unwrappedDecodedData  = getDefaults()
        else {return nil}
       self.init(data: unwrappedDecodedData)
    }

    convenience init?(data: [String: Any]) {
        guard
            let userId = data["id"] as? Int
        else {
            return nil
        }

        self.init(
            userId: userId,
            firstName: data["first_name"] as? String,
            lastName: data["last_name"] as? String,
            email: data["email"] as? String,
            token: data["token"] as? String,
            phone: data["phone"] as? String,
            profileImgUrl: data["profile_img_url"] as? String,
            profileImgBase64: data["profile_img"] as? String,
            phone_validated: data["phone_validated"] as? Bool,
            email_validated: data["email_validated"] as? Bool
            )
    }

    
    
    func saveToDefaults() {
        let userDetails = self.toDict()
        setDefaults(data: userDetails)
    }
    func toDict() -> [String: Any]{
        return [
            "id": self.userId,
            "first_name": self.firstName as Any,
            "last_name": self.lastName as Any,
            "email": self.email as Any,
            "token": self.token as Any,
            "phone": self.phone as Any,
            "profile_img_url": self.profileImgUrl as Any,
            "profile_img": self.profileImgBase64 as Any,
            "phone_validated": self.phone_validated as Any,
            "email_validated": self.email_validated as Any
            
            ] as [String : Any]
    }
    
    
    
    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: defaultsKey)
        UserDefaults.standard.synchronize()
    }
    
}


func updateDefaults(data: [String: Any]) {
    guard var defaults = getDefaults() else {return}
    for (str, _data) in data {
        defaults[str] = _data
    }
    setDefaults(data: defaults)
}

func setDefaults(data: [String: Any]) {
    let userDefaults = UserDefaults.standard
    do {
        let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
        userDefaults.set(encodedData, forKey: "userDetails")
        userDefaults.synchronize()
        return
    } catch {
        return
    }
}

func getDefaults() -> [String:Any]? {
    guard
        let decoded = UserDefaults.standard.data(forKey: defaultsKey)
        else {return nil}
    //        let decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded)
    do {
        let decodedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded)
        return decodedData as? [String: Any]
    } catch {
        return nil
    }
}
