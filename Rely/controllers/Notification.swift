//
//  Notification.swift
//  Rely
//
//  Created by kavii on 6/18/19.
//  Copyright © 2019 kavii. All rights reserved.
//

import Foundation
import Alamofire

class Notification{
    
    let urlString = Config.init().rootUrl + "/notifications"
    var response = "status Failed"
    typealias WebServiceResponse = ([[String: Any ]]?,Error?) -> Void
    
    // ios push notification
    func pushNotification(notification: NotificationModel, completion: @escaping WebServiceResponse){
        Alamofire.request(urlString + "/ios", method: .post, parameters:
            [
                "device_token" :notification.getDeviceToken(),
                "device_name":notification.getDeviceName(),
                "user_id":notification.getUserId()
                
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
    
    // get token
    func token(id:String,completion: @escaping WebServiceResponse){
         Alamofire.request(urlString + "/token?dev_id="+id, method: .get,encoding: JSONEncoding.default, headers: nil
            ).responseJSON { (response) in
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
