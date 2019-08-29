//
//  Files.swift
//  Rely
//
//  Created by kavii on 6/18/19.
//  Copyright © 2019 kavii. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Files{
    
    let urlString = Config.init().rootUrl + "/files"
    var response = "status Failed"
    typealias WebServiceResponse = ([[String: Any ]]?,Error?) -> Void
    
    // get aws image url
    func profile(base64: String, completion: @escaping WebServiceResponse){
        Alamofire.request(urlString + "/profile", method: .post, parameters:
            [
                "base64" :base64
                
            ],encoding: JSONEncoding.default, headers: nil
            ).responseJSON {
                response in
                
                if let error = response.result.error {
                    completion(nil,error)
                } else if let jsonArray = response.result.value as? [[String: Any]]{
                    completion(jsonArray,nil)
                } else if let jsonDict = response.result.value as? [String: Any]{
                    completion([jsonDict],nil)
                }
        }
    }
    
}
