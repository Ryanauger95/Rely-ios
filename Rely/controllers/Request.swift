//
//  Request.swift
//  reli
//
//  Created by Ryan Auger on 8/27/19.
//  Copyright © 2019        . All rights reserved.
//

import UIKit

class Request: RequestModel {

    // save request as deal
    func submit(completion: @escaping WebServiceResponse){
        apiPOST(endpoint: apiEndpoint.Txn, path: "", body:
            [
                "amount": self.totalAmount!,
                "reserve": self.reserveAmount!,
                "description" : self.description!,
                "payer": self.payer?.userId as Any,
                "collector": self.collector?.userId as Any,
                "originator": self.originator as Any
            ], completion: completion)
    }
}
