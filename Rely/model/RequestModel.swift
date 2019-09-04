//
//  Request.swift
//  Rely
//
//  Created by Ryan Auger on 7/5/19.
//  Copyright © 2019 Rely. All rights reserved.
//

import Foundation

class RequestModel {
    var payer : User!
    var collector : User!
    var originator: Int!
    
    var totalAmount: Double!
    var reserveAmount: Double!
    var feeAmount: Double!
    var payerTotal: Double!
    var collectorTotal: Double!
    var description: String!
    
    init (payer : User, collector : User, originator: Int, totalAmount: Double, reserveAmount: Double, feeAmount: Double, description: String) {
        self.payer = payer
        self.collector = collector
        self.originator = originator
        self.totalAmount = totalAmount
        self.reserveAmount = reserveAmount
        self.feeAmount = feeAmount
        self.payerTotal = (payer.userId == originator) ? self.totalAmount + self.feeAmount : self.totalAmount
        self.collectorTotal = self.payerTotal - self.feeAmount
        self.description = description
    }
    
    convenience init?(requestBuilder: RequestBuilder) {
        self.init(payer : requestBuilder.payer!, collector : requestBuilder.collector!, originator: requestBuilder.originator, totalAmount: requestBuilder.totalAmount!, reserveAmount: requestBuilder.reserveAmount!, feeAmount: requestBuilder.feeAmount!, description: requestBuilder.description!)
    }
//    convenience init?(payer : User?, collector : User?, originator: Int?, totalAmount: Double?, reserveAmount: Double?,  description: String?) {
//        guard
//            let _payer = payer,
//            let _collector = collector,
//            let _originator = originator,
//            let _totalAmount = totalAmount,
//            let _reserveAmount = reserveAmount,
//            let _description = description
//        else {
//           return nil
//        }
//        self.init(payer: _payer, collector: _collector, originator: _originator, totalAmount: _totalAmount, reserveAmount: _reserveAmount,  description: _description)
//    }
}
