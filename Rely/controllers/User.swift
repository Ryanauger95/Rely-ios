//
//  User.swift
//
//  Created by Ryan Auger on 8/27/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: UserModel{

    // Login will call internal func loginUser and
    // call the CB with a new User object
    func login(completion: @escaping (User?, LOGIN_ERROR?) -> Void) {
        guard
            let email = self.email,
            let token = self.token
            else {
                completion(nil, .UNKNOWN)
                return
        }
        
        
        self.loginUser(email: email, token: token, completion: {
            (json, code, error) in
            guard
                code == 200,
                let json = json,
                let userDetails = json["data"] as? [String: Any]
                else {
                    completion(nil, .INVALID_USERPASS)
                    return
            }
            let loggedUser = User(data: userDetails)
            loggedUser?.token = token
            completion(loggedUser, nil)
        })
    }
    
    // Will signup/register the user
    func signup(completion: @escaping (User?, SIGNUP_ERROR?) -> Void) {
        apiPOST(endpoint: apiEndpoint.User, path: "", body:
            [
                "first_name": self.firstName as Any,
                "last_name": self.lastName as Any,
                "email": self.email as Any,
                "token": self.token as Any
        ]) { (json, code, error) in
            guard
                let json = json,
                code == 200,
                let data = json["data"] as? [String:Any]
                else {
                    completion(nil, .UNKNOWN)
                    return
            }
            guard
                let newUser = User(data: data),
                let email = newUser.email,
                let token = newUser.token
            else { completion(nil, nil); return}
            setGlobalAuthorization(email: email, token: token)
            completion(newUser, nil)
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func fetchProfilePic (completion: @escaping (UIImage?, String?) -> ()) {
        guard
            let urlStr = self.profileImgUrl,
            let url = URL(string: urlStr) else {return}
        
        getData(from: url) { (data, response, error) in
            guard
                let data = data,
                error == nil
                else {
                    completion(nil, nil)
                    return
            }
            
            guard let str = String(data: data, encoding: String.Encoding.utf8) else {
                completion(nil, nil)
                return
            }
            let image = str.toUIImage()
            completion(image, str)
        }
    }
    
    
    // save user
    func save(completion: @escaping WebServiceResponse){
        apiPOST(endpoint: apiEndpoint.User, path: "/signup", body:
            [
                "first_name" :self.firstName as Any,
                "last_name": self.lastName as Any,
                "email": self.email as Any,
                "token": self.token as Any
            ], completion: completion)
    }
    
    // GET the user's wallet
    func wallet(completion: @escaping WebServiceResponse) {
        let path = String(format: "/%d/wallet", self.userId)
        apiGET(endpoint: .User, path: path, completion: completion)
    }
    
    // find user
    func find(id: Int,completion: @escaping WebServiceResponse){
        apiPOST(endpoint: apiEndpoint.User,
                   path: "/details?uid=" + String(id),
                   body: [:],
                   completion: completion)
    }
    
    // delete user
    func remove(id:String) -> Bool {
        return true
    }
    
    
    // contact number validation
    func phoneNumberUpdate(phone:String, completion: @escaping WebServiceResponse){
        apiPUT(endpoint: apiEndpoint.User, path: "", body:
            [
                "phone": phone,
            ], completion: completion)
    }
    
    // contact number validation
    func phoneNumberConfirmOTC(code:String, completion: @escaping WebServiceResponse){
        apiPUT(endpoint: apiEndpoint.User, path: "", body:
            [
            "phone_otc" : code,
            ],
        completion: completion)
    }
    
    
    // loginUser
    // 1) set the global authentication header
    // 2) Do a fetch with BASIC_AUTH. If it is successfull,
    // then we have the right email/password combo
    func loginUser(email:String,token:String,completion: @escaping WebServiceResponse){
        setGlobalAuthorization(email: email, token: token)
        apiGET(endpoint: apiEndpoint.User, path: "/?email=" + email, completion: completion)
    }
    
    // Get all users
    // TODO: Fetch only X users, first fetching those they have done business with
    func getAll(id:Int,completion: @escaping WebServiceResponse){
        apiGET(endpoint: apiEndpoint.User, path: "",
               completion: completion)
    }
    
    // user profile image save
    func uploadProfileImage(imgStr: String,completion: @escaping WebServiceResponse){
        apiPUT(endpoint: apiEndpoint.User, path: "/profile_img", body:
            [
                "profile_img": imgStr
            ], completion: completion)
    }


    ////////////////////////////////////
    /// get all txns for a user
    ////////////////////////////////////
    func getActiveTxns(completion: @escaping WebServiceResponse){
        apiGET(endpoint: apiEndpoint.Txn, path: "", completion: completion)
    }
    


    ////////////////////////////////////
    /// User Wallet
    ////////////////////////////////////
    // GET the user's wallet
    func getWallet(completion: @escaping WebServiceResponse) {
        let path = String(format: "/%d/wallet", self.userId)
        apiGET(endpoint: .User, path: path, completion: completion)
    }

    func registerWallet(
        address1 : String,
        address2 : String,
        city: String,
        state: String,
        zip: String,
        ssn: String,
        completion: @escaping WebServiceResponse) {
        
        let path = String(format: "/%d/wallet", self.userId)
        apiPOST(endpoint: .User, path: path, body:
            [
                "address_1": address1,
                "address_2": address2,
                "city": city,
                "state": state,
                "zip": zip,
                "ssn": ssn
            ], completion: completion)
    }
    
    func linkBankToWallet(publicToken: String, completion: @escaping WebServiceResponse){
        let path = String(format: "/%d/wallet/accounts", self.userId)
        apiPOST(endpoint: .User, path: path, body:
            ["public_token": publicToken as Any]
            , completion: completion)
        
    }
}

