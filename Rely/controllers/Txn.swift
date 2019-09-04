//
//  DealApi.swift
//  Rely
//
//  Created by Ryan Auger on 6/24/19.
//  Copyright © 2019 Ryan Auger. All rights reserved.
//

import Foundation

enum cancelType : Int{
    case transferReserve = 0
    case returnReserve = 1
}

class Txn : TxnModel, CurrencyConversionProtocol {

    // Update Deal State
    func updateState(newState: DEAL_STATE, completion: @escaping WebServiceResponse){
        let path = String(format: "/%d", self.dealId)
        apiPUT(endpoint: apiEndpoint.Txn, path: path, body:
            [
                "state_change": true as Any,
                "new_state" : newState.rawValue as Any
            ], completion: completion)
    }
    
    //Update deal state, but more involved
    func dispute(collectorAmount:Int, payerAmount: Int, completion: @escaping (Bool) -> Void){
        let path = String(format: "/%d", self.dealId)
        apiPUT(endpoint: .Txn, path: path, body:
            [
                "state_change": true,
                "new_state": DEAL_STATE.DISPUTE.rawValue,
                "dispute_payer_amount": payerAmount,
                "dispute_collector_amount": collectorAmount
            ]
        ){(json, code, error) in
            guard code == 200 else {
                completion(false)
                return
            }
            completion(true)
        }
        
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

func minorToMajorCurrencyStr(minor: Int) -> String{
    return String(format: "%.2f", minorToMajorCurrency(minor: minor))
}
func minorToMajorCurrency(minor: Int) -> Double{
    return Double(minor)/100
}
