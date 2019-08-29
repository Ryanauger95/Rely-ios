//
//  NotificationModel.swift
//  Rely
//
//  Created by kavii on 6/18/19.
//  Copyright © 2019 kavii. All rights reserved.
//

import Foundation
class NotificationModel{
    private var device_token: String?
    private var device_name: String?
    private var user_id: String?

    init(){}
    
    init(device_token: String?, device_name: String?, user_id: String?) {
        self.device_token = device_token
        self.device_name = device_name
        self.user_id = user_id
    }
    
    func getDeviceToken() -> String{
        return self.device_token!
    }
    func getDeviceName() -> String{
        return self.device_name!
    }
    func getUserId() -> String{
        return self.user_id!
    }
}
