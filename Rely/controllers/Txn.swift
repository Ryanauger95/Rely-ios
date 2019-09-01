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

    // Update Deal State
    func updateState(newState: DEAL_STATE, completion: @escaping WebServiceResponse){
        let path = String(format: "/%d", self.dealId)
        apiPUT(endpoint: apiEndpoint.Txn, path: path, body:
            [
                "state_change": true as Any,
                "new_state" : newState.rawValue as Any
            ], completion: completion)
    }

    func amountStr() -> String {
        return String(format: "%.2f", Double(self.reserve)/100)
    }
    func reserveStr() -> String {
        return String(format:"%.2f", Double(self.reserve)/100)
    }
    func isActive() -> Bool {
        switch (self.dealState) {
        case .DISPUTE:
            return true
        case .TIMEOUT:
            return false
        case .CANCELLED:
            return false
        case .PENDING:
            return true
        case .PROGRESS:
            return true
        case .REVIEW:
            return true
        case .COMPLETE:
            return false

        }
    }
}

