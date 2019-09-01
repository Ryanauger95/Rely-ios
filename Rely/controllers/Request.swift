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
        //Convert amounts to integers!
        let amount: Int = Int(self.totalAmount * 100)
        let reserve: Int = Int(self.reserveAmount * 100)
        apiPOST(endpoint: apiEndpoint.Txn, path: "", body:
            [
                "amount": amount,
                "reserve": reserve,
                "description" : self.description!,
                "payer": self.payer?.userId as Any,
                "collector": self.collector?.userId as Any,
                "originator": self.originator as Any
            ], completion: completion)
    }
}
