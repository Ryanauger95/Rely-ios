//
//  RequestWrapper.swift
//  Rely
//
//  Created by Ryan Auger on 6/29/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum apiEndpoint {
    case Signup
    case User
    case Wallet
    case Txn
    case Message
}

typealias Code = Int
typealias WebServiceResponse = ([String: Any ]?, Code?, Error?) -> Void

let baseUrl = Config.init().rootUrl

var sessionAuth: String = ""

func passwordToToken(password: String) -> String{
    return password.sha256()
}
func setGlobalAuthorization(email: String, token: String) -> Void{
    sessionAuth = "{\"email\": \"\(email)\", \"token\": \"\(token)\"}"
}

func endpointToString(endpoint: apiEndpoint) -> String{
    switch endpoint{
    case .User:
        return "/user"
    case .Txn:
        return "/txn"
    case .Wallet:
        return "" // TODO: Cluge. Need to find a better way to pass /user/%d/wallet
    case .Signup:
        return "/signup"
    case .Message:
        return "/messages"
    }
}

func apiGET(endpoint: apiEndpoint, path: String, completion: @escaping WebServiceResponse) {
    let urlString = baseUrl + endpointToString(endpoint: endpoint) + path
    print("userRequest to url: ", urlString)
    Alamofire.request(urlString, method: .get, encoding: JSONEncoding.default, headers: ["Authorization": sessionAuth]
        ).responseJSON { (response) in
            let code = response.response?.statusCode
            if let error = response.result.error {
                completion(nil, code, error)
            } else if let jsonDict = response.result.value as? [String: Any]{
                completion(jsonDict, code, nil)
            } else {
               completion(nil, code, nil)
            }
        }.responseString(completionHandler: {(response) in
            print("Response Body:\(String(describing: response.result.value))")
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print("Response result value: \(data)")
                }
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        })
}



func apiPOST(endpoint: apiEndpoint, path: String, body: [String: Any], completion: @escaping WebServiceResponse) {
    let urlString = baseUrl + endpointToString(endpoint: endpoint) + path
    Alamofire.request(urlString, method: .post, parameters:
        body,encoding: JSONEncoding.default, headers: ["Authorization": sessionAuth]
        ).responseJSON { (response) in
            let code = response.response?.statusCode
            if let error = response.result.error {
                completion(nil, code, error)
            } else if let jsonDict = response.result.value as? [String: Any]{
                completion(jsonDict, code, nil)
            } else {
                completion(nil, code, nil)
            }
        }.responseString(completionHandler: {(response) in
            print("Response Body:\(String(describing: response.result.value))")
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print("Response reult value: \(data)")
                }
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        })
}



func apiPUT(endpoint: apiEndpoint, path: String, body: [String: Any], completion: @escaping WebServiceResponse){
    let urlString = baseUrl + endpointToString(endpoint: endpoint) + path
    Alamofire.request(urlString, method: .put, parameters:
        body,encoding: JSONEncoding.default, headers: ["Authorization": sessionAuth]
        ).responseJSON { (response) in
            let code = response.response?.statusCode
            if let error = response.result.error {
                completion(nil, code, error)
            } else if let jsonDict = response.result.value as? [String: Any]{
                completion(jsonDict, code, nil)
            } else {
                completion(nil, code, nil)
            }
        }.responseString(completionHandler: {(response) in
            print("Response Body:\(String(describing: response.result.value))")
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print("Response reult value: \(data)")
                }
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        })
}
