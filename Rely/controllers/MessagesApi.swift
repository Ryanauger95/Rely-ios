//
//  MessagesApi.swift
//  Rely
//
//  Created by Ryan Auger on 7/16/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

class MessagesApi {

    func submitFeedback(userId: Int, message: String, completion: @escaping WebServiceResponse) {
        apiPOST(endpoint: .Message, path: "/feedback", body:
            [
                "user_id" : userId,
                "message": message
            ], completion: completion)
    }
}
