//
//  DealApi.swift
//  Rely
//
//  Created by kavii on 4/24/19.
//  Copyright © 2019 kavii. All rights reserved.
//

import Foundation
import SwiftyJSON

enum cancelType : Int{
    case transferReserve = 0
    case returnReserve = 1
}

class Txn : TxnModel{

    // cancel deal
    func cancel(completion: @escaping WebServiceResponse){
        apiPOST(endpoint: apiEndpoint.Txn, path: "/cancel", body:
            [
                "deal_id" : self.dealId
            ], completion: completion)
    }
    
    
}

